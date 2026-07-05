# Detect the [geobounds](https://CRAN.R-project.org/package=geobounds) cache directory

Detects the active cache directory. See
[`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md).

## Usage

``` r
gb_detect_cache_dir(x = NULL)
```

## Arguments

- x:

  An object. Ignored.

## Value

A character scalar containing the path to the active cache directory. It
also appears in a clickable message. See
[cli::inline-markup](https://cli.r-lib.org/reference/inline-markup.html).

## See also

Cache management functions:
[`gb_clear_cache()`](https://dieghernan.github.io/geobounds/reference/gb_clear_cache.md),
[`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md)

## Examples

``` r
gb_detect_cache_dir()
#> ℹ /tmp/RtmpnOlUEY/geobounds
#> [1] "/tmp/RtmpnOlUEY/geobounds"
```
