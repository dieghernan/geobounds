test_that("sf output", {
  skip_on_cran()
  skip_if_offline()

  expect_silent(
    wrld <- get_geobn_world()
  )

  expect_s3_class(wrld, "sf")
  expect_gt(nrow(wrld), 150)
})
