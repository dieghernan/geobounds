test_that("Metadata calls", {
  skip_on_cran()
  skip_if_offline()

  # Single metadata
  meta <- get_gb(
    country = "Portugal",
    adm_lvl = "ADM0",
    metadata = TRUE
  )

  expect_s3_class(meta, "data.frame")
  expect_equal(nrow(meta), 1L)

  # One call, several sources
  meta2 <- get_gb(
    country = "Portugal",
    adm_lvl = "ALL",
    metadata = TRUE
  )
  expect_s3_class(meta2, "data.frame")
  expect_gt(nrow(meta2), 1L)

  # Several call, several sources
  meta3 <- get_gb(
    country = c("Portugal", "Italy"),
    adm_lvl = "ALL",
    metadata = TRUE
  )

  expect_s3_class(meta3, "data.frame")
  expect_gt(nrow(meta3), nrow(meta2))

  # Debug of ALL in countries
  all1 <- get_gb(
    country = "ALL",
    adm_lvl = "ADM0",
    metadata = TRUE
  )
  expect_s3_class(all1, "data.frame")
  expect_gt(nrow(all1), 100)

  all2 <- get_gb(
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
    err <- get_gb(
      country = c("AND", "ESP", "ATA"),
      adm_lvl = "ADM2",
      metadata = TRUE
    )
  )

  expect_s3_class(err, "data.frame")
  expect_equal(nrow(err), 1)

  expect_snapshot(
    err2 <- get_gb(
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

  expect_snapshot(err2 <- get_gb(country = "ATA", adm_lvl = "ADM2"))

  expect_null(err2)
})

test_that("sf output simplified", {
  skip_on_cran()
  skip_if_offline()

  tmpd <- file.path(tempdir(), "testthat")
  expect_silent(
    che <- get_gb(
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
    chefull <- get_gb(
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
    che <- get_gb(
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
    che <- get_gb(
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
