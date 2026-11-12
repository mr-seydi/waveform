#' Smooth Gaussian white noise curves
#'
#' Smooths the curves in a matrix produced by [gaussian_swn()], then shifts
#' and scales them to the requested mean and standard deviation. The same
#' input data can be passed with different `fwhm` values to compare smoothness.
#'
#' @param data A finite numeric matrix with evaluation points in rows and
#'   curves in columns, such as the output of [gaussian_swn()].
#' @param mu A finite number, or a numeric vector with one target mean per
#'   evaluation point. A scalar is used at every point and for every curve.
#' @param sig A positive finite number, or a numeric vector with one target
#'   standard deviation per evaluation point. A scalar is used at every point
#'   and for every curve.
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
#'
#' # The target mean and SD can vary across evaluation points.
#' smooth_varied <- smooth_gaussian_curves(
#'   noise,
#'   mu = seq(-1, 1, length.out = nrow(noise)),
#'   sig = seq(0.5, 1.5, length.out = nrow(noise)),
#'   fwhm = 4
#' )
#' @export
smooth_gaussian_curves <- function(data, mu, sig, fwhm) {
  if (!is.matrix(data) || !is.numeric(data) || is.complex(data) ||
      nrow(data) < 1L || ncol(data) < 1L || any(!is.finite(data))) {
    stop("data must be a non-empty finite numeric matrix", call. = FALSE)
  }

  n_points <- nrow(data)
  if (!is.numeric(mu) || is.complex(mu) ||
      !(length(mu) %in% c(1L, n_points)) || any(!is.finite(mu))) {
    stop("mu must be a finite number or have one finite value per evaluation point",
         call. = FALSE)
  }

  if (!is.numeric(sig) || is.complex(sig) ||
      !(length(sig) %in% c(1L, n_points)) || any(!is.finite(sig)) ||
      any(sig <= 0)) {
    stop("sig must be a positive finite number or have one positive finite value per evaluation point",
         call. = FALSE)
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

  smoothed_data_final <- sweep(smoothed_data_scaled, 2L, sig, `*`)
  smoothed_data_final <- sweep(smoothed_data_final, 2L, mu, `+`)

  # Return evaluation points in rows and curves in columns, like gaussian_swn().
  return(t(smoothed_data_final))
}
