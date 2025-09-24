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

get_risk_category <- function(AQHI, language = "en") {
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

get_health_messages <- function(risk_categories, language = "en") {
  stopifnot(tolower(language) %in% c("en", "fr"), length(language) == 1)

  aqhi_messaging <- AQHI_health_messages[[language]]
  aqhi_messaging[match(risk_categories, aqhi_messaging$risk_category), ] |>
    dplyr::select(-risk_category)
}

override_AQHI_with_AQHI_plus <- function(AQHI_obs) {
  stopifnot(all(c("AQHI_plus", "AQHI") %in% colnames(AQHI_obs)))

  AQHI_obs |>
    dplyr::mutate(
      AQHI_plus_exceeds_AQHI = (as.numeric(.data$AQHI_plus) >
        as.numeric(.data$AQHI)) |>
        handyr::swap(NA, with = TRUE),
      level = .data$AQHI_plus_exceeds_AQHI |>
        ifelse(
          yes = .data$AQHI_plus,
          no = .data$AQHI
        ) |>
        factor(levels = 1:11, labels = c(1:10, "+"))
    )
}
