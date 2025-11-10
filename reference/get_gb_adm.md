# Get country files from geoBoundaries for a given administration level

[Attribution](https://www.geoboundaries.org/index.html#usage) is
required for all uses of this dataset.

These functions are wrappers of
[`get_gb()`](https://dieghernan.github.io/geobounds/reference/get_gb.md)
for extracting any given administration level:

- `get_gb_adm0()` returns the country boundary.

- `get_gb_adm1()` returns first-level administration boundaries (e.g.
  States in the United States).

- `get_gb_adm2()` returns second-level administration boundaries (e.g.
  Counties in the United States).

- `get_gb_adm3()` returns third-level administration boundaries (e.g.
  towns or cities in some countries).

- `get_gb_adm4()` returns fourth-level administration boundaries.

Note that not all countries have the same number of levels.

## Usage

``` r
get_gb_adm0(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  metadata = FALSE,
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
)

get_gb_adm1(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  metadata = FALSE,
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
)

get_gb_adm2(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  metadata = FALSE,
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
)

get_gb_adm3(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  metadata = FALSE,
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
)

get_gb_adm4(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  metadata = FALSE,
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
)
```

## Source

geoboundaries API Service <https://www.geoboundaries.org/api.html>.

## Arguments

- country:

  A character vector of country codes. It could be either `"ALL"` (that
  would return the data for all countries), a vector of country names or
  ISO3 country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

- simplified:

  Logical. Return the simplified boundary or not.

- release_type:

  One of `"gbOpen"`, `"gbHumanitarian"`, `"gbAuthoritative"`. Source of
  the spatial data. See **Details**.

- metadata:

  Should the result be the metadata of the boundary?

- quiet:

  Logical, on `FALSE` it displays information of the call. Useful for
  debugging, default is no messages `quiet = TRUE`.

- overwrite:

  A logical whether to update cache. Default is `FALSE`. When set to
  `TRUE` it would force a fresh download of the source `.geojson` file.

- cache_dir:

  A path to a cache directory. If not set (the default `NULL`), the data
  would be stored in the default cache directory (see
  [`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md)).
  If no cache directory has been set, files would be stored in the
  temporary directory (see
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html)).

## Value

- With `metadata = FALSE`: A
  [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

- With `metadata = TRUE`: A tibble.

## Details

See **Details** in
[`get_gb()`](https://dieghernan.github.io/geobounds/reference/get_gb.md).

## References

Runfola, D. et al. (2020) geoBoundaries: A global database of political
administrative boundaries. *PLOS ONE* 15(4): e0231866.
[doi:10.1371/journal.pone.0231866](https://doi.org/10.1371/journal.pone.0231866)
.

## See also

Other API functions:
[`get_gb()`](https://dieghernan.github.io/geobounds/reference/get_gb.md),
[`get_gb_cgaz()`](https://dieghernan.github.io/geobounds/reference/get_gb_cgaz.md)

## Examples

``` r
# \donttest{
lev2 <- get_gb_adm2(
  c("Italia", "Suiza", "Austria"),
  simplified = TRUE
)


library(ggplot2)

ggplot(lev2) +
  geom_sf(aes(fill = shapeGroup)) +
  labs(
    title = "Second-level administration",
    subtitle = "Selected countries",
    caption = "Source: www.geoboundaries.org"
  )

# }
```
