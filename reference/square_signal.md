# Generate a square signal

Generates a piecewise constant signal over the integer domain from zero
to `num_points - 1`. The signal takes `start_height` outside the
requested interval and `signal_height` inside it, including both
endpoints.

## Usage

``` r
square_signal(start_end_signal, start_height, signal_height, num_points)
```

## Arguments

- start_end_signal:

  Numeric vector of two integer domain indices: `c(start, end)`. Both
  endpoints are included.

- start_height:

  Single finite number used outside the signal interval.

- signal_height:

  Single finite number used inside the signal interval.

- num_points:

  Positive integer giving the number of domain points.

## Value

A numeric vector of length `num_points`, with values corresponding to
domain points from zero to `num_points - 1`.

## Examples

``` r
signal <- square_signal(
  start_end_signal = c(2, 5), start_height = 0,
  signal_height = 3, num_points = 8
)
signal # 0 0 3 3 3 3 0 0
#> [1] 0 0 3 3 3 3 0 0
```
