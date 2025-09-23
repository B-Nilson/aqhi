AQHI_colours <- c(
  #Low [1 - 3]
  "#21C6F5",
  '#189ACA',
  "#0D6797",
  # Moderate [4 - 6]
  "#FFFD37",
  '#FFCC2E',
  "#FE9A3F",
  # High [7 - 10]
  "#FD6769",
  "#FF3B3B",
  "#FF0101",
  "#CB0713",
  # Very High [+]
  "#650205",
  # Missing
  "#bbbbbb"
)

AQHI_formula <- function(pm25_rolling_3hr, no2_rolling_3hr, o3_rolling_3hr) {
  aqhi_breakpoints <- c(-Inf, 1:10, Inf) |>
    stats::setNames(c(NA, 1:10, "+"))
  aqhi <- round(
    10 /
      10.4 *
      100 *
      ((exp(0.000537 * o3_rolling_3hr) - 1) +
        (exp(0.000871 * no2_rolling_3hr) - 1) +
        (exp(0.000487 * pm25_rolling_3hr) - 1))
  )
  cut(
    aqhi,
    breaks = aqhi_breakpoints,
    labels = names(aqhi_breakpoints[-1])
  )
}

# TODO: export this
AQHI_risk_category <- function(AQHI, language = "en") {
  aqhi_levels <- list(
    Low = 1:3,
    Moderate = 4:6,
    High = 7:10,
    "Very High" = "+"
  )
  if (language == "fr") {
    names(aqhi_levels) <- c(
      "Faible",
      "Mod\u00e9r\u00e9",
      "Elev\u00e9",
      "Tr\u00e8s Elev\u00e9"
    )
  } else if (language != "en") {
    stop("Language must be 'en' or 'fr'")
  }

  aqhi_labels <- aqhi_levels |>
    seq_along() |>
    sapply(
      \(i) {
        names(aqhi_levels)[i] |>
          rep(length(aqhi_levels[[i]]))
      }
    )
  AQHI |>
    factor(
      levels = unlist(aqhi_levels),
      labels = unlist(aqhi_labels)
    )
}

AQHI_health_messaging <- function(risk_categories, language = "en") {
  if (language == "en") {
    aqhi_messaging <- list(
      Low = data.frame(
        high_risk_pop_message = "Enjoy your usual activities.",
        general_pop_message = "Ideal air quality for outdoor activities."
      ),
      Moderate = data.frame(
        high_risk_pop_message = "Consider reducing or rescheduling activities outdoors if you experience symptoms.",
        general_pop_message = "No need to modify your usual activities unless you experience symptoms."
      ),
      High = data.frame(
        high_risk_pop_message = "Reduce or reschedule activities outdoors.",
        general_pop_message = "Consider reducing or rescheduling activities outdoors if you experience symptoms."
      ),
      "Very High" = data.frame(
        high_risk_pop_message = "Avoid strenuous activity outdoors.",
        general_pop_message = "Reduce or reschedule activities outdoors, especially if you experience symptoms."
      )
    )
  } else if (language == "fr") {
    aqhi_messaging <- list(
      Faible = data.frame(
        high_risk_pop_message = "Profiter des activit\u00e9s ext\u00e9rieures habituelles.",
        general_pop_message = "Qualit\u00e9 de l'air id\u00e9ale pour les activit\u00e9s en plein air."
      ),
      "Mod\u00e9r\u00e9" = data.frame(
        high_risk_pop_message = "Envisagez de r\u00e9duire ou de reporter les activit\u00e9s ext\u00e9rieures en plein air si vous \u00e9prouvez des sympt\u00f4mes.",
        general_pop_message = "Aucun besoin de modifier vos activit\u00e9s habituelles en plein air \u00e0 moins d'\u00e9prouver des sympt\u00f4mes comme la toux ou une irritation de la gorge."
      ),
      "Elev\u00e9" = data.frame(
        high_risk_pop_message = "R\u00e9duisez ou r\u00e9organisez les activit\u00e9s ext\u00e9rieures en plein air. Les enfants et les a\u00ce7n\u00e9s doivent \u00e9galement mod\u00e9rer leurs activit\u00e9s.",
        general_pop_message = "Envisagez de r\u00e9duire ou de r\u00e9organiser les activit\u00e9s ext\u00e9rieures en plein air si vous \u00e9prouvez des sympt\u00f4mes comme la toux ou une irritation de la gorge."
      ),
      "Tr\u00e8s \u00c9lev\u00e9" = data.frame(
        high_risk_pop_message = "\u00c9vitez les activit\u00e9s ext\u00e9rieures en plein air.",
        general_pop_message = "R\u00e9duisez ou reportez les activit\u00e9s ext\u00e9rieures en plein air, particuli\u00e8rement si vous \u00e9prouvez des sympt\u00f4mes comme la toux ou une irritation de la gorge."
      )
    )
  } else {
    stop("Language must be 'en' or 'fr'")
  }
  # TODO: is this necessary?
  aqhi_messaging[risk_categories] |>
    handyr::for_each(
      .as_list = TRUE,
      .bind = TRUE,
      .show_progress = FALSE,
      \(x) {
        if (is.null(x)) {
          data.frame(high_risk_pop_message = NA, general_pop_message = NA)
        } else {
          x
        }
      }
    )
}

# TODO: make sure AQHI is a column in obs
AQHI_replace_w_AQHI_plus <- function(obs, aqhi_plus) {
  obs |>
    dplyr::mutate(
      AQHI_plus_exceeds_AQHI = (as.numeric(.data$AQHI_plus) >
        as.numeric(.data$AQHI)) |>
        handyr::swap(NA, with = TRUE),
      level = ifelse(
        .data$AQHI_plus_exceeds_AQHI,
        .data$AQHI_plus,
        .data$AQHI
      ),
      risk = ifelse(.data$AQHI_plus_exceeds_AQHI, aqhi_plus$risk, .data$risk),
      colour = ifelse(
        .data$AQHI_plus_exceeds_AQHI,
        aqhi_plus$colour,
        .data$colour
      ),
      high_risk_pop_message = ifelse(
        .data$AQHI_plus_exceeds_AQHI,
        aqhi_plus$high_risk_pop_message,
        .data$high_risk_pop_message
      ),
      general_pop_message = ifelse(
        .data$AQHI_plus_exceeds_AQHI,
        aqhi_plus$general_pop_message,
        .data$general_pop_message
      )
    )
}
