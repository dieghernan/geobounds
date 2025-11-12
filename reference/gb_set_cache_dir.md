# Set your geobounds cache dir

This function will store your `cache_dir` path on your local machine and
would load it for future sessions. Type
[`gb_detect_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_detect_cache_dir.md)
to find your cached path.

Alternatively, you can store the `cache_dir` manually with the following
options:

- Run `Sys.setenv(GEOBOUNDS_CACHE_DIR = "cache_dir")`. You would need to
  run this command on each session (Similar to `install = FALSE`).

- Write this line on your .Renviron file:
  `GEOBOUNDS_CACHE_DIR = "value_for_cache_dir"` (same behavior than
  `install = TRUE`). This would store your `cache_dir` permanently.

## Usage

``` r
gb_set_cache_dir(cache_dir, overwrite = FALSE, install = FALSE, quiet = FALSE)
```

## Arguments

- cache_dir:

  A path to a cache directory. On missing value the function would store
  the cached files on a temporary dir (See
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html)).

- overwrite:

  Logical. If this is set to `TRUE`, it will overwrite an existing
  `cache_dir`.

- install:

  Logical. If `TRUE`, will install the key in your local machine for use
  in future sessions. Defaults to `FALSE.` If `cache_dir` is `FALSE`
  this parameter is set to `FALSE` automatically.

- quiet:

  Logical, on `FALSE` it displays information of the call. Useful for
  debugging, default is no messages `quiet = TRUE`.

## Value

An (invisible) character with the path to your `cache_dir`.

## See also

[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html)

Other cache utilities:
[`gb_clear_cache()`](https://dieghernan.github.io/geobounds/reference/gb_clear_cache.md),
[`gb_detect_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_detect_cache_dir.md)

## Examples

``` r
# Caution! This may modify your current state

# \dontrun{
my_cache <- gb_detect_cache_dir()
#> ℹ C:\Users\RUNNER~1\AppData\Local\Temp\RtmpOOMCic/geobounds

# Set an example cache
ex <- file.path(tempdir(), "example", "cachenew")
gb_set_cache_dir(ex)
#> ✔ geobounds cache dir is C:\Users\RUNNER~1\AppData\Local\Temp\RtmpOOMCic/example/cachenew.
#> ℹ To install your `cache_dir` path for use in future sessions run this function with `install = TRUE`.

gb_detect_cache_dir()
#> ℹ C:\Users\RUNNER~1\AppData\Local\Temp\RtmpOOMCic/example/cachenew
#> [1] "C:\\Users\\RUNNER~1\\AppData\\Local\\Temp\\RtmpOOMCic/example/cachenew"

# Restore initial cache
gb_set_cache_dir(my_cache)
#> ✔ geobounds cache dir is C:\Users\RUNNER~1\AppData\Local\Temp\RtmpOOMCic/geobounds.
#> ℹ To install your `cache_dir` path for use in future sessions run this function with `install = TRUE`.
identical(my_cache, gb_detect_cache_dir())
#> ℹ C:\Users\RUNNER~1\AppData\Local\Temp\RtmpOOMCic/geobounds
#> [1] TRUE
# }

gb_detect_cache_dir()
#> ℹ C:\Users\RUNNER~1\AppData\Local\Temp\RtmpOOMCic/geobounds
#> [1] "C:\\Users\\RUNNER~1\\AppData\\Local\\Temp\\RtmpOOMCic/geobounds"
```
