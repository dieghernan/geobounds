# Utils names

    Code
      gb_helper_countrynames(c("Espagne", "United Kingdom"))
    Output
      [1] "ESP" "GBR"

---

    Code
      gb_helper_countrynames(c("ESP", "POR", "RTA", "USA"))
    Message
      ! Countries ommited: POR and RTA
      i Review the names or switch to ISO3 codes.
    Output
      [1] "ESP" "USA"

# Problematic names

    Code
      gb_helper_countrynames(c("Espagne", "Antartica"))
    Output
      [1] "ESP" "ATA"

---

    Code
      gb_helper_countrynames(c("spain", "antartica"))
    Output
      [1] "ESP" "ATA"

---

    Code
      gb_helper_countrynames(c("Spain", "Kosovo", "Antartica"))
    Output
      [1] "ESP" "XKX" "ATA"

---

    Code
      gb_helper_countrynames(c("ESP", "XKX", "DEU"))
    Output
      [1] "ESP" "XKX" "DEU"

---

    Code
      gb_helper_countrynames(c("Spain", "Rea", "Kosovo", "Antartica", "Murcua"))
    Condition
      Warning:
      Some values were not matched unambiguously: Murcua, Rea
    Message
      ! Countries ommited: Rea and Murcua
      i Review the names or switch to ISO3 codes.
    Output
      [1] "ESP" "ATA" "XKX"

---

    Code
      gb_helper_countrynames("Kosovo")
    Output
      [1] "XKX"

---

    Code
      gb_helper_countrynames("XKX")
    Output
      [1] "XKX"

