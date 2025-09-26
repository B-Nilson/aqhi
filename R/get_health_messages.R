#' Get health messages for AQHI+ risk categories
#' 
#' @description
#' 
#' Health messages for at risk population and general population are available for each AQHI health risk category (see \code{\link{get_risk_category}}).
#' 
#' English messages:
#' 
#' | Risk | AQHI | At Risk Population | General Population |
#' | --- | --- | --- | --- |
#' | Low | 1 - 3 | Enjoy your usual outdoor activities. | Ideal air quality for outdoor activities. |
#' | Moderate | 4 - 6 | Consider reducing or rescheduling strenuous activities outdoors if you are experiencing symptoms. | No need to modify your usual outdoor activities unless you experience symptoms such as coughing and throat irritation. |
#' | High | 7 - 10 | Reduce or reschedule strenuous activities outdoors. Children and the elderly should also take it easy. | Consider reducing or rescheduling strenuous activities outdoors if you experience symptoms such as coughing and throat irritation. |
#' | Very High | >10 | Avoid strenuous activities outdoors. Children and the elderly should also avoid outdoor physical exertion. | Reduce or reschedule strenuous activities outdoors, especially if you experience symptoms such as coughing and throat irritation. |
#' 
#' See \href{https://www.canada.ca/en/environment-climate-change/services/air-quality-health-index/about.html}{Environment and Climate Change Canada's website} for more information.
#'
#' @param risk_categories A factor or character vector of AQHI+ risk categories (Low, Moderate, High, Very High).
#' @inheritParams AQHI
#'
#' @return A data frame of health messages (for at risk population and general population) for the AQHI+ risk categories.
#' @export
#' @examples
#' # Get health messages for all risk categories
#' get_health_messages()
#' 
#' # The same, but en Francais
#' get_health_messages(language = "fr")
#' 
#' # Get health messages for some observations
#' hourly_pm25_ugm3 <- sample(1:100, 50, replace = TRUE)
#' risk_categories <- hourly_pm25_ugm3 |> 
#'   AQHI_plus(detailed = FALSE) |> 
#'   get_risk_category()
#' risk_categories |> get_health_messages()
get_health_messages <- function(risk_categories = c("Low", "Moderate", "High", "Very High"), language = "en") {
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

AQHI_health_messages <- list(
  en = dplyr::tibble(
    risk_category = c("Low", "Moderate", "High", "Very High"),
    high_risk_pop_message = c(
      "Enjoy your usual activities.",
      "Consider reducing or rescheduling activities outdoors if you experience symptoms.",
      "Reduce or reschedule activities outdoors.",
      "Avoid strenuous activity outdoors."
    ),
    general_pop_message = c(
      "Ideal air quality for outdoor activities.",
      "No need to modify your usual activities unless you experience symptoms.",
      "Consider reducing or rescheduling activities outdoors if you experience symptoms.",
      "Reduce or reschedule activities outdoors, especially if you experience symptoms."
    )
  ),
  fr = dplyr::tibble(
    risk_category = c(
      "Faible",
      "Mod\u00e9r\u00e9",
      "Elev\u00e9",
      "Tr\u00e8s Elev\u00e9"
    ),
    high_risk_pop_message = c(
      "Profitez des activit\u00e9s ext\u00e9rieures habituelles.",
      "Envisagez de r\u00e9duire ou de reporter les activit\u00e9s ext\u00e9rieures en plein air si vous \u00e9prouvez des sympt\u00f4mes.",
      "R\u00e9duisez ou r\u00e9organisez les activit\u00e9s ext\u00e9rieures en plein air.",
      " \u00c9vitez les activit\u00e9s ext\u00e9rieures en plein air."
    ),
    general_pop_message = c(
      "Qualit\u00e9 de l'air id\u00e9ale pour les activit\u00e9s en plein air.",
      "Aucun besoin de modifier vos activit\u00e9s habituelles en plein air \u00e0 moins d'\u00e9prouver des sympt\u00f4mes comme la toux ou une irritation de la gorge.",
      "Envisagez de r\u00e9duire ou de reporter les activit\u00e9s ext\u00e9rieures en plein air si vous \u00e9prouvez des sympt\u00f4mes.",
      "R\u00e9duisez ou r\u00e9organisez les activit\u00e9s ext\u00e9rieures en plein air, surtout si vous \u00e9prouvez des sympt\u00f4mes comme la toux ou une irritation de la gorge."
    )
  )
)
