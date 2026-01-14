# Detect cache dir for geobounds

Helper function to detect the current cache folder. See
[`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md).

## Usage

``` r
gb_detect_cache_dir(x = NULL)
```

## Arguments

- x:

  Ignored.

## Value

A character with the path to your `cache_dir`. The same path would
appear also as a clickable message, see
[`cli::inline-markup`](https://cli.r-lib.org/reference/inline-markup.html).

## See also

Other cache utilities:
[`gb_clear_cache()`](https://dieghernan.github.io/geobounds/reference/gb_clear_cache.md),
[`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md)

## Examples

``` r
gb_detect_cache_dir()
#> ℹ C:\Users\RUNNER~1\AppData\Local\Temp\RtmpIvw5vL/geobounds
#> [1] "C:\\Users\\RUNNER~1\\AppData\\Local\\Temp\\RtmpIvw5vL/geobounds"
```
