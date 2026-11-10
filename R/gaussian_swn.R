#' Generate standardized Gaussian white noise curves
#'
#' Generates independent standard normal values arranged into curves. Each
#' column is one curve and each row is one evaluation point.
#'
#' @param number_of_curves Positive integer giving the number of curves.
#' @param num_points Positive integer giving the number of evaluation points
#'   in each curve.
#'
#' @return A numeric matrix with `num_points` rows and `number_of_curves`
#'   columns. Each column is a curve; values are independent draws from a
#'   standard normal distribution.
#' @export
gaussian_swn <- function(number_of_curves, num_points) {
  validate_dimension <- function(x, name) {
    if (!is.numeric(x) || is.logical(x) || is.complex(x) || length(x) != 1L ||
        is.na(x) || !is.finite(x) || x < 1 || x != floor(x)) {
      stop(name, " must be a single positive integer", call. = FALSE)
    }
    x
  }

  number_of_curves <- validate_dimension(number_of_curves, "number_of_curves")
  num_points <- validate_dimension(num_points, "num_points")

  if (number_of_curves > .Machine$integer.max / num_points) {
    stop("the requested matrix is too large", call. = FALSE)
  }

  data <- matrix(
    rnorm(number_of_curves * num_points),
    nrow = num_points,
    ncol = number_of_curves
  )
  return(data)
}
