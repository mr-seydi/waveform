# waveform

**waveform** is an R package for generating and working with
one-dimensional functional data. It provides Gaussian white-noise
curves, smoothed Gaussian curves, simple signal shapes, a residual-field
smoothness estimate, and tools for evaluating curves on a new grid.

**Version:** 1.1.0 · **Author:** Mohammad Reza Seydi

[Package website](https://mr-seydi.github.io/waveform/) · [Function
reference](https://mr-seydi.github.io/waveform/reference/)

## What it can do

- Generate independent standardized Gaussian white-noise curves.
- Generate a specified sample size of smoothed Gaussian curves with
  user-defined mean, standard deviation, and FWHM.
- Smooth the same noise realization with different FWHM values to
  compare smoothness directly.
- Generate Gaussian, square, sine, and cosine signals.
- Estimate the FWHM of a residual random field.
- Fit curves with an `fda` B-spline basis and evaluate them on a denser
  or sparser grid.
- Use the included male and female thorax obliquity curves as example
  data.

## Example data

The package includes thorax obliquity curves from 65 male and 71 female
participants. Each dataset has 101 evaluation points per participant.
See [`?male`](https://mr-seydi.github.io/waveform/reference/male.md) and
[`?female`](https://mr-seydi.github.io/waveform/reference/female.md) for
details and the source citation.

## Install from GitHub

Install the released source directly from GitHub with `remotes`:

``` r

install.packages("remotes")
remotes::install_github("mr-seydi/waveform")
```

The package imports [`fda`](https://cran.r-project.org/package=fda) for
functional-data fitting in
[`dense_data()`](https://mr-seydi.github.io/waveform/reference/dense_data.md).

## Data layout

Curve matrices use the same orientation throughout the package:

- **Rows are evaluation points.**
- **Columns are curves.**

Thus `gaussian_swn(number_of_curves, num_points)` returns a matrix with
`num_points` rows and `number_of_curves` columns.
[`smooth_gaussian_curves()`](https://mr-seydi.github.io/waveform/reference/smooth_gaussian_curves.md)
preserves these dimensions, and
[`dense_data()`](https://mr-seydi.github.io/waveform/reference/dense_data.md)
returns one column per input curve. In the smoothing and
curve-generation functions, `mu` and `sig` can be scalars or vectors
with one value per evaluation point; pointwise vectors are shared across
curves.

## Functions

| Function | Purpose | Output |
|----|----|----|
| [`gaussian_swn()`](https://mr-seydi.github.io/waveform/reference/gaussian_swn.md) | Generate independent standardized Gaussian white-noise curves. | Matrix: points × curves. |
| [`smooth_gaussian_curves()`](https://mr-seydi.github.io/waveform/reference/smooth_gaussian_curves.md) | Smooth a curve matrix and set its target mean and standard deviation. | Matrix with the input dimensions. |
| [`gaussian_curves_generator()`](https://mr-seydi.github.io/waveform/reference/gaussian_curves_generator.md) | Generate and smooth curves; calculate pointwise mean and standard deviation across curves. | List: `curves`, `mean`, and `sd`. |
| [`gaussian_signal()`](https://mr-seydi.github.io/waveform/reference/gaussian_signal.md) | Generate a Gaussian-shaped signal with a specified center, peak, and FWHM. | List: `signal_values` and `domain`. |
| [`square_signal()`](https://mr-seydi.github.io/waveform/reference/square_signal.md) | Generate a piecewise-constant signal over an inclusive interval. | Numeric vector. |
| [`sin_signal()`](https://mr-seydi.github.io/waveform/reference/sin_signal.md) / [`cos_signal()`](https://mr-seydi.github.io/waveform/reference/cos_signal.md) | Generate periodic signals with adjustable amplitude, frequency, phase, and offset. | List: `signal_values` and `domain`. |
| [`estimate_fwhm()`](https://mr-seydi.github.io/waveform/reference/estimate_fwhm.md) | Estimate global FWHM from curves after pointwise centering. | Numeric scalar. |
| [`dense_data()`](https://mr-seydi.github.io/waveform/reference/dense_data.md) | Fit curves with an `fda` B-spline basis and evaluate on a new grid. | Matrix: evaluation points × curves. |

## Citation

To cite the package in R, run `citation("waveform")`. The citation is
also provided here in BibTeX format:

``` bibtex
@Manual{seydi_waveform_2026,
  title  = {waveform: Simulating One-Dimensional Functional Data},
  author = {Mohammad Reza Seydi},
  year   = {2026},
  note   = {R package, version 1.1.0},
  url    = {https://github.com/mr-seydi/waveform}
}
```

## Development

Source files live in `R/`, help pages in `man/`, and tests in
`tests/testthat/`. Long-form guides can be added to `vignettes/`.

Use `devtools::document()` to update help pages and `devtools::check()`
to check the package. To manage the project library with `renv`,
initialize it from the package root:

``` r

install.packages("renv")
renv::init()
```
