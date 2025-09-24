#' Get health messages for AQHI+ risk categories
#'
#' @param risk_categories A factor or character vector of AQHI+ risk categories (Low, Moderate, High, Very High).
#' @inheritParams AQHI
#'
#' @return A data frame of health messages (for at risk population and general population) for the AQHI+ risk categories.
#' @export
#' @examples
#' get_health_messages(c("Low", "Moderate", "High", "Very High"))
#' get_health_messages(c("Low", "Moderate", "High", "Very High"), language = "fr")
get_health_messages <- function(risk_categories, language = "en") {
  stopifnot(
    is.factor(risk_categories) |
      is.character(risk_categories) |
      all(is.na(risk_categories)),
    length(risk_categories) > 0,
    all(
      as.character(risk_categories) %in%
        c(dplyr::bind_rows(AQHI_health_messages)$risk_category, NA)
    )
  )
  stopifnot(tolower(language) %in% c("en", "fr"), length(language) == 1)

  # Extract language-specific messages
  language <- tolower(language)
  aqhi_messaging <- AQHI_health_messages[[language]]

  # Match risk categories to messages
  rows <- risk_categories |> match(aqhi_messaging$risk_category)
  aqhi_messaging[rows, ]
}
