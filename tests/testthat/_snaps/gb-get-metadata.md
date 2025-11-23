# Check meta errors

    Code
      db <- gb_get_metadata(country = "ESP", adm_lvl = "ADM5")
    Message
      x <https://www.geoboundaries.org/api/current/gbOpen/ESP/ADM5> gives error 404 - Not Found

---

    Code
      err <- gb_get_metadata(country = c("AND", "ESP", "ATA"), adm_lvl = "ADM2")
    Message
      x <https://www.geoboundaries.org/api/current/gbOpen/AND/ADM2> gives error 404 - Not Found
      x <https://www.geoboundaries.org/api/current/gbOpen/ATA/ADM2> gives error 404 - Not Found

