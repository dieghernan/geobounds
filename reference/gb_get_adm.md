# Get individual country files for an ADM level

These functions wrap
[`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md)
for a single ADM level. `gb_get_adm0()` returns country boundaries,
`gb_get_adm1()` returns first-level subnational boundaries (for example,
states in the United States) and `gb_get_adm2()` returns second-level
subnational boundaries (for example, counties in the United States).
`gb_get_adm3()`, `gb_get_adm4()` and `gb_get_adm5()` return third-,
fourth- and fifth-level administrative boundaries, respectively.

Not all countries have the same number of ADM levels. Use
[`gb_get_max_adm_lvl()`](https://dieghernan.github.io/geobounds/reference/gb_get_max_adm_lvl.md)
to check availability.

[Attribution](https://www.geoboundaries.org/index.html#usage) is
required whenever these data are used.

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

[**geoBoundaries** API](https://www.geoboundaries.org/api.html).

## Arguments

- country:

  A character vector of country names or ISO 3166-1 alpha-3 country
  codes. Use `"all"` to return data for all countries. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/man/countrycode.html).

- simplified:

  Logical. If `TRUE`, return simplified boundaries. The default `FALSE`
  uses the primary **geoBoundaries** file. See simplified boundaries at
  <https://www.geoboundaries.org/>.

- release_type:

  One of `"gbOpen"`, `"gbHumanitarian"` or `"gbAuthoritative"`. For most
  users, use `"gbOpen"` (the default), which is CC BY 4.0 compliant and
  suitable for most purposes when attribution is provided.
  `"gbHumanitarian"` files are mirrored from [UN
  OCHA](https://www.unocha.org/) and may have less open licensing.
  `"gbAuthoritative"` files are mirrored from UN SALB, verified through
  in-country processes and cannot be used for commercial purposes.

- quiet:

  Logical. If `TRUE`, suppress informational messages.

- overwrite:

  Logical. If `TRUE`, force a fresh download of the source `.zip`
  archive.

- cache_dir:

  A path to a cache directory. If not set (the default `NULL`), the data
  will be stored in the default cache directory (see
  [`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md)).
  If no cache directory has been set, files are stored in a temporary
  cache directory. See
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html) and the
  cache strategies in
  [`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md).

## Value

An [sf](https://r-spatial.github.io/sf/reference/sf.html) object
containing the requested boundaries.

## Details

Each individual country file is governed by the license identified in
its boundary metadata. See
[`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_metadata.md).
Users should also cite the sources listed in the boundary metadata for
each file.

## References

Runfola et al. (2020) **geoBoundaries**: A global database of political
administrative boundaries. *PLOS ONE* **15**(4), e0231866.
[doi:10.1371/journal.pone.0231866](https://doi.org/10.1371/journal.pone.0231866)
.

## See also

[`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_metadata.md),
[`gb_get_max_adm_lvl()`](https://dieghernan.github.io/geobounds/reference/gb_get_max_adm_lvl.md).

API functions:
[`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md),
[`gb_get_world()`](https://dieghernan.github.io/geobounds/reference/gb_get_world.md)

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
    title = "Second-level administrative boundaries",
    subtitle = "Selected countries",
    caption = "Source: www.geoboundaries.org"
  )

# }
```
