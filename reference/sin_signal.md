# Generate a sine signal

Generates a sine curve over the integer domain from zero to
`num_points - 1`. Frequency is measured in cycles per domain unit and
phase in radians.

## Usage

``` r
sin_signal(
  num_points,
  amplitude = 1,
  frequency = 1/num_points,
  phase = 0,
  offset = 0
)
```

## Arguments

- num_points:

  Positive integer giving the number of domain points.

- amplitude:

  Finite number setting the oscillation amplitude.

- frequency:

  Finite number of cycles per domain unit. Defaults to `1 / num_points`,
  approximately one cycle across the domain.

- phase:

  Finite phase shift in radians.

- offset:

  Finite vertical offset added to the curve.

## Value

A list with `signal_values`, the sine signal at each domain point, and
`domain`, the integer values from zero to `num_points - 1`.

## Examples

``` r
signal <- sin_signal(num_points = 101, amplitude = 2, frequency = 0.05,
                     phase = 0, offset = 1)
length(signal$signal_values) # 101
#> [1] 101
```
