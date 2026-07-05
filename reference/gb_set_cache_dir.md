# Set the [geobounds](https://CRAN.R-project.org/package=geobounds) cache directory

Sets the active cache directory and optionally saves it for future
sessions. Use
[`gb_detect_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_detect_cache_dir.md)
to find the active cache directory.

## Usage

``` r
gb_set_cache_dir(cache_dir, overwrite = FALSE, install = FALSE, quiet = FALSE)
```

## Arguments

- cache_dir:

  A path to a cache directory. If missing, the function stores cache
  files in a temporary directory. See
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html).

- overwrite:

  A logical value. If `TRUE`, replace a cache directory already saved in
  the configuration file.

- install:

  A logical value. If `TRUE`, save the cache directory for use in future
  sessions. Defaults to `FALSE`. If `cache_dir` is missing or empty,
  this parameter is set to `FALSE` automatically.

- quiet:

  A logical value. If `TRUE`, suppress informational messages.

## Value

An invisible character scalar containing the path to the cache
directory.

## Details

By default, when no `cache_dir` is set,
[geobounds](https://CRAN.R-project.org/package=geobounds) uses a
directory inside
[`base::tempdir()`](https://rdrr.io/r/base/tempfile.html). Files in this
directory are removed when the R session ends. To reuse a cache
directory across R sessions, use
`gb_set_cache_dir(cache_dir = "a/path/here", install = TRUE)`. This
saves the directory in a configuration file under
`tools::R_user_dir("geobounds", "config")`.

## Cache strategies

- For occasional use, use the default temporary cache directory.

- Set the cache directory for the current session with
  `gb_set_cache_dir(cache_dir = "a/path/here")`.

- Save a persistent cache directory for future R sessions with
  `gb_set_cache_dir(cache_dir = "a/path/here", install = TRUE)`.

- Set the cache directory for an individual download with the
  `cache_dir` argument. See
  [`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md).

## See also

[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html) identifies
standard locations for user-specific files.

Cache management functions:
[`gb_clear_cache()`](https://dieghernan.github.io/geobounds/reference/gb_clear_cache.md),
[`gb_detect_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_detect_cache_dir.md)

## Examples

``` r

# Caution: this may modify your current state.

# \dontrun{
my_cache <- gb_detect_cache_dir()
#> ℹ /tmp/RtmpKz3cqP/geobounds

# Set an example cache.
ex <- file.path(tempdir(), "example", "cachenew")
gb_set_cache_dir(ex)
#> ✔ geobounds cache directory is /tmp/RtmpKz3cqP/example/cachenew.
#> ℹ To use this cache directory in future sessions, call `gb_set_cache_dir()` with `install = TRUE`.

gb_detect_cache_dir()
#> ℹ /tmp/RtmpKz3cqP/example/cachenew
#> [1] "/tmp/RtmpKz3cqP/example/cachenew"

# Restore the initial cache.
gb_set_cache_dir(my_cache)
#> ✔ geobounds cache directory is /tmp/RtmpKz3cqP/geobounds.
#> ℹ To use this cache directory in future sessions, call `gb_set_cache_dir()` with `install = TRUE`.
identical(my_cache, gb_detect_cache_dir())
#> ℹ /tmp/RtmpKz3cqP/geobounds
#> [1] TRUE
# }

gb_detect_cache_dir()
#> ℹ /tmp/RtmpKz3cqP/geobounds
#> [1] "/tmp/RtmpKz3cqP/geobounds"
```
