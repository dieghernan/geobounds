# Set your geobounds cache dir

This function will store your `cache_dir` path on your local machine and
would load it for future sessions. Type
[`gb_detect_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_detect_cache_dir.md)
to find your cached path.

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

  logical. If `TRUE` suppresses informational messages.

## Value

An (invisible) character with the path to your `cache_dir`.

## Details

By default, when no cache `cache_dir` is set the package uses a folder
inside [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html) (so
files are temporary and are removed when the **R** session ends). To
persist a cache across **R** sessions, use
`gb_set_cache(path, install = TRUE)` which writes the chosen path to a
small configuration file under
`tools::R_user_dir("geobounds", "config")`.

## Caching strategies

- For occasional use, rely on the default
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html)-based cache (no
  install).

- Modify the cache for a single session setting
  `gb_set_cache_dir(cache_dir = "a/path/here)`.

- For reproducible workflows, install a persistent cache with
  `gb_set_cache_dir(cache_dir = "a/path/here, install = TRUE)` that
  would be kept across **R** sessions.

- For caching specific files, use the `cache_dir` argument in the
  corresponding function. See
  [`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md).

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
#> ℹ C:\Users\RUNNER~1\AppData\Local\Temp\RtmpK4xBHG/geobounds

# Set an example cache
ex <- file.path(tempdir(), "example", "cachenew")
gb_set_cache_dir(ex)
#> ✔ geobounds cache dir is C:\Users\RUNNER~1\AppData\Local\Temp\RtmpK4xBHG/example/cachenew.
#> ℹ To install your `cache_dir` path for use in future sessions run this function with `install = TRUE`.

gb_detect_cache_dir()
#> ℹ C:\Users\RUNNER~1\AppData\Local\Temp\RtmpK4xBHG/example/cachenew
#> [1] "C:\\Users\\RUNNER~1\\AppData\\Local\\Temp\\RtmpK4xBHG/example/cachenew"

# Restore initial cache
gb_set_cache_dir(my_cache)
#> ✔ geobounds cache dir is C:\Users\RUNNER~1\AppData\Local\Temp\RtmpK4xBHG/geobounds.
#> ℹ To install your `cache_dir` path for use in future sessions run this function with `install = TRUE`.
identical(my_cache, gb_detect_cache_dir())
#> ℹ C:\Users\RUNNER~1\AppData\Local\Temp\RtmpK4xBHG/geobounds
#> [1] TRUE
# }

gb_detect_cache_dir()
#> ℹ C:\Users\RUNNER~1\AppData\Local\Temp\RtmpK4xBHG/geobounds
#> [1] "C:\\Users\\RUNNER~1\\AppData\\Local\\Temp\\RtmpK4xBHG/geobounds"
```
