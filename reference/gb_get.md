# Get individual country files from **geoBoundaries**

Returns individual country files that reflect how countries represent
their own boundaries, without special identification of disputed areas.

Use
[`gb_get_world()`](https://dieghernan.github.io/geobounds/reference/gb_get_world.md)
for global composite files that standardize disputed areas and fill gaps
between borders.

[Attribution](https://www.geoboundaries.org/index.html#usage) is
required whenever these data are used.

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
  codes. Use `"all"` to return data for all countries. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/man/countrycode.html).

- adm_lvl:

  ADM level. Accepted values are `"all"` (all available boundaries) or
  the ADM level (`"adm0"` is the country boundary, `"adm1"` is the first
  level of subnational boundaries, `"adm2"` is the second level and so
  on). Uppercase versions (`"ADM1"`) and level numbers (`1`, `2`, `3`,
  `4`, `5`) are also accepted.

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
each file. See **Examples**.

The wrappers
[`gb_get_adm0()`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md),
[`gb_get_adm1()`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md),
[`gb_get_adm2()`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md),
[`gb_get_adm3()`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md),
[`gb_get_adm4()`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md)
and
[`gb_get_adm5()`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md)
are also available for requesting a single ADM level.

## References

Runfola et al. (2020) **geoBoundaries**: A global database of political
administrative boundaries. *PLOS ONE* **15**(4), e0231866.
[doi:10.1371/journal.pone.0231866](https://doi.org/10.1371/journal.pone.0231866)
.

## See also

[`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_metadata.md),
[`gb_get_max_adm_lvl()`](https://dieghernan.github.io/geobounds/reference/gb_get_max_adm_lvl.md).

API functions:
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
  labs(caption = "Source: www.geoboundaries.org")

# }

# Inspect boundary metadata.
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
gb_get_metadata(
  "Sri Lanka",
  adm_lvl = 2
) |>
  # Check the individual license.
  select(boundaryISO, boundaryType, licenseDetail, licenseSource) |>
  glimpse()
#> Rows: 1
#> Columns: 4
#> $ boundaryISO   <chr> "LKA"
#> $ boundaryType  <chr> "ADM2"
#> $ licenseDetail <chr> "Open Data Commons Open Database License 1.0"
#> $ licenseSource <chr> "www.openstreetmap.org/copyright"
```
