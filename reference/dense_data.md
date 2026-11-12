# Evaluate curves on a new grid using a B-spline basis

Converts discretely sampled curves to functional data with an fda
B-spline basis, then evaluates the fitted functions at an evenly spaced
grid over the original domain. The output grid may be denser or sparser
than the input grid. Input and output matrices have evaluation points in
rows and curves in columns.

## Usage

``` r
dense_data(data, num_evaluation)
```

## Arguments

- data:

  Finite numeric matrix with at least two evaluation points in rows and
  one curve per column.

- num_evaluation:

  Integer of at least two giving the number of points in the output
  grid.

## Value

A numeric matrix with `num_evaluation` rows and one column per input
curve.

## Details

The input domain is assumed to be the equally spaced sequence from zero
to `nrow(data) - 1`. The B-spline basis is created from that domain and
passed explicitly to
[`fda::Data2fd()`](https://rdrr.io/pkg/fda/man/Data2fd.html).

## Examples

``` r
set.seed(123)
generated <- gaussian_curves_generator(
  sample_size = 5,  # number of curves
  num_points = 101, # original evaluation points per curve
  mu = 0,           # target mean
  sig = 1,          # target standard deviation
  fwhm = 20         # smoothing FWHM used to generate the curves
)
dense_curves <- dense_data(data = generated$curves, num_evaluation = 200)
dim(dense_curves) # 200 5
#> [1] 200   5
```
