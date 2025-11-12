# geobounds (development version)

## Breaking change

Functions for downloading data have been renamed to follow the convention
`object_verb()` (see <https://devguide.ropensci.org/pkg_building.html>):

-   `get_gb()` -\> `gb_get()`.
-   `get_gb_adm` family -\> `gb_get_adm`.
-   `get_gb_cgaz()` -\> `gb_get_cgaz()`.
-   `get_gb_meta()` -\> `gb_get_meta()`.

### Other changes

-   `gb_get_adm5()` added.
-   All functions:
    -   Source files: Use of the `.zip/.shp` version of the dataset instead of
        `.geojson/.gpkg`. This implies that the **geojsonsf** dependency in
        `Imports` is removed as it is not needed any more. As a consequence
        cached files with previous versions of the package are not used any
        more.
    -   Improve detection for Antarctica and Kosovo.
    -   All functions return a `MULTIPOLYGON`.
    -   Function fails gracefully when the country file is not available (with
        neither errors nor warnings).
    -   `httr2::req_retry()` implemented to avoid timeout / transient errors.
-   `gb_get*()`: In all functions now the `country` argument recognize mixed
    types (e.g. `gb_get(country = c("Germany", "USA"))` would work).
-   `gb_get_cgaz()` get the latest data available on the repo
    <https://github.com/wmgeolab/geoBoundaries/tree/main/releaseData>.
-   Add DOI.
-   

# geobounds 0.0.1

-   Initial release.
