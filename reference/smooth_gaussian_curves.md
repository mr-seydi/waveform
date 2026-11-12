# Smooth Gaussian white noise curves

Smooths the curves in a matrix produced by
[`gaussian_swn()`](https://mr-seydi.github.io/waveform/reference/gaussian_swn.md),
then shifts and scales them to the requested mean and standard
deviation. The same input data can be passed with different `fwhm`
values to compare smoothness.

## Usage

``` r
smooth_gaussian_curves(data, mu, sig, fwhm)
```

## Arguments

- data:

  A finite numeric matrix with evaluation points in rows and curves in
  columns, such as the output of
  [`gaussian_swn()`](https://mr-seydi.github.io/waveform/reference/gaussian_swn.md).

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

A numeric matrix with the same dimensions as `data`: evaluation points
in rows and curves in columns.

## Examples

``` r
set.seed(123)
noise <- gaussian_swn(number_of_curves = 3, num_points = 100)
smooth_2 <- smooth_gaussian_curves(noise, mu = 0, sig = 1, fwhm = 2)
smooth_8 <- smooth_gaussian_curves(noise, mu = 0, sig = 1, fwhm = 8)
dim(smooth_2) # 100 3
#> [1] 100   3
dim(smooth_8) # 100 3
#> [1] 100   3

# The target mean and SD can vary across evaluation points.
smooth_varied <- smooth_gaussian_curves(
  noise,
  mu = seq(-1, 1, length.out = nrow(noise)),
  sig = seq(0.5, 1.5, length.out = nrow(noise)),
  fwhm = 4
)
```
