AQHI_formula <- function(pm25_rolling_3hr, no2_rolling_3hr, o3_rolling_3hr) {
  aqhi_breakpoints <- c(-Inf, 1:10, Inf) |>
    stats::setNames(c(NA, 1:10, "+"))
  aqhi <- round(10 / 10.4 * 100 * (
    (exp(0.000537 * o3_rolling_3hr) - 1) +
      (exp(0.000871 * no2_rolling_3hr) - 1) +
      (exp(0.000487 * pm25_rolling_3hr) - 1)
  ))
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
    names(aqhi_levels) <- c("Faible", "Modéré", "Elevé", "Très Elevé")
  } else if (language != "en") {
    stop("Language must be 'en' or 'fr'")
  }

  aqhi_labels <- aqhi_levels |>
    seq_along() |>
    sapply(
      \(i) names(aqhi_levels)[i] |>
        rep(length(aqhi_levels[[i]]))
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
        high_risk_pop_message = "Profiter des activités extérieures habituelles.",
        general_pop_message = "Qualité de l'air idéale pour les activités en plein air."
      ),
      Modéré = data.frame(
        high_risk_pop_message = "Envisagez de réduire ou de reporter les activités exténuantes en plein air si vous éprouvez des symptômes.",
        general_pop_message = "Aucun besoin de modifier vos activités habituelles en plein air à moins d'éprouver des symptômes comme la toux ou une irritation de la gorge."
      ),
      Elevé = data.frame(
        high_risk_pop_message = "Réduisez ou réorganisez les activités exténuantes en plein air. Les enfants et les aînés doivent également modérer leurs activités.",
        general_pop_message = "Envisagez de réduire ou de réorganiser les activités exténuantes en plein air si vous éprouvez des symptômes comme la toux ou une irritation de la gorge."
      ),
      "Très Elevé" = data.frame(
        high_risk_pop_message = "Évitez les activités exténuantes en plein air.",
        general_pop_message = "Réduisez ou reportez les activités exténuantes en plein air, particulièrement si vous éprouvez des symptômes comme la toux ou une irritation de la gorge."
      )
    )
  } else {
    stop("Language not supported.")
  }
  # TODO: is this necessary?
  aqhi_messaging[risk_categories] |> 
    handyr::for_each(
      .as_list = TRUE, .bind = TRUE,
      \(x) if (is.null(x)) {
        data.frame(high_risk_pop_message = NA, general_pop_message = NA)
      } else {
        x
      }
  )
}

# TODO: make sure AQHI is a column in obs
AQHI_replace_w_AQHI_plus <- function(obs, aqhi_plus) {
  dplyr::mutate(obs,
    AQHI_plus_exceeds_AQHI = (as.numeric(aqhi_plus$AQHI_plus) > as.numeric(.data$AQHI)) |>
      handyr::swap(NA, with = TRUE),
    AQHI = ifelse(.data$AQHI_plus_exceeds_AQHI,
      aqhi_plus$AQHI_plus, .data$AQHI
    ),
    risk = ifelse(.data$AQHI_plus_exceeds_AQHI,
      aqhi_plus$risk, .data$risk
    ),
    high_risk_pop_message = ifelse(.data$AQHI_plus_exceeds_AQHI,
      aqhi_plus$high_risk_pop_message, .data$high_risk_pop_message
    ),
    general_pop_message = ifelse(.data$AQHI_plus_exceeds_AQHI,
      aqhi_plus$general_pop_message, .data$general_pop_message
    )
  )
}
