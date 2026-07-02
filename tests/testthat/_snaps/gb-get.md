# NULL output

    Code
      err2 <- gb_get(country = "ATA", adm_lvl = "ADM2")
    Message
      x Request to <https://www.geoboundaries.org/api/current/gbOpen/ATA/ADM2> failed with HTTP status 404 - Not Found.
      x No matching boundary files found. Returning `NULL`.

# Fail gracefully single

    Code
      res_sf <- lapply(url_bound, function(x) {
        gbnds_dev_shp_query(url = x, subdir = "gbOpen", quiet = TRUE, overwrite = FALSE,
          cache_dir = tempdir())
      })
    Message
      x Request to <https://github.com/wmgeolab/geoBoundaries/raw/FAKE/releaseData/gbOpen/ESP/ADM0/fakefile.geojson> failed with HTTP status 404 - Not Found.

# Fail gracefully several

    Code
      res_sf <- lapply(url_bound, function(x) {
        gbnds_dev_shp_query(url = x, subdir = "gbOpen", quiet = TRUE, overwrite = FALSE,
          cache_dir = tempdir(), simplified = TRUE)
      })
    Message
      x Request to <https://github.com/wmgeolab/geoBoundaries/raw/FAKE/releaseData/gbOpen/ESP/ADM0/fakefile.zip> failed with HTTP status 404 - Not Found.

