# world downloads reject unsupported ADM levels

    Code
      gb_get_world("Andorra", adm_lvl = "4", cache_dir = tmpd)
    Condition
      Error in `gb_get_world()`:
      ! Invalid `adm_lvl` value: "4".
      i Accepted values are "adm0", "adm1", "adm2", "0", "1", or "2".

