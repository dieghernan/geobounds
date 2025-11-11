# geobounds (development version)

## Breaking change

Functions for downloading data have been renamed to follow the convention
`object_verb()` (see <https://devguide.ropensci.org/pkg_building.html>):

-   `get_gb()` -\> `gb_get()`.
-   `get_gb_adm` family -\> `gb_get_adm`.
-   `get_gb_cgaz()` -\> `gb_get_cgaz()`.
-   `get_gb_meta()` -\> `gb_get_meta()`.

### Others

-   All functions:
    -   Improve detection for Antarctica and Kosovo.
    -   All functions return a `MULTIPOLYGON`.
    -   Function fails gracefully when the country file is not available (with
        neither errors nor warnings).
-   `gb_get*()`: In all functions now the `country` argument recognize mixed
    types (e.g. `gb_get(country = c("Germany", "USA"))` would work).
-   `gb_get_cgaz()` get the latest data available on the repo
    <https://github.com/wmgeolab/geoBoundaries/tree/main/releaseData>.
-   Add DOI.
-   

# geobounds 0.0.1

-   Initial release.
