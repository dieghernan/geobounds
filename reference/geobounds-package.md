# geobounds: Download Administrative Boundary Data from 'geoBoundaries'

Provides tools to download individual country boundaries and global
composite boundaries from 'geoBoundaries'
<https://www.geoboundaries.org/> across multiple administrative ('ADM')
levels. Returns boundaries as 'sf' objects for mapping and spatial
analysis. Runfola et al. (2020)
[doi:10.1371/journal.pone.0231866](https://doi.org/10.1371/journal.pone.0231866)
describe the underlying database.

## Source

[**geoBoundaries** API](https://www.geoboundaries.org/api.html).

## References

Runfola et al. (2020) "geoBoundaries: A global database of political
administrative boundaries." *PLOS ONE*, **15**(4), e0231866.
[doi:10.1371/journal.pone.0231866](https://doi.org/10.1371/journal.pone.0231866)
.

## See also

[`gb_get()`](https://dieghernan.github.io/geobounds/reference/gb_get.md)
downloads individual country boundaries, the [ADM
wrappers](https://dieghernan.github.io/geobounds/reference/gb_get_adm.md)
select one level and
[`gb_get_world()`](https://dieghernan.github.io/geobounds/reference/gb_get_world.md)
downloads global composite boundaries.
[`gb_get_metadata()`](https://dieghernan.github.io/geobounds/reference/gb_get_metadata.md)
retrieves boundary metadata and
[`gb_set_cache_dir()`](https://dieghernan.github.io/geobounds/reference/gb_set_cache_dir.md)
configures archive caching. See
[`vignette("geobounds", package = "geobounds")`](https://dieghernan.github.io/geobounds/articles/geobounds.md)
for mapping workflows and
[`vignette("metadata", package = "geobounds")`](https://dieghernan.github.io/geobounds/articles/metadata.md)
for provenance and licensing.

## Author

**Maintainer**: Diego Hernangómez <diego.hernangomezherrero@gmail.com>
([ORCID](https://orcid.org/0000-0001-8457-4658)) \[copyright holder\]

Authors:

- Diego Hernangómez <diego.hernangomezherrero@gmail.com>
  ([ORCID](https://orcid.org/0000-0001-8457-4658)) \[copyright holder\]

Other contributors:

- William & Mary geoLab ([ROR](https://ror.org/03hsf0573)) (for the
  geoBoundaries project) \[data contributor\]
