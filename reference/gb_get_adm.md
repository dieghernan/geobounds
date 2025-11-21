# Get country files from geoBoundaries for a given administration level

[Attribution](https://www.geoboundaries.org/index.html#usage) is
required for all uses of this dataset.

These functions are wrappers of
[`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md)
for extracting any given administration level:

- `gb_get_adm0()` returns the country boundary.

- `gb_get_adm1()` returns first-level administration boundaries (e.g.
  States in the United States).

- `gb_get_adm2()` returns second-level administration boundaries (e.g.
  Counties in the United States).

- `gb_get_adm3()` returns third-level administration boundaries (e.g.
  towns or cities in some countries).

- `gb_get_adm4()` returns fourth-level administration boundaries.

- `gb_get_adm5()` returns fifth-level administration boundaries.

Note that not all countries have the same number of levels. Check
[gb_get_max_adm_lvl](https://dieghernan.github.io/geobounds/reference/gb_get_max_adm_lvl.md).

## Usage

``` r
gb_get_adm0(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
)

gb_get_adm1(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
)

gb_get_adm2(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
)

gb_get_adm3(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
)

gb_get_adm4(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
)

gb_get_adm5(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
)
```

## Source

geoBoundaries API Service <https://www.geoboundaries.org/api.html>.

## Arguments

- country:

  A character vector of country codes. It could be either `"all"` (that
  would return the data for all countries), a vector of country names or
  ISO3 country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

- simplified:

  logical. Return the simplified boundary or not. The default `FALSE`
  would use the premier geoBoundaries release.

- release_type:

  One of `"gbOpen"`, `"gbHumanitarian"`, `"gbAuthoritative"`. For most
  users, we suggest using `"gbOpen"` (the default), as it is CC-BY 4.0
  compliant and can be used for most purposes so long as attribution is
  provided:

  - `"gbHumanitarian"` files are mirrored from [UN
    OCHA](https://www.unocha.org/), but may have less open licensure.

  - `"gbAuthoritative"` files are mirrored from [UN
    SALB](https://salb.un.org/en), and cannot be used for commercial
    purposes, but are verified through in-country processes.

- quiet:

  logical. If `TRUE` suppresses informational messages.

- overwrite:

  logical. When set to `TRUE` it would force a fresh download of the
  source `.zip` file.

- cache_dir:

  A path to a cache directory. If not set (the default `NULL`), the data
  would be stored in the default cache directory (see
  [`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md)).
  If no cache directory has been set, files would be stored in the
  temporary directory (see
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html)). See
  caching strategies in
  [`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md).

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

Individual data files in the geoBoundaries database are governed by the
license or licenses identified within the metadata for each respective
boundary (see
[`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_meta.md).
Users using individual boundary files from geoBoundaries should
additionally ensure that they are citing the sources provided in the
metadata for each file.

## References

Runfola, D. et al. (2020) geoBoundaries: A global database of political
administrative boundaries. *PLoS ONE* 15(4): e0231866.
[doi:10.1371/journal.pone.0231866](https://doi.org/10.1371/journal.pone.0231866)
.

## See also

[`gb_get_max_adm_lvl()`](https://dieghernan.github.io/geobounds/reference/gb_get_max_adm_lvl.md).

Other API functions:
[`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md),
[`gb_get_cgaz()`](https://dieghernan.github.io/geobounds/reference/gb_get_cgaz.md)

## Examples

``` r
# \donttest{
lev2 <- gb_get_adm2(
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
