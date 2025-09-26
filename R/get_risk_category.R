#' Get the risk category for each AQHI level
#' 
#' @description
#' AQHI levels are broken down into categories for easier communication of health risks:
#'  - Low: AQHI = 1-3
#'  - Moderate: AQHI = 4-6
#'  - High: AQHI = 7-10
#'  - Very High: AQHI = "+" (>10) 
#' 
#' Health messages for at risk population and general population are available for each risk category - see \code{\link{get_health_messages}}
#'
#' @param aqhi_levels (Optional). 
#'   A vector of AQHI levels (1-10, "+", or NA).
#'   Default is all unique levels.
#' @inheritParams AQHI
#' 
#' @references Environment and Climate Change Canada: \url{https://www.canada.ca/en/environment-climate-change/services/air-quality-health-index/about.html}
#' @return A factor of risk categories (Low, Moderate, High, Very High) representing each level of \code{aqhi_levels}.
#' @export
#' @examples
#' # Get risk categories for all AQHI levels
#' get_risk_category()
#' 
#' # The same, but en Francais
#' get_risk_category(language = "fr")
#' 
#' # Get risk categories for obervations
#' aqhi_levels <- sample(c(1:10, "+"), 50, replace = TRUE)
#' get_risk_category(aqhi_levels)
get_risk_category <- function(aqhi_levels = c(1:10, "+"), language = "en") {
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
  risk_categories <- .risk_categories[[language]]

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

.risk_categories <- list(
  en = list(
    Low = 1:3,
    Moderate = 4:6,
    High = 7:10,
    "Very High" = "+"
  ),
  fr = list(
    Faible = 1:3,
    "Mod\u00e9r\u00e9" = 4:6,
    "Elev\u00e9" = 7:10,
    "Tr\u00e8s Elev\u00e9" = "+"
  )
)
