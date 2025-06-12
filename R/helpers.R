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
AQHI_risk_category <- function(AQHI) {
  aqhi_levels <- list(
    Low = 1:3, 
    Moderate = 4:6,
    High = 7:10, 
    "Very High" = "+"
  )
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

AQHI_health_messaging <- function(risk_categories) {
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
  # TODO: is this necessary?
  aqhi_messaging[risk_categories] |> lapply(
    \(x) if (is.null(x)) {
      data.frame(high_risk_pop_message = NA, general_pop_message = NA)
    } else {
      x
    }
  ) |>
    dplyr::bind_rows()
}

# TODO: make sure AQHI is a column in obs
AQHI_replace_w_AQHI_plus <- function(obs, aqhi_plus) {
  dplyr::mutate(obs,
    AQHI_plus_exceeds_AQHI = swap_na(
      with = TRUE,
      as.numeric(aqhi_plus$AQHI_plus) > as.numeric(.data$AQHI)
    ),
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

# Calculates rolling mean if enough non-na provided
# TODO: code without zoo (use dplyr::lag/lead)
# TODO: document, test, and export
roll_mean <- function(x, width, direction = "backward", fill = NA, min_n = 0, digits = 0) {
  align <- ifelse(direction == "backward", "right",
    ifelse(direction == "forward", "left", "center")
  )
  x |>
    zoo::rollapply(
      width = width, align = align, fill = fill,
      FUN = mean_if_enough, min_n = min_n
    ) |>
    round(digits = digits)
}