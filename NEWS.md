# geobounds (development version)

- Country inputs now reject empty or wholly unmatched values, and Kosovo aliases must match `"Kosovo"` or `"XKX"` exactly.
- `gb_clear_cache()` now rejects unsafe cache locations before recursively deleting cached data. Cache functions also validate scalar arguments, report directory creation failures clearly and confirm that requested deletions succeeded.
- `gb_get()` now rejects missing or non-scalar download options and invalid cache directory values before requesting data. Invalid cached archives are removed with an actionable error so a subsequent request can download them again.
- `gb_get_max_adm_lvl()` now derives the maximum level from each ADM label instead of assuming that available metadata levels are consecutive.
- `gb_get_world()` now returns `NULL` when a download fails or no requested country is available, and validates download options before requesting data.

# geobounds 1.0.0

- Changed the software license from CC BY 4.0 to MIT and clarified that
  downloaded boundaries and included figures retain the licenses and attribution
  requirements of **geoBoundaries** and their original sources. Documentation
  now distinguishes the varying `gbOpen` licenses, UN OCHA terms and the
  non-commercial restriction on UN SALB boundaries. Downloads from
  `gbAuthoritative` now display a licensing notice.

# geobounds 0.1.2

- Improved documentation and user-facing messages to align terminology across
  **roxygen2** and narrative documentation and clarify package output.

# geobounds 0.1.1

- Migrated package documentation to **Quarto**.
- Updated package documentation.

# geobounds 0.1.0

**First CRAN release**.

## Breaking changes

Functions for downloading boundaries have been renamed to follow the convention
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
  source archive format changed.
- Country matching now improves detection for Antarctica and Kosovo.
- `gb_get*()` functions now allow mixed `country` argument types, such as
  `gb_get(country = c("Germany", "USA"))`.
- `gb_get_adm5()` was added.
- `gb_get_max_adm_lvl()` was added.
- `gb_get_world()` now retrieves the latest boundaries available from the
  repository at
  <https://github.com/wmgeolab/geoBoundaries/tree/main/releaseData>.

# geobounds 0.0.1

- Initial release.
