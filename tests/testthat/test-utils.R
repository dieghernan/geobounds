test_that("Utils names", {
  skip_on_cran()

  expect_snapshot(gbnds_dev_country2iso(c("Espagne", "United Kingdom")))
  expect_error(gbnds_dev_country2iso("UA"))
  expect_snapshot(gbnds_dev_country2iso(c("ESP", "POR", "RTA", "USA")))
  expect_snapshot(gbnds_dev_country2iso(c("ESP", "Alemania")))

  expect_identical(
    gbnds_dev_country2iso(c("ESP", "POR", "RTA", "USA", "all")),
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
  expect_snapshot(gbnds_dev_country2iso(c(
    "Spain",
    "Rea",
    "Kosovo",
    "Antartica",
    "Murcua"
  )))

  expect_snapshot(gbnds_dev_country2iso("Kosovo"))
  expect_snapshot(gbnds_dev_country2iso("XKX"))

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
  expect_snapshot(assert_adm_lvl(1:2), error = TRUE)

  expect_snapshot(assert_adm_lvl(adm_lvl = 10), error = TRUE)

  expect_identical(assert_adm_lvl(1), "ADM1")

  expect_identical(assert_adm_lvl("adm5"), "ADM5")

  expect_identical(assert_adm_lvl("all", dict = "all"), "ALL")

  # Ignore case, this feature is not documented
  expect_identical(assert_adm_lvl("ADM5"), "ADM5")
  expect_identical(assert_adm_lvl("ALL", dict = "all"), "ALL")

  # Test integers
  vec_integers <- vapply(0:5, assert_adm_lvl, FUN.VALUE = character(1))
  expect_identical(vec_integers, paste0("ADM", 0:5))
})

test_that("Internal helpers clean and parse common API values", {
  expect_identical(
    gb_hlp_unique_values(c("a", "a", NA_character_, "b")),
    c("a", "b")
  )

  tb <- dplyr::tibble(one = "1", two = "2", three = "three")
  out <- gb_hlp_as_numeric(tb, c("one", "two", "missing"))
  expect_identical(out$one, 1)
  expect_identical(out$two, 2)
  expect_identical(out$three, "three")

  api_datetime <- "Mon Jan 02 03:04:05 2023"
  parsed_datetime <- gb_hlp_parse_api_datetime(api_datetime)
  expect_s3_class(parsed_datetime, "POSIXlt")
  expect_identical(
    strftime(parsed_datetime, "%Y-%m-%d %H:%M:%S", tz = "GMT"),
    "2023-01-02 03:04:05"
  )

  expect_identical(
    gb_hlp_parse_api_date("Jan 02, 2023"),
    as.Date("2023-01-02")
  )
})

test_that("Internal shapefile selection respects simplified files", {
  shp_files <- c(
    "folder/source.shp",
    "folder/source.dbf",
    "folder/source_simplified.shp"
  )

  expect_identical(
    gb_hlp_select_shapefile(shp_files, simplified = FALSE),
    "folder/source.shp"
  )
  expect_identical(
    gb_hlp_select_shapefile(shp_files, simplified = TRUE),
    "folder/source_simplified.shp"
  )
})

test_that("UTF-8", {
  skip_on_cran()
  skip_if_offline()

  ff <- gb_get("CZE", "ADM1", simplified = TRUE)
  expect_true(all(Encoding(ff$shapeName) == "UTF-8"))
})

test_that("Pretty match", {
  skip_on_cran()
  my_fun <- function(arg_one = c(10, 1000, 3000, 5000)) {
    match_arg_pretty(arg_one)
  }

  # OK, returns character
  expect_identical(my_fun(1000), "1000")
  expect_identical(my_fun("1000"), "1000")
  expect_identical(my_fun(NULL), "10")
  expect_identical(my_fun(), "10")
  # Some errors here
  # Single value no match
  expect_snapshot(my_fun("error here"), error = TRUE)

  # Several values no match
  expect_snapshot(my_fun(c("an", "error")), error = TRUE)

  # One value regex
  expect_snapshot(my_fun("5"), error = TRUE)
  # Several value regex
  expect_snapshot(my_fun("00"), error = TRUE)

  my_fun2 <- function(year = 20) {
    match_arg_pretty(year)
  }

  # Pass more options than expected
  expect_snapshot(my_fun2(c(1, 2)), error = TRUE)

  # With custom options
  my_fun3 <- function(an_arg = 20) {
    match_arg_pretty(an_arg, c("30", "20"))
  }
  expect_identical(my_fun3(), "20")
  expect_snapshot(my_fun3("3"), error = TRUE)
  # Pass more options than expected
  expect_snapshot(my_fun2(c(1, 2)), error = TRUE)
})
