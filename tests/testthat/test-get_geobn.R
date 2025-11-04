test_that("Metadata calls", {
  skip_on_cran()
  skip_if_offline()

  # Single metadata
  meta <- get_geobn(
    country = "Portugal", boundary_type = "ADM0",
    metadata = TRUE
  )

  expect_s3_class(meta, "data.frame")
  expect_equal(nrow(meta), 1L)

  # One call, several sources
  meta2 <- get_geobn(
    country = "Portugal", boundary_type = "ALL",
    metadata = TRUE
  )
  expect_s3_class(meta2, "data.frame")
  expect_gt(nrow(meta2), 1L)

  # Several call, several sources
  meta3 <- get_geobn(
    country = c("Portugal", "Italy"),
    boundary_type = "ALL",
    metadata = TRUE
  )

  expect_s3_class(meta3, "data.frame")
  expect_gt(nrow(meta3), nrow(meta2))

  # Debug of ALL in countries
  all1 <- get_geobn(
    country = "ALL", boundary_type = "ADM0",
    metadata = TRUE
  )
  expect_s3_class(all1, "data.frame")
  expect_gt(nrow(all1), 100)

  all2 <- get_geobn(
    country = c("ALL", "Spain"), boundary_type = "ADM0",
    metadata = TRUE
  )
  expect_s3_class(all2, "data.frame")
  expect_identical(all1, all2)
})

test_that("Metadata errors", {
  skip_on_cran()
  skip_if_offline()
  expect_snapshot(err <- get_geobn(
    country = c("AND", "ESP", "ATA"),
    boundary_type = "ADM2", metadata = TRUE
  ))

  expect_s3_class(err, "data.frame")
  expect_equal(nrow(err), 1)

  expect_snapshot(err2 <- get_geobn(
    country = "ATA", boundary_type = "ADM2",
    metadata = TRUE
  ))

  expect_s3_class(err2, "data.frame")
  expect_equal(nrow(err2), 0)
})
