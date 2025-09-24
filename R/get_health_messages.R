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
      "Profiter des activit\u00e9s ext\u00e9rieures habituelles.",
      "Envisagez de r\u00e9duire ou de reporter les activit\u00e9s ext\u00e9rieures en plein air si vous \u00e9prouvez des sympt\u00f4mes.",
      "R\u00e9duisez ou r\u00e9organisez les activit\u00e9s ext\u00e9rieures en plein air.",
      "\u00c9vitez les activit\u00e9s ext\u00e9rieures en plein air."
    ),
    general_pop_message = c(
      "Qualit\u00e9 de l'air id\u00e9ale pour les activit\u00e9s en plein air.",
      "Aucun besoin de modifier vos activit\u00e9s habituelles en plein air \u00e0 moins d'\u00e9prouver des sympt\u00f4mes comme la toux ou une irritation de la gorge.",
      "Envisagez de r\u00e9duire ou de reporter les activit\u00e9s ext\u00e9rieures en plein air si vous \u00e9prouvez des sympt\u00f4mes.",
      "R\u00e9duisez ou r\u00e9organisez les activit\u00e9s ext\u00e9rieures en plein air, surtout si vous \u00e9prouvez des sympt\u00f4mes comme la toux ou une irritation de la gorge."
    )
  )
)
