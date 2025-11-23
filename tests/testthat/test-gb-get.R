test_that("NULL output", {
  skip_on_cran()
  skip_if_offline()

  expect_snapshot(err2 <- gb_get(country = "ATA", adm_lvl = "ADM2"))

  expect_null(err2)
})

test_that("sf output simplified", {
  skip_on_cran()
  skip_if_offline()

  tmpd <- file.path(tempdir(), "testthat")
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
  unlink(tmpd, recursive = TRUE)
  expect_false(dir.exists(tmpd))
})

test_that("sf output messages", {
  skip_on_cran()
  skip_if_offline()

  tmpd <- file.path(tempdir(), "testthat2")
  msg <- expect_message(
    che <- gb_get(
      country = "San Marino",
      adm_lvl = "ADM0",
      cache_dir = tmpd,
      simplified = TRUE,
      quiet = FALSE
    ),
    "Downloading file"
  )

  expect_s3_class(che, "sf")
  expect_equal(nrow(che), 1)

  # Cached
  msg <- expect_message(
    che <- gb_get(
      country = "San Marino",
      adm_lvl = "ADM0",
      cache_dir = tmpd,
      simplified = TRUE,
      quiet = FALSE
    ),
    "already cached"
  )

  unlink(tmpd, recursive = TRUE)
  expect_false(dir.exists(tmpd))
})

test_that("Fail gracefully single", {
  skip_on_cran()
  skip_if_offline()

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
        cache_dir = tempdir()
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
        cache_dir = tempdir(),
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
      cache_dir = tempdir()
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
  library(dplyr)
  iso <- gb_get_metadata(release_type = "gbHumanitarian", adm_lvl = "ADM0") %>%
    slice_head(n = 1) %>%
    pull(boundaryISO)

  res <- gb_get_adm0(iso, simplified = TRUE, release_type = "gbHumanitarian")
  expect_s3_class(res, "sf")

  iso <- gb_get_metadata(release_type = "gbAuthoritative", adm_lvl = "ADM0") %>%
    slice_head(n = 1) %>%
    pull(boundaryISO)

  res <- gb_get_adm0(iso, simplified = TRUE, release_type = "gbAuthoritative")
  expect_s3_class(res, "sf")
})
