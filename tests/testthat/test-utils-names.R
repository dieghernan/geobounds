test_that("Utils names", {
  skip_on_cran()

  expect_snapshot(gb_helper_countrynames(c("Espagne", "United Kingdom")))
  expect_error(gb_helper_countrynames("UA"))
  expect_snapshot(gb_helper_countrynames(
    c("ESP", "POR", "RTA", "USA")
  ))
  expect_snapshot(gb_helper_countrynames(c("ESP", "Alemania")))
})

test_that("Problematic names", {
  skip_on_cran()
  skip_if_offline()

  expect_snapshot(gb_helper_countrynames(c("Espagne", "Antartica")))
  expect_snapshot(gb_helper_countrynames(c("spain", "antartica")))

  ata <- gb_get_adm0("Antartica", simplified = TRUE)
  expect_s3_class(ata, "sf")

  # Special case for Kosovo
  expect_snapshot(gb_helper_countrynames(c("Spain", "Kosovo", "Antartica")))
  expect_snapshot(gb_helper_countrynames(c("ESP", "XKX", "DEU")))
  expect_snapshot(
    gb_helper_countrynames(c("Spain", "Rea", "Kosovo", "Antartica", "Murcua"))
  )

  expect_snapshot(
    gb_helper_countrynames("Kosovo")
  )
  expect_snapshot(
    gb_helper_countrynames("XKX")
  )

  kos <- gb_get_adm0("Kosovo", simplified = TRUE)
  expect_s3_class(kos, "sf")

  full <- gb_get_adm0(c("Antarctica", "Kosovo"), simplified = TRUE)
  expect_s3_class(full, "sf")
  expect_identical(full$shapeGroup, c("ATA", "XKX"))
  expect_equal(nrow(full), 2)
})

test_that("Test full name conversion", {
  skip_on_cran()
  skip_if_offline()

  allnames <- gb_get_meta(adm_lvl = "ADM0")
  nm <- unique(allnames$boundaryName)
  expect_silent(nm2 <- gb_helper_countrynames(nm))
  isos <- unique(allnames$boundaryISO)
  expect_silent(isos2 <- gb_helper_countrynames(isos))
  expect_identical(length(nm), length(isos2))
  expect_identical(length(nm), length(nm2))
})
test_that("Test mixed countries", {
  skip_on_cran()
  skip_if_offline()
  expect_silent(cnt <- gb_get(country = c("Germany", "USA"), simplified = TRUE))
  expect_s3_class(cnt, "sf")
})
