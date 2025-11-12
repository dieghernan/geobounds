test_that("Metadata calls", {
  skip_on_cran()
  skip_if_offline()

  # Single metadata
  meta <- gb_get(
    country = "Portugal",
    adm_lvl = "ADM0",
    metadata = TRUE
  )

  expect_s3_class(meta, "data.frame")
  expect_equal(nrow(meta), 1L)

  # One call, several sources
  meta2 <- gb_get(
    country = "Portugal",
    adm_lvl = "ALL",
    metadata = TRUE
  )
  expect_s3_class(meta2, "data.frame")
  expect_gt(nrow(meta2), 1L)

  # Several call, several sources
  meta3 <- gb_get(
    country = c("Portugal", "Italy"),
    adm_lvl = "ALL",
    metadata = TRUE
  )

  expect_s3_class(meta3, "data.frame")
  expect_gt(nrow(meta3), nrow(meta2))

  # Debug of ALL in countries
  all1 <- gb_get(
    country = "ALL",
    adm_lvl = "ADM0",
    metadata = TRUE
  )
  expect_s3_class(all1, "data.frame")
  expect_gt(nrow(all1), 100)

  all2 <- gb_get(
    country = c("ALL", "Spain"),
    adm_lvl = "ADM0",
    metadata = TRUE
  )
  expect_s3_class(all2, "data.frame")
  expect_identical(all1, all2)
})

test_that("Metadata errors", {
  skip_on_cran()
  skip_if_offline()
  expect_snapshot(
    err <- gb_get(
      country = c("AND", "ESP", "ATA"),
      adm_lvl = "ADM2",
      metadata = TRUE
    )
  )

  expect_s3_class(err, "data.frame")
  expect_equal(nrow(err), 1)

  expect_snapshot(
    err2 <- gb_get(
      country = "ATA",
      adm_lvl = "ADM2",
      metadata = TRUE
    )
  )

  expect_s3_class(err2, "data.frame")
  expect_equal(nrow(err2), 0)
})


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
      hlp_gb_get_sf_single(
        url = x,
        subdir = "gbOpen",
        verbose = FALSE,
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

  sev <- gb_get_meta(c("Andorra", "Vatican"), adm_lvl = "ADM0")
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
      hlp_gb_get_sf_single(
        url = x,
        subdir = "gbOpen",
        verbose = FALSE,
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
    hlp_gb_get_sf_single(
      url = x,
      subdir = "gbOpen",
      verbose = FALSE,
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
  iso <- gb_get_meta(release_type = "gbHumanitarian", adm_lvl = "ADM0") %>%
    slice_head(n = 1) %>%
    pull(boundaryISO)

  res <- gb_get_adm0(iso, simplified = TRUE, release_type = "gbHumanitarian")
  expect_s3_class(res, "sf")

  iso <- gb_get_meta(release_type = "gbAuthoritative", adm_lvl = "ADM0") %>%
    slice_head(n = 1) %>%
    pull(boundaryISO)

  res <- gb_get_adm0(iso, simplified = TRUE, release_type = "gbAuthoritative")
  expect_s3_class(res, "sf")
})
