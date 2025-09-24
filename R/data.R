#' AQHI_colours
#'
#' A named character vector of hexidecimal codes used to represent the AQHI levels.
#'
#' @format A named character vector.
#' @source The AQHI colours were derived from \href{https://www.canada.ca/en/environment-climate-change/services/air-quality-health-index/about.html}{Environment and Climate Change Canada}.
AQHI_colours <- c(
  #Low [1 - 3]
  low_1 = "#21C6F5",
  low_2 = '#189ACA',
  low_3 = "#0D6797",
  # Moderate [4 - 6]
  mod_4 = "#FFFD37",
  mod_5 = '#FFCC2E',
  mod_6 = "#FE9A3F",
  # High [7 - 10]
  high_7 = "#FD6769",
  high_8 = "#FF3B3B",
  high_9 = "#FF0101",
  high_10 = "#CB0713",
  # Very High [+]
  very_high = "#650205",
  # Missing [-]
  missing = "#bbbbbb"
)

#' AQHI_risk_categories
#'
#' A named list of lists of the risk categories and their respective AQHI levels (one list for each language - "en" and "fr").
#'
#' @format A named list of lists of integer (or character for "Very High") vectors
#' @source \href{https://www.canada.ca/en/environment-climate-change/services/air-quality-health-index/about.html}{Environment and Climate ChangeD Canada}.
AQHI_risk_categories <- list(
  en = list(
    Low = 1:3,
    Moderate = 4:6,
    High = 7:10,
    "Very High" = "+"
  ),
  fr = list(
    Faible = 1:3,
    "Mod\u00e9r\u00e9" = 4:6,
    "Elev\u00e9"= 7:10,
    "Tr\u00e8s Elev\u00e9" = "+"
  )
)

#' AQHI_health_messages
#'
#' A named list of the health messages for the AQHI risk categories for both English ("en") and French ("fr").
#'
#' @format A namedad list of tibbles, 1 tibble per language.
#' @source \href{https://www.canada.ca/en/environment-climate-change/services/air-quality-health-index/understanding-messages.html}{Environment and Climate Change Canada}.
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
