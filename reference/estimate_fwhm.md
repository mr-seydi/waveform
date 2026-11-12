# Estimate the FWHM of a residual random field

Estimates smoothness from functional curves sampled at equally spaced
evaluation points. The curves are centered pointwise to estimate
residuals for a single group. For multiple groups, provide residual
curves after subtracting each group's estimated mean function.

## Usage

``` r
estimate_fwhm(R)
```

## Arguments

- R:

  Finite numeric matrix of curves, with evaluation points in rows and
  curves in columns. At least two curves and two evaluation points are
  required. The domain is assumed to have unit spacing.

## Value

A single positive number giving the estimated global FWHM, in
evaluation-point units.

## Details

At each evaluation point `t`, the local derivative ratio is
`lambda(t) = SS[r_derivative(t)] / SS[r(t)]`, where sums of squares are
taken across curves. The local FWHM is `sqrt(4 * log(2) / lambda(t))`.
The returned global estimate is the reciprocal of the mean resels per
node, `1 / mean(sqrt(lambda(t) / (4 * log(2))))`, over points with
nonzero residual sum of squares.

## Examples

``` r
set.seed(123)
generated <- gaussian_curves_generator(
  sample_size = 5,  # number of curves
  num_points = 101, # evaluation points per curve
  mu = 0,           # target mean
  sig = 1,          # target standard deviation
  fwhm = 20         # smoothing FWHM used to generate the curves
)
estimate_fwhm(R = generated$curves)
#> [1] 17.46428
```
