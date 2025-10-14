test_that("AQHI returns expected output", {
  # TODO: need to ensure AQHI levels are accurate
  # - this includes when AQHI+ should/shouldnt override AQHI

  obs <- example_obs[example_obs$site_id == 1, ] |>
    dplyr::select(
      date = "date_utc",
      pm25 = "pm25_1hr",
      o3 = "o3_1hr",
      no2 = "no2_1hr"
    )
  # Throw some NAs in
  obs$pm25[c(1, 4, 5, 7)] <- NA
  obs$o3[c(2, 4, 5, 6)] <- NA
  obs$no2[c(3, 4, 6, 7)] <- NA

  # All 3 pollutants (AQHI and AQHI+)
  aqhi_en <- obs$date |>
    AQHI(
      pm25_1hr_ugm3 = obs$pm25,
      o3_1hr_ppb = obs$o3,
      no2_1hr_ppb = obs$no2,
      quiet = TRUE
    )
  expect_snapshot(aqhi_en)

  # French version
  aqhi_fr <- obs$date |>
    AQHI(
      pm25_1hr_ugm3 = obs$pm25,
      o3_1hr_ppb = obs$o3,
      no2_1hr_ppb = obs$no2,
      quiet = TRUE,
      language = "fr"
    )
  expect_snapshot(aqhi_fr)
  expect_equal(names(aqhi_fr), names(aqhi_en))

  # All 3 pollutants, no AQHI+ override
  aqhi_en_no_override <- obs$date |>
    AQHI(
      pm25_1hr_ugm3 = obs$pm25,
      o3_1hr_ppb = obs$o3,
      no2_1hr_ppb = obs$no2,
      quiet = TRUE,
      allow_aqhi_plus_override = FALSE
    )
  expect_snapshot(aqhi_en_no_override)
  expect_equal(names(aqhi_en_no_override), names(aqhi_en))
  expect_true(all(is.na(aqhi_en_no_override$AQHI_plus)))

  # PM2.5 only (AQHI+)
  aqhi_plus_en <- obs$date |>
    AQHI(
      pm25_1hr_ugm3 = obs$pm25,
      quiet = TRUE
    )
  expect_snapshot(aqhi_plus_en)
  expect_equal(names(aqhi_en), names(aqhi_plus_en))

  # French version
  aqhi_plus_fr <- obs$date |>
    AQHI(
      pm25_1hr_ugm3 = obs$pm25,
      quiet = TRUE,
      language = "fr"
    )
  expect_snapshot(aqhi_plus_fr)
  expect_equal(names(aqhi_fr), names(aqhi_plus_fr))
})

# TODO: add a `groups` argument that handles this cleanly
test_that("group_by works", {
  example_obs |>
    dplyr::group_by(site_id) |>
    dplyr::mutate(
      AQHI = AQHI(
        dates = .data$date_utc,
        pm25_1hr_ugm3 = .data$pm25_1hr,
        o3_1hr_ppb = .data$o3_1hr,
        no2_1hr_ppb = .data$no2_1hr,
        allow_aqhi_plus_override = TRUE,
        detailed = FALSE
      )
    ) |>
    expect_no_warning() |>
    expect_snapshot()

  example_obs |>
    dplyr::group_by(site_id) |>
    dplyr::group_split() |>
    lapply(\(site_data) {
      site_data |>
        dplyr::mutate(
          AQHI = AQHI(
            dates = .data$date_utc,
            pm25_1hr_ugm3 = .data$pm25_1hr,
            o3_1hr_ppb = .data$o3_1hr,
            no2_1hr_ppb = .data$no2_1hr,
            allow_aqhi_plus_override = TRUE,
            detailed = TRUE
          )
        )
    }) |>
    dplyr::bind_rows() |>
    expect_no_warning() |>
    expect_snapshot()
})
