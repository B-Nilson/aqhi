#' Calculate the Canadian AQHI from hourly PM2.5, NO2, and O3 observations
#'
#' @param dates Vector of hourly datetimes corresponding to observations. Date gaps will be filled automatically as needed.
#' @param pm25_1hr_ugm3 Numeric vector of hourly mean fine particulate matter (PM2.5) concentrations (ug/m^3).
#' @param no2_1hr_ppb (Optional). Numeric vector of hourly mean nitrogen dioxide (NO2) concentrations (ppb). If not provided AQHI+ will be calculated from PM2.5 only.
#' @param o3_1hr_ppb (Optional). Numeric vector of hourly mean ozone (O3) concentrations (ppb). If not provided AQHI+ will be calculated from PM2.5 only.
#' @param detailed (Optional). A single logical (TRUE/FALSE) value indicating if a tibble with AQHI, risk levels, health messages, etc should be returned.
#'   If FALSE only the AQHI (as a factor) will be returned.
#'   Default is TRUE.
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
#' @return If `detailed = TRUE`:
#' - A tibble (data.frame) with a detailed summary of the AQHI, risk levels, health messages, etc and the same number of rows as `length(dates)`
#'
#' If `detailed = FALSE`:
#' - a factor vector of AQHI levels with `length(dates)` elements
#'
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
  o3_1hr_ppb = NA_real_,
  no2_1hr_ppb = NA_real_,
  detailed = TRUE,
  language = "en",
  verbose = TRUE
) {
  stopifnot("POSIXct" %in% class(dates), length(dates) > 0)
  stopifnot(is.numeric(pm25_1hr_ugm3), length(pm25_1hr_ugm3) > 0)
  stopifnot(is.numeric(o3_1hr_ppb), length(o3_1hr_ppb) > 0)
  stopifnot(is.numeric(no2_1hr_ppb) & length(no2_1hr_ppb) > 0)
  stopifnot(is.logical(detailed), length(detailed) == 1)
  stopifnot(
    is.character(language),
    length(language) == 1,
    tolower(language) %in% c("en", "fr")
  )
  stopifnot(is.logical(verbose), length(verbose) == 1)

  # Ensure lowercase language
  language <- tolower(language)

  # Combine inputs
  obs <- dplyr::tibble(
    date = dates,
    pm25_1hr_ugm3,
    o3_1hr_ppb,
    no2_1hr_ppb
  ) |>
    # Fill in missing hours
    tidyr::complete(date = seq(min(date), max(date), "1 hours")) |>
    dplyr::arrange(date)

  # Calculate AQHI+ (PM2.5 Only) - AQHI+ overrides AQHI if higher
  initial_cols <- c(
    "pm25_1hr_ugm3",
    "o3_1hr_ppb",
    "no2_1hr_ppb",
    "pm25_3hr_ugm3",
    "o3_3hr_ppb",
    "no2_3hr_ppb",
    "level",
    "AQHI",
    "AQHI_plus",
    "AQHI_plus_exceeds_AQHI"
  )
  aqhi_plus <- obs$pm25_1hr_ugm3 |>
    AQHI_plus(language = language) |>
    # Include expected AQHI columns in case only returning AQHI+
    dplyr::mutate(
      date = obs$date,
      o3_1hr_ppb = NA_real_,
      no2_1hr_ppb = NA_real_,
      pm25_3hr_ugm3 = NA_real_,
      o3_3hr_ppb = NA_real_,
      no2_3hr_ppb = NA_real_,
      AQHI = NA_real_ |> factor(levels = c(1:10, "+")),
      AQHI_plus = .data$level,
      AQHI_plus_exceeds_AQHI = !is.na(.data$level)
    ) |>
    dplyr::relocate("date", .before = 1) |>
    dplyr::relocate(dplyr::all_of(initial_cols), .after = "date")

  # If no non-missing NO2 / O3 provided, return AQHI+
  has_all_3_pol <- any(complete.cases(obs$pm25_1hr_ugm3, obs$no2_1hr_ppb, obs$o3_1hr_ppb))
  if (!has_all_3_pol) {
    if (verbose) {
      warning(
        "No non-missing NO2 / O3 data provided. Returning AQHI+ (PM2.5 only) instead of AQHI."
      )
    }
    if (!detailed) {
      return(aqhi_plus$level)
    }
    return(aqhi_plus)
  }

  # Calculate rolling 3 hour averages
  rolling_cols <- names(obs)[2:4] |>
    stats::setNames(
      names(obs)[2:4] |> sub(pattern = "_1hr_", replacement = "_3hr_")
    )
  obs <- obs |>
    dplyr::mutate(
      dplyr::across(
        dplyr::all_of(rolling_cols),
        \(x) {
          x |>
            handyr::rolling(
              FUN = "mean",
              .width = 3,
              .direction = "backward",
              .min_non_na = 2
            ) |>
            round(digits = 1)
        }
      )
    )

  # Calculate AQHI and the combined AQHI/AQHI+
  AQHI_obs <- obs |>
    dplyr::mutate(
      AQHI = AQHI_formula(
        pm25_rolling_3hr = .data$pm25_3hr_ugm3,
        o3_rolling_3hr = .data$o3_3hr_ppb,
        no2_rolling_3hr = .data$no2_3hr_ppb
      ),
      AQHI_plus = aqhi_plus$level
    ) |>
    dplyr::filter(.data$date %in% dates) |> # drop infilled dates
    AQHI_replace_w_AQHI_plus()

  # Return level early if desired
  if (!detailed) {
    return(AQHI_obs$level)
  } 

  # Add risk + level colour
  AQHI_obs <- AQHI_obs |>
    dplyr::mutate(
      risk = .data$level |> AQHI_risk_category(language = language),
      colour = AQHI_colours[as.numeric(.data$level)]
    )
  
  # Add health messaging, sort columns, return
  AQHI_obs |>
    dplyr::bind_cols(
      AQHI_obs$risk |> AQHI_health_messaging(language = language)
    ) |>
    # Ensure column order is consistent
    dplyr::select(names(aqhi_plus))
}
