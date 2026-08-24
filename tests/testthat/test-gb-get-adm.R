test_that("ADM wrappers forward levels zero through five", {
  testthat::local_mocked_bindings(gb_get = function(
    country,
    release_type,
    adm_lvl = "ADM0",
    simplified = FALSE,
    quiet = TRUE,
    overwrite = FALSE,
    cache_dir = NULL
  ) {
    list(
      country = country,
      release_type = release_type,
      adm_lvl = adm_lvl,
      simplified = simplified,
      quiet = quiet,
      overwrite = overwrite,
      cache_dir = cache_dir
    )
  })

  forwarded <- gb_get_adm0(
    country = "ESP",
    simplified = TRUE,
    release_type = "gbHumanitarian",
    quiet = FALSE,
    overwrite = TRUE,
    cache_dir = "cache"
  )
  expect_identical(
    forwarded,
    list(
      country = "ESP",
      release_type = "gbHumanitarian",
      adm_lvl = "ADM0",
      simplified = TRUE,
      quiet = FALSE,
      overwrite = TRUE,
      cache_dir = "cache"
    )
  )

  levels <- c(
    gb_get_adm0("ESP")$adm_lvl,
    gb_get_adm1("ESP")$adm_lvl,
    gb_get_adm2("ESP")$adm_lvl,
    gb_get_adm3("ESP")$adm_lvl,
    gb_get_adm4("ESP")$adm_lvl,
    gb_get_adm5("ESP")$adm_lvl
  )
  expect_identical(levels, paste0("ADM", 0:5))
})

test_that("ADM wrappers support humanitarian and authoritative releases", {
  skip_on_cran()
  skip_if_offline()

  tmpd <- local_test_cache("geobounds-test-adm-release-")
  iso <- gb_get_metadata(release_type = "gbHumanitarian", adm_lvl = "adm0") |>
    dplyr::slice_head(n = 1) |>
    dplyr::pull(boundaryISO)

  res <- gb_get_adm0(
    iso,
    simplified = TRUE,
    release_type = "gbHumanitarian",
    cache_dir = tmpd
  )
  expect_s3_class(res, "sf")

  iso <- gb_get_metadata(release_type = "gbAuthoritative", adm_lvl = "adm0") |>
    dplyr::slice_head(n = 1) |>
    dplyr::pull(boundaryISO)

  res <- gb_get_adm0(
    iso,
    simplified = TRUE,
    release_type = "gbAuthoritative",
    cache_dir = tmpd
  )
  expect_s3_class(res, "sf")
})

test_that("ADM wrappers return multipolygon sf objects", {
  skip_on_cran()
  skip_if_offline()
  tmpd <- local_test_cache("geobounds-test-adm-object-")
  p <- gb_get_adm0(country = c("Andorra", "Vatican"), cache_dir = tmpd)
  expect_s3_class(p, "sf")
  expect_identical(
    unique(as.character(sf::st_geometry_type(p))),
    "MULTIPOLYGON"
  )
})
