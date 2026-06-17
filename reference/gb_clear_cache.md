# Clear the [geobounds](https://CRAN.R-project.org/package=geobounds) cache directory

**Use this function with caution**. This function clears cached data and
configuration by deleting the
[geobounds](https://CRAN.R-project.org/package=geobounds) config
directory (`tools::R_user_dir("geobounds", "config")`), deleting
`cache_dir` and clearing the value stored in
`Sys.getenv("GEOBOUNDS_CACHE_DIR")`.

## Usage

``` r
gb_clear_cache(config = FALSE, cached_data = TRUE, quiet = TRUE)
```

## Arguments

- config:

  Logical. If `TRUE`, delete the configuration directory of
  [geobounds](https://CRAN.R-project.org/package=geobounds).

- cached_data:

  Logical. If `TRUE`, delete `cache_dir` and all its contents.

- quiet:

  Logical. If `TRUE`, suppress informational messages.

## Value

[`invisible()`](https://rdrr.io/r/base/invisible.html). This function is
called for its side effects.

## Details

This comprehensive reset restores the same cache state as a fresh
[geobounds](https://CRAN.R-project.org/package=geobounds) installation.

## See also

Other cache utilities:
[`gb_detect_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_detect_cache_dir.md),
[`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md)

## Examples

``` r

# Caution! This may modify your current state.

# \dontrun{
my_cache <- gb_detect_cache_dir()
#> ℹ /tmp/RtmpyeGLNS/geobounds
# Set an example cache.
ex <- file.path(tempdir(), "example", "cache")
gb_set_cache_dir(ex, quiet = TRUE)

gb_clear_cache(quiet = FALSE)
#> ! geobounds cached data deleted: /tmp/RtmpyeGLNS/example/cache.

# Restore the initial cache.
gb_set_cache_dir(my_cache)
#> ✔ geobounds cache directory is /tmp/RtmpyeGLNS/geobounds.
#> ℹ To use this `cache_dir` path in future sessions, run this function with `install = TRUE`.
identical(my_cache, gb_detect_cache_dir())
#> ℹ /tmp/RtmpyeGLNS/geobounds
#> [1] TRUE
# }
```
