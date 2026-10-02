# Download global composite boundaries from **geoBoundaries**

Returns global composite boundaries for the requested ADM level.
Boundaries are clipped to international borders, with gaps between
borders filled.

Always acknowledge **geoBoundaries** and follow the terms in the CGAZ
archive.

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

- **geoBoundaries** global downloads:
  <https://www.geoboundaries.org/globalDownloads.html>.

- CGAZ release files:
  <https://github.com/wmgeolab/geoBoundaries/tree/main/releaseData/CGAZ>.

## Arguments

- country:

  A character vector of country names or ISO 3166-1 alpha-3 codes. Use
  `"all"` to return all countries. The complete global layer is
  downloaded and read before filtering, so country selection does not
  reduce the initial download size or the memory needed to read it.

- adm_lvl:

  ADM level. Accepted values are levels 0, 1 and 2 (`"adm0"` is the
  country boundary, `"adm1"` is the first level of subnational
  boundaries and `"adm2"` is the second level). Uppercase versions
  (`"ADM1"`) and level numbers (`0`, `1`, `2`) are also accepted,
  including numbers supplied as text (for example, `"1"`).

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

CGAZ uses extensive simplification and standardizes disputed areas. See
[`vignette("geobounds", package = "geobounds")`](https://dieghernan.github.io/geobounds/articles/geobounds.md)
for product differences. Archives come from the repository's `main`
branch and historical versions cannot be selected. See
[`vignette("metadata", package = "geobounds")`](https://dieghernan.github.io/geobounds/articles/metadata.md)
for provenance.

## References

Runfola et al. (2020) "geoBoundaries: A global database of political
administrative boundaries." *PLOS ONE*, **15**(4), e0231866.
[doi:10.1371/journal.pone.0231866](https://doi.org/10.1371/journal.pone.0231866)
.

## See also

[`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md)
downloads individual country boundaries instead of CGAZ layers.
[`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md)
configures where downloaded archives are cached. See
[`vignette("geobounds", package = "geobounds")`](https://dieghernan.github.io/geobounds/articles/geobounds.md)
for a comparison of individual country boundaries and global composites.

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
  labs(caption = "Source: geoBoundaries (CGAZ)")

# }
```
