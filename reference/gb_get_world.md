# Download global composite boundaries from **geoBoundaries**

Returns global composite boundaries for the requested ADM level.
Boundaries are clipped to international borders, with gaps between
borders filled.

[Attribution](https://www.geoboundaries.org/index.html#usage) is
required whenever these data are used.

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

[**geoBoundaries** API](https://www.geoboundaries.org/api.html).

## Arguments

- country:

  A character vector of country names or ISO 3166-1 alpha-3 country
  codes. Use `"all"` to return data for all countries. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/man/countrycode.html).

- adm_lvl:

  ADM level. Accepted values are levels 0, 1 and 2 (`"adm0"` is the
  country boundary, `"adm1"` is the first level of subnational
  boundaries and `"adm2"` is the second level). Uppercase versions
  (`"ADM1"`) and level numbers (`0`, `1`, `2`) are also accepted.

- quiet:

  A logical value. If `TRUE`, suppress informational messages.

- overwrite:

  A logical value. If `TRUE`, force a fresh download of the source
  `.zip` archive.

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

An [sf](https://r-spatial.github.io/sf/reference/sf.html) object from
[sf](https://CRAN.R-project.org/package=sf) containing the requested
boundaries. If no boundary files match the request, the function returns
`NULL`.

## Details

Comprehensive Global Administrative Zones (CGAZ) are global composites
for administrative boundaries. Compared with individual country boundary
files, global composite boundaries use extensive simplification so file
sizes are small enough for most desktop software. They remove disputed
areas, replace them with polygons following US Department of State
definitions and fill gaps between borders.

## References

Runfola et al. (2020) **geoBoundaries**: A global database of political
administrative boundaries. *PLOS ONE* **15**(4), e0231866.
[doi:10.1371/journal.pone.0231866](https://doi.org/10.1371/journal.pone.0231866)
.

## See also

- [`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_metadata.md)
  inspects boundary metadata and licensing.

- [`gb_get_max_adm_lvl()`](https://dieghernan.github.io/geobounds/reference/gb_get_max_adm_lvl.md)
  checks the ADM levels available for individual country boundaries.

Boundary download functions:
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
