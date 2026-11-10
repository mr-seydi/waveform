#' Generate a Gaussian signal curve
#'
#' Generates a Gaussian-shaped signal on the integer domain from zero through
#' `num_points - 1`. The sampled signal is scaled so its maximum equals
#' `amplitude`; `sfwhm` sets its full width at half maximum.
#'
#' @param center Single finite number giving the signal center on the domain.
#' @param amplitude Single finite number giving the signal's peak height.
#' @param sfwhm Single positive finite number giving the signal's full width
#'   at half maximum.
#' @param num_points Positive integer giving the number of domain points.
#'
#' @return A list with `signal_values`, the Gaussian signal at each domain
#'   point, and `domain`, the integer values from zero to `num_points - 1`.
#' @examples
#' signal <- gaussian_signal(center = 50, amplitude = 2, sfwhm = 12,
#'                           num_points = 101)
#' length(signal$signal_values) # 101
#' range(signal$domain) # 0 100
#' @export
gaussian_signal <- function(center, amplitude, sfwhm, num_points) {
  validate_finite_scalar <- function(x, name) {
    if (!is.numeric(x) || is.complex(x) || length(x) != 1L ||
        !is.finite(x)) {
      stop(name, " must be a single finite number", call. = FALSE)
    }
    x
  }

  center <- validate_finite_scalar(center, "center")
  amplitude <- validate_finite_scalar(amplitude, "amplitude")
  sfwhm <- validate_finite_scalar(sfwhm, "sfwhm")
  if (sfwhm <= 0) {
    stop("sfwhm must be positive", call. = FALSE)
  }

  if (!is.numeric(num_points) || is.complex(num_points) ||
      length(num_points) != 1L || !is.finite(num_points) ||
      num_points < 1 || num_points != floor(num_points) ||
      num_points > .Machine$integer.max) {
    stop("num_points must be a positive integer", call. = FALSE)
  }
  num_points <- as.integer(num_points)

  sigma <- fwhm_to_sigma(sfwhm)
  domain <- seq.int(from = 0L, to = num_points - 1L)
  density_val <- stats::dnorm(domain, mean = center, sd = sigma)
  signal_values <- amplitude_signal(density_val, amplitude)

  return(list(signal_values = signal_values, domain = domain))
}
