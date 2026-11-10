#' Evaluate curves on a new grid using a B-spline basis
#'
#' Converts discretely sampled curves to functional data with an fda
#' B-spline basis, then evaluates the fitted functions at an evenly spaced
#' grid over the original domain. The output grid may be denser or sparser than
#' the input grid. Input and output matrices have
#' evaluation points in rows and curves in columns.
#'
#' @param data Finite numeric matrix with at least two evaluation points in
#'   rows and one curve per column.
#' @param num_evaluation Integer of at least two giving the number of points in
#'   the output grid.
#'
#' @return A numeric matrix with `num_evaluation` rows and one column per input
#'   curve.
#' @examples
#' set.seed(123)
#' generated <- gaussian_curves_generator(
#'   sample_size = 5,  # number of curves
#'   num_points = 101, # original evaluation points per curve
#'   mu = 0,           # target mean
#'   sig = 1,          # target standard deviation
#'   fwhm = 20         # smoothing FWHM used to generate the curves
#' )
#' dense_curves <- dense_data(data = generated$curves, num_evaluation = 200)
#' dim(dense_curves) # 200 5
#' @export
dense_data <- function(data, num_evaluation) {
  if (!is.matrix(data) || !is.numeric(data) || is.complex(data) ||
      nrow(data) < 2L || ncol(data) < 1L || any(!is.finite(data))) {
    stop(
      "data must be a finite numeric matrix with at least two rows and one column",
      call. = FALSE
    )
  }

  if (!is.numeric(num_evaluation) || is.complex(num_evaluation) ||
      length(num_evaluation) != 1L || !is.finite(num_evaluation) ||
      num_evaluation < 2 || num_evaluation != floor(num_evaluation) ||
      num_evaluation > .Machine$integer.max) {
    stop("num_evaluation must be an integer of at least two", call. = FALSE)
  }
  num_evaluation <- as.integer(num_evaluation)

  if (num_evaluation > .Machine$integer.max / ncol(data)) {
    stop("the requested output matrix is too large", call. = FALSE)
  }

  argvals <- seq.int(from = 0L, to = nrow(data) - 1L)
  basis <- fda::create.bspline.basis(argvals)
  fd_data <- fda::Data2fd(argvals = argvals, y = data, basisobj = basis)

  rangeval <- fd_data$basis$rangeval
  evaluation_grid <- seq(
    from = rangeval[1],
    to = rangeval[2],
    length.out = num_evaluation
  )
  evaluated <- fda::eval.fd(fdobj = fd_data, evalarg = evaluation_grid)
  evaluated <- matrix(evaluated, nrow = num_evaluation, ncol = ncol(data))

  return(evaluated)
}
