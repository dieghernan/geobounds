# Utils names

    Code
      gbnds_dev_country2iso(c("Espagne", "United Kingdom"))
    Output
      [1] "ESP" "GBR"

---

    Code
      gbnds_dev_country2iso(c("ESP", "POR", "RTA", "USA"))
    Message
      ! Some values were not matched unambiguously: POR and RTA
      i Review the names or switch to ISO3 codes.
    Output
      [1] "ESP" "USA"

---

    Code
      gbnds_dev_country2iso(c("ESP", "Alemania"))
    Output
      [1] "ESP" "DEU"

# Problematic names

    Code
      gbnds_dev_country2iso(c("Espagne", "Antartica"))
    Output
      [1] "ESP" "ATA"

---

    Code
      gbnds_dev_country2iso(c("spain", "antartica"))
    Output
      [1] "ESP" "ATA"

---

    Code
      gbnds_dev_country2iso(c("Spain", "Kosovo", "Antartica"))
    Output
      [1] "ESP" "XKX" "ATA"

---

    Code
      gbnds_dev_country2iso(c("ESP", "XKX", "DEU"))
    Output
      [1] "ESP" "XKX" "DEU"

---

    Code
      gbnds_dev_country2iso(c("Spain", "Rea", "Kosovo", "Antartica", "Murcua"))
    Message
      ! Some values were not matched unambiguously: Rea and Murcua
      i Review the names or switch to ISO3 codes.
    Output
      [1] "ESP" "XKX" "ATA"

---

    Code
      gbnds_dev_country2iso("Kosovo")
    Output
      [1] "XKX"

---

    Code
      gbnds_dev_country2iso("XKX")
    Output
      [1] "XKX"

# Assert admin levels

    Code
      assert_adm_lvl(1:2)
    Condition
      Error in `assert_adm_lvl()`:
      ! You can't mix different `adm_lvl`. You entered 1 and 2.

---

    Code
      assert_adm_lvl(adm_lvl = 10)
    Condition
      Error in `assert_adm_lvl()`:
      ! Not a valid `adm_lvl` level code ("10").
      Accepted values are "all", "adm0", "adm1", "adm2", "adm3", "adm4", "adm5", "0", "1", "2", "3", "4", and "5".

