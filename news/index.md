# Changelog

## geobounds (development version)

### Breaking change

Functions for downloading data have been renamed to follow the
convention `object_verb()` (see
<https://devguide.ropensci.org/pkg_building.html>):

- `get_gb()` -\>
  [`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md).
- `?get_gb_adm` family -\>
  [`?gb_get_adm`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md)
  family.
- `get_gb_cgaz()` -\>
  [`gb_get_cgaz()`](https://dieghernan.github.io/geobounds/reference/gb_get_cgaz.md).
- `get_gb_meta()` -\>
  [`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_metadata.md).

Additionally, the `metadata` argument has been removed. Use
[`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_metadata.md)
instead.

#### Other changes

- [`gb_get_adm5()`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md)
  added.
- [`gb_get_max_adm_lvl()`](https://dieghernan.github.io/geobounds/reference/gb_get_max_adm_lvl.md)
  added.
- All functions:
  - Source files: Use of the `.zip/.shp` version of the dataset instead
    of `.geojson/.gpkg`. This implies that the **geojsonsf** dependency
    in `Imports` is removed as it is not needed any more. As a
    consequence cached files with previous versions of the package are
    not used any more.
  - Improve detection for Antarctica and Kosovo.
  - All functions return a `MULTIPOLYGON`.
  - Function fails gracefully when the country file is not available
    (with neither errors nor warnings).
  - [`httr2::req_retry()`](https://httr2.r-lib.org/reference/req_retry.html)
    implemented to avoid timeout / transient errors.
- `gb_get*()`: In all functions now the `country` argument recognize
  mixed types (e.g. `gb_get(country = c("Germany", "USA"))` would work).
- [`gb_get_cgaz()`](https://dieghernan.github.io/geobounds/reference/gb_get_cgaz.md)
  get the latest data available on the repo
  <https://github.com/wmgeolab/geoBoundaries/tree/main/releaseData>.
- Add DOI.

## geobounds 0.0.1

- Initial release.
