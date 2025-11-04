test_that("Utils names", {
  skip_on_cran()

  expect_snapshot(geobn_helper_countrynames(c("Espagne", "United Kingdom")))
  expect_error(geobn_helper_countrynames("UA"))
  expect_snapshot(geobn_helper_countrynames(
    c("ESP", "POR", "RTA", "USA")
  ))
})
