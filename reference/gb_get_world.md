# Get global composite files (CGAZ) from geoBoundaries

[Attribution](https://www.geoboundaries.org/index.html#usage) is
required for all uses of this dataset.

This function returns global composite files for the required
administrative level, clipped to international boundaries, with gaps
filled between borders.

## Usage

``` r
gb_get_world(
  country = "all",
  adm_lvl = "adm0",
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
)
```

## Source

geoBoundaries API service <https://www.geoboundaries.org/api.html>.

## Arguments

- country:

  A character vector of country codes. It can be either `"all"` (which
  returns the data for all countries), a vector of country names or ISO
  3166-1 alpha-3 country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/man/countrycode.html).

- adm_lvl:

  Type of boundary. Accepted values are administrative levels 0, 1 and 2
  (`"adm0"` is the country boundary, `"adm1"` is the first level of
  subnational boundaries, `"adm2"` is the second level and so on).
  Upper-case versions (`"ADM1"`) and the number of the level (`0, 1, 2`)
  are also accepted.

- quiet:

  Logical. If `TRUE`, suppress informational messages.

- overwrite:

  Logical. If `TRUE`, force a fresh download of the source `.zip` file.

- cache_dir:

  A path to a cache directory. If not set (the default `NULL`), the data
  will be stored in the default cache directory (see
  [`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md)).
  If no cache directory has been set, files will be stored in the
  temporary directory. See
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html) and caching
  strategies in
  [`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md).

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

Comprehensive Global Administrative Zones (CGAZ) are global composites
for administrative boundaries. Compared with individual country files,
the global product uses extensive simplification so file sizes are small
enough for most desktop software, removes disputed areas and replaces
them with polygons following US Department of State definitions, and
fills gaps between borders.

## References

Runfola, D. et al. (2020) geoBoundaries: A global database of political
administrative boundaries. *PLOS ONE* *15*(4), 1-9.
[doi:10.1371/journal.pone.0231866](https://doi.org/10.1371/journal.pone.0231866)
.

## See also

Other API functions:
[`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md),
[`gb_get_adm`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md)

## Examples

``` r
# This download may take some time.
# \dontrun{
world <- gb_get_world()

library(ggplot2)

ggplot(world) +
  geom_sf() +
  coord_sf(expand = FALSE) +
  labs(caption = "Source: www.geoboundaries.org")

# }
```
