#' Calculate the Canadian AQHI from hourly PM2.5, NO2, and O3 observations
#'
#' @param dates Vector of hourly datetimes corresponding to observations. Date gaps will be filled automatically.
#' @param pm25_1hr_ugm3 Numeric vector of hourly mean fine particulate matter (PM2.5) concentrations (ug/m^3).
#' @param no2_1hr_ppb (Optional). Numeric vector of hourly mean nitrogen dioxide (NO2) concentrations (ppb). If not provided AQHI+ will be calculated from PM2.5 only.
#' @param o3_1hr_ppb (Optional). Numeric vector of hourly mean ozone (O3) concentrations (ppb). If not provided AQHI+ will be calculated from PM2.5 only.
#' @param language (Optional). A single string value indicating the language to use for health messaging.
#'   Must be "en" or "fr".
#'   Default is "en".
#' @param verbose (Optional). A single logical (TRUE/FALSE) value indicating if non-critical warnings/messages should be displayed. Default is TRUE
#'
#' @description
#' The Canadian Air Quality Health Index (AQHI) combines the health risk of
#' fine particulate matter (PM2.5), ozone (O3), and nitrogen dioxide (NO2) on a scale from 1-10 (+).
#' The AQHI is "the sum of excess mortality risk associated with individual pollutants
#' from a time-series analysis of air pollution and mortality in Canadian cities,
#' adjusted to a 0–10 scale, and calculated hourly on the basis of trailing 3-hr average pollutant concentrations."
#'
#' The AQHI is overriden by the Canadian AQHI+ if the AQHI+ exceeds the AQHI for a particular hour.
#' The AQHI+ is a modification of the Canadian Air Quality Health Index (AQHI).
#' AQHI+ only uses fine particulate matter (PM2.5) instead of the combination of PM2.5, ozone (O3), and nitrogen dioxide (NO2).
#' Unlike the AQHI which uses 3-hour mean averages, AQHI+ is calculated using hourly means.
#'
#' The AQHI was originally published by Steib et. al in 2008,
#' and has been adopted by all Canadian provinces/territories
#' (except Quebec where they use the AQI instead of the AQHI/AQHI+).
#'
#' @references \url{https://doi.org/10.3155/1047-3289.58.3.435}
#'
#' @family Canadian Air Quality
#' @family Air Quality Standards
#'
#' @return A tibble (data.frame) with columns (*if all 3 pollutants provided):
#' date, pm25, o3*, no2*, pm25_rolling_3hr*, o3_rolling_3hr*, o3_rolling_3hr*,
#'  AQHI, AQHI_plus, risk, high_risk_pop_message, general_pop_message, AQHI_plus_exceeds_AQHI*
#'  and potentially more rows than `length(dates)` (due to any missing hours being filled with NA values).
#' @export
#'
#' @examples
#' obs <- data.frame(
#'   date = seq(
#'     as.POSIXct("2024-01-01 00:00:00"),
#'     as.POSIXct("2024-01-01 23:00:00"), "1 hours"
#'   ),
#'   pm25 = sample(1:150, 24), o3 = sample(1:150, 24), no2 = sample(1:150, 24)
#' )
#' AQHI(
#'   dates = obs$date, pm25_1hr_ugm3 = obs$pm25,
#'   o3_1hr_ppb = obs$o3, no2_1hr_ppb = obs$no2
#' )
#'
#' AQHI(dates = obs$date, pm25_1hr_ugm3 = obs$pm25) # Returns AQHI+
AQHI <- function(
  dates,
  pm25_1hr_ugm3,
  no2_1hr_ppb = NA,
  o3_1hr_ppb = NA,
  language = "en",
  verbose = TRUE
) {
  obs <- dplyr::bind_cols(
    date = dates,
    pm25 = pm25_1hr_ugm3,
    o3 = o3_1hr_ppb,
    no2 = no2_1hr_ppb
  ) |>
    tidyr::complete(date = seq(min(date), max(date), "1 hours")) |>
    dplyr::arrange(date)

  # Calculate AQHI+ (PM2.5 Only) - AQHI+ overrides AQHI if higher
  aqhi_plus <- AQHI_plus(pm25_1hr_ugm3 = obs$pm25, language = language) |>
    dplyr::mutate(
      AQHI = NA,
      AQHI_plus = .data$level,
      AQHI_plus_exceeds_AQHI = !is.na(.data$level)
    ) |>
    dplyr::relocate(c("AQHI", "AQHI_plus"), .before = "risk")
  # Calculate AQHI (if all 3 pollutants provided)
  has_all_3_pol <- any(
    !is.na(pm25_1hr_ugm3) & !is.na(no2_1hr_ppb) & !is.na(o3_1hr_ppb)
  )
  if (has_all_3_pol) {
    rolling_cols <- c("pm25", "no2", "o3")
    names(rolling_cols) <- paste0(rolling_cols, "_rolling_3hr")
    obs <- obs |>
      dplyr::mutate(
        dplyr::across(
          dplyr::all_of(rolling_cols),
          \(x) {
            x |>
              handyr::rolling(
                "mean",
                .width = 3,
                .direction = "backward",
                .min_non_na = 2
              ) |>
              round(digits = 1)
          }
        ),
        AQHI = AQHI_formula(
          pm25_rolling_3hr = .data$pm25_rolling_3hr,
          no2_rolling_3hr = .data$no2_rolling_3hr,
          o3_rolling_3hr = .data$o3_rolling_3hr
        ),
        AQHI_plus = aqhi_plus$level,
        risk = AQHI_risk_category(.data$AQHI, language = language),
        colour = AQHI_colours[as.numeric(.data$AQHI)]
      )
    obs |>
      dplyr::bind_cols(AQHI_health_messaging(obs$risk, language = language)) |>
      AQHI_replace_w_AQHI_plus(aqhi_plus = aqhi_plus) |>
      dplyr::relocate(c("level", "AQHI", "AQHI_plus"), .before = "risk")
  } else {
    if (verbose) {
      warning(
        "Returning AQHI+ (PM2.5 only) as no non-missing NO2 / O3 provided."
      )
    }
    return(aqhi_plus)
  }
}
