# Metadata errors

    Code
      err <- gb_get(country = c("AND", "ESP", "ATA"), adm_lvl = "ADM2", metadata = TRUE)
    Message
      x <https://www.geoboundaries.org/api/current/gbOpen/AND/ADM2> gives error 404 - Not Found
      x <https://www.geoboundaries.org/api/current/gbOpen/ATA/ADM2> gives error 404 - Not Found

---

    Code
      err2 <- gb_get(country = "ATA", adm_lvl = "ADM2", metadata = TRUE)
    Message
      x <https://www.geoboundaries.org/api/current/gbOpen/ATA/ADM2> gives error 404 - Not Found

# NULL output

    Code
      err2 <- gb_get(country = "ATA", adm_lvl = "ADM2")
    Message
      x <https://www.geoboundaries.org/api/current/gbOpen/ATA/ADM2> gives error 404 - Not Found
      x Nothing to download, returning `NULL`

# Fail gracefully single

    Code
      res_sf <- lapply(url_bound, function(x) {
        hlp_gb_get_sf_single(url = x, subdir = "gbOpen", verbose = FALSE, overwrite = FALSE,
          cache_dir = tempdir())
      })
    Message
      x <https://github.com/wmgeolab/geoBoundaries/raw/FAKE/releaseData/gbOpen/ESP/ADM0/fakefile.geojson> gives error 404 - Not Found

# Fail gracefully several

    Code
      res_sf <- lapply(url_bound, function(x) {
        hlp_gb_get_sf_single(url = x, subdir = "gbOpen", verbose = FALSE, overwrite = FALSE,
          cache_dir = tempdir(), simplified = TRUE)
      })
    Message
      x <https://github.com/wmgeolab/geoBoundaries/raw/FAKE/releaseData/gbOpen/ESP/ADM0/fakefile.zip> gives error 404 - Not Found

