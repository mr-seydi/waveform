#' Generate random Gaussian curves and pointwise summaries
#'
#' Generates standardized Gaussian white noise curves, smooths them, and
#' returns the curves with their pointwise mean and sample standard deviation
#' across curves. When only one curve is generated, the pointwise mean is that
#' curve and the pointwise sample standard deviation is undefined, so `sd`
#' contains `NA` values.
#'
#' @param sample_size Positive integer giving the number of curves to generate.
#' @param num_points Positive integer giving the number of evaluation points
#'   per curve.
#' @param mu A finite number, or a numeric vector with one target mean per
#'   evaluation point. A scalar is used at every point and for every curve.
#' @param sig A positive finite number, or a numeric vector with one target
#'   standard deviation per evaluation point. A scalar is used at every point
#'   and for every curve.
#' @param fwhm Positive finite scalar giving the full width at half maximum
#'   used for smoothing.
#'
#' @return A list with three components: `curves`, a matrix with evaluation
#'   points in rows and curves in columns; `sd`, the pointwise sample standard
#'   deviation across curves; and `mean`, the pointwise mean across curves.
#' @examples
#' set.seed(123)
#' result <- gaussian_curves_generator(
#'   sample_size = 5, num_points = 100, mu = 0, sig = 1, fwhm = 4
#' )
#' dim(result$curves) # 100 5
#'
#' # The target mean and SD can vary across evaluation points.
#' varied <- gaussian_curves_generator(
#'   sample_size = 3, num_points = 100,
#'   mu = seq(-1, 1, length.out = 100),
#'   sig = seq(0.5, 1.5, length.out = 100), fwhm = 4
#' )
#' dim(varied$curves) # 100 3
#'
#' one_curve <- gaussian_curves_generator(
#'   sample_size = 1, num_points = 100, mu = 0, sig = 1, fwhm = 4
#' )
#' all(is.na(one_curve$sd)) # TRUE
#' identical(unname(one_curve$mean), unname(one_curve$curves[, 1])) # TRUE
#' @export
gaussian_curves_generator <- function(sample_size, num_points, mu, sig, fwhm) {
  curves <- gaussian_swn(
    number_of_curves = sample_size,
    num_points = num_points
  )
  curves <- smooth_gaussian_curves(
    data = curves,
    mu = mu,
    sig = sig,
    fwhm = fwhm
  )

  pointwise_mean <- rowMeans(curves)
  pointwise_sd <- if (ncol(curves) == 1L) {
    rep(NA_real_, nrow(curves))
  } else {
    apply(curves, 1L, stats::sd)
  }

  return(list(curves = curves, sd = pointwise_sd, mean = pointwise_mean))
}
