# Check meta errors

    Code
      db <- gb_get_metadata(country = "ESP", adm_lvl = "ADM5")
    Message
      x Request to <https://www.geoboundaries.org/api/current/gbOpen/ESP/ADM5> failed with HTTP status 404 - Not Found.

---

    Code
      err <- gb_get_metadata(country = c("AND", "ESP", "ATA"), adm_lvl = "ADM2")
    Message
      x Request to <https://www.geoboundaries.org/api/current/gbOpen/AND/ADM2> failed with HTTP status 404 - Not Found.
      x Request to <https://www.geoboundaries.org/api/current/gbOpen/ATA/ADM2> failed with HTTP status 404 - Not Found.

