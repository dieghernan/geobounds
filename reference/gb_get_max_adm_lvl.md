# Get the highest administrative level available for a given country

Get a summary of selected or all countries and their highest
administrative level available in geoBoundaries.

## Usage

``` r
gb_get_max_adm_lvl(
  country = "all",
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative")
)
```

## Source

geoBoundaries API Service <https://www.geoboundaries.org/api.html>.

## Arguments

- country:

  A character vector of country codes. It can be either `"all"` (that
  would return the data for all countries), a vector of country names or
  ISO3 country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

- release_type:

  One of `"gbOpen"`, `"gbHumanitarian"`, `"gbAuthoritative"`. For most
  users, we suggest using `"gbOpen"` (the default), as it is CC-BY 4.0
  compliant and can be used for most purposes so long as attribution is
  provided:

  - `"gbHumanitarian"` files are mirrored from [UN
    OCHA](https://www.unocha.org/), but may have more restrictive
    licensing.

  - `"gbAuthoritative"` files are mirrored from UN SALB, and cannot be
    used for commercial purposes, but are verified through in-country
    processes.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html)
with the country names and corresponding highest administrative level.

## See also

Other metadata functions:
[`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_metadata.md)

## Examples

``` r
all <- gb_get_max_adm_lvl()
library(dplyr)

# Countries with only 1 level available
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

# Countries with level 4 available
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
