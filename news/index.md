# Changelog

## geobounds (development version)

- All functions:
  - Improve detection for Antarctica and Kosovo.
  - All functions return a `MULTIPOLYGON`.
- `get_gb*()`: In all functions now the `country` argument recognize
  mixed types (e.g. `get_gb(country = c("Germany", "USA"))` would work).
- [`get_gb_cgaz()`](https://dieghernan.github.io/geobounds/reference/get_gb_cgaz.md)
  get the latest data available on the repo
  <https://github.com/wmgeolab/geoBoundaries/tree/main/releaseData>.
- Add DOI.
- 

## geobounds 0.0.1

- Initial release.
