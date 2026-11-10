sigma_to_fwhm <- function(sigma) {
  return(sigma * (2 * sqrt(2 * log(2))))
}

fwhm_to_sigma <- function(fwhm) {
  return(fwhm / (2 * sqrt(2 * log(2))))
}


# Apply this scaling factor to smoothed data to ensure unit variance.
# Adapted from the _set_scale function in power1d:
# https://github.com/0todd0000/power1d/blob/master/src/power1d/random.py#L35
set_scale <- function(nNodes, SD) {
  # Define a small epsilon to prevent division by zero.
  eps <- .Machine$double.eps

  # Define and normalize a Gaussian kernel.
  t <- seq(-0.5 * (nNodes - 1), 0.5 * (nNodes - 1), length.out = nNodes)
  gf <- exp(-(t^2) / (2 * SD^2 + eps))
  gf <- gf / sum(gf)

  # Calculate the expected variance of the smoothed data.
  AG <- fft(gf)
  Pag <- Mod(AG)^2
  COV <- Re(fft(Pag, inverse = TRUE)) / length(Pag)
  svar <- COV[1]

  # Calculate the scaling factor.
  SCALE <- sqrt(1.0 / svar)

  return(SCALE)
}

# Computes a 1-D Gaussian (or derivative) kernel.
# sigma: standard deviation
# order: 0 for the standard Gaussian, positive integers for derivatives
# radius: half-width of the kernel
# Adapted to match scipy.ndimage.gaussian_filter1d(..., mode = "wrap").
gaussian_kernel1d <- function(sigma, order = 0, radius) {
  if (order < 0) {
    stop("order must be non-negative")
  }

  # Create a grid from -radius to radius.
  x <- seq(-radius, radius)

  # Compute and normalize the basic Gaussian.
  phi_x <- exp(-0.5 * (x / sigma)^2)
  phi_x <- phi_x / sum(phi_x)

  if (order == 0) {
    return(phi_x)
  } else {
    # For derivatives, multiply the Gaussian by a polynomial.
    expo <- 0:order
    q <- numeric(order + 1)
    q[1] <- 1

    # Build the differentiation matrices D (superdiagonal) and P (subdiagonal).
    D <- matrix(0, nrow = order + 1, ncol = order + 1)
    for (i in 1:order) {
      D[i, i + 1] <- expo[i + 1]
    }
    P <- matrix(0, nrow = order + 1, ncol = order + 1)
    for (i in 2:(order + 1)) {
      P[i, i - 1] <- 1 / (-sigma^2)
    }
    Q_deriv <- D + P

    # Apply the operator repeatedly (order times).
    for (i in 1:order) {
      q <- Q_deriv %*% q
    }

    # Evaluate the polynomial at each grid point.
    poly_val <- as.vector(outer(x, expo, `^`) %*% q)
    return(poly_val * phi_x)
  }
}

# Performs 1-D correlation using periodic (wrap) boundary conditions.
# input: numeric vector
# weights: 1-D kernel, assumed to have odd length
correlate1d_wrap <- function(input, weights) {
  n <- length(input)
  k <- length(weights)
  half <- (k - 1) / 2
  result <- numeric(n)

  # Sum over the kernel using periodic indexing.
  for (i in seq_len(n)) {
    offsets <- (-half):half
    idx <- ((i - 1 + offsets) %% n) + 1
    result[i] <- sum(input[idx] * weights)
  }
  return(result)
}

# A 1-D Gaussian filter with periodic (wrap) boundary conditions.
# Arguments:
# - input: numeric vector or matrix to filter
# - fwhm: full width at half maximum
# - order: derivative order (0 means no derivative)
# - truncate: number of sigmas included in the kernel
# - radius: optional kernel half-width; otherwise round(truncate * sigma)
gaussian_filter1d <- function(input, fwhm, order = 0, truncate = 4.0, radius = NULL) {
  sigma <- fwhm_to_sigma(fwhm)
  if (!is.numeric(input)) {
    stop("input must be numeric")
  }

  # Determine kernel half-width.
  if (is.null(radius)) {
    radius <- round(truncate * sigma)
  } else if (radius < 0 || radius != as.integer(radius)) {
    stop("radius must be a nonnegative integer")
  }

  # Create the kernel and reverse it for correlation, as in SciPy.
  weights <- gaussian_kernel1d(sigma, order, radius)
  weights <- rev(weights)

  # Apply the filter using periodic (wrap) boundary conditions.
  output <- t(apply(input, 1, function(x) correlate1d_wrap(x, weights)))
  return(output)
}

amplitude_signal <- function(data, amp) {
  if (!is.numeric(data) || length(data) == 0L ||
      any(!is.finite(data)) || max(data) <= 0) {
    stop("data must contain finite numeric values with a positive maximum")
  }
  if (!is.numeric(amp) || length(amp) != 1L || !is.finite(amp)) {
    stop("amp must be a single finite number")
  }

  return(data * (amp / max(data)))
}
make_trigonometric_signal <- function(num_points, amplitude, frequency,
                                      phase, offset, wave) {
  if (!is.numeric(num_points) || is.complex(num_points) ||
      length(num_points) != 1L || !is.finite(num_points) ||
      num_points < 1 || num_points != floor(num_points) ||
      num_points > .Machine$integer.max) {
    stop("num_points must be a positive integer", call. = FALSE)
  }
  num_points <- as.integer(num_points)

  validate_finite_scalar <- function(x, name) {
    if (!is.numeric(x) || is.complex(x) || length(x) != 1L ||
        !is.finite(x)) {
      stop(name, " must be a single finite number", call. = FALSE)
    }
    x
  }
  amplitude <- validate_finite_scalar(amplitude, "amplitude")
  frequency <- validate_finite_scalar(frequency, "frequency")
  phase <- validate_finite_scalar(phase, "phase")
  offset <- validate_finite_scalar(offset, "offset")

  domain <- seq.int(from = 0L, to = num_points - 1L)
  signal_values <- offset + amplitude * wave(2 * pi * frequency * domain + phase)
  list(signal_values = signal_values, domain = domain)
}
