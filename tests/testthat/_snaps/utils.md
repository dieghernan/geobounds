# Utils names

    Code
      gbnds_dev_country2iso(c("Espagne", "United Kingdom"))
    Output
      [1] "ESP" "GBR"

---

    Code
      gbnds_dev_country2iso(c("ESP", "POR", "RTA", "USA"))
    Message
      ! Some values supplied to `country` could not be matched unambiguously: "POR" and "RTA".
      i Review the values or use ISO 3166-1 alpha-3 codes.
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
      ! Some values supplied to `country` could not be matched unambiguously: "Rea" and "Murcua".
      i Review the values or use ISO 3166-1 alpha-3 codes.
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
      ! Use a single `adm_lvl` value. You supplied 1 and 2.

---

    Code
      assert_adm_lvl(adm_lvl = 10)
    Condition
      Error in `assert_adm_lvl()`:
      ! Invalid `adm_lvl` value: "10".
      Accepted values are "all", "adm0", "adm1", "adm2", "adm3", "adm4", "adm5", "0", "1", "2", "3", "4", or "5".

# Pretty match

    Code
      my_fun("error here")
    Condition
      Error:
      ! `arg_one` must be one of "10", "1000", "3000" or "5000", not "error here".

---

    Code
      my_fun(c("an", "error"))
    Condition
      Error:
      ! `arg_one` must be one of "10", "1000", "3000" or "5000", not "an" or "error".

---

    Code
      my_fun("5")
    Condition
      Error:
      ! `arg_one` must be one of "10", "1000", "3000" or "5000", not "5".
      i Did you mean "5000"?

---

    Code
      my_fun("00")
    Condition
      Error:
      ! `arg_one` must be one of "10", "1000", "3000" or "5000", not "00".

---

    Code
      my_fun2(c(1, 2))
    Condition
      Error:
      ! `year` must be "20", not "1" or "2".

---

    Code
      my_fun3("3")
    Condition
      Error:
      ! `an_arg` must be one of "30" or "20", not "3".
      i Did you mean "30"?

---

    Code
      my_fun2(c(1, 2))
    Condition
      Error:
      ! `year` must be "20", not "1" or "2".

# Test gb_abort_if_not

    Code
      gb_abort_if_not(isFALSE(TRUE))
    Condition
      Error:
      ! Every condition supplied to `gb_abort_if_not()` must be named.

---

    Code
      gb_set_cache_dir(cache_dir = 34)
    Condition
      Error in `gb_set_cache_dir()`:
      ! `cache_dir` must be a <character>.

---

    Code
      gb_set_cache_dir(overwrite = "a")
    Condition
      Error in `gb_set_cache_dir()`:
      ! `overwrite` must be a <logical>.

---

    Code
      gb_set_cache_dir(install = "a")
    Condition
      Error in `gb_set_cache_dir()`:
      ! `install` must be a <logical>.

---

    Code
      gb_set_cache_dir(quiet = "a")
    Condition
      Error in `gb_set_cache_dir()`:
      ! `quiet` must be a <logical>.

