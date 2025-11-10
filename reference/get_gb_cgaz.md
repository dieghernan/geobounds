# Get global composites data (CGAZ) from geoBoundaries

[Attribution](https://www.geoboundaries.org/index.html#usage) is
required for all uses of this dataset.

This function returns a global composite of the required administration
level, clipped to international boundaries, with gaps filled between
borders.

## Usage

``` r
get_gb_cgaz(
  country = "ALL",
  adm_lvl = c("ADM0", "ADM1", "ADM2"),
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

  Type of boundary Accepted values are the ADM level (`"ADM0"` is the
  country boundary, `"ADM1"` is the first level of sub national
  boundaries, `"ADM2"` is the second level).

- quiet:

  Logical, on `FALSE` it displays information of the call. Useful for
  debugging, default is no messages `quiet = TRUE`.

- overwrite:

  A logical whether to update cache. Default is `FALSE`. When set to
  `TRUE` it would force a fresh download of the source `.gpkg` file.

- cache_dir:

  A path to a cache directory. If not set (the default `NULL`), the data
  would be stored in the default cache directory (see
  [`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md)).
  If no cache directory has been set, files would be stored in the
  temporary directory (see
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html)).

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

Comprehensive Global Administrative Zones (CGAZ) is a set of global
composites for administrative boundaries. There are two important
distinctions between our global product and individual country
downloads.

- Extensive simplification is performed to ensure that file sizes are
  small enough to be used in most traditional desktop software.

- Disputed areas are removed and replaced with polygons following US
  Department of State definitions.

## References

Runfola, D. et al. (2020) geoBoundaries: A global database of political
administrative boundaries. *PLOS ONE* 15(4): e0231866.
[doi:10.1371/journal.pone.0231866](https://doi.org/10.1371/journal.pone.0231866)
.

## See also

Other API functions:
[`get_gb()`](https://dieghernan.github.io/geobounds/reference/get_gb.md),
[`get_gb_adm`](https://dieghernan.github.io/geobounds/reference/get_gb_adm.md)

## Examples

``` r
# This download may take some time
# \dontrun{
world <- get_gb_cgaz()

library(ggplot2)

ggplot(world) +
  geom_sf() +
  coord_sf(expand = FALSE) +
  labs(caption = "Source: www.geoboundaries.org")

# }
```
