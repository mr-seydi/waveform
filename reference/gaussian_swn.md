# Generate standardized Gaussian white noise curves

Generates independent standard normal values arranged into curves. Each
column is one curve and each row is one evaluation point.

## Usage

``` r
gaussian_swn(number_of_curves, num_points)
```

## Arguments

- number_of_curves:

  Positive integer giving the number of curves.

- num_points:

  Positive integer giving the number of evaluation points in each curve.

## Value

A numeric matrix with `num_points` rows and `number_of_curves` columns.
Each column is a curve; values are independent draws from a standard
normal distribution.
