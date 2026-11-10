#' Generate a cosine signal
#'
#' Generates a cosine curve over the integer domain from zero to
#' `num_points - 1`. Frequency is measured in cycles per domain unit and phase
#' in radians.
#'
#' @inheritParams sin_signal
#' @return A list with `signal_values`, the cosine signal at each domain point,
#'   and `domain`, the integer values from zero to `num_points - 1`.
#' @examples
#' signal <- cos_signal(num_points = 101, amplitude = 2, frequency = 0.05,
#'                      phase = 0, offset = 1)
#' length(signal$signal_values) # 101
#' @export
cos_signal <- function(num_points, amplitude = 1, frequency = 1 / num_points,
                       phase = 0, offset = 0) {
  make_trigonometric_signal(
    num_points = num_points,
    amplitude = amplitude,
    frequency = frequency,
    phase = phase,
    offset = offset,
    wave = cos
  )
}
