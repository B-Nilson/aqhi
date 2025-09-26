#' Get AQHI colours for each AQHI level
#' 
#' @description
#' Every AQHI level (1-10, "+", and NA) is assigned a hexidecimal colour code for visualization.
#' 
#' These colours are defined by \href{https://www.canada.ca/en/environment-climate-change/services/air-quality-health-index/about.html}{Environment and Climate Change Canada} such that:
#' - Low AQHI (1-3) are light to dark blue
#' - Moderate AQHI (4-6) are yellow to orange
#' - High AQHI (7-10) are light to dark red
#' - Very High AQHI (+) is darker red
#' - Missing AQHI (NA) is light grey
#'
#' @param aqhi_levels (Optional).
#'   A character or factor vector of AQHI levels (1-10, "+", or NA).
#'   Default is all AQHI levels (1-10, "+", and NA).
#' @references Environment and Climate Change Canada: \url{https://www.canada.ca/en/environment-climate-change/services/air-quality-health-index/about.html}
#' @return A character vector of hexidecimal codes correspoding to each AQHI level.
#' @export
#' @examples
#' # Get AQHI colours for all AQHI levels
#' get_aqhi_colours()
#'
#' # Get AQHI colours for obervation data
#' hourly_pm25_ugm3 <- sample(1:100, 50, replace = TRUE)
#' aqhi_levels <- hourly_pm25_ugm3 |> 
#'   AQHI_plus(detailed = FALSE)
#' aqhi_levels |> get_aqhi_colours()
get_aqhi_colours <- function(aqhi_levels = c(1:10, "+", NA)) {
  stopifnot(
    is.factor(aqhi_levels) |
      is.character(aqhi_levels) |
      is.numeric(aqhi_levels) |
      all(is.na(aqhi_levels)),
    length(aqhi_levels) > 0
  )

  # Define colours
  AQHI_colours <- c(
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

  # Ensure aqhi_levels is a factor with correct levels, then convert to numeric
  aqhi_levels <- aqhi_levels |>
    factor(levels = unique(unlist(.risk_categories))) |>
    as.numeric()

  # Replace missing AQHI levels with 12 (missing)
  aqhi_levels[is.na(aqhi_levels)] <- 12

  # Match up AQHI levels with colours
  AQHI_colours[aqhi_levels]
}
