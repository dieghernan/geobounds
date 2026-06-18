

<!-- index.md is generated from index.qmd. Please edit that file -->

# geobounds <a href="https://dieghernan.github.io/geobounds/"><img src="man/figures/logo.png" alt="geobounds website" align="right" height="139"/></a>

<!-- badges: start -->

[![CRAN-status](https://www.r-pkg.org/badges/version/geobounds)](https://CRAN.R-project.org/package=geobounds)
[![CRAN-results](https://badges.cranchecks.info/worst/geobounds.svg)](https://cran.r-project.org/web/checks/check_results_geobounds.html)
[![Downloads](https://cranlogs.r-pkg.org/badges/geobounds)](https://CRAN.R-project.org/package=geobounds)
[![r-universe](https://dieghernan.r-universe.dev/badges/geobounds)](https://dieghernan.r-universe.dev/geobounds)
[![R-CMD-check](https://github.com/dieghernan/geobounds/actions/workflows/check-full.yaml/badge.svg)](https://github.com/dieghernan/geobounds/actions/workflows/check-full.yaml)
[![codecov](https://codecov.io/gh/dieghernan/geobounds/graph/badge.svg)](https://app.codecov.io/gh/dieghernan/geobounds)
[![CodeFactor](https://www.codefactor.io/repository/github/dieghernan/geobounds/badge)](https://www.codefactor.io/repository/github/dieghernan/geobounds)
[![DOI](https://img.shields.io/badge/DOI-%2010.32614/CRAN.package.geobounds%20-blue)](https://doi.org/10.32614/CRAN.package.geobounds)
[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

<!-- badges: end -->

## Why this package?

The **geobounds** package provides an **R**-friendly interface for
downloading administrative boundary data from
[**geoBoundaries**](https://www.geoboundaries.org/), the Global Database
of Political Administrative Boundaries. With **geobounds**, you can:

- Download individual country files and global composite files from
  **geoBoundaries**.
- Use **tidyverse** and **sf** workflows in **R** to map, analyze and
  join administrative boundary data with your own data.
- Work in an open-data context where attribution to **geoBoundaries** is
  required.

In short, if you work with administrative boundaries in **R**, this
package simplifies downloading, cache management and integration with
spatial data workflows.

<div class="callout callout-style-default callout-important callout-titled">
<div class="callout-header d-flex align-content-center">
<div class="callout-icon-container"><i class="callout-icon"></i></div>
<div class="callout-title-container flex-fill">Important</div>
</div>
<div class="callout-body-container callout-body">
<p><a href="https://www.geoboundaries.org/index.html#usage" class="external-link">Attribution</a> is required when using 
<strong>geoBoundaries</strong>.</p>
</div>
</div>

## Installation

Install **geobounds** from
[**CRAN**](https://CRAN.R-project.org/package=geobounds):

``` r
install.packages("geobounds")
```

<div class="pkgdown-devel">

Check the documentation for the development version at
<https://dieghernan.github.io/geobounds/dev/>

You can install the development version of **geobounds** with:

``` r
# install.packages("pak")
pak::pak("dieghernan/geobounds")
```

Alternatively, you can install **geobounds** from
[R-universe](https://dieghernan.r-universe.dev/geobounds):

``` r
# Install geobounds.
install.packages(
  "geobounds",
  repos = c(
    "https://dieghernan.r-universe.dev",
    "https://cloud.r-project.org"
  )
)
```

</div>

## Example usage

``` r
library(geobounds)

sri_lanka_adm1 <- gb_get_adm1("Sri Lanka")
sri_lanka_adm2 <- gb_get_adm2("Sri Lanka")
sri_lanka_adm3 <- gb_get_adm3("Sri Lanka")

library(sf)
library(dplyr)

library(ggplot2)

ggplot(sri_lanka_adm3) +
  geom_sf(fill = "#DFDFDF", color = "white") +
  geom_sf(data = sri_lanka_adm2, fill = NA, color = "#F0B323") +
  geom_sf(data = sri_lanka_adm1, fill = NA, color = "black") +
  labs(caption = "Source: www.geoboundaries.org") +
  theme_void()
```

<img src="man/figures/README-simple_plot-1.png" style="width:100.0%"
alt="ADM1, ADM2 and ADM3 boundaries for Sri Lanka." />

## Release types

**geoBoundaries** provides three release types with different sources,
validation processes and licensing:

- **gbOpen**: Freely available boundaries under CC BY 4.0, suitable for
  most uses when attribution is provided.
- **gbHumanitarian**: Boundaries mirrored from UN OCHA for humanitarian
  use, which may have less open licensing.
- **gbAuthoritative**: Boundaries mirrored from UN SALB and verified
  through in-country processes. These boundaries cannot be used for
  commercial purposes.

Use the `release_type` argument to request a specific release type, for
example, `gb_get_adm1("Sri Lanka", release_type = "gbHumanitarian")`.

For coverage and boundary metadata by release type, see the package
articles.

## Advanced usage

Map the highest available ADM level in **geoBoundaries** by country:

``` r
library(geobounds)
library(ggplot2)
library(dplyr)

world <- gb_get_world()
max_lvl <- gb_get_max_adm_lvl(release_type = "gbOpen")

world_max <- world |>
  mutate(boundaryISO = shapeGroup) |>
  left_join(max_lvl) |>
  mutate(max_lvl = factor(maxBoundaryType, levels = 0:5))

pal <- c("#0e221b", "#0f4a38", "#0b6e4f", "#719384", "#b9975a", "#936e28")
names(pal) <- levels(world_max$max_lvl)

ggplot(world_max) +
  geom_sf(fill = "#e5e5e5", color = "#e5e5e5") +
  geom_sf(aes(fill = max_lvl), color = "transparent") +
  scale_fill_manual(values = pal, na.translate = FALSE, drop = FALSE) +
  guides(fill = guide_legend(direction = "horizontal", nrow = 1)) +
  coord_sf(expand = TRUE, crs = "+proj=robin") +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    text = element_text(family = "sans", face = "bold"),
    legend.position = "bottom",
    legend.title.position = "top",
    legend.title = element_text(size = rel(0.75), face = "plain"),
    legend.text = element_text(size = rel(1)),
    legend.text.position = "right",
    legend.key.height = unit(1, "line"),
    legend.key.width = unit(1, "line"),
    plot.caption = element_text(
      size = rel(0.7),
      margin = margin(r = 4)
    )
  ) +
  labs(
    fill = "gbOpen: Highest available ADM level",
    caption = "Source: www.geoboundaries.org"
  )
```

<img src="man/figures/README-map-coverage-1.png" style="width:100.0%"
alt="Highest available gbOpen ADM level by country." />

## Documentation and resources

- Visit the **pkgdown** site for full documentation:
  <https://dieghernan.github.io/geobounds/>
- Articles on **geoBoundaries** release types:
  - [gbOpen](https://dieghernan.github.io/geobounds/articles/gbopen.html)
  - [gbHumanitarian](https://dieghernan.github.io/geobounds/articles/gbhumanitarian.html)
  - [gbAuthoritative](https://dieghernan.github.io/geobounds/articles/gbauthoritative.html)
- Explore the **geoBoundaries** homepage:
  <https://www.geoboundaries.org/>
- Read the original paper describing the **geoBoundaries** dataset
  ([Runfola et al. 2020](#ref-10.1371/journal.pone.0231866)).
- Report issues or contribute on
  [GitHub](https://github.com/dieghernan/geobounds).

## License

This package is released under the [CC BY
4.0](https://creativecommons.org/licenses/by/4.0/) license. The default
**geoBoundaries** release type, **gbOpen**, is CC BY 4.0 compliant when
attribution is provided. Other release types may have additional
licensing restrictions, so check the boundary metadata returned by
`gb_get_metadata()` before reuse.

## Acknowledgments

- Thanks to the **geoBoundaries** team and the [William & Mary
  geoLab](https://sites.google.com/view/wmgeolab/) for creating and
  maintaining the dataset.
- Thanks to the **R** package community and all contributors to this
  package’s development.
- If you use **geobounds** and the underlying **geoBoundaries** data,
  please cite both.

## Citation

<p>

Hernangómez D (2026). <em>geobounds: Download Administrative Boundary
Data from geoBoundaries</em>.
<a href="https://doi.org/10.32614/CRAN.package.geobounds">doi:10.32614/CRAN.package.geobounds</a>.
<a href="https://dieghernan.github.io/geobounds/">https://dieghernan.github.io/geobounds/</a>.
</p>

A BibTeX entry for LaTeX users:

    @Manual{R-geobounds,
      title = {{geobounds}: Download Administrative Boundary Data from geoBoundaries},
      author = {Diego Hernangómez},
      year = {2026},
      version = {0.1.2},
      url = {https://dieghernan.github.io/geobounds/},
      abstract = {Provides tools for downloading individual country files and global composite files from geoBoundaries <https://www.geoboundaries.org/> across multiple administrative (ADM) levels. Returns boundary data as sf objects for mapping and spatial analysis. Runfola et al. (2020) <doi:10.1371/journal.pone.0231866> describe the underlying database.},
      doi = {10.32614/CRAN.package.geobounds},
    }

## References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-10.1371/journal.pone.0231866" class="csl-entry">

Runfola, Daniel, Austin Anderson, Heather Baier, et al. 2020.
“<span class="nocase">geoBoundaries</span>: A Global Database of
Political Administrative Boundaries.” *PLOS ONE* 15 (4): 1–9.
<https://doi.org/10.1371/journal.pone.0231866>.

</div>

</div>
