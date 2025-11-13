# geobounds

[**Attribution**](https://www.geoboundaries.org/index.html#usage) **is
required when using geoBoundaries.**

## Why this package?

The **geobounds** package provides an **R**-friendly interface to access
and work with the [**geoBoundaries**](https://www.geoboundaries.org/)
dataset (an open-license global database of administrative boundary
polygons). Using this package, you can:

- Programmatically retrieve administrative boundary geometries (e.g.,
  country → region → district) from geoBoundaries
- Use **tidyverse** / **sf** workflows in **R** to map, analyse and join
  these boundaries with your own data
- Work in an open-data context (geoBoundaries uses [CC
  BY-4.0](https://creativecommons.org/licenses/by/4.0/)) / open
  licences)

In short: if you work with geospatial boundaries in **R** (shape files,
polygons, join with other data), this package simplifies the process.

## Installation

You can install the developing version of **geobounds** with:

``` r
# install.packages("pak")
pak::pak("dieghernan/geobounds")
```

Alternatively, you can install **geobounds** using the
[r-universe](https://dieghernan.r-universe.dev/geobounds):

``` r
# Install geobounds in R:
install.packages("geobounds",
  repos = c(
    "https://dieghernan.r-universe.dev",
    "https://cloud.r-project.org"
  )
)
```

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

![Map of all administration levels for Sri
Lanka](reference/figures/README-simple_plot-1.png)

> Note: This is a simple illustration. See the [package
> vignettes](https://dieghernan.github.io/geobounds/articles/geobounds.html)
> for full details on parameters, filters, caching, and advanced usage.

## Documentation & Resources

- Visit the **pkgdown** site for full documentation:
  <https://dieghernan.github.io/geobounds/>
- Explore the geoBoundaries homepage: <https://www.geoboundaries.org/>
- Read the original paper describing the geoBoundaries dataset ([Runfola
  et al. 2020](#ref-geoboundaries)).

## License

This package is released under the [CC
BY-4.0](https://creativecommons.org/licenses/by/4.0/) license. Note that
the boundary data being accessed (via geoBoundaries) also uses open
licences; please check the specific dataset metadata for licensing
details.

## Acknowledgements

- Many thanks to the geoBoundaries team and the [William & Mary
  geoLab](https://sites.google.com/view/wmgeolab/) for creating and
  maintaining the dataset.
- Thanks to the **R** package community and all contributors to this
  package’s development.
- If you use **geobounds** (and underlying geoBoundaries data) in your
  research or project, a citation and acknowledgement is greatly
  appreciated.

## Citation

Hernangómez D (2025). *geobounds: Download Map Data from geoBoundaries*.
[doi:10.5281/zenodo.17554275](https://doi.org/10.5281/zenodo.17554275),
<https://dieghernan.github.io/geobounds/>.

A BibTeX entry for LaTeX users:

``` R
@Manual{R-geobounds,
  title = {{geobounds}: Download Map Data from geoBoundaries},
  author = {Diego Hernangómez},
  year = {2025},
  version = {0.0.1.9000},
  url = {https://dieghernan.github.io/geobounds/},
  abstract = {Tools to download data from geoBoundaries <https://www.geoboundaries.org/>. Several administration levels available. See Runfola, D. et al. (2020) geoBoundaries: A global database of political administrative boundaries. PLOS ONE 15(4): e0231866. <doi:10.1371/journal.pone.0231866>.},
  doi = {10.5281/zenodo.17554275},
}
```

## References

Runfola, Daniel, Austin Anderson, Heather Baier, Matt Crittenden,
Elizabeth Dowker, Sydney Fuhrig, Seth Goodman, et al. 2020.
“geoBoundaries: A Global Database of Political Administrative
Boundaries.” *PLOS ONE* 15 (4): 1–9.
<https://doi.org/10.1371/journal.pone.0231866>.
