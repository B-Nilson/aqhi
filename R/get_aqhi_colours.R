#' Get AQHI colours for each AQHI level
#'
#' @param aqhi_levels (Optional).
#'   A character or factor vector of AQHI levels (1-10, "+", or NA).
#'   Default is all AQHI levels (1-10, "+", and NA).
#' @return A character vector of hexidecimal codes correspoding to each AQHI level.
#' @export
#' @examples
#' get_aqhi_colours()
#' 
#' 1:100 |> AQHI_plus(detailed = FALSE) |> get_aqhi_colours()
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
    factor(levels = unique(unlist(AQHI_risk_categories))) |> 
    as.numeric()

  # Replace missing AQHI levels with 12 (missing)
  aqhi_levels[is.na(aqhi_levels)] <- 12

  # Match up AQHI levels with colours
  AQHI_colours[aqhi_levels]
}
