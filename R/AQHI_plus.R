#' Calculate the Canadian AQHI+ from hourly \ifelse{html}{\out{PM<sub>2.5</sub>}}{\eqn{PM_{2.5}}} concentrations
#'
#' @inheritParams AQHI
#' @param min_allowed_pm25 (Optional).
#'   A single numeric value indicating the minimum allowed concentration.
#'   All values in `pm25_1hr_ugm3` less than this will be replaced with NA.
#'   Default is 0 \ifelse{html}{\out{&mu;g m<sup>-3</sup>}}{\eqn{ug m^{-3}}}.
#'
#' @description
#' The Canadian AQHI+ is a modification of the Canadian Air Quality Health Index (\code{\link{AQHI}}).
#' AQHI+ only uses fine particulate matter (\ifelse{html}{\out{PM<sub>2.5</sub>}}{\eqn{PM_{2.5}}}) instead of the combination of
#' \ifelse{html}{\out{PM<sub>2.5</sub>}}{\eqn{PM_{2.5}}}, ozone (\ifelse{html}{\out{O<sub>3</sub>}}{\eqn{O_3}}), and nitrogen dioxide (\ifelse{html}{\out{NO<sub>2</sub>}}{\eqn{NO_2}}).
#' Unlike the AQHI which uses 3-hourly mean averages,
#' AQHI+ is calculated using hourly mean averages.
#' The AQHI+ overrides the AQHI if it exceeds the AQHI for a particular hour.
#'
#' AQHI+ categorizes hourly \ifelse{html}{\out{PM<sub>2.5</sub>}}{\eqn{PM_{2.5}}} concentrations into
#' 10 equal bins from 0 to 100 \ifelse{html}{\out{&mu;g m<sup>-3</sup>}}{\eqn{ug m^{-3}}} (AQHI+ 1-10),
#' and assigns "+" to values greater than 100 \ifelse{html}{\out{&mu;g m<sup>-3</sup>}}{\eqn{ug m^{-3}}}.
#' The risk categories match the Canadian AQHI and share the same health messaging:
#' - Low:  AQHI+ of 1-3, or a concentration of 0-30 \ifelse{html}{\out{&mu;g m<sup>-3</sup>}}{\eqn{ug m^{-3}}}
#' - Moderate: AQHI+ of 4-6, or a concentration of 30.1-60 \ifelse{html}{\out{&mu;g m<sup>-3</sup>}}{\eqn{ug m^{-3}}}
#' - High: AQHI+ of 7-10, or a concentration of 60.1-100 \ifelse{html}{\out{&mu;g m<sup>-3</sup>}}{\eqn{ug m^{-3}}}
#' - Very High: AQHI+ of +, or a concentration above 100 \ifelse{html}{\out{&mu;g m<sup>-3</sup>}}{\eqn{ug m^{-3}}}
#'
#' The AQHI+ was originally published by Yao et al (2019): \doi{doi:10.17269/s41997-019-00237-w},
#' and has been adopted by all\* Canadian provinces/territories as of 2024.
#' (\*except Québec where they use the AQI instead of the AQHI/AQHI+).
#'
#' Quote from Yao et al (2019):
#'
#' This algorithm is a linear extrapolation based on two anchor points:
#'  1. the AQHI-Plus value should reach 7 (high risk category),
#' when 1-h PM2.5 concentrations are over 60 ug/m3.
#' This is consistent with \[...\] the analyses of the likelihood of exceeding the 25 ug/m3 24-h threshold value; and
#'  2. the AQHI-Plus value should reach 4 (moderate risk category)
#' when the 1-h PM2.5 concentrations are over 30 ug/m3,
#' which is the threshold for odour perception of burning softwood
#' (Kistler et al. 2012: \doi{doi:10.1016/j.atmosenv.2012.01.044}),
#' the major type of forest species in \[British Columbia\].
#'
#' \[...\]
#'
#' These conclusions suggest that the AQHI is most indicative of the mortality and
#' circulatory risks during periods affected by wildfire smoke.
#' However, the \[...\] AQHI-Plus is most indicative of the respiratory risks
#' during high-intensity fire periods, particularly for people with asthma.
#' This is consistent with the rationale behind the AQHI formulation
#' and with existing health evidence related to the effects of wildfire smoke.
#'
#' @references Yao et al (2019): \doi{doi:10.17269/s41997-019-00237-w}
#'
#' Environment and Climate Change Canada: \url{https://www.canada.ca/en/environment-climate-change/services/air-quality-health-index/about.html}
#'
#' @return If `detailed` is TRUE:
#' - A tibble (data.frame) with columns detailing the AQHI+, risk level, health messages, etc
#'
#' If `detailed` is FALSE:
#' - A factor vector of AQHI+ levels with `length(pm25_1hr_ugm3)` elements
#'
#' @export
#'
#' @examples
#' # Hourly pm2.5 concentrations
#' pm25 <- sample(1:150, 24)
#' # Calculate the detailed AQHI+ (tibble with risk levels etc)
#' AQHI_plus(pm25)
#' # Or just the AQHI+ (returned as a factor)
#' AQHI_plus(pm25, detailed = FALSE)
#'
#' # Hourly pm2.5 concentrations (with negative values)
#' pm25 <- c(-2, -0.1, sample(1:150, 22))
#' # Calculate the AQHI+ for each hour, except for hours where pm2.5 is < -0.5
#' AQHI_plus(pm25, min_allowed_pm25 = -0.5)
AQHI_plus <- function(
  pm25_1hr_ugm3,
  min_allowed_pm25 = 0,
  detailed = TRUE,
  language = "en"
) {
  stopifnot(is.numeric(pm25_1hr_ugm3), length(pm25_1hr_ugm3) > 0)
  stopifnot(is.numeric(min_allowed_pm25), length(min_allowed_pm25) == 1)
  stopifnot(is.logical(detailed), length(detailed) == 1)
  stopifnot(
    is.character(language),
    length(language) == 1,
    tolower(language) %in% c("en", "fr")
  )

  # Ensure lowercase language
  language <- tolower(language)

  # Censor values below the provided minimum
  pm25_1hr_ugm3[pm25_1hr_ugm3 < min_allowed_pm25] <- NA

  # Calculate AQHI+
  aqhi_breakpoints <- c(-Inf, 1:10 * 10, Inf) |>
    stats::setNames(c(NA, 1:10, "+"))
  aqhi_plus <- pm25_1hr_ugm3 |>
    cut(
      breaks = aqhi_breakpoints,
      labels = names(aqhi_breakpoints)[-1]
    )

  # Early return if AQHI+ is all thats desired
  if (!detailed) {
    return(aqhi_plus)
  }

  # Get the associated risk level (low, moderate, high, very high))
  risk <- aqhi_plus |> get_risk_category(language = language)

  # Combine and return
  dplyr::tibble(
    pm25_1hr_ugm3 = pm25_1hr_ugm3,
    level = aqhi_plus,
    colour = aqhi_plus |> get_aqhi_colours(),
    risk = risk,
    # High risk pop + general pop health warnings
    risk |>
      get_health_messages(language = language) |>
      dplyr::select(-"risk_category")
  )
}
