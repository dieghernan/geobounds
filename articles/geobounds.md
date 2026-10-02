# geobounds: Download administrative boundaries in R

Important

The package code is MIT licensed. Always acknowledge **geoBoundaries**
when sharing downloaded boundaries or derived figures. Check the
boundary metadata for any additional source attribution and licensing
requirements before reuse.

## Introduction

The **geobounds** package provides an interface for downloading and
working with administrative boundaries from the Global Database of
Political Administrative Boundaries, maintained by
[**geoBoundaries**](https://www.geoboundaries.org/) ([Runfola et al.
2020](#ref-10.1371/journal.pone.0231866)).

The default **gbOpen** product provides boundaries across multiple ADM
levels. With **geobounds**, you can download boundaries as **sf**
objects and integrate them into spatial workflows. For release types,
dates, sources and licensing, see [the metadata
vignette](https://dieghernan.github.io/geobounds/articles/metadata.md).

This vignette explains how to [choose between individual country and
global composite boundaries](#understanding-the-boundaries), then covers
[cache management](#cache-management-and-performance) and finishes with
a [spatial analysis example](#spatial-analysis-workflows).

## Understanding the boundaries

The **geoBoundaries** database supports commercial, non-commercial and
academic uses, subject to the license reported for each boundary. Its
quality assurance includes manual review and hand digitization of
physical maps where necessary.

This precision comes at a cost: some files can be quite large and may
take longer to download. For visualization or general mapping purposes,
the [simplified
boundaries](https://www.geoboundaries.org/simplifiedDownloads.html) are
less accurate but faster to render. Request them by setting
`simplified = TRUE`.

``` r

library(geobounds)
library(ggplot2)
library(dplyr)

# Compare resolutions.
norway <- gb_get_adm0("NOR") |>
  mutate(res = "Full resolution")
print(object.size(norway), units = "Mb")
#> 26.5 Mb

norway_simp <- gb_get_adm0(country = "NOR", simplified = TRUE) |>
  mutate(res = "Simplified")
print(object.size(norway_simp), units = "Mb")
#> 1.5 Mb

norway_all <- bind_rows(norway, norway_simp)

# Plot the boundaries.
ggplot(norway_all) +
  geom_sf(fill = "#BA0C2F", color = "#00205B") +
  facet_wrap(vars(res)) +
  theme_minimal() +
  labs(
    caption = paste(
      "Sources: geoBoundaries and the original boundary provider,",
      "check gb_get_metadata() for the license"
    )
  )
```

![Two maps of Norway arranged side by side, with longitude and latitude
axes. The full-resolution and simplified outlines show the same overall
shape, but simplification reduces detail along the
coastline.](./norway-1.png)

Comparison between full-resolution and simplified boundaries.

### Individual country boundaries

**geoBoundaries** provides terrestrial administrative boundaries. Its
[contribution
guidelines](https://github.com/wmgeolab/geoBoundaries/blob/main/CONTRIBUTING.md)
require coastal and island boundaries to exclude state-claimed waters.
These data should not be interpreted as maritime boundaries or used to
delineate territorial seas or exclusive economic zones.

The **geoBoundaries** API provides [individual country
boundaries](https://www.geoboundaries.org/countryDownloads.html) that
reflect how countries represent their own boundaries, without special
identification of disputed areas.

Download individual country boundaries with
[`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md)
or the `gb_get_adm*()` wrappers. Borders are not guaranteed to align
perfectly, gaps may exist between countries and disputed territories may
not be represented consistently.

``` r

india_pak <- gb_get_adm0(c("India", "Pakistan"))

# Highlight the disputed Kashmir area.
ggplot(india_pak) +
  geom_sf(aes(fill = shapeName), alpha = 0.5) +
  scale_fill_manual(values = c("#FF671F", "#00401A")) +
  labs(
    fill = "Country",
    title = "Map of India and Pakistan",
    subtitle = "Note the overlap in the Kashmir region",
    caption = paste(
      "Sources: geoBoundaries and the original boundary providers,",
      "check gb_get_metadata() for licenses"
    )
  )
```

![Map of India and Pakistan with longitude and latitude axes. India is
filled orange and Pakistan dark green, both partly transparent. Their
national boundary polygons overlap in the disputed Kashmir
region.](./intersect-1.png)

Map showing overlap in the disputed Kashmir area.

Inspect sources and licenses with
[`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_metadata.md)
before sharing a boundary or derived product. See [sources and
licenses](https://dieghernan.github.io/geobounds/articles/metadata.html#inspect-sources-and-licenses)
for a worked example.

### Global composite boundaries

Use
[`gb_get_world()`](https://dieghernan.github.io/geobounds/reference/gb_get_world.md)
for global composite boundaries that standardize disputed areas and fill
gaps between borders. These boundaries are also known as Comprehensive
Global Administrative Zones (CGAZ). They differ from individual country
boundaries in three important ways:

1.  Extensive simplification keeps file sizes small enough for most
    desktop software.
2.  Disputed areas are removed and replaced with polygons following
    United States Department of State definitions.
3.  Gaps between borders are filled.

CGAZ boundaries and figures are not covered by the package’s MIT
license. Follow the citation and use information included in each
downloaded CGAZ archive.

``` r

cgaz_india_pak <- gb_get_world(c("India", "Pakistan"))

ggplot(cgaz_india_pak) +
  geom_sf(aes(fill = shapeName), alpha = 0.5) +
  scale_fill_manual(values = c("#FF671F", "#00401A")) +
  labs(
    fill = "Country",
    title = "Map of India and Pakistan",
    subtitle = "CGAZ does not overlap",
    caption = "Source: geoBoundaries (CGAZ)"
  )
```

![Map of India and Pakistan with longitude and latitude axes. India is
filled orange and Pakistan dark green. The global composite boundary
polygons meet without overlapping in the Kashmir region.](./cgaz-1.png)

Map showing no overlap in Kashmir, provided by CGAZ.

## Cache management and performance

**geobounds** reuses downloaded archives from a cache directory. Use
`cache_dir` for an individual download or
[`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md)
to configure a shared directory. See
[`?gb_set_cache_dir`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md)
for persistent cache options.

``` r

gb_get_adm1("Sri Lanka", cache_dir = "boundary-cache")
```

[`gb_get_world()`](https://dieghernan.github.io/geobounds/reference/gb_get_world.md)
downloads and reads the complete global archive before selecting
countries. Filtering countries reduces the returned object, but not the
initial download size or memory needed to read the layer.

For cache freshness, historical versions and preserving data provenance,
see [the metadata
vignette](https://dieghernan.github.io/geobounds/articles/metadata.html#preserve-data-provenance).

To clear the cache, use
[`gb_clear_cache()`](https://dieghernan.github.io/geobounds/reference/gb_clear_cache.md).

## Spatial analysis workflows

Because boundaries are returned as **sf** objects, you can combine them
with other spatial data:

- Clip raster data to administrative units.
- Compute zonal statistics.
- Create choropleth maps.
- Perform spatial joins with survey or tabular data.

This example creates a choropleth map using metadata from individual
country boundaries and global composite boundaries from CGAZ:

``` r

# Get boundary metadata.
latam_meta <- gb_get_metadata(adm_lvl = "ADM0") |>
  select(boundaryISO, boundaryName, Continent, worldBankIncomeGroup) |>
  filter(Continent == "Latin America and the Caribbean") |>
  glimpse()
#> Rows: 47
#> Columns: 4
#> $ boundaryISO          <chr> "ABW", "AIA", "ARG", "ATG", "BES", "BHS", "BLM", …
#> $ boundaryName         <chr> "Aruba", "Anguilla", "Argentina", "Antigua and Ba…
#> $ Continent            <chr> "Latin America and the Caribbean", "Latin America…
#> $ worldBankIncomeGroup <chr> "High-income Countries", "No income group availab…

# Adjust factors.
latam_meta$income_factor <- factor(
  latam_meta$worldBankIncomeGroup,
  levels = c(
    "High-income Countries",
    "Upper-middle-income Countries",
    "Lower-middle-income Countries",
    "Low-income Countries"
  )
)

# Get global composite boundaries from CGAZ.
latam_sf <- gb_get_world(adm_lvl = "ADM0") |>
  inner_join(latam_meta, by = c("shapeGroup" = "boundaryISO"))

ggplot(latam_sf) +
  geom_sf(aes(fill = income_factor)) +
  scale_fill_brewer(palette = "Greens", direction = -1) +
  guides(fill = guide_legend(position = "bottom", nrow = 2)) +
  coord_sf(
    crs = "+proj=laea +lon_0=-75 +lat_0=-15"
  ) +
  labs(
    title = "World Bank Income Group",
    subtitle = "Latin America and the Caribbean",
    fill = "",
    caption = "Source: geoBoundaries (CGAZ and gbOpen metadata)"
  )
```

![Choropleth map of Latin America and the Caribbean. Green shades
distinguish World Bank income groups, with darker shades for higher
incomes and lighter shades for lower incomes. Areas without a listed
income group are gray.](./choro-1.png)

World Bank income groups: Latin America and the Caribbean.

## Summary

The **geobounds** package supports reproducible workflows for
downloading, caching and visualizing administrative boundaries. The
returned **sf** objects can be used directly in mapping, spatial
analysis and data integration workflows.

## References

Runfola, Daniel, Austin Anderson, Heather Baier, et al. 2020.
“geoBoundaries: A Global Database of Political Administrative
Boundaries.” *PLOS ONE* 15 (4): e0231866.
<https://doi.org/10.1371/journal.pone.0231866>.
