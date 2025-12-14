# geobounds: Accessing Global Administrative Boundary Data in R

[**Attribution**](https://www.geoboundaries.org/index.html#usage) **is
required when using geoBoundaries.**

## Introduction

The **geobounds** package provides a straightforward interface for
downloading and working with global political and administrative
boundary data from the [geoBoundaries](https://www.geoboundaries.org/)
project ([Runfola et al. 2020](#ref-geoboundaries)).

These datasets are openly licensed ([CC BY
4.0](https://creativecommons.org/licenses/by/4.0/)) and cover countries
worldwide across multiple administrative levels. With **geobounds**, you
can easily fetch boundary geometries as **sf** objects, explore
metadata, cache datasets locally, and seamlessly integrate the
boundaries into your spatial workflows.

## Understanding the data

The geoBoundaries database undergoes a rigorous quality assurance
process, including manual review and hand-digitization of physical maps
where necessary. Its primary goal is to provide the highest possible
level of spatial accuracy for scientific and academic applications.

This precision comes at a cost: some files can be quite large and may
take longer to download. For visualization or general mapping purposes,
we recommend using the simplified datasets available by setting
`simplified = TRUE`.

``` r
library(geobounds)
library(ggplot2)
library(dplyr)

# Different resolutions
norway <- gb_get_adm0("NOR") |>
  mutate(res = "Full resolution")
print(object.size(norway), units = "Mb")
#> 26.5 Mb

norway_simp <- gb_get_adm0(country = "NOR", simplified = TRUE) |>
  mutate(res = "Simplified")
print(object.size(norway_simp), units = "Mb")
#> 1.5 Mb

norway_all <- bind_rows(norway, norway_simp)

# Plot ggplot2
ggplot(norway_all) +
  geom_sf(fill = "#BA0C2F", color = "#00205B") +
  facet_wrap(vars(res)) +
  theme_minimal() +
  labs(caption = "Source: www.geoboundaries.org")
```

![Comparison between full vs. simplified map.](norway-1.png)

Comparison between full vs. simplified map.

### Individual country files

The geoBoundaries API provides [individual country
files](https://www.geoboundaries.org/countryDownloads.html), whose aim
is to represent every nation “as they would represent themselves”, with
no special identification of disputed areas.

The download of this data is implemented in
[`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md)
and the `gb_get_adm` family of functions. It is not guaranteed that
borders align perfectly or that there are no gaps between countries.
Additionally, these files do not include a special identification of
disputed areas.

``` r
india_pak <- gb_get_adm0(c("India", "Pakistan"))

# Disputed area: Kashmir
ggplot(india_pak) +
  geom_sf(aes(fill = shapeName), alpha = 0.5) +
  scale_fill_manual(values = c("#FF671F", "#00401A")) +
  labs(
    fill = "Country",
    title = "Map of India & Pakistan",
    subtitle = "Note overlapping in Kashmir region",
    caption = "Source: www.geoboundaries.org"
  )
```

![Map showing overlapping in disputed area: Kashmir.](intersect-1.png)

Map showing overlapping in disputed area: Kashmir.

Note that individual data files are governed by the license or licenses
identified within the metadata for each respective boundary.

``` r
gb_get_metadata(c("India", "Pakistan"), adm_lvl = "ADM0") |>
  select(boundaryName, boundaryLicense, boundarySource)
#> # A tibble: 2 × 3
#>   boundaryName boundaryLicense                                      boundarySource           
#>   <chr>        <chr>                                                <chr>                    
#> 1 India        CC0 1.0 Universal (CC0 1.0) Public Domain Dedication geoBoundaries, Wikimedia…
#> 2 Pakistan     Open Data Commons Open Database License 1.0          OpenStreetMap, Wambacher
```

### Composite files

If you would prefer data that explicitly includes disputed areas, please
use
[`gb_get_cgaz()`](https://dieghernan.github.io/geobounds/reference/gb_get_cgaz.md).
This function downloads global composite datasets for administrative
boundaries, also known as CGAZ (Comprehensive Global Administrative
Zones). There are three important distinctions between CGAZ and
individual country downloads:

1.  Extensive simplification is performed to ensure that file sizes are
    small enough to be used in most traditional desktop software.

2.  Disputed areas are removed and replaced with polygons following US
    Department of State definitions.

3.  Gaps between borders have been filled.

``` r
cgaz_india_pak <- gb_get_cgaz(c("India", "Pakistan"))

ggplot(cgaz_india_pak) +
  geom_sf(aes(fill = shapeName), alpha = 0.5) +
  scale_fill_manual(values = c("#FF671F", "#00401A")) +
  labs(
    fill = "Country",
    title = "Map of India & Pakistan",
    subtitle = "CGAZ does not overlap",
    caption = "Source: www.geoboundaries.org"
  )
```

![Map showing no overlapping in Kashmir, provided by CGAZ.](cgaz-1.png)

Map showing no overlapping in Kashmir, provided by CGAZ.

## Caching and performance

The package provides a built-in mechanism to cache files locally so that
repeated downloads for the same country/level will use the cached
version. For example:

``` r
# Current folder
current <- gb_detect_cache_dir()
#> ℹ 'C:\Users\diego\AppData\Local\Temp\RtmpsVnmBg'

current
#> [1] "C:\\Users\\diego\\AppData\\Local\\Temp\\RtmpsVnmBg"

# Change to new
newdir <- file.path(tempdir(), "/geoboundvignette")
gb_set_cache_dir(newdir)
#> ✔ geobounds cache dir is 'C:\Users\diego\AppData\Local\Temp\RtmpsVnmBg//geoboundvignette'.
#> ℹ To install your `cache_dir` path for use in future sessions run this function with `install = TRUE`.

# Download
example <- gb_get_adm0("Vatican City", quiet = FALSE)
#> ℹ Downloading file from <https://github.com/wmgeolab/geoBoundaries/raw/9469f09/releaseData/gbOpen/VAT/ADM0/geoBoundaries-VAT-ADM0-all.zip>
#> → Cache dir is 'C:\Users\diego\AppData\Local\Temp\RtmpsVnmBg//geoboundvignette/gbOpen'

# Restore cache dir
gb_set_cache_dir(current)
#> ✔ geobounds cache dir is 'C:\Users\diego\AppData\Local\Temp\RtmpsVnmBg'.
#> ℹ To install your `cache_dir` path for use in future sessions run this function with `install = TRUE`.

current == gb_detect_cache_dir()
#> ℹ 'C:\Users\diego\AppData\Local\Temp\RtmpsVnmBg'
#> [1] TRUE
```

Specific cache directories on each function call can be set using the
`cache_dir` argument of each function.

## Use in spatial analysis pipelines

Because the boundaries are returned as **sf** objects, you can easily
use them in combination with other spatial data:

- Clip raster data to administrative units
- Compute zonal statistics
- Create choropleth maps
- Perform spatial joins with survey or tabular data

In this example we would create a choropleth map using the meta data of
the individual files and the boundaries data of CGAZ:

``` r
# Metadata

latam_meta <- gb_get_metadata(adm_lvl = "ADM0") |>
  select(boundaryISO, boundaryName, Continent, worldBankIncomeGroup) |>
  filter(Continent == "Latin America and the Caribbean") |>
  glimpse()
#> Rows: 47
#> Columns: 4
#> $ boundaryISO          <chr> "ABW", "AIA", "ARG", "ATG", "BES", "BHS", "BLM", "BLZ", "BOL",…
#> $ boundaryName         <chr> "Aruba", "Anguilla", "Argentina", "Antigua and Barbuda", "Bona…
#> $ Continent            <chr> "Latin America and the Caribbean", "Latin America and the Cari…
#> $ worldBankIncomeGroup <chr> "High-income Countries", "No income group available", "High-in…

# Adjust factors
latam_meta$income_factor <- factor(latam_meta$worldBankIncomeGroup,
  levels = c(
    "High-income Countries",
    "Upper-middle-income Countries",
    "Lower-middle-income Countries",
    "Low-income Countries"
  )
)

# Get the shapes from CGAZ
latam_sf <- gb_get_cgaz(adm_lvl = "ADM0") |>
  inner_join(latam_meta,
    by =
      c("shapeGroup" = "boundaryISO")
  )

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
    caption = "Source: www.geoboundaries.org"
  )
```

![World Bank Income Group: Latin America and the Caribbean
](choro-1.png)

World Bank Income Group: Latin America and the Caribbean

## Summary

The **geobounds** package makes it easy to fetch, manage and visualize
administrative boundary data worldwide in a reproducible and efficient
way. Whether you’re doing mapping, spatial analysis, survey integration
or geospatial modelling, it gives you a high-quality boundary dataset
with minimal overhead.

## References

Runfola, Daniel, Austin Anderson, Heather Baier, Matt Crittenden,
Elizabeth Dowker, Sydney Fuhrig, Seth Goodman, et al. 2020.
“geoBoundaries: A Global Database of Political Administrative
Boundaries.” *PLoS ONE* 15 (4): 1–9.
<https://doi.org/10.1371/journal.pone.0231866>.
