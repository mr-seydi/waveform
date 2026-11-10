#' Smooth Gaussian white noise curves
#'
#' Smooths the curves in a matrix produced by [gaussian_swn()], then shifts
#' and scales them to the requested mean and standard deviation. The same
#' input data can be passed with different `fwhm` values to compare smoothness.
#'
#' @param data A finite numeric matrix with evaluation points in rows and
#'   curves in columns, such as the output of [gaussian_swn()].
#' @param mu Single finite number giving the target mean for all curves.
#' @param sig Single positive finite number giving the target standard
#'   deviation for all curves.
#' @param fwhm Positive finite scalar giving the full width at half maximum
#'   used for smoothing.
#'
#' @return A numeric matrix with the same dimensions as `data`: evaluation
#'   points in rows and curves in columns.
#' @examples
#' set.seed(123)
#' noise <- gaussian_swn(number_of_curves = 3, num_points = 100)
#' smooth_2 <- smooth_gaussian_curves(noise, mu = 0, sig = 1, fwhm = 2)
#' smooth_8 <- smooth_gaussian_curves(noise, mu = 0, sig = 1, fwhm = 8)
#' dim(smooth_2) # 100 3
#' dim(smooth_8) # 100 3
#' @export
smooth_gaussian_curves <- function(data, mu, sig, fwhm) {
  if (!is.matrix(data) || !is.numeric(data) || is.complex(data) ||
      nrow(data) < 1L || ncol(data) < 1L || any(!is.finite(data))) {
    stop("data must be a non-empty finite numeric matrix", call. = FALSE)
  }

  if (!is.numeric(mu) || is.complex(mu) || length(mu) != 1L ||
      !is.finite(mu)) {
    stop("mu must be a single finite number", call. = FALSE)
  }

  if (!is.numeric(sig) || is.complex(sig) || length(sig) != 1L ||
      !is.finite(sig) || sig <= 0) {
    stop("sig must be a single positive finite number", call. = FALSE)
  }

  if (!is.numeric(fwhm) || is.complex(fwhm) || length(fwhm) != 1L ||
      !is.finite(fwhm) || fwhm <= 0) {
    stop("fwhm must be a single positive finite number", call. = FALSE)
  }

  # gaussian_filter1d operates on curves in rows, so transpose the input.
  smoothed_data <- gaussian_filter1d(t(data), fwhm)

  # Rescale the smoothed field to unit variance, then apply mu and sig.
  nNodes <- ncol(smoothed_data)
  SD <- fwhm_to_sigma(fwhm)
  scale_factor <- set_scale(nNodes, SD)
  smoothed_data_scaled <- smoothed_data * scale_factor

  n_curves <- nrow(smoothed_data_scaled)
  n_points <- ncol(smoothed_data_scaled)
  smoothed_data_final <- smoothed_data_scaled *
    sig + mu

  # Return evaluation points in rows and curves in columns, like gaussian_swn().
  return(t(smoothed_data_final))
}
