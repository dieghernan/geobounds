test_that("Check meta", {
  skip_on_cran()
  skip_if_offline()

  adm1 <- get_gb_meta(adm_lvl = "ADM1")
  expect_s3_class(adm1, "tbl")
  expect_identical(unique(adm1$boundaryType), "ADM1")

  # Another source
  aa <- get_gb_meta(release_type = "gbHumanitarian", adm_lvl = "ADM1")
  expect_s3_class(aa, "tbl")

  expect_lt(nrow(aa), nrow(adm1))
})
