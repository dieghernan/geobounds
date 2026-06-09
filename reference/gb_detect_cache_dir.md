# Detect the [geobounds](https://CRAN.R-project.org/package=geobounds) cache directory

Detect the current cache folder. See
[`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md).

## Usage

``` r
gb_detect_cache_dir(x = NULL)
```

## Arguments

- x:

  Ignored.

## Value

A character vector with the path to your `cache_dir`. The same path also
appears as a clickable message. See
[`cli::inline-markup`](https://cli.r-lib.org/reference/inline-markup.html).

## See also

Other cache utilities:
[`gb_clear_cache()`](https://dieghernan.github.io/geobounds/reference/gb_clear_cache.md),
[`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md)

## Examples

``` r
gb_detect_cache_dir()
#> ℹ /tmp/RtmpCNnWcC/geobounds
#> [1] "/tmp/RtmpCNnWcC/geobounds"
```
