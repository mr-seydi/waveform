#' Estimate the FWHM of a residual random field
#'
#' Estimates smoothness from functional curves sampled at equally spaced
#' evaluation points. The curves are centered pointwise to estimate residuals
#' for a single group. For multiple groups, provide residual curves after
#' subtracting each group's estimated mean function.
#'
#' At each evaluation point `t`, the local derivative ratio is
#' `lambda(t) = SS[r'(t)] / SS[r(t)]`, where sums of squares are taken across
#' curves. The local FWHM is `sqrt(4 * log(2) / lambda(t))`. The returned global
#' estimate is the reciprocal of the mean resels per node,
#' `1 / mean(sqrt(lambda(t) / (4 * log(2))))`, over points with nonzero
#' residual sum of squares.
#'
#' @param R Finite numeric matrix of curves, with evaluation points in rows and
#'   curves in columns. At least two curves and two evaluation points are
#'   required. The domain is assumed to have unit spacing.
#'
#' @return A single positive number giving the estimated global FWHM, in
#'   evaluation-point units.
#' @examples
#' set.seed(123)
#' generated <- gaussian_curves_generator(
#'   sample_size = 5,  # number of curves
#'   num_points = 101, # evaluation points per curve
#'   mu = 0,           # target mean
#'   sig = 1,          # target standard deviation
#'   fwhm = 20         # smoothing FWHM used to generate the curves
#' )
#' estimate_fwhm(R = generated$curves)
#' @export
estimate_fwhm <- function(R) {
  if (!is.matrix(R) || !is.numeric(R) || is.complex(R) ||
      nrow(R) < 2L || ncol(R) < 2L || any(!is.finite(R))) {
    stop(
      "R must be a finite numeric matrix with at least two points and two curves",
      call. = FALSE
    )
  }

  # Estimate the mean function and form residual curves (points x curves).
  R <- sweep(R, 1L, rowMeans(R), "-")
  R <- t(R) # curves in rows, evaluation points in columns

  n_rows <- nrow(R)
  n_cols <- ncol(R)
  ss_residual <- colSums(R^2)

  # Approximate derivatives along the unit-spaced evaluation domain.
  dx <- matrix(NA_real_, nrow = n_rows, ncol = n_cols)
  dx[, 1L] <- R[, 2L] - R[, 1L]
  dx[, n_cols] <- R[, n_cols] - R[, n_cols - 1L]
  if (n_cols > 2L) {
    dx[, 2L:(n_cols - 1L)] <-
      (R[, 3L:n_cols, drop = FALSE] - R[, 1L:(n_cols - 2L), drop = FALSE]) / 2
  }

  ss_derivative <- colSums(dx^2)
  valid <- is.finite(ss_residual) & ss_residual > 0 &
    is.finite(ss_derivative)
  if (!any(valid)) {
    stop("FWHM cannot be estimated because residuals have no variation",
         call. = FALSE)
  }

  eps <- .Machine$double.eps
  lambda <- ss_derivative[valid] / (ss_residual[valid] + eps)
  resels_per_node <- sqrt(lambda / (4 * log(2)))
  mean_resels <- mean(resels_per_node)
  if (!is.finite(mean_resels) || mean_resels <= 0) {
    stop("FWHM cannot be estimated because residual curves do not vary over the domain",
         call. = FALSE)
  }

  return(1 / mean_resels)
}
