#' Get the risk category for each AQHI level
#'
#' @param aqhi_levels A vector of AQHI levels (1-10 or "+").
#' @inheritParams AQHI
#'
#' @return A factor of risk categories (Low, Moderate, High, Very High) for each AQHI level.
#' @export
#' @examples
#' get_risk_category(1:10)
#' get_risk_category(1:10, language = "fr")
get_risk_category <- function(aqhi_levels, language = "en") {
  stopifnot(
    is.factor(aqhi_levels) |
      is.character(aqhi_levels) |
      is.numeric(aqhi_levels) |
      all(is.na(aqhi_levels)),
    length(aqhi_levels) > 0,
    as.character(aqhi_levels) %in% c(1:10, "+", NA)
  )
  stopifnot(tolower(language) %in% c("en", "fr"), length(language) == 1)

  # Extract language-specific risk categories
  language <- tolower(language)
  risk_categories <- AQHI_risk_categories[[language]]

  # Repeat each risk category for each AQHI level within it
  aqhi_labels <- risk_categories |>
    seq_along() |>
    sapply(
      \(i) names(risk_categories)[i] |> rep(length(risk_categories[[i]]))
    )

  # Convert to factor with categories as labels
  aqhi_levels |>
    factor(
      levels = unlist(risk_categories),
      labels = unlist(aqhi_labels)
    )
}
