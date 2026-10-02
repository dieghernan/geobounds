# Download individual country boundaries from **geoBoundaries**

Returns individual country boundaries that reflect how countries
represent their own boundaries, without special identification of
disputed areas.

Use
[`gb_get_world()`](https://dieghernan.github.io/geobounds/reference/gb_get_world.md)
for global composite boundaries that standardize disputed areas and fill
gaps between borders.

Always acknowledge **geoBoundaries** and follow the boundary's license.
See
[`vignette("metadata", package = "geobounds")`](https://dieghernan.github.io/geobounds/articles/metadata.md)
for sources and licensing.

The wrappers
[`gb_get_adm0()`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md),
[`gb_get_adm1()`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md),
[`gb_get_adm2()`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md),
[`gb_get_adm3()`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md),
[`gb_get_adm4()`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md)
and
[`gb_get_adm5()`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md)
are also available for requesting a single ADM level.

## Usage

``` r
gb_get(
  country,
  adm_lvl = "adm0",
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

- adm_lvl:

  ADM level. Accepted values are `"all"` (all available boundaries) or
  the ADM level (`"adm0"` is the country boundary, `"adm1"` is the first
  level of subnational boundaries, `"adm2"` is the second level and so
  on). Uppercase versions (`"ADM1"`) and level numbers (`0`, `1`, `2`,
  `3`, `4`, `5`) are also accepted, including numbers supplied as text
  (for example, `"1"`).

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

## Details

These are terrestrial boundaries, not maritime boundaries. For product
selection and mapping workflows, see
[`vignette("geobounds", package = "geobounds")`](https://dieghernan.github.io/geobounds/articles/geobounds.md).

This function uses current API metadata and reuses cached archives
without checking for upstream changes. Historical versions cannot be
selected. See
[`vignette("metadata", package = "geobounds")`](https://dieghernan.github.io/geobounds/articles/metadata.md)
for cache limitations and provenance.

## References

Runfola et al. (2020) "geoBoundaries: A global database of political
administrative boundaries." *PLOS ONE*, **15**(4), e0231866.
[doi:10.1371/journal.pone.0231866](https://doi.org/10.1371/journal.pone.0231866)
.

## See also

[`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_metadata.md)
inspects boundary metadata and licensing.
[`gb_get_max_adm_lvl()`](https://dieghernan.github.io/geobounds/reference/gb_get_max_adm_lvl.md)
checks the ADM levels available for individual country boundaries.
[`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md)
configures where downloaded archives are cached.

Boundary download functions:
[`gb_get_adm`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md),
[`gb_get_world()`](https://dieghernan.github.io/geobounds/reference/gb_get_world.md)

## Examples

``` r
# \donttest{
# Map ADM2 in Sri Lanka.
sri_lanka <- gb_get(
  "Sri Lanka",
  adm_lvl = 2,
  simplified = TRUE
)

sri_lanka
#> Simple feature collection with 25 features and 5 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 79.65102 ymin: 5.919017 xmax: 81.87896 ymax: 9.835791
#> Geodetic CRS:  WGS 84
#> # A tibble: 25 × 6
#>    shapeName     shapeISO shapeID shapeGroup shapeType                  geometry
#>  * <chr>         <chr>    <chr>   <chr>      <chr>            <MULTIPOLYGON [°]>
#>  1 Jaffna Distr… LK-41    463711… LKA        ADM2      (((79.7152 9.529465, 79.…
#>  2 Kilinochchi … LK-42    463711… LKA        ADM2      (((80.01015 9.472403, 80…
#>  3 Mannar Distr… LK-43    463711… LKA        ADM2      (((80.11535 9.209068, 80…
#>  4 Mullaitivu D… LK-45    463711… LKA        ADM2      (((80.61353 9.456581, 80…
#>  5 Vavuniya Dis… LK-44    463711… LKA        ADM2      (((80.23541 8.680412, 80…
#>  6 Galle Distri… LK-31    463711… LKA        ADM2      (((79.98757 6.440352, 79…
#>  7 Hambantota D… LK-33    463711… LKA        ADM2      (((80.67006 6.306029, 80…
#>  8 Matara Distr… LK-32    463711… LKA        ADM2      (((80.3818 5.965264, 80.…
#>  9 Ampara Distr… LK-52    463711… LKA        ADM2      (((81.70788 6.51073, 81.…
#> 10 Anuradhapura… LK-71    463711… LKA        ADM2      (((80.03237 8.527211, 80…
#> # ℹ 15 more rows

library(ggplot2)
ggplot(sri_lanka) +
  geom_sf() +
  labs(
    caption = paste(
      "Sources: geoBoundaries, OpenStreetMap and Wambacher,",
      "license: ODbL 1.0"
    )
  )

# }
```
