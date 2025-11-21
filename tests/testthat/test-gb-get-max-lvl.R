test_that("Max levels", {
  skip_on_cran()
  skip_if_offline()
  all <- gb_get_max_adm_lvl()

  expect_identical(range(all$maxBoundaryType), c(0L, 5L))

  # Another source
  all2 <- gb_get_max_adm_lvl(release_type = "gbAuthoritative")
  expect_lt(nrow(all2), nrow(all))
  expect_s3_class(all, "tbl_df")
  expect_gt(nrow(all), 190)

  # Single
  uno <- gb_get_max_adm_lvl("Spain")
  expect_identical(nrow(uno), 1L)

  # Several
  sev <- gb_get_max_adm_lvl(c("FRA", "ITA"))
  expect_identical(nrow(sev), 2L)
  expect_identical(sev$boundaryISO, c("FRA", "ITA"))
})
