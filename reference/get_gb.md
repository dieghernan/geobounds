# Get individual country files from geoBoundaries

[Attribution](https://www.geoboundaries.org/index.html#usage) is
required for all uses of this dataset.

This function returns data of individual countries "as they would
represent themselves", with no special identification of disputed areas.

If you would prefer data that explicitly includes disputed areas, please
use
[`get_gb_cgaz()`](https://dieghernan.github.io/geobounds/reference/get_gb_cgaz.md).

## Usage

``` r
get_gb(
  country,
  adm_lvl = c("ADM0", "ADM1", "ADM2", "ADM3", "ADM4", "ALL"),
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

- adm_lvl:

  Type of boundary Accepted values are `"ALL"` (all available
  boundaries) or the ADM level (`"ADM0"` is the country boundary,
  `"ADM1"` is the first level of sub national boundaries, `"ADM2"` is
  the second level and so on.

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

For most users, we suggest using `"gbOpen"`, as it is CC-BY 4.0
compliant, and can be used for most purposes so long as attribution is
provided.

- `"gbHumanitarian"` files are mirrored from [UN
  OCHA](https://www.unocha.org/), but may have less open licensure.

- `"gbAuthoritative"` files are mirrored from [UN
  SALB](https://salb.un.org/en), and cannot be used for commercial
  purposes, but are verified through in-country processes.

## References

Runfola, D. et al. (2020) geoBoundaries: A global database of political
administrative boundaries. *PLOS ONE* 15(4): e0231866.
[doi:10.1371/journal.pone.0231866](https://doi.org/10.1371/journal.pone.0231866)
.

## See also

Other API functions:
[`get_gb_adm`](https://dieghernan.github.io/geobounds/reference/get_gb_adm.md),
[`get_gb_cgaz()`](https://dieghernan.github.io/geobounds/reference/get_gb_cgaz.md)

## Examples

``` r
# \donttest{
sri_lanka <- get_gb(
  "Sri Lanka",
  adm_lvl = "ADM3",
  simplified = TRUE
)

sri_lanka
#> Simple feature collection with 330 features and 5 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 79.51937 ymin: 5.918507 xmax: 81.8772 ymax: 9.835718
#> Geodetic CRS:  WGS 84
#> # A tibble: 330 × 6
#>    shapeName     shapeISO shapeID shapeGroup shapeType                  geometry
#>  * <chr>         <chr>    <chr>   <chr>      <chr>            <MULTIPOLYGON [°]>
#>  1 Manmunai Sou… ""       854035… LKA        ADM3      (((81.81611 7.459573, 81…
#>  2 Koralai Patt… ""       854035… LKA        ADM3      (((81.51482 7.922462, 81…
#>  3 Thenmaradchi… ""       854035… LKA        ADM3      (((80.18725 9.622936, 80…
#>  4 Manmunai Sou… ""       854035… LKA        ADM3      (((81.64394 7.52247, 81.…
#>  5 Manmunai Pat… ""       854035… LKA        ADM3      (((81.78383 7.601931, 81…
#>  6 Koralai Pattu ""       854035… LKA        ADM3      (((81.51629 7.892779, 81…
#>  7 Porativu Pat… ""       854035… LKA        ADM3      (((81.64394 7.52247, 81.…
#>  8 Eravur Pattu  ""       854035… LKA        ADM3      (((81.54727 7.534724, 81…
#>  9 Mundel        ""       854035… LKA        ADM3      (((79.82017 7.96686, 79.…
#> 10 Addalaichenai ""       854035… LKA        ADM3      (((81.86513 7.300187, 81…
#> # ℹ 320 more rows

library(ggplot2)
ggplot(sri_lanka) +
  geom_sf() +
  labs(caption = "Source: www.geoboundaries.org")

# }

# Metadata
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
get_gb(
  "Sri Lanka",
  adm_lvl = "ADM3",
  metadata = TRUE
) %>%
  glimpse()
#> Rows: 1
#> Columns: 32
#> $ boundaryID                <chr> "LKA-ADM3-8540358"
#> $ boundaryName              <chr> "Sri Lanka"
#> $ boundaryISO               <chr> "LKA"
#> $ boundaryYearRepresented   <chr> "2020"
#> $ boundaryType              <chr> "ADM3"
#> $ boundaryCanonical         <chr> "Divisional Secretariat"
#> $ boundarySource            <chr> "OCHA ROAP, Survey Department of Sri Lanka"
#> $ boundaryLicense           <chr> "Creative Commons Attribution 3.0 Intergover…
#> $ licenseDetail             <chr> NA
#> $ licenseSource             <chr> "data.humdata.org/dataset/sri-lanka-administ…
#> $ boundarySourceURL         <chr> "data.humdata.org/dataset/sri-lanka-administ…
#> $ sourceDataUpdateDate      <dttm> 2023-01-19 07:31:04
#> $ buildDate                 <date> 2023-12-12
#> $ Continent                 <chr> "Asia"
#> $ `UNSDG-region`            <chr> "Central and Southern Asia"
#> $ `UNSDG-subregion`         <chr> "Southern Asia"
#> $ worldBankIncomeGroup      <chr> "Lower-middle-income Countries"
#> $ admUnitCount              <dbl> 330
#> $ meanVertices              <dbl> 4097
#> $ minVertices               <dbl> 286
#> $ maxVertices               <dbl> 30321
#> $ meanPerimeterLengthKM     <dbl> 87.90021
#> $ minPerimeterLengthKM      <dbl> 6.072107
#> $ maxPerimeterLengthKM      <dbl> 322.9302
#> $ meanAreaSqKM              <dbl> 200.0581
#> $ minAreaSqKM               <dbl> 1.813479
#> $ maxAreaSqKM               <dbl> 1060.133
#> $ staticDownloadLink        <chr> "https://github.com/wmgeolab/geoBoundaries/r…
#> $ gjDownloadURL             <chr> "https://github.com/wmgeolab/geoBoundaries/r…
#> $ tjDownloadURL             <chr> "https://github.com/wmgeolab/geoBoundaries/r…
#> $ imagePreview              <chr> "https://github.com/wmgeolab/geoBoundaries/r…
#> $ simplifiedGeometryGeoJSON <chr> "https://github.com/wmgeolab/geoBoundaries/r…
```
