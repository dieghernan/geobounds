# Metadata errors

    Code
      err <- get_gb(country = c("AND", "ESP", "ATA"), adm_lvl = "ADM2", metadata = TRUE)
    Message
      x <https://www.geoboundaries.org/api/current/gbOpen/AND/ADM2> gives error 404 - Not Found
      x <https://www.geoboundaries.org/api/current/gbOpen/ATA/ADM2> gives error 404 - Not Found

---

    Code
      err2 <- get_gb(country = "ATA", adm_lvl = "ADM2", metadata = TRUE)
    Message
      x <https://www.geoboundaries.org/api/current/gbOpen/ATA/ADM2> gives error 404 - Not Found

# NULL output

    Code
      err2 <- get_gb(country = "ATA", adm_lvl = "ADM2")
    Message
      x <https://www.geoboundaries.org/api/current/gbOpen/ATA/ADM2> gives error 404 - Not Found
      x Nothing to download, returning `NULL`

