# Generate a Gaussian signal curve

Generates a Gaussian-shaped signal on the integer domain from zero
through `num_points - 1`. The sampled signal is scaled so its maximum
equals `amplitude`; `sfwhm` sets its full width at half maximum.

## Usage

``` r
gaussian_signal(center, amplitude, sfwhm, num_points)
```

## Arguments

- center:

  Single finite number giving the signal center on the domain.

- amplitude:

  Single finite number giving the signal's peak height.

- sfwhm:

  Single positive finite number giving the signal's full width at half
  maximum.

- num_points:

  Positive integer giving the number of domain points.

## Value

A list with `signal_values`, the Gaussian signal at each domain point,
and `domain`, the integer values from zero to `num_points - 1`.

## Examples

``` r
signal <- gaussian_signal(center = 50, amplitude = 2, sfwhm = 12,
                          num_points = 101)
length(signal$signal_values) # 101
#> [1] 101
range(signal$domain) # 0 100
#> [1]   0 100
```
