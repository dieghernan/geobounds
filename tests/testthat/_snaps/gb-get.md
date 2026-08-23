# missing boundaries return NULL

    Code
      err2 <- gb_get(country = "ATA", adm_lvl = "ADM2", cache_dir = tmpd)
    Message
      ! Request to <https://www.geoboundaries.org/api/current/gbOpen/ATA/ADM2> failed with HTTP status `404 - Not Found`.
      ! No matching boundaries found. Returning `NULL`.

# authoritative boundaries display their license notice

    Code
      gb_hlp_license_notice("gbAuthoritative")
    Message
      ! UN SALB boundaries are restricted to non-commercial use.
      i Review the terms at
        <https://salb.un.org/sites/default/files/wysiwyg_uploads/docs_uploads/TermsOfUseSALB2021.pdf>
        before reusing the boundaries.

# a failed single boundary download returns an empty table

    Code
      res_sf <- lapply(url_bound, function(x) {
        gbnds_dev_shp_query(url = x, subdir = "gbOpen", quiet = TRUE, overwrite = FALSE,
          cache_dir = tmpd)
      })
    Message
      ! Request to <https://github.com/wmgeolab/geoBoundaries/raw/FAKE/releaseData/gbOpen/ESP/ADM0/fakefile.geojson> failed with HTTP status `404 - Not Found`.

# mixed downloads return successful boundaries

    Code
      res_sf <- lapply(url_bound, function(x) {
        gbnds_dev_shp_query(url = x, subdir = "gbOpen", quiet = TRUE, overwrite = FALSE,
          cache_dir = tmpd, simplified = TRUE)
      })
    Message
      ! Request to <https://github.com/wmgeolab/geoBoundaries/raw/FAKE/releaseData/gbOpen/ESP/ADM0/fakefile.zip> failed with HTTP status `404 - Not Found`.

