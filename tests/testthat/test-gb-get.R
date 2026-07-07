test_that("NULL output", {
  skip_on_cran()
  skip_if_offline()
  tmpd <- local_test_cache("geobounds-test-get-null-")

  expect_snapshot(
    err2 <- gb_get(country = "ATA", adm_lvl = "ADM2", cache_dir = tmpd)
  )

  expect_null(err2)
})

test_that("license notices", {
  expect_silent(gb_hlp_license_notice("gbOpen"))
  expect_snapshot(gb_hlp_license_notice("gbAuthoritative"))
})

test_that("sf output simplified", {
  skip_on_cran()
  skip_if_offline()

  tmpd <- local_test_cache("geobounds-test-get-")
  expect_silent(
    che <- gb_get(
      country = "San Marino",
      adm_lvl = "ADM0",
      cache_dir = tmpd,
      simplified = TRUE
    )
  )

  expect_s3_class(che, "sf")
  expect_equal(nrow(che), 1)

  # Not simplified
  expect_silent(
    chefull <- gb_get(
      country = "San Marino",
      adm_lvl = "ADM0",
      cache_dir = tmpd,
      simplified = FALSE
    )
  )

  expect_true(object.size(che) < object.size(chefull))
})

test_that("sf output messages", {
  skip_on_cran()
  skip_if_offline()

  tmpd <- local_test_cache("geobounds-test-get-messages-")
  expect_message(
    che <- gb_get(
      country = "San Marino",
      adm_lvl = "ADM0",
      cache_dir = tmpd,
      simplified = TRUE,
      quiet = FALSE
    ),
    "Downloading source archive"
  )

  expect_s3_class(che, "sf")
  expect_equal(nrow(che), 1)

  # Cached
  expect_message(
    che <- gb_get(
      country = "San Marino",
      adm_lvl = "ADM0",
      cache_dir = tmpd,
      simplified = TRUE,
      quiet = FALSE
    ),
    "Using cached file"
  )
})

test_that("Fail gracefully single", {
  skip_on_cran()
  skip_if_offline()
  tmpd <- local_test_cache("geobounds-test-get-fail-single-")

  # Mock a fake call
  url_bound <- paste0(
    "https://github.com/wmgeolab/geoBoundaries/",
    "raw/FAKE/releaseData/gbOpen/ESP/ADM0/",
    "fakefile.geojson"
  )

  expect_snapshot(
    res_sf <- lapply(url_bound, function(x) {
      gbnds_dev_shp_query(
        url = x,
        subdir = "gbOpen",
        quiet = TRUE,
        overwrite = FALSE,
        cache_dir = tmpd
      )
    })
  )
  meta_sf <- dplyr::bind_rows(res_sf)

  expect_s3_class(meta_sf, "tbl")
  expect_equal(nrow(meta_sf), 0)
})

test_that("Fail gracefully several", {
  skip_on_cran()
  skip_if_offline()
  tmpd <- local_test_cache("geobounds-test-get-fail-several-")

  # Replicate internal logic

  sev <- gb_get_metadata(c("Andorra", "Vatican"), adm_lvl = "ADM0")
  geoms <- sev$staticDownloadLink

  # Mock a fake call
  url <- paste0(
    "https://github.com/wmgeolab/geoBoundaries/",
    "raw/FAKE/releaseData/gbOpen/ESP/ADM0/",
    "fakefile.zip"
  )
  url_bound <- c(geoms, url)

  expect_snapshot(
    res_sf <- lapply(url_bound, function(x) {
      gbnds_dev_shp_query(
        url = x,
        subdir = "gbOpen",
        quiet = TRUE,
        overwrite = FALSE,
        cache_dir = tmpd,
        simplified = TRUE
      )
    })
  )
  meta_sf <- dplyr::bind_rows(res_sf)

  expect_s3_class(meta_sf, "tbl")
  expect_s3_class(meta_sf, "sf")
  expect_equal(nrow(meta_sf), 2)

  # If we change order...
  url_bound <- c(url, geoms)

  res_sf <- lapply(url_bound, function(x) {
    gbnds_dev_shp_query(
      url = x,
      subdir = "gbOpen",
      quiet = TRUE,
      overwrite = FALSE,
      cache_dir = tmpd
    )
  })

  meta_sf <- dplyr::bind_rows(res_sf)

  expect_s3_class(meta_sf, "tbl")
  expect_s3_class(meta_sf, "sf")
  expect_equal(nrow(meta_sf), 2)
})

test_that("Release type", {
  skip_on_cran()
  skip_if_offline()
  tmpd <- local_test_cache("geobounds-test-get-release-")

  library(dplyr)
  iso <- gb_get_metadata(release_type = "gbHumanitarian", adm_lvl = "ADM0") |>
    slice_head(n = 1) |>
    pull(boundaryISO)

  res <- gb_get_adm0(
    iso,
    simplified = TRUE,
    release_type = "gbHumanitarian",
    cache_dir = tmpd
  )
  expect_s3_class(res, "sf")

  iso <- gb_get_metadata(release_type = "gbAuthoritative", adm_lvl = "ADM0") |>
    slice_head(n = 1) |>
    pull(boundaryISO)

  res <- gb_get_adm0(
    iso,
    simplified = TRUE,
    release_type = "gbAuthoritative",
    cache_dir = tmpd
  )
  expect_s3_class(res, "sf")
})
