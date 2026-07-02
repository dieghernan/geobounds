# Clear the [geobounds](https://CRAN.R-project.org/package=geobounds) cache directory

**Use this function with caution**. It clears cached data and
configuration by deleting the
[geobounds](https://CRAN.R-project.org/package=geobounds) configuration
directory (`tools::R_user_dir("geobounds", "config")`), deleting the
active cache directory and clearing `Sys.getenv("GEOBOUNDS_CACHE_DIR")`.

## Usage

``` r
gb_clear_cache(config = FALSE, cached_data = TRUE, quiet = TRUE)
```

## Arguments

- config:

  Logical. If `TRUE`, delete the
  [geobounds](https://CRAN.R-project.org/package=geobounds)
  configuration directory.

- cached_data:

  Logical. If `TRUE`, delete the active cache directory and all its
  contents.

- quiet:

  Logical. If `TRUE`, suppress informational messages.

## Value

[`invisible()`](https://rdrr.io/r/base/invisible.html). This function is
called for its side effects.

## Details

This reset restores the cache state of a fresh
[geobounds](https://CRAN.R-project.org/package=geobounds) installation.

## See also

Cache utilities:
[`gb_detect_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_detect_cache_dir.md),
[`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md)

## Examples

``` r

# Caution: this may modify your current state.

# \dontrun{
my_cache <- gb_detect_cache_dir()
#> ℹ /tmp/RtmpIJ3pji/geobounds
# Set an example cache.
ex <- file.path(tempdir(), "example", "cache")
gb_set_cache_dir(ex, quiet = TRUE)

gb_clear_cache(quiet = FALSE)
#> ! Deleted the geobounds cache directory /tmp/RtmpIJ3pji/example/cache.

# Restore the initial cache.
gb_set_cache_dir(my_cache)
#> ✔ geobounds cache directory is /tmp/RtmpIJ3pji/geobounds.
#> ℹ To use this cache directory in future sessions, run this function with `install = TRUE`.
identical(my_cache, gb_detect_cache_dir())
#> ℹ /tmp/RtmpIJ3pji/geobounds
#> [1] TRUE
# }
```
