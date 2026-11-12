# Generate random Gaussian curves and pointwise summaries

Generates standardized Gaussian white noise curves, smooths them, and
returns the curves with their pointwise mean and sample standard
deviation across curves. When only one curve is generated, the pointwise
mean is that curve and the pointwise sample standard deviation is
undefined, so `sd` contains `NA` values.

## Usage

``` r
gaussian_curves_generator(sample_size, num_points, mu, sig, fwhm)
```

## Arguments

- sample_size:

  Positive integer giving the number of curves to generate.

- num_points:

  Positive integer giving the number of evaluation points per curve.

- mu:

  A finite number, or a numeric vector with one target mean per
  evaluation point. A scalar is used at every point and for every curve.

- sig:

  A positive finite number, or a numeric vector with one target standard
  deviation per evaluation point. A scalar is used at every point and
  for every curve.

- fwhm:

  Positive finite scalar giving the full width at half maximum used for
  smoothing.

## Value

A list with three components: `curves`, a matrix with evaluation points
in rows and curves in columns; `sd`, the pointwise sample standard
deviation across curves; and `mean`, the pointwise mean across curves.

## Examples

``` r
set.seed(123)
result <- gaussian_curves_generator(
  sample_size = 5, num_points = 100, mu = 0, sig = 1, fwhm = 4
)
dim(result$curves) # 100 5
#> [1] 100   5

# The target mean and SD can vary across evaluation points.
varied <- gaussian_curves_generator(
  sample_size = 3, num_points = 100,
  mu = seq(-1, 1, length.out = 100),
  sig = seq(0.5, 1.5, length.out = 100), fwhm = 4
)
dim(varied$curves) # 100 3
#> [1] 100   3

one_curve <- gaussian_curves_generator(
  sample_size = 1, num_points = 100, mu = 0, sig = 1, fwhm = 4
)
all(is.na(one_curve$sd)) # TRUE
#> [1] TRUE
identical(unname(one_curve$mean), unname(one_curve$curves[, 1])) # TRUE
#> [1] TRUE
```
