test_that("expected output returned", {
  colours <- get_aqhi_colours()
  expected <- c(
    "#21C6F5",
    "#189ACA",
    "#0D6797",
    "#FFFD37",
    "#FFCC2E",
    "#FE9A3F",
    "#FD6769",
    "#FF3B3B",
    "#FF0101",
    "#CB0713",
    "#650205",
    "#bbbbbb"
  )

  expect_equal(colours, expected)
})

test_that("types work", {
  expected <- c(
    "#21C6F5",
    "#189ACA",
    "#0D6797",
    "#FFFD37",
    "#FFCC2E",
    "#FE9A3F",
    "#FD6769",
    "#FF3B3B",
    "#FF0101",
    "#CB0713",
    "#650205",
    "#bbbbbb"
  )

  # Get AQHI colours for observation data
  hourly_pm25_ugm3 <- c(1:11 * 10, NA)
  aqhi_levels <- hourly_pm25_ugm3 |>
    AQHI_plus(detailed = FALSE)
  aqhi_levels |> get_aqhi_colours() |> expect_equal(expected)

  # The same but with PM2.5 provided
  hourly_pm25_ugm3 |>
    get_aqhi_colours(types = "pm25_1hr") |>
    expect_equal(expected)

  # Or even a mix
  values <- c(aqhi_levels, hourly_pm25_ugm3)
  types <- rep("aqhi", length(aqhi_levels)) |>
    c(rep("pm25_1hr", length(hourly_pm25_ugm3)))

  values |>
    get_aqhi_colours(types = types) |>
    expect_equal(c(expected, expected))
})
