# Metadata errors

    Code
      err <- get_geobn(country = c("AND", "ESP", "ATA"), boundary_type = "ADM2",
      metadata = TRUE)
    Message
      x <https://www.geoboundaries.org/api/current/gbOpen/AND/ADM2> gives error 404 - Not Found
      x <https://www.geoboundaries.org/api/current/gbOpen/ATA/ADM2> gives error 404 - Not Found

---

    Code
      err2 <- get_geobn(country = "ATA", boundary_type = "ADM2", metadata = TRUE)
    Message
      x <https://www.geoboundaries.org/api/current/gbOpen/ATA/ADM2> gives error 404 - Not Found

