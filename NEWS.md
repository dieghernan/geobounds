# geobounds (development version)

-   All functions:
    -   Improve detection for Antarctica and Kosovo.
    -   All functions return a `MULTIPOLYGON`.
    -   Function fails gracefully when the country file is not available (with
        neither errors nor warnings).
-   `get_gb*()`: In all functions now the `country` argument recognize mixed
    types (e.g. `get_gb(country = c("Germany", "USA"))` would work).
-   `get_gb_cgaz()` get the latest data available on the repo
    <https://github.com/wmgeolab/geoBoundaries/tree/main/releaseData>.
-   Add DOI.
-   

# geobounds 0.0.1

-   Initial release.

