test_that("Check meta", {
  skip_on_cran()
  skip_if_offline()

  # Single metadata
  meta <- gb_get_meta(
    country = "Portugal",
    adm_lvl = "adm0"
  )

  expect_s3_class(meta, "data.frame")
  expect_equal(nrow(meta), 1L)

  # One call, several sources
  meta2 <- gb_get_meta(
    country = "Portugal",
    adm_lvl = "all",
  )
  expect_s3_class(meta2, "data.frame")
  expect_gt(nrow(meta2), 1L)

  # Several call, several sources
  meta3 <- gb_get_meta(
    country = c("Portugal", "Italy"),
    adm_lvl = "all",
  )

  expect_s3_class(meta3, "data.frame")
  expect_gt(nrow(meta3), nrow(meta2))

  # Debug of ALL in countries
  all1 <- gb_get_meta(
    country = "all",
    adm_lvl = "adm0"
  )
  expect_s3_class(all1, "data.frame")
  expect_gt(nrow(all1), 100)

  all2 <- gb_get_meta(
    country = c("ALL", "Spain"),
    adm_lvl = "adm0"
  )
  expect_s3_class(all2, "data.frame")
  expect_identical(all1, all2)

  adm1 <- gb_get_meta(adm_lvl = "ADM1")
  expect_s3_class(adm1, "tbl")
  expect_identical(unique(adm1$boundaryType), "ADM1")

  adm5 <- gb_get_meta(adm_lvl = "ADM5")
  expect_s3_class(adm5, "tbl")
  expect_identical(unique(adm5$boundaryType), "ADM5")

  # Another source
  aa <- gb_get_meta(release_type = "gbHumanitarian", adm_lvl = "ADM1")
  expect_s3_class(aa, "tbl")

  expect_lt(nrow(aa), nrow(adm1))
})

test_that("Check meta errors", {
  skip_on_cran()
  skip_if_offline()

  expect_snapshot(
    db <- gb_get_meta(country = "ESP", adm_lvl = "ADM5"),
  )
  expect_s3_class(db, "tbl_df")
  expect_equal(nrow(db), 0)

  expect_snapshot(
    err <- gb_get_meta(
      country = c("AND", "ESP", "ATA"),
      adm_lvl = "ADM2"
    )
  )

  expect_s3_class(err, "data.frame")
  expect_equal(nrow(err), 1)
})
