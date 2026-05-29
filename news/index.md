# Changelog

## geobounds 0.1.2

- Documentation and internal code were reviewed with AI assistance to
  improve maintainability, align terminology across **roxygen2** and
  narrative documentation, and clarify user-facing messages.

## geobounds 0.1.1

CRAN release: 2026-03-24

- Migrated package documentation to Quarto.
- Updated package documentation.

## geobounds 0.1.0

CRAN release: 2026-02-11

**First CRAN release**.

### Breaking changes

Functions for downloading data have been renamed to follow the
convention `object_verb()` (see
<https://devguide.ropensci.org/pkg_building.html>):

- `get_gb()` -\>
  [`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md).
- `?get_gb_adm` family -\>
  [`?gb_get_adm`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md)
  family.
- `get_gb_cgaz()` -\>
  [`gb_get_world()`](https://dieghernan.github.io/geobounds/reference/gb_get_world.md).
  [`gb_get_cgaz()`](https://dieghernan.github.io/geobounds/reference/gb_get_world.md)
  is also available for backward compatibility as an alias of
  [`gb_get_world()`](https://dieghernan.github.io/geobounds/reference/gb_get_world.md).
- `get_gb_meta()` -\>
  [`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_metadata.md).

Additionally, the `metadata` argument has been removed. Use
[`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_metadata.md)
instead.

#### Other changes

- Added a DOI.
- All download functions now use `.zip/.shp` datasets instead of
  `.geojson/.gpkg`, removing the **geojsonsf** dependency from
  `Imports`.
- All download functions now return `MULTIPOLYGON` geometries.
- All download functions now fail gracefully when a country file is
  unavailable, without errors or warnings.
- All download functions now retry transient request failures with
  [`httr2::req_retry()`](https://httr2.r-lib.org/reference/req_retry.html).
- Cached files from previous package versions are no longer reused
  because the source file format changed.
- Country matching now improves detection for Antarctica and Kosovo.
- `gb_get*()` functions now allow mixed `country` argument types, such
  as `gb_get(country = c("Germany", "USA"))`.
- [`gb_get_adm5()`](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md)
  was added.
- [`gb_get_max_adm_lvl()`](https://dieghernan.github.io/geobounds/reference/gb_get_max_adm_lvl.md)
  was added.
- [`gb_get_world()`](https://dieghernan.github.io/geobounds/reference/gb_get_world.md)
  now gets the latest data available from the repository at
  <https://github.com/wmgeolab/geoBoundaries/tree/main/releaseData>.

## geobounds 0.0.1

- Initial release.
