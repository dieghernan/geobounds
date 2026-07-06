# Download country boundaries for one ADM level

These functions call
[`gb_get()`](https://dieghernan.github.io/geobounds/dev/reference/gb_get.md)
for a single ADM level. `gb_get_adm0()` returns country boundaries,
`gb_get_adm1()` returns first-level subnational boundaries (for example,
states in the United States) and `gb_get_adm2()` returns second-level
subnational boundaries (for example, counties in the United States).
`gb_get_adm3()`, `gb_get_adm4()` and `gb_get_adm5()` return third-,
fourth- and fifth-level administrative boundaries, respectively.

Not all countries have the same number of ADM levels. Use
[`gb_get_max_adm_lvl()`](https://dieghernan.github.io/geobounds/dev/reference/gb_get_max_adm_lvl.md)
to check availability.

Data downloaded through these functions are not covered by the package's
MIT license.
[Attribution](https://www.geoboundaries.org/index.html#usage) to
**geoBoundaries** and the original sources is required when sharing the
data or derived products.

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

  A logical value. If `TRUE`, return simplified boundaries. The default
  `FALSE` uses the primary **geoBoundaries** file. See simplified
  boundaries at <https://www.geoboundaries.org/>.

- release_type:

  A character string, one of `"gbOpen"`, `"gbHumanitarian"` or
  `"gbAuthoritative"`. For most users, use `"gbOpen"` (the default),
  which contains openly licensed boundaries suitable for most purposes
  when their individual license terms are followed. `"gbHumanitarian"`
  boundaries are mirrored from [UN OCHA](https://www.unocha.org/) and
  may have additional conditions. `"gbAuthoritative"` boundaries are
  mirrored from [UN SALB](https://salb.un.org/en), verified through
  in-country processes and cannot be used for commercial purposes.

- quiet:

  A logical value. If `TRUE`, suppress informational messages.

- overwrite:

  A logical value. If `TRUE`, force a fresh download of the source
  `.zip` archive.

- cache_dir:

  A path to a cache directory. If not set (the default `NULL`), the data
  will be stored in the default cache directory (see
  [`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/dev/reference/gb_set_cache_dir.md)).
  If no cache directory has been set, files are stored in a temporary
  cache directory. See
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html) and the
  cache strategies in
  [`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/dev/reference/gb_set_cache_dir.md).

## Value

An [sf](https://r-spatial.github.io/sf/reference/sf.html) object from
[sf](https://CRAN.R-project.org/package=sf) containing the requested
boundaries. If no boundary files match the request, the function returns
`NULL`.

## Details

Each individual country boundary file is governed by the original
license identified in its boundary metadata. See
[`gb_get_metadata()`](https://dieghernan.github.io/geobounds/dev/reference/gb_get_metadata.md).
Users should cite the sources listed in the metadata and comply with any
attribution, share-alike or non-commercial terms.

## References

Runfola et al. (2020) **geoBoundaries**: A global database of political
administrative boundaries. *PLOS ONE* **15**(4), e0231866.
[doi:10.1371/journal.pone.0231866](https://doi.org/10.1371/journal.pone.0231866)
.

## See also

- [`gb_get_metadata()`](https://dieghernan.github.io/geobounds/dev/reference/gb_get_metadata.md)
  inspects boundary metadata and licensing.

- [`gb_get_max_adm_lvl()`](https://dieghernan.github.io/geobounds/dev/reference/gb_get_max_adm_lvl.md)
  checks available ADM levels.

Boundary download functions:
[`gb_get()`](https://dieghernan.github.io/geobounds/dev/reference/gb_get.md),
[`gb_get_world()`](https://dieghernan.github.io/geobounds/dev/reference/gb_get_world.md)

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
    caption = paste(
      "Sources: geoBoundaries and the original boundary providers,",
      "check gb_get_metadata() for licenses"
    )
  )

# }
```
