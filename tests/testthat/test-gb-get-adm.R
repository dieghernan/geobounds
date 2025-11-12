test_that("Test levels", {
  skip_on_cran()
  skip_if_offline()

  library(dplyr)

  # Get country with all levels
  db <- gb_get(country = "ALL", adm_lvl = "ALL", metadata = TRUE)

  cnt <- db %>%
    group_by(boundaryISO) %>%
    mutate(n = n()) %>%
    # Countries with all levels
    filter(n == 6) %>%
    ungroup() %>%
    filter(boundaryType == "ADM5") %>%
    mutate(total = admUnitCount * meanVertices) %>%
    # Minimum vertices
    slice_min(order_by = total, n = 1) %>%
    pull(boundaryISO)

  # Check 0
  a <- gb_get(cnt, simplified = TRUE, adm_lvl = "ADM0")
  b <- gb_get_adm0(cnt, simplified = TRUE)
  expect_identical(a, b)

  # Check 1
  a <- gb_get(cnt, simplified = TRUE, adm_lvl = "ADM1")
  b <- gb_get_adm1(cnt, simplified = TRUE)
  expect_identical(a, b)

  # Check 2
  a <- gb_get(cnt, simplified = TRUE, adm_lvl = "ADM2")
  b <- gb_get_adm2(cnt, simplified = TRUE)
  expect_identical(a, b)

  # Check 3
  a <- gb_get(cnt, simplified = TRUE, adm_lvl = "ADM3")
  b <- gb_get_adm3(cnt, simplified = TRUE)
  expect_identical(a, b)

  # Check 4
  a <- gb_get(cnt, simplified = TRUE, adm_lvl = "ADM4")
  b <- gb_get_adm4(cnt, simplified = TRUE)
  expect_identical(a, b)

  # Check 5
  a <- gb_get(cnt, simplified = TRUE, adm_lvl = "ADM5")
  b <- gb_get_adm5(cnt, simplified = TRUE)
  expect_identical(a, b)
})
