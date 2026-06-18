# Get boundary metadata from **geoBoundaries**

Returns boundary metadata from the [**geoBoundaries**
API](https://www.geoboundaries.org/api.html).

## Usage

``` r
gb_get_metadata(
  country = "all",
  adm_lvl = "all",
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative")
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

- release_type:

  One of `"gbOpen"`, `"gbHumanitarian"` or `"gbAuthoritative"`. For most
  users, use `"gbOpen"` (the default), which is CC BY 4.0 compliant and
  suitable for most purposes when attribution is provided.
  `"gbHumanitarian"` files are mirrored from [UN
  OCHA](https://www.unocha.org/) and may have less open licensing.
  `"gbAuthoritative"` files are mirrored from UN SALB, verified through
  in-country processes and cannot be used for commercial purposes.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html)
with one row per matching boundary file and the columns described in
**Details**.

## Details

The result is a
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) with
the following columns:

- `boundaryID`: The ID for this layer. It combines the ISO code,
  boundary type and a unique identifier generated from the input
  metadata and geometry. This only changes if the underlying data
  changes.

- `boundaryName`: The name of the country represented by the layer.

- `boundaryISO`: ISO 3166-1 alpha-3 code for the country.

- `boundaryYearRepresented`: The year or range of years in
  `"START to END"` format that the boundary layers represent.

- `boundaryType`: The type of boundary.

- `boundaryCanonical`: The canonical name of the boundary.

- `boundarySource`: A comma-separated list of the primary sources for
  the boundary.

- `boundaryLicense`: The original license under which the primary source
  released the boundary data.

- `licenseDetail`: Any notes regarding the license.

- `licenseSource`: The URL of the primary source.

- `sourceDataUpdateDate`: The date the source information was integrated
  into the **geoBoundaries** repository.

- `buildDate`: The date the source data was most recently standardized
  and built into a **geoBoundaries** release.

- `Continent`: The continent the country is associated with.

- `UNSDG-region`: The United Nations Sustainable Development Goals (SDG)
  region the country is associated with.

- `UNSDG-subregion`: The United Nations Sustainable Development Goals
  (SDG) subregion the country is associated with.

- `worldBankIncomeGroup`: The World Bank income group the country is
  associated with.

- `admUnitCount`: The number of administrative units in the file.

- `meanVertices`: Mean number of vertices defining the boundaries of
  each administrative unit in the layer.

- `minVertices`: Minimum number of vertices defining a boundary.

- `maxVertices`: Maximum number of vertices defining a boundary.

- `minPerimeterLengthKM`: The minimum perimeter length of an
  administrative unit in the layer, measured in kilometers and based on
  a World Equidistant Cylindrical projection.

- `meanPerimeterLengthKM`: The mean perimeter length of an
  administrative unit in the layer, measured in kilometers and based on
  a World Equidistant Cylindrical projection.

- `maxPerimeterLengthKM`: The maximum perimeter length of an
  administrative unit in the layer, measured in kilometers and based on
  a World Equidistant Cylindrical projection.

- `meanAreaSqKM`: The mean area of all administrative units in the
  layer, measured in square kilometers and based on an EASE-GRID 2
  projection.

- `minAreaSqKM`: The minimum area of an administrative unit in the
  layer, measured in square kilometers and based on an EASE-GRID 2
  projection.

- `maxAreaSqKM`: The maximum area of an administrative unit in the
  layer, measured in square kilometers and based on an EASE-GRID 2
  projection.

- `staticDownloadLink`: The static download link for the aggregate ZIP
  file containing all boundary information.

- `gjDownloadURL`: The static download link for the GeoJSON.

- `tjDownloadURL`: The static download link for the TopoJSON.

- `imagePreview`: The static download link for an automatically rendered
  PNG image of the layer.

- `simplifiedGeometryGeoJSON`: The static download link for the
  simplified GeoJSON.

## See also

[`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md).

Metadata functions:
[`gb_get_max_adm_lvl()`](https://dieghernan.github.io/geobounds/reference/gb_get_max_adm_lvl.md)

## Examples

``` r
# Get boundary metadata for ADM4.

library(dplyr)

gb_get_metadata(adm_lvl = "ADM4") |>
  glimpse()
#> Rows: 21
#> Columns: 32
#> $ boundaryID                <chr> "AUT-ADM4-71187352", "BEL-ADM4-45533444", "B…
#> $ boundaryName              <chr> "Austria", "Belgium", "Bangladesh", "Czechia…
#> $ boundaryISO               <chr> "AUT", "BEL", "BGD", "CZE", "FJI", "FRA", "G…
#> $ boundaryYearRepresented   <chr> "2017", "2018", "2020", "2017", "2007", "201…
#> $ boundaryType              <chr> "ADM4", "ADM4", "ADM4", "ADM4", "ADM4", "ADM…
#> $ boundaryCanonical         <chr> "Unknown", "Unknown", "Union Councils / Muni…
#> $ boundarySource            <chr> "Federal Office for Metrology and Survey, Au…
#> $ boundaryLicense           <chr> "Creative Commons Attribution-ShareAlike 2.0…
#> $ licenseDetail             <chr> NA, "Creative Commons Attribution 4.0 Intern…
#> $ licenseSource             <chr> "twitter.com/WMgeoLab/status/125348789431395…
#> $ boundarySourceURL         <chr> "www.bev.gv.at/portal/page?_pageid=713,26393…
#> $ sourceDataUpdateDate      <dttm> 2023-01-19 07:31:04, 2023-07-10 13:37:13, 2…
#> $ buildDate                 <date> 2023-12-12, 2023-12-12, 2023-12-12, 2023-12…
#> $ Continent                 <chr> "Europe", "Europe", "Asia", "Europe", "Ocean…
#> $ `UNSDG-region`            <chr> "Europe and Northern America", "Europe and N…
#> $ `UNSDG-subregion`         <chr> "Western Europe", "Western Europe", "Souther…
#> $ worldBankIncomeGroup      <chr> "High-income Countries", "High-income Countr…
#> $ admUnitCount              <dbl> 7850, 589, 5160, 13090, 1602, 2054, 32, 7152…
#> $ meanVertices              <dbl> 824, 440, 1505, 413, 86, 2710, 4352, 348, 18…
#> $ minVertices               <dbl> 29, 67, 21, 9, 5, 53, 632, 11, 4, 38, 31, 4,…
#> $ maxVertices               <dbl> 52740, 1084, 9182, 4028, 847, 15387, 10383, …
#> $ meanPerimeterLengthKM     <dbl> 20.856955, 45.147426, 33.020823, 17.697541, …
#> $ minPerimeterLengthKM      <dbl> 0.5618598, 6.5279918, 1.3478627, 0.3701208, …
#> $ maxPerimeterLengthKM      <dbl> 152.20420, 115.80431, 1004.40607, 80.51895, …
#> $ meanAreaSqKM              <dbl> 10.693872, 52.056224, 27.103105, 6.025353, 1…
#> $ minAreaSqKM               <dbl> 0.004377737, 1.156515012, 0.026838648, 0.002…
#> $ maxAreaSqKM               <dbl> 467.16996, 215.52080, 1230.96466, 87.32215, …
#> $ staticDownloadLink        <chr> "https://github.com/wmgeolab/geoBoundaries/r…
#> $ gjDownloadURL             <chr> "https://github.com/wmgeolab/geoBoundaries/r…
#> $ tjDownloadURL             <chr> "https://github.com/wmgeolab/geoBoundaries/r…
#> $ imagePreview              <chr> "https://github.com/wmgeolab/geoBoundaries/r…
#> $ simplifiedGeometryGeoJSON <chr> "https://github.com/wmgeolab/geoBoundaries/r…
```
