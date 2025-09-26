#' Calculate the Canadian AQHI from hourly \ifelse{html}{\out{PM<sub>2.5</sub>}}{\eqn{PM_{2.5}}}, \ifelse{html}{\out{O<sub>3</sub>}}{\eqn{O_3}}, and \ifelse{html}{\out{NO<sub>2</sub>}}{\eqn{NO_2}} concentrations
#'
#' @description
#' The Canadian Air Quality Health Index (AQHI) is a measure of the health risk associated with exposure to ambient air pollution.
#' It combines the impacts of fine particulate matter (\ifelse{html}{\out{PM<sub>2.5</sub>}}{\eqn{PM_{2.5}}}),
#' ozone (\ifelse{html}{\out{O<sub>3</sub>}}{\eqn{O_3}}),
#' and nitrogen dioxide (\ifelse{html}{\out{NO<sub>2</sub>}}{\eqn{NO_2}}) on a scale from 1-10 (+).
#'
#' AQHI formula:
#'   <sup>10</sup>&frasl;<sub>10.4</sub> &times; 100 &times;
#'   (e<sup>0.000537 * O<sub>3</sub></sup> - 1) +
#'   (e<sup>0.000871 * NO<sub>2</sub></sup> - 1) +
#'   (e<sup>0.000487 * PM<sub>2.5</sub></sup> - 1)
#'
#' The AQHI was originally published by Stieb et al. (2008): \doi{doi:10.3155/1047-3289.58.3.435},
#' and is used by all Canadian provinces and territories except for Québec, which uses the AQI instead.
#' The AQHI is calculated for each hour using 3-hour rolling mean concentrations of \ifelse{html}{\out{PM<sub>2.5</sub>}}{\eqn{PM_{2.5}}}, \ifelse{html}{\out{O<sub>3</sub>}}{\eqn{O_3}}, and \ifelse{html}{\out{NO<sub>2</sub>}}{\eqn{NO_2}}.
#' However, the AQHI is overriden by the AQHI+ for a given hour if that AQHI+ level is higher.
#' The AQHI+ is a modification of the AQHI that only uses \ifelse{html}{\out{PM<sub>2.5</sub>}}{\eqn{PM_{2.5}}} and is calculated using hourly means (see \code{\link{AQHI_plus}}).
#'
#' @param dates A POSIXct (date-time) vector corresponding to hourly pollutant observations.
#'   Date gaps will be filled with NA's automatically as needed when calculating 3-hour averages.
#' @param pm25_1hr_ugm3
#'   A numeric vector of hourly mean \ifelse{html}{\out{PM<sub>2.5</sub>}}{\eqn{PM_{2.5}}} concentrations (units = \ifelse{html}{\out{&mu;g m<sup>-3</sup>}}{\eqn{ug m^{-3}}}).
#'   Must be a single value or the same length as \code{dates} or a single value (which will be repeated).
#' @param no2_1hr_ppb (Optional).
#'   A numeric vector of hourly mean nitrogen dioxide (\ifelse{html}{\out{NO<sub>2</sub>}}{\eqn{NO_2}}) concentrations (units = ppb).
#'   Must be a single value or the same length as \code{dates} or a single value (which will be repeated).
#'   If all are NA (the default) AQHI won't be calculated and instead AQHI+ (see \code{\link{AQHI_plus}}) will used.
#' @param o3_1hr_ppb (Optional).
#'   A numeric vector of hourly mean ozone (\ifelse{html}{\out{O<sub>3</sub>}}{\eqn{O_3}}) concentrations (units = ppb).
#'   Must be a single value or the same length as \code{dates} or a single value (which will be repeated).
#'   If all are NA (the default) AQHI won't be calculated and instead AQHI+ (see \code{\link{AQHI_plus}}) will be used.
#' @param detailed (Optional).
#'   A single logical value indicating if a tibble with levels, risk categories, health messages, etc should be returned.
#'   If FALSE only the levels will be returned.
#'   Default is TRUE.
#' @param allow_aqhi_plus_override (Optional).
#'   A single logical value indicating if the AQHI+ should be allowed to override the AQHI if it exceeds the AQHI for a particular hour.
#'   Default is TRUE.
#' @param language (Optional).
#'   A single character value indicating the language to use for risk levels and health messaging.
#'   Must be either "en" (English) or "fr" (French). Not case sensitive.
#'   Default is "en".
#' @param quiet (Optional).
#'   A single logical (TRUE/FALSE) value indicating if non-critical warnings/messages should be hidden.
#'   Default is FALSE.
#'
#' @references Stieb et al. (2008): \doi{doi:10.3155/1047-3289.58.3.435}
#'
#' Environment and Climate Change Canada: \url{https://www.canada.ca/en/environment-climate-change/services/air-quality-health-index/about.html}
#'
#' @return If `detailed = TRUE`:
#' - A tibble (data.frame) with a detailed summary of the AQHI, risk levels, health messages, etc and the same number of rows as `length(dates)`
#'
#' If `detailed = FALSE`:
#' - a factor vector of AQHI levels with `length(dates)` elements
#'
#' @export
#' @importFrom rlang .data
#'
#' @examples
#' obs <- data.frame(
#'   date = seq(
#'     as.POSIXct("2024-01-01 00:00:00"),
#'     as.POSIXct("2024-01-01 23:00:00"), "1 hours"
#'   ),
#'   pm25 = sample(1:150, 24), o3 = sample(1:150, 24), no2 = sample(1:150, 24)
#' )
#'
#' # Calculate the AQHI
#' obs$date |>
#'   AQHI(
#'     pm25_1hr_ugm3 = obs$pm25,
#'     o3_1hr_ppb = obs$o3,
#'     no2_1hr_ppb = obs$no2
#'   )
#'
#' # Return just the AQHI levels
#' obs$date |>
#'   AQHI(
#'     pm25_1hr_ugm3 = obs$pm25,
#'     o3_1hr_ppb = obs$o3,
#'     no2_1hr_ppb = obs$no2,
#'     detailed = FALSE
#'   )
#'
#' # Calculate just the AQHI+
#' obs$date |> AQHI(pm25_1hr_ugm3 = obs$pm25)
#' obs$date |> AQHI(pm25_1hr_ugm3 = obs$pm25, quiet = TRUE) # silence warning
#'
#' # Return French version
#' obs$date |>
#'   AQHI(
#'     pm25_1hr_ugm3 = obs$pm25,
#'     o3_1hr_ppb = obs$o3,
#'     no2_1hr_ppb = obs$no2,
#'     language = "fr"
#'   )
#' obs$date |> AQHI(pm25_1hr_ugm3 = obs$pm25, language = "fr")
#'
#' # Don't allow AQHI+ override (not recommended)
#' obs$date |>
#'   AQHI(
#'     pm25_1hr_ugm3 = obs$pm25,
#'     o3_1hr_ppb = obs$o3,
#'     no2_1hr_ppb = obs$no2,
#'     allow_aqhi_plus_override = FALSE
#'   )
AQHI <- function(
  dates,
  pm25_1hr_ugm3,
  o3_1hr_ppb = NA_real_,
  no2_1hr_ppb = NA_real_,
  allow_aqhi_plus_override = TRUE,
  detailed = TRUE,
  language = "en",
  quiet = FALSE
) {
  stopifnot("POSIXct" %in% class(dates), length(dates) > 0)
  stopifnot(is.numeric(pm25_1hr_ugm3), length(pm25_1hr_ugm3) > 0)
  stopifnot(is.numeric(o3_1hr_ppb), length(o3_1hr_ppb) > 0)
  stopifnot(is.numeric(no2_1hr_ppb) & length(no2_1hr_ppb) > 0)
  stopifnot(
    length(dates) == length(pm25_1hr_ugm3),
    length(dates) == length(o3_1hr_ppb) | length(o3_1hr_ppb) == 1,
    length(dates) == length(no2_1hr_ppb) | length(no2_1hr_ppb) == 1
  )
  stopifnot(is.logical(detailed), length(detailed) == 1)
  stopifnot(
    is.character(language),
    length(language) == 1,
    tolower(language) %in% c("en", "fr")
  )
  stopifnot(is.logical(quiet), length(quiet) == 1)

  # Ensure lowercase language
  language <- tolower(language)

  # Combine inputs
  obs <- dplyr::tibble(
    date = dates,
    pm25_1hr_ugm3,
    o3_1hr_ppb,
    no2_1hr_ppb
  )

  # Calculate AQHI+ (PM2.5 Only) - AQHI+ overrides AQHI if higher
  if (allow_aqhi_plus_override) {
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
        AQHI_plus_exceeds_AQHI = !is.na(.data$level),
        AQHI_pm25_ratio = NA_real_,
        AQHI_o3_ratio = NA_real_,
        AQHI_no2_ratio = NA_real_
      ) |>
      dplyr::select(dplyr::all_of(.aqhi_columns))
  } else {
    aqhi_plus <- data.frame(level = NA_real_ |> factor(levels = c(1:10, "+")))
  }

  # If no non-missing NO2 / O3 provided, return AQHI+
  has_all_3_pol <- any(stats::complete.cases(
    obs$pm25_1hr_ugm3,
    obs$no2_1hr_ppb,
    obs$o3_1hr_ppb
  ))
  if (!has_all_3_pol & allow_aqhi_plus_override) {
    if (!quiet) {
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
    # Fill in missing hours
    tidyr::complete(date = seq(min(date), max(date), "1 hours")) |>
    dplyr::arrange(date) |>
    # get rolling averages
    dplyr::mutate(
      dplyr::across(
        dplyr::all_of(rolling_cols),
        \(x) {
          x |>
            roll_mean(
              width = 3,
              direction = "backward",
              fill = NA,
              min_non_na = 2
            ) |>
            round(digits = 1)
        }
      )
    )

  # Calculate AQHI
  AQHI_obs <- obs |>
    dplyr::mutate(
      get_AQHI(
        pm25_rolling_3hr = .data$pm25_3hr_ugm3,
        o3_rolling_3hr = .data$o3_3hr_ppb,
        no2_rolling_3hr = .data$no2_3hr_ppb
      ),
      AQHI_plus = aqhi_plus$level
    ) |>
    # drop infilled dates
    dplyr::filter(.data$date %in% dates)

  # Override AQHI with AQHI+ where AQHI+ is higher
  if (allow_aqhi_plus_override) {
    AQHI_obs <- AQHI_obs |> override_AQHI_with_AQHI_plus()
  } else {
    AQHI_obs$AQHI_plus <- NA_real_ |> factor(levels = c(1:10, "+"))
    AQHI_obs$AQHI_plus_exceeds_AQHI <- FALSE
    AQHI_obs$level <- AQHI_obs$AQHI
  }

  # Return level early if desired
  if (!detailed) {
    return(AQHI_obs$level)
  }

  # Add risk + level colour + health messaging
  AQHI_obs |>
    dplyr::mutate(
      risk = .data$level |> get_risk_category(language = language),
      colour = .data$level |> get_aqhi_colours(),
      .data$risk |>
        get_health_messages(language = language) |>
        dplyr::select(-"risk_category")
    ) |>
    dplyr::select(dplyr::all_of(.aqhi_columns))
}

.aqhi_columns <- c(
  "date",
  "pm25_1hr_ugm3",
  "o3_1hr_ppb",
  "no2_1hr_ppb",
  "pm25_3hr_ugm3",
  "o3_3hr_ppb",
  "no2_3hr_ppb",
  "level",
  "AQHI",
  "AQHI_plus",
  "AQHI_plus_exceeds_AQHI",
  "AQHI_pm25_ratio",
  "AQHI_o3_ratio",
  "AQHI_no2_ratio",
  "colour",
  "risk",
  "high_risk_pop_message",
  "general_pop_message"
)

get_AQHI <- function(pm25_rolling_3hr, no2_rolling_3hr, o3_rolling_3hr) {
  # Calculate each piece of the AQHI (See Stieb et al. 2008)
  o3_fraction <- exp(0.000537 * o3_rolling_3hr) - 1
  no2_fraction <- exp(0.000871 * no2_rolling_3hr) - 1
  pm25_fraction <- exp(0.000487 * pm25_rolling_3hr) - 1

  # Sum, then convert to AQHI (See Stieb et al. 2008)
  combined_fractions <- o3_fraction + no2_fraction + pm25_fraction
  decimal_aqhi <- 10 / 10.4 * 100 * combined_fractions

  # Convert to factor from 1-10, "+", or NA
  aqhi_breakpoints <- c(-Inf, 1:10, Inf) |>
    stats::setNames(c(NA, 1:10, "+"))
  aqhi <- decimal_aqhi |>
    round() |> # round to nearest integer
    cut(
      breaks = aqhi_breakpoints,
      labels = names(aqhi_breakpoints[-1])
    )

  # Combine with relative contributions and return
  dplyr::tibble(
    AQHI = aqhi,
    AQHI_pm25_ratio = pm25_fraction / combined_fractions,
    AQHI_o3_ratio = o3_fraction / combined_fractions,
    AQHI_no2_ratio = no2_fraction / combined_fractions
  )
}

# Check if AQHI+ is greater than AQHI, set level to highest of the two
override_AQHI_with_AQHI_plus <- function(AQHI_obs) {
  stopifnot(all(c("AQHI_plus", "AQHI") %in% colnames(AQHI_obs)))

  AQHI_obs |>
    dplyr::mutate(
      # Check if AQHI+ is greater than AQHI
      AQHI_plus_exceeds_AQHI = dplyr::case_when(
        is.na(.data$AQHI) & is.na(.data$AQHI_plus) ~ NA,
        is.na(.data$AQHI) ~ TRUE,
        is.na(.data$AQHI_plus) ~ FALSE,
        TRUE ~ as.numeric(.data$AQHI_plus) > as.numeric(.data$AQHI)
      ),
      # Replace AQHI with AQHI+ where AQHI+ is higher
      level = .data$AQHI_plus_exceeds_AQHI |>
        ifelse(
          yes = as.character(.data$AQHI_plus),
          no = as.character(.data$AQHI)
        ) |>
        factor(levels = c(1:10, "+"))
    )
}
