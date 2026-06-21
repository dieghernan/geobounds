# geobounds 0.1.2

- Documentation and user-facing messages were reviewed with AI assistance to
  align terminology across **roxygen2** and narrative documentation and to
  clarify package output.

# geobounds 0.1.1

- Migrated package documentation to Quarto.
- Updated package documentation.

# geobounds 0.1.0

**First CRAN release**.

## Breaking changes

Functions for downloading data have been renamed to follow the convention
`object_verb()` (see <https://devguide.ropensci.org/pkg_building.html>):

- `get_gb()` -\> `gb_get()`.
- `?get_gb_adm` family -\> `?gb_get_adm` family.
- `get_gb_cgaz()` -\> `gb_get_world()`. `gb_get_cgaz()` is also available for
  backward compatibility as an alias of `gb_get_world()`.
- `get_gb_meta()` -\> `gb_get_metadata()`.

Additionally, the `metadata` argument has been removed. Use `gb_get_metadata()`
instead.

### Other changes

- Added a DOI.
- All download functions now use `.zip` archives containing `.shp` files instead
  of `.geojson` or `.gpkg` files, removing the **geojsonsf** dependency from
  `Imports`.
- All download functions now return `MULTIPOLYGON` geometries.
- All download functions now return `NULL` without an error or warning when a
  country file is unavailable.
- All download functions now retry transient request failures with
  `httr2::req_retry()`.
- Cached files from previous package versions are no longer reused because the
  source file format changed.
- Country matching now improves detection for Antarctica and Kosovo.
- `gb_get*()` functions now allow mixed `country` argument types, such as
  `gb_get(country = c("Germany", "USA"))`.
- `gb_get_adm5()` was added.
- `gb_get_max_adm_lvl()` was added.
- `gb_get_world()` now retrieves the latest data available from the repository
  at <https://github.com/wmgeolab/geoBoundaries/tree/main/releaseData>.

# geobounds 0.0.1

- Initial release.
