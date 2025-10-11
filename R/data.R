#' Hourly Air Quality Observations from the BC Government
#'
#' @description
#' A real example of hourly qaqced air pollutant concentrations for calculating AQHI and AQHI+.
#' Data were collected using `airquality::get_bcgov_data(stations = "all")` for the period 2018-01-01 00:00:00 to 2018-12-31 23:00:00 (PST).
#' QA/QC performed by the data provider.
#' Any missing values were omitted, and site ids were anonymized.
#'
#' @format ## `example_obs`
#' A data frame with 307,586 rows and 5 columns:
#' \describe{
#'   \item{site_id}{Anonymized monitoring site identifier}
#'   \item{date_utc}{Time-ending date of observation (tz = UTC)}
#'   \item{pm25_1hr, o3_1hr, no2_1hr}{Hourly air pollutant concentrations for the AQHI constituents with units set to \ifelse{html}{\out{&mu;g m<sup>-3</sup>}}{\eqn{ug m^{-3}}} or ppb}
#' }
#' @source <https://github.com/B-Nilson/airquality/>
"example_obs"