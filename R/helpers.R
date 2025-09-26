# Vectorized rolling mean # TODO: replace with handyr::rolling once handyr is on CRAN
roll_mean <- function(
  x,
  width = 3,
  direction = "backward",
  fill = NULL,
  min_non_na = 0
) {
  rolling_sum <- x |>
    roll_sum(
      width = width,
      direction = direction,
      fill = fill,
      min_non_na = min_non_na,
      .include_counts = TRUE
    )
  n_non_missing <- attr(rolling_sum, "n_non_missing")
  n_non_missing <- ifelse(n_non_missing == 0, NA, n_non_missing)
  as.numeric(rolling_sum) / n_non_missing
}

# Vectorized rolling sum # TODO: remove once handyr is on CRAN
roll_sum <- function(
  x,
  width = 3,
  direction = "backward",
  fill = NULL,
  min_non_na = 0,
  .include_counts = FALSE
) {
  value_matrix <- x |>
    build_roll_matrix(
      width = width,
      direction = direction,
      fill = fill
    )
  n_non_missing <- width - rowSums(is.na(value_matrix))
  rolling_sum <- rowSums(value_matrix, na.rm = TRUE)
  rolling_sum[n_non_missing < min_non_na] <- NA

  if (.include_counts) {
    n_possible <- rep(width, length(x))
    n_possible[1:width] <- 1:width
    attr(rolling_sum, "n") <- n_possible
    attr(rolling_sum, "n_non_missing") <- n_non_missing
  }

  if (!is.null(fill)) {
    if (direction == "backward") {
      rolling_sum[1:(width - 1)] <- fill
    } else if (direction == "forward") {
      rolling_sum[(length(x) - width + 1):length(x)] <- fill
    }
  }

  return(rolling_sum)
}

# Make lag/lead matrix for rolling functions # TODO: remove once handyr is on CRAN
build_roll_matrix <- function(x, width = 3, direction = "backward", fill = NA) {
  fill <- ifelse(is.null(fill), NA, fill)
  value_matrix <- matrix(fill, nrow = length(x), ncol = width)
  for (i in 0:(width - 1)) {
    if (direction == "backward") {
      value_matrix[(i + 1):length(x), i + 1] <- x[1:(length(x) - i)]
    } else if (direction == "forward") {
      value_matrix[1:(length(x) - i), i + 1] <- x[(i + 1):length(x)]
    } else {
      # TODO: implement center
      stop("direction must be 'backward' or 'forward'")
    }
  }
  return(value_matrix)
}
