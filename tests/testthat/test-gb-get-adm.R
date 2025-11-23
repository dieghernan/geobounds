test_that("Test levels", {
  skip_on_cran()
  skip_if_offline()

  library(dplyr)

  # Get country with all levels
  db <- gb_get_metadata(country = "ALL", adm_lvl = "ALL")

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

test_that("Release type", {
  skip_on_cran()
  skip_if_offline()

  tmpd <- file.path(tempdir(), "testthat")
  library(dplyr)
  iso <- gb_get_metadata(release_type = "gbHumanitarian", adm_lvl = "adm0") %>%
    slice_head(n = 1) %>%
    pull(boundaryISO)

  res <- gb_get_adm0(
    iso,
    simplified = TRUE,
    release_type = "gbHumanitarian",
    cache_dir = tmpd
  )
  expect_s3_class(res, "sf")

  iso <- gb_get_metadata(release_type = "gbAuthoritative", adm_lvl = "adm0") %>%
    slice_head(n = 1) %>%
    pull(boundaryISO)

  res <- gb_get_adm0(
    iso,
    simplified = TRUE,
    release_type = "gbAuthoritative",
    cache_dir = tmpd
  )
  expect_s3_class(res, "sf")

  unlink(tmpd, recursive = TRUE)
  expect_false(dir.exists(tmpd))
})

test_that("type of object returned is as expected", {
  skip_on_cran()
  skip_if_offline()
  tmpd <- file.path(tempdir(), "testthat")
  p <- gb_get_adm0(country = c("Andorra", "Vatican"), cache_dir = tmpd)
  expect_s3_class(p, "sf")
  expect_true(all(sf::st_geometry_type(p) == "MULTIPOLYGON"))

  unlink(tmpd, recursive = TRUE)
  expect_false(dir.exists(tmpd))
})
