#' Generate a square signal
#'
#' Generates a piecewise constant signal over the integer domain from zero to
#' `num_points - 1`. The signal takes `start_height` outside the requested
#' interval and `signal_height` inside it, including both endpoints.
#'
#' @param start_end_signal Numeric vector of two integer domain indices:
#'   `c(start, end)`. Both endpoints are included.
#' @param start_height Single finite number used outside the signal interval.
#' @param signal_height Single finite number used inside the signal interval.
#' @param num_points Positive integer giving the number of domain points.
#'
#' @return A numeric vector of length `num_points`, with values corresponding
#'   to domain points from zero to `num_points - 1`.
#' @examples
#' signal <- square_signal(
#'   start_end_signal = c(2, 5), start_height = 0,
#'   signal_height = 3, num_points = 8
#' )
#' signal # 0 0 3 3 3 3 0 0
#' @export
square_signal <- function(start_end_signal, start_height, signal_height,
                          num_points) {
  if (!is.numeric(num_points) || is.complex(num_points) ||
      length(num_points) != 1L || !is.finite(num_points) ||
      num_points < 1 || num_points != floor(num_points) ||
      num_points > .Machine$integer.max) {
    stop("num_points must be a positive integer", call. = FALSE)
  }
  num_points <- as.integer(num_points)

  if (!is.numeric(start_end_signal) || is.complex(start_end_signal) ||
      length(start_end_signal) != 2L || any(!is.finite(start_end_signal)) ||
      any(start_end_signal != floor(start_end_signal))) {
    stop("start_end_signal must contain two finite integer indices",
         call. = FALSE)
  }
  if (start_end_signal[1] < 0 || start_end_signal[2] > num_points - 1L) {
    stop("start_end_signal indices must be between 0 and num_points - 1",
         call. = FALSE)
  }
  if (start_end_signal[1] > start_end_signal[2]) {
    stop("the start index must be less than or equal to the end index",
         call. = FALSE)
  }

  validate_height <- function(x, name) {
    if (!is.numeric(x) || is.complex(x) || length(x) != 1L ||
        !is.finite(x)) {
      stop(name, " must be a single finite number", call. = FALSE)
    }
    x
  }
  start_height <- validate_height(start_height, "start_height")
  signal_height <- validate_height(signal_height, "signal_height")

  signal <- rep(start_height, num_points)
  start <- as.integer(start_end_signal[1]) + 1L
  end <- as.integer(start_end_signal[2]) + 1L
  signal[start:end] <- signal_height

  return(signal)
}
