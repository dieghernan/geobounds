test_that("Test levels", {
  skip_on_cran()
  skip_if_offline()

  library(dplyr)

  # Get country with all levels
  db <- get_geobn(country = "ALL", boundary_type = "ALL", metadata = TRUE)

  cnt <- db %>%
    group_by(boundaryISO) %>%
    count() %>%
    filter(n == 5) %>%
    ungroup() %>%
    slice_head(n = 1) %>%
    pull(boundaryISO)

  # Check 0
  a <- get_geobn(cnt, simplified = TRUE, boundary_type = "ADM0")
  b <- get_geobn_adm0(cnt, simplified = TRUE)
  expect_identical(a, b)

  # Check 1
  a <- get_geobn(cnt, simplified = TRUE, boundary_type = "ADM1")
  b <- get_geobn_adm1(cnt, simplified = TRUE)
  expect_identical(a, b)

  # Check 2
  a <- get_geobn(cnt, simplified = TRUE, boundary_type = "ADM2")
  b <- get_geobn_adm2(cnt, simplified = TRUE)
  expect_identical(a, b)

  # Check 3
  a <- get_geobn(cnt, simplified = TRUE, boundary_type = "ADM3")
  b <- get_geobn_adm3(cnt, simplified = TRUE)
  expect_identical(a, b)

  # Check 4
  a <- get_geobn(cnt, simplified = TRUE, boundary_type = "ADM4")
  b <- get_geobn_adm4(cnt, simplified = TRUE)
  expect_identical(a, b)
})
