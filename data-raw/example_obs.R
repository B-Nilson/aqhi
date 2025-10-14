## code to prepare `example_obs` dataset goes here
rlang::check_installed("airquality")

raw_obs <- airquality::get_bcgov_data(
  date_range = c("2018-01-01 00:00:00", "2018-12-31 23:00:00"),
  variables = c("pm25", "o3", "no2"),
  quiet = TRUE
)

desired_cols <- c(
  "site_id",
  "date_utc",
  "pm25_1hr",
  "o3_1hr",
  "no2_1hr"
)

example_obs <- raw_obs |>
  dplyr::select(dplyr::all_of(desired_cols)) |>
  na.omit() |>
  dplyr::filter(length(.data$date_utc) > (365 * 0.8 * 24), .by = "site_id") |>
  dplyr::mutate(
    site_id = .data$site_id |>
      factor() |>
      as.integer()
  )

usethis::use_data(example_obs, overwrite = TRUE)
