# Clear your geobounds cache dir

**Use this function with caution**. This function would clear your
cached data and configuration, specifically:

- Deletes the geobounds config directory
  (`tools::R_user_dir("geobounds", "config")`).

- Deletes the `cache_dir` directory.

- Deletes the values on stored on `Sys.getenv("GEOBOUNDS_CACHE_DIR")`.

## Usage

``` r
gb_clear_cache(config = FALSE, cached_data = TRUE, quiet = TRUE)
```

## Arguments

- config:

  Logical. If `TRUE`, will delete the configuration folder of geobounds.

- cached_data:

  Logical. If `TRUE`, it will delete your `cache_dir` and all its
  content.

- quiet:

  Logical, on `FALSE` it displays information of the call. Useful for
  debugging, default is no messages `quiet = TRUE`.

## Value

Invisible. This function is called for its side effects.

## Details

This is an overkill function that is intended to reset your status as it
you would never have installed and/or used geobounds.

## See also

Other cache utilities:
[`gb_detect_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_detect_cache_dir.md),
[`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md)

## Examples

``` r
# Don't run this! It would modify your current state
# \dontrun{
gb_clear_cache(quiet = FALSE)
#> ! geobounds data deleted: C:\Users\RUNNER~1\AppData\Local\Temp\RtmpOaiNsa/geobounds
# }
```
