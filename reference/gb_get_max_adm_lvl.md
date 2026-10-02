# Find the highest available ADM level

Returns a summary of selected country codes and their highest available
ADM level in **geoBoundaries**. ADM0 represents the country boundary.
Use
[`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_metadata.md)
to list available layers in the selected release type.

## Usage

``` r
gb_get_max_adm_lvl(
  country = "all",
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
per matching country. The `boundaryISO` column contains ISO 3166-1
alpha-3 country codes and `maxBoundaryType` contains the highest
available ADM level as an integer.

## References

Runfola et al. (2020) "geoBoundaries: A global database of political
administrative boundaries." *PLOS ONE*, **15**(4), e0231866.
[doi:10.1371/journal.pone.0231866](https://doi.org/10.1371/journal.pone.0231866)
.

## See also

[`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md)
downloads boundaries for the available ADM levels. The [ADM
wrappers](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md)
request a single administrative level. See
[`vignette("metadata", package = "geobounds")`](https://dieghernan.github.io/geobounds/articles/metadata.md)
for availability and metadata fields.

Metadata and licensing functions:
[`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_metadata.md)

## Examples

``` r
all <- gb_get_max_adm_lvl()
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union

# Countries whose highest available level is ADM1.
all |>
  filter(maxBoundaryType == 1)
#> # A tibble: 21 × 2
#>    boundaryISO maxBoundaryType
#>    <chr>                 <int>
#>  1 AND                       1
#>  2 ARE                       1
#>  3 ATG                       1
#>  4 BHR                       1
#>  5 BRB                       1
#>  6 DMA                       1
#>  7 GRD                       1
#>  8 GRL                       1
#>  9 KNA                       1
#> 10 LBY                       1
#> # ℹ 11 more rows

# Countries whose highest available level is ADM4.
all |>
  filter(maxBoundaryType == 4)
#> # A tibble: 18 × 2
#>    boundaryISO maxBoundaryType
#>    <chr>                 <int>
#>  1 AUT                       4
#>  2 BEL                       4
#>  3 BGD                       4
#>  4 CZE                       4
#>  5 FJI                       4
#>  6 GLP                       4
#>  7 IRN                       4
#>  8 ITA                       4
#>  9 LKA                       4
#> 10 MDG                       4
#> 11 MTQ                       4
#> 12 MYT                       4
#> 13 REU                       4
#> 14 SLB                       4
#> 15 SLE                       4
#> 16 SVK                       4
#> 17 UGA                       4
#> 18 ZAF                       4
```
