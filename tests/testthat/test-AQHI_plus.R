test_that("AQHI+ returns expected output", {
  pm25_hourly <- c(NA, -1, 0:10 * 10, 0:10 * 10 + 0.1) |> sort(na.last = FALSE)
  expected_aqhi <- c(NA, NA, 1, rep(1:10, each = 2), "+") |> 
    factor(levels = c(1:10, "+"))

  expect_snapshot(
    pm25_hourly |> AQHI_plus(detailed = TRUE)
  )

  expect_snapshot(
    pm25_hourly |> AQHI_plus(detailed = TRUE, language = "fr")
  )
  
  AQHI_plus(pm25_hourly, detailed = FALSE) |> 
    expect_equal(expected_aqhi)
})
