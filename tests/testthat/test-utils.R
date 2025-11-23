test_that("Utils names", {
  skip_on_cran()

  expect_snapshot(gbnds_dev_country2iso(c("Espagne", "United Kingdom")))
  expect_error(gbnds_dev_country2iso("UA"))
  expect_snapshot(gbnds_dev_country2iso(
    c("ESP", "POR", "RTA", "USA")
  ))
  expect_snapshot(gbnds_dev_country2iso(c("ESP", "Alemania")))

  expect_identical(
    gbnds_dev_country2iso(
      c("ESP", "POR", "RTA", "USA", "all")
    ),
    "ALL"
  )
})

test_that("Problematic names", {
  skip_on_cran()
  skip_if_offline()

  expect_snapshot(gbnds_dev_country2iso(c("Espagne", "Antartica")))
  expect_snapshot(gbnds_dev_country2iso(c("spain", "antartica")))

  ata <- gb_get_adm0("Antartica", simplified = TRUE)
  expect_s3_class(ata, "sf")

  # Special case for Kosovo
  expect_snapshot(gbnds_dev_country2iso(c("Spain", "Kosovo", "Antartica")))
  expect_snapshot(gbnds_dev_country2iso(c("ESP", "XKX", "DEU")))
  expect_snapshot(
    gbnds_dev_country2iso(c("Spain", "Rea", "Kosovo", "Antartica", "Murcua"))
  )

  expect_snapshot(
    gbnds_dev_country2iso("Kosovo")
  )
  expect_snapshot(
    gbnds_dev_country2iso("XKX")
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

  allnames <- gb_get_metadata(adm_lvl = "ADM0")
  nm <- unique(allnames$boundaryName)
  expect_silent(nm2 <- gbnds_dev_country2iso(nm))
  isos <- unique(allnames$boundaryISO)
  expect_silent(isos2 <- gbnds_dev_country2iso(isos))
  expect_identical(length(nm), length(isos2))
  expect_identical(length(nm), length(nm2))
})
test_that("Test mixed countries", {
  skip_on_cran()
  skip_if_offline()
  expect_silent(cnt <- gb_get(country = c("Germany", "USA"), simplified = TRUE))
  expect_s3_class(cnt, "sf")
})

test_that("Assert admin levels", {
  expect_snapshot(
    assert_adm_lvl(1:2),
    error = TRUE
  )

  expect_snapshot(
    assert_adm_lvl(adm_lvl = 10),
    error = TRUE
  )

  expect_identical(
    assert_adm_lvl(1),
    "ADM1"
  )

  expect_identical(
    assert_adm_lvl("adm5"),
    "ADM5"
  )

  expect_identical(
    assert_adm_lvl("all", dict = "all"),
    "ALL"
  )

  # Ignore case, this feature is not documented
  expect_identical(
    assert_adm_lvl("ADM5"),
    "ADM5"
  )
  expect_identical(
    assert_adm_lvl("ALL", dict = "all"),
    "ALL"
  )

  # Test integers
  vec_integers <- vapply(0:5, assert_adm_lvl, FUN.VALUE = character(1))
  expect_identical(
    vec_integers,
    paste0("ADM", 0:5)
  )
})

test_that("UTF-8", {
  skip_on_cran()
  skip_if_offline()

  ff <- gb_get("CZE", "ADM1", simplified = TRUE)
  expect_true(all(Encoding(ff$shapeName) == "UTF-8"))
})
