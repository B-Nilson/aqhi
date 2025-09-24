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
