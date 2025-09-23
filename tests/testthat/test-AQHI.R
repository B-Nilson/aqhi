test_that("AQHI returns expected output", {
  # TODO: need to ensure AQHI levels are accurate
  # - this includes when AQHI+ should/shouldnt override AQHI

  obs <- data.frame(
    date = seq(
      as.POSIXct("2024-01-01 00:00:00"),
      as.POSIXct("2024-01-01 23:00:00"),
      "1 hours"
    ),
    pm25 = 1:24,
    o3 = 1:24,
    no2 = 1:24
  )

  # All 3 pollutants (AQHI and AQHI+)
  aqhi_en <- obs$date |>
    AQHI(
      pm25_1hr_ugm3 = obs$pm25,
      o3_1hr_ppb = obs$o3,
      no2_1hr_ppb = obs$no2,
      verbose = FALSE
    )
  expect_snapshot(aqhi_en)

  # French version
  aqhi_fr <- obs$date |>
    AQHI(
      pm25_1hr_ugm3 = obs$pm25,
      o3_1hr_ppb = obs$o3,
      no2_1hr_ppb = obs$no2,
      verbose = FALSE,
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
      verbose = FALSE,
      allow_aqhi_plus_override = FALSE
    )
  expect_snapshot(aqhi_en_no_override)
  expect_equal(names(aqhi_en_no_override), names(aqhi_en))
  expect_true(all(is.na(aqhi_en_no_override$AQHI_plus)))

  # PM2.5 only (AQHI+)
  aqhi_plus_en <- obs$date |>
    AQHI(
      pm25_1hr_ugm3 = obs$pm25,
      verbose = FALSE
    )
  expect_snapshot(aqhi_plus_en)
  expect_equal(names(aqhi_en), names(aqhi_plus_en))

  # French version
  aqhi_plus_fr <- obs$date |>
    AQHI(
      pm25_1hr_ugm3 = obs$pm25,
      verbose = FALSE,
      language = "fr"
    )
  expect_snapshot(aqhi_plus_fr)
  expect_equal(names(aqhi_fr), names(aqhi_plus_fr))
})
