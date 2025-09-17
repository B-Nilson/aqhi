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
  aqhi_messaging[risk_categories] |>
    handyr::for_each(
      .as_list = TRUE,
      .bind = TRUE,
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
      colour = ifelse(.data$AQHI_plus_exceeds_AQHI, aqhi_plus$colour, .data$colour),
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
