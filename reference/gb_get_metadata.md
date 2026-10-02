# Retrieve boundary metadata from **geoBoundaries**

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

- release_type:

  A character string, one of `"gbOpen"` (the default),
  `"gbHumanitarian"` or `"gbAuthoritative"`. Selects a product, not a
  dataset version. `"gbAuthoritative"` is restricted to non-commercial
  use. See
  [`vignette("metadata", package = "geobounds")`](https://dieghernan.github.io/geobounds/articles/metadata.md)
  for product sources and licenses.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html)
from [tibble](https://CRAN.R-project.org/package=tibble) with one row
per matching boundary. Numeric statistics are converted to numeric
values, `sourceDataUpdateDate` to
[POSIXlt](https://rdrr.io/r/base/DateTimeClasses.html) in GMT and
`buildDate` to [Date](https://rdrr.io/r/base/Dates.html). Literal
`"nan"` values become `NA`.

## Details

This function queries `/api/current` and does not select historical
versions. See
[`vignette("metadata", package = "geobounds")`](https://dieghernan.github.io/geobounds/articles/metadata.md)
for column definitions, type conversions, availability, licensing and
reproducible workflows.

## References

Runfola et al. (2020) "geoBoundaries: A global database of political
administrative boundaries." *PLOS ONE*, **15**(4), e0231866.
[doi:10.1371/journal.pone.0231866](https://doi.org/10.1371/journal.pone.0231866)
.

## See also

[`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md)
downloads the boundaries described by the metadata. The [ADM
wrappers](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md)
request a single administrative level. This metadata describes
individual country boundaries, not the CGAZ layers returned by
[`gb_get_world()`](https://dieghernan.github.io/geobounds/reference/gb_get_world.md).

Metadata and licensing functions:
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
