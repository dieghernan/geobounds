# Download country boundaries for one ADM level

These functions call
[`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md)
for a single ADM level. `gb_get_adm0()` returns country boundaries,
`gb_get_adm1()` returns first-level subnational boundaries (for example,
states in the United States) and `gb_get_adm2()` returns second-level
subnational boundaries (for example, counties in the United States).
`gb_get_adm3()`, `gb_get_adm4()` and `gb_get_adm5()` return third-,
fourth- and fifth-level administrative boundaries, respectively.

Use
[`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_metadata.md)
to check availability for the requested country, ADM level and release
type.

See
[`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md)
for download behavior and licensing, and
[`vignette("geobounds", package = "geobounds")`](https://dieghernan.github.io/geobounds/articles/geobounds.md)
for worked examples.

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
  codes. Use `"all"` to return boundaries for all countries. See also
  [`countrycode::countrycode()`](https://rdrr.io/pkg/countrycode/man/countrycode.html)
  from [countrycode](https://CRAN.R-project.org/package=countrycode).

- simplified:

  A logical value. If `TRUE`, read simplified boundaries that are faster
  to render. Both options download the complete ZIP archive.

- release_type:

  A character string, one of `"gbOpen"` (the default),
  `"gbHumanitarian"` or `"gbAuthoritative"`. Selects a product, not a
  dataset version. `"gbAuthoritative"` is restricted to non-commercial
  use. See
  [`vignette("metadata", package = "geobounds")`](https://dieghernan.github.io/geobounds/articles/metadata.md)
  for product sources and licenses.

- quiet:

  A logical value. If `TRUE`, suppress informational messages.

- overwrite:

  A logical value. If `TRUE`, force a fresh download of the source
  `.zip` archive.

- cache_dir:

  A path to a cache directory. If `NULL`, use the configured directory,
  or a temporary directory when none is configured. See
  [`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md).

## Value

An [sf](https://r-spatial.github.io/sf/reference/sf.html) object from
[sf](https://CRAN.R-project.org/package=sf) containing the requested
boundaries. Returns [`NULL`](https://rdrr.io/r/base/NULL.html) if no
boundaries match the request or the downloads return no geometries.

## References

Runfola et al. (2020) "geoBoundaries: A global database of political
administrative boundaries." *PLOS ONE*, **15**(4), e0231866.
[doi:10.1371/journal.pone.0231866](https://doi.org/10.1371/journal.pone.0231866)
.

## See also

[`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_metadata.md)
lists the layers available for a country and release type.
[`gb_get_max_adm_lvl()`](https://dieghernan.github.io/geobounds/reference/gb_get_max_adm_lvl.md)
summarizes the highest available ADM level.

Boundary download functions:
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
    caption = paste(
      "Sources: geoBoundaries and the original boundary providers,",
      "check gb_get_metadata() for licenses"
    )
  )

# }
```
