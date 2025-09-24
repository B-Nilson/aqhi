#' AQHI_colours
#'
#' A named character vector of hexidecimal codes used to represent the AQHI levels.
#'
#' @format A named character vector.
#' @source The AQHI colours were derived from \href{https://www.canada.ca/en/environment-climate-change/services/air-quality-health-index/about.html}{Environment and Climate Change Canada}.
AQHI_colours <- c(
  #Low [1 - 3]
  low_1 = "#21C6F5",
  low_2 = '#189ACA',
  low_3 = "#0D6797",
  # Moderate [4 - 6]
  mod_4 = "#FFFD37",
  mod_5 = '#FFCC2E',
  mod_6 = "#FE9A3F",
  # High [7 - 10]
  high_7 = "#FD6769",
  high_8 = "#FF3B3B",
  high_9 = "#FF0101",
  high_10 = "#CB0713",
  # Very High [+]
  very_high = "#650205",
  # Missing [-]
  missing = "#bbbbbb"
)

#' AQHI_risk_categories
#'
#' A named list of the risk categories and their respective AQHI levels.
#'
#' @format A named list of integer (or character for "Very High") vectors
#' @source \href{https://www.canada.ca/en/environment-climate-change/services/air-quality-health-index/about.html}{Environment and Climate ChangeD Canada}.
AQHI_risk_categories <- list(
  Low = 1:3,
  Moderate = 4:6,
  High = 7:10,
  "Very High" = "+"
)

#' AQHI_health_messages
#'
#' A named list of the health messages for the AQHI risk categories for both English ("en") and French ("fr").
#'
#' @format A namedad list of tibbles, 1 tibble per language.
#' @source \href{https://www.canada.ca/en/environment-climate-change/services/air-quality-health-index/understanding-messages.html}{Environment and Climate Change Canada}.
AQHI_health_messages <- list(
  en = dplyr::tibble(
    risk_category = c("Low", "Moderate", "High", "Very High"),
    high_risk_pop_message = c(
      "Enjoy your usual activities.",
      "Consider reducing or rescheduling activities outdoors if you experience symptoms.",
      "Reduce or reschedule activities outdoors.",
      "Avoid strenuous activity outdoors."
    ),
    general_pop_message = c(
      "Ideal air quality for outdoor activities.",
      "No need to modify your usual activities unless you experience symptoms.",
      "Consider reducing or rescheduling activities outdoors if you experience symptoms.",
      "Reduce or reschedule activities outdoors, especially if you experience symptoms."
    )
  ),
  fr = dplyr::tibble(
    risk_category_fr = c(
      "Faible",
      "Mod\u00e9r\u00e9",
      "Elev\u00e9",
      "Tr\u00e8s Elev\u00e9"
    ),
    high_risk_pop_message_fr = c(
      "Profiter des activit\u00e9s ext\u00e9rieures habituelles.",
      "Envisagez de r\u00e9duire ou de reporter les activit\u00e9s ext\u00e9rieures en plein air si vous \u00e9prouvez des sympt\u00f4mes.",
      "R\u00e9duisez ou r\u00e9organisez les activit\u00e9s ext\u00e9rieures en plein air.",
      "\u00c9vitez les activit\u00e9s ext\u00e9rieures en plein air."
    ),
    general_pop_message_fr = c(
      "Qualit\u00e9 de l'air id\u00e9ale pour les activit\u00e9s en plein air.",
      "Aucun besoin de modifier vos activit\u00e9s habituelles en plein air \u00e0 moins d'\u00e9prouver des sympt\u00f4mes comme la toux ou une irritation de la gorge.",
      "Envisagez de r\u00e9duire ou de reporter les activit\u00e9s ext\u00e9rieures en plein air si vous \u00e9prouvez des sympt\u00f4mes.",
      "R\u00e9duisez ou r\u00e9organisez les activit\u00e9s ext\u00e9rieures en plein air, surtout si vous \u00e9prouvez des sympt\u00f4mes comme la toux ou une irritation de la gorge."
    )
  )
)

get_AQHI <- function(pm25_rolling_3hr, no2_rolling_3hr, o3_rolling_3hr) {
  aqhi_breakpoints <- c(-Inf, 1:10, Inf) |>
    stats::setNames(c(NA, 1:10, "+"))

  o3_fraction <- exp(0.000537 * o3_rolling_3hr) - 1
  no2_fraction <- exp(0.000871 * no2_rolling_3hr) - 1
  pm25_fraction <- exp(0.000487 * pm25_rolling_3hr) - 1
  combined_fractions <- o3_fraction + no2_fraction + pm25_fraction

  aqhi <- ((10 / 10.4) * (100 * (combined_fractions))) |>
    cut(
      breaks = aqhi_breakpoints,
      labels = names(aqhi_breakpoints[-1])
    )

  dplyr::tibble(
    AQHI = aqhi,
    AQHI_pm25_ratio = pm25_fraction / combined_fractions,
    AQHI_o3_ratio = o3_fraction / combined_fractions,
    AQHI_no2_ratio = no2_fraction / combined_fractions
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
    names(AQHI_risk_categories) <- c(
      "Faible",
      "Mod\u00e9r\u00e9",
      "Elev\u00e9",
      "Tr\u00e8s Elev\u00e9"
    )
  } else if (language != "en") {
    stop("Language must be 'en' or 'fr'")
  }

  aqhi_labels <- AQHI_risk_categories |>
    seq_along() |>
    sapply(
      \(i) {
        names(AQHI_risk_categories)[i] |>
          rep(length(AQHI_risk_categories[[i]]))
      }
    )
  AQHI |>
    factor(
      levels = unlist(AQHI_risk_categories),
      labels = unlist(aqhi_labels)
    )
}

AQHI_health_messaging <- function(risk_categories, language = "en") {
  stopifnot(tolower(language) %in% c("en", "fr"), length(language) == 1)

  aqhi_messaging <- AQHI_health_messages[[language]]
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
AQHI_replace_w_AQHI_plus <- function(AQHI_obs) {
  AQHI_obs |>
    dplyr::mutate(
      AQHI_plus_exceeds_AQHI = (as.numeric(.data$AQHI_plus) >
        as.numeric(.data$AQHI)) |>
        handyr::swap(NA, with = TRUE),
      level = ifelse(
        .data$AQHI_plus_exceeds_AQHI,
        .data$AQHI_plus,
        .data$AQHI
      ) |>
        factor(levels = 1:11, labels = c(1:10, "+"))
    )
}
