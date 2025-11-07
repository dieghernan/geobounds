test_that("Utils names", {
  skip_on_cran()

  expect_snapshot(gb_helper_countrynames(c("Espagne", "United Kingdom")))
  expect_error(gb_helper_countrynames("UA"))
  expect_snapshot(gb_helper_countrynames(
    c("ESP", "POR", "RTA", "USA")
  ))
})
