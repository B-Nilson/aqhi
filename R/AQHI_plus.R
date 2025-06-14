#' Calculate the Canadian AQHI+ from hourly PM2.5 observations
#'
#' @param pm25_1hr_ugm3 A numeric/integer vector with hourly mean PM2.5 concentrations (ug/m^3).
#' @param min_allowed_pm25 A single numeric value indicating the minimum allowed concentration (Defaults to 0 ug/m^3). All values in `pm25_1hr_ugm3` less than this will be replaced with NA.
#'
#' @description
#' The Canadian AQHI+ is a modification of the Canadian Air Quality Health Index (AQHI).
#' AQHI+ is meant for augmenting the AQHI to provide a more responsive health index during wildfire smoke events.
#' AQHI+ only uses fine particulate matter (PM2.5) instead of the combination of PM2.5, ozone (O3), and nitrogen dioxide (NO2).
#' In addition, AQHI+ is calculated using hourly mean averages instead of 3-hourly mean averages used by the AQHI.
#' The AQHI+ overrides the AQHI if it exceeds the AQHI for a particular hour.
#'
#' AQHI+ splits hourly PM2.5 concentrations into bins of 10 ug/m^3 from 0 to 100 ug/m^3 (AQHI+ 1 - 10),
#' and assigns "+" to values greater than 100 ug/m^3.
#' The risk categories match the AQHI (Low \[1-3, or 0-30 ug/m^3\], Moderate \[4-6, or 30.1-60 ug/m^3\],
#' High \[7-10, or 60.1-100 ug/m^3\], and Very High \[+, or >100 ug/m^3\]) and share the same health messaging.
#'
#' The AQHI+ was originally published by Yao et. al in 2019,
#' and has been adopted by all Canadian provinces/territories as of 2024
#' (except Quebec where they use the AQI instead of the AQHI and AQHI+).
#'
#' @references \url{https://doi.org/10.17269/s41997-019-00237-w}
#'
#' @family Canadian Air Quality
#' @family Air Quality Standards
#'
#' @return A tibble (data.frame) with columns:
#' hourly_pm25, AQHI_plus, risk, high_risk_pop_message, general_pop_message
#' and `length(pm25_1hr_ugm3)` rows
#' @export
#'
#' @examples
#' # Hourly pm2.5 concentrations
#' obs <- data.frame(
#'   date = seq(
#'     lubridate::ymd_h("2024-01-01 00"),
#'     lubridate::ymd_h("2024-01-01 23"), "1 hours"
#'   ),
#'   pm25 = sample(1:150, 24)
#' )
#' # Calculate the AQHI+
#' AQHI_plus(obs$pm25)
#'
#' # Hourly pm2.5 concentrations (with negative values)
#' obs <- data.frame(
#'   date = seq(
#'     lubridate::ymd_h("2024-01-01 00"),
#'     lubridate::ymd_h("2024-01-01 23"), "1 hours"
#'   ),
#'   pm25 = c(-2, -0.1, sample(1:150, 22))
#' )
#' # Calculate the AQHI+ for each hour, except for hours where pm2.5 is < -0.5
#' AQHI_plus(obs$pm25, min_allowed_pm25 = -0.5)
#' @importFrom rlang .data
AQHI_plus <- function(pm25_1hr_ugm3, min_allowed_pm25 = 0) {
  # Remove values below the provided minimum
  pm25_1hr_ugm3[pm25_1hr_ugm3 < min_allowed_pm25] <- NA
  # Calculate AQHI+, and get the associated risk and health messaging
  aqhi_breakpoints <- c(-Inf, 1:10 * 10, Inf) |>
    stats::setNames(c(NA, 1:10, "+"))
  aqhi_p <- pm25_1hr_ugm3 |> cut(
    breaks = aqhi_breakpoints,
    labels = names(aqhi_breakpoints)[-1]
  )
  risk <- AQHI_risk_category(aqhi_p)
  health_messages <- AQHI_health_messaging(risk)
  # Combine and return
  dplyr::tibble(
    pm25_1hr_ugm3 = pm25_1hr_ugm3,
    AQHI_plus = aqhi_p,
    risk = risk,
    health_messages
  )
}