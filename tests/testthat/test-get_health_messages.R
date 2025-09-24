test_that("expected output returned", {
  risk_categories_en <- AQHI_health_messages$en$risk_category
  risk_categories_fr <- AQHI_health_messages$fr$risk_category
  expected_en <- AQHI_health_messages$en
  expected_fr <- AQHI_health_messages$fr

  result_en <- get_health_messages(risk_categories_en, language = "en")
  result_fr <- get_health_messages(risk_categories_fr, language = "fr")

  expect_equal(result_en, expected_en)
  expect_equal(result_fr, expected_fr)
})
