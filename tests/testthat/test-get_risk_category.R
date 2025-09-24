test_that("expected output returned", {
  # Define test cases
  aqhi_levels <- list(
    c(1:10, "+"),
    c(NA, 1:10, "+"),
    1:10,
    "+",
    NA,
    c(1:10, "+") |> factor(levels = c(1:10, "+"))
  )

  # Expected output for initial case
  expected <- c("Low", "Moderate") |>
    rep(each = 3) |>
    c(rep("High", 4), "Very High") |>
    factor(levels = names(AQHI_risk_categories$en))

  results <- lapply(aqhi_levels, get_risk_category)

  expect_equal(results[[1]], expected)
  expect_equal(
    results[[2]],
    c(NA, expected) |> factor(1:4, names(AQHI_risk_categories$en))
  )
  expect_equal(results[[3]], expected[1:10])
  expect_equal(results[[4]], expected[11])
  expect_equal(results[[5]], NA |> factor(1:4, names(AQHI_risk_categories$en)))
  expect_equal(results[[6]], expected)
})
