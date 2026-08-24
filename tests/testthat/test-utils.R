test_that("country names and ISO codes are normalized to ISO3 codes", {
  expect_snapshot(gbnds_dev_country2iso(c("Espagne", "United Kingdom")))
  expect_snapshot(gbnds_dev_country2iso(c("ESP", "Alemania")))
})

test_that("invalid country identifiers are rejected or omitted", {
  expect_snapshot(gbnds_dev_country2iso("UA"), error = TRUE)
  expect_snapshot(gbnds_dev_country2iso(c("ESP", "POR")))
  expect_snapshot(gbnds_dev_country2iso(c("ESP", "POR", "RTA", "USA")))
  expect_snapshot(gbnds_dev_country2iso(c(
    "Spain",
    "Rea",
    "Kosovo",
    "Antartica",
    "Murcua"
  )))
})

test_that("ALL selects all countries", {
  expect_identical(
    gbnds_dev_country2iso(c("ESP", "POR", "RTA", "USA", "all")),
    "ALL"
  )
})

test_that("Antarctica misspellings and Kosovo aliases are normalized", {
  expect_snapshot(gbnds_dev_country2iso(c("Espagne", "Antartica")))
  expect_snapshot(gbnds_dev_country2iso(c("spain", "antartica")))
  expect_snapshot(gbnds_dev_country2iso(c("Spain", "Kosovo", "Antartica")))
  expect_snapshot(gbnds_dev_country2iso(c("ESP", "XKX", "DEU")))
  expect_snapshot(gbnds_dev_country2iso("Kosovo"))
  expect_snapshot(gbnds_dev_country2iso("XKX"))
})

test_that("Antarctica and Kosovo boundaries can be downloaded", {
  skip_on_cran()
  skip_if_offline()
  tmpd <- local_test_cache("geobounds-test-utils-names-")

  ata <- gb_get_adm0("Antartica", simplified = TRUE, cache_dir = tmpd)
  expect_s3_class(ata, "sf")

  kos <- gb_get_adm0("Kosovo", simplified = TRUE, cache_dir = tmpd)
  expect_s3_class(kos, "sf")

  full <- gb_get_adm0(
    c("Antarctica", "Kosovo"),
    simplified = TRUE,
    cache_dir = tmpd
  )
  expect_s3_class(full, "sf")
  expect_identical(full$shapeGroup, c("ATA", "XKX"))
  expect_equal(nrow(full), 2)
})

test_that("all metadata country names and codes can be converted", {
  skip_on_cran()
  skip_if_offline()

  allnames <- gb_get_metadata(adm_lvl = "ADM0")
  nm <- unique(allnames$boundaryName)
  expect_silent(nm2 <- gbnds_dev_country2iso(nm))
  isos <- unique(allnames$boundaryISO)
  expect_silent(isos2 <- gbnds_dev_country2iso(isos))
  expect_setequal(nm2, isos)
  expect_setequal(isos2, isos)
})

test_that("mixed country names and codes can be downloaded", {
  skip_on_cran()
  skip_if_offline()
  tmpd <- local_test_cache("geobounds-test-utils-mixed-")

  expect_silent(
    cnt <- gb_get(
      country = c("Germany", "USA"),
      simplified = TRUE,
      cache_dir = tmpd
    )
  )
  expect_s3_class(cnt, "sf")
})

test_that("ADM validation accepts valid and rejects invalid values", {
  expect_snapshot(assert_adm_lvl(1:2), error = TRUE)

  expect_snapshot(assert_adm_lvl(adm_lvl = 10), error = TRUE)

  my_fun <- function(adm_lvl = "adm0") {
    assert_adm_lvl(adm_lvl)
  }
  expect_snapshot(my_fun("adm9"), error = TRUE)

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

test_that("unique value helper removes duplicates and missing values", {
  expect_identical(
    gb_hlp_unique_values(c("a", "a", NA_character_, "b")),
    c("a", "b")
  )
})

test_that("numeric helper converts only matching columns", {
  tb <- dplyr::tibble(one = "1", two = "2", three = "three")
  out <- gb_hlp_as_numeric(tb, c("one", "two", "missing"))
  expect_identical(out$one, 1)
  expect_identical(out$two, 2)
  expect_identical(out$three, "three")
})

test_that("API date-time helper parses values in GMT", {
  api_datetime <- "Mon Jan 02 03:04:05 2023"
  parsed_datetime <- gb_hlp_parse_api_datetime(api_datetime)
  expect_s3_class(parsed_datetime, "POSIXlt")
  expect_identical(
    strftime(parsed_datetime, "%Y-%m-%d %H:%M:%S", tz = "GMT"),
    "2023-01-02 03:04:05"
  )
})

test_that("API date helper parses values", {
  expect_identical(gb_hlp_parse_api_date("Jan 02, 2023"), as.Date("2023-01-02"))
})

test_that("internal HTTP helpers format requests and HTTP errors", {
  req <- gb_hlp_request("https://example.com/data.zip", quiet = FALSE)
  expect_s3_class(req, "httr2_request")

  resp <- httr2::response(
    status_code = 404,
    url = "https://example.com/data.zip"
  )

  expect_identical(gb_hlp_http_error(resp), "404 - Not Found")
  expect_message(
    gb_hlp_alert_http_error("https://example.com/data.zip", resp),
    "404 - Not Found"
  )
})

test_that("shapefile selection respects the simplified option", {
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

test_that("downloaded boundary names use UTF-8 encoding", {
  skip_on_cran()
  skip_if_offline()
  tmpd <- local_test_cache("geobounds-test-utils-utf8-")

  ff <- gb_get("CZE", "ADM1", simplified = TRUE, cache_dir = tmpd)
  expect_identical(unique(Encoding(ff$shapeName)), "UTF-8")
})

test_that("argument matching returns exact values and defaults", {
  my_fun <- function(arg_one = c(10, 1000, 3000, 5000)) {
    match_arg_pretty(arg_one)
  }

  expect_identical(my_fun(1000), "1000")
  expect_identical(my_fun("1000"), "1000")
  expect_identical(my_fun(NULL), "10")
  expect_identical(my_fun(), "10")

  my_fun2 <- function(an_arg = 20) {
    match_arg_pretty(an_arg, c("30", "20"))
  }
  expect_identical(my_fun2(), "20")
})

test_that("argument matching reports invalid values and suggestions", {
  my_fun <- function(arg_one = c(10, 1000, 3000, 5000)) {
    match_arg_pretty(arg_one)
  }

  expect_snapshot(my_fun("error here"), error = TRUE)
  expect_snapshot(my_fun(c("an", "error")), error = TRUE)
  expect_snapshot(my_fun("5"), error = TRUE)
  expect_snapshot(my_fun("00"), error = TRUE)

  my_fun2 <- function(year = 20) {
    match_arg_pretty(year)
  }

  expect_snapshot(my_fun2(c(1, 2)), error = TRUE)

  my_fun3 <- function(an_arg = 20) {
    match_arg_pretty(an_arg, c("30", "20"))
  }
  expect_snapshot(my_fun3("3"), error = TRUE)
})

test_that("gb_abort_if_not accepts empty and true conditions", {
  expect_invisible(gb_abort_if_not())
  expect_invisible(gb_abort_if_not("A" = is.character("a")))
})

test_that("gb_abort_if_not rejects unnamed conditions", {
  expect_snapshot(error = TRUE, gb_abort_if_not(isFALSE(TRUE)))
})

test_that("gb_abort_if_not reports the first false condition", {
  expect_snapshot(
    error = TRUE,
    gb_abort_if_not(
      "First condition failed." = FALSE,
      "Second condition failed." = FALSE
    )
  )
})

test_that("cache setup rejects invalid argument types", {
  expect_snapshot(error = TRUE, gb_set_cache_dir(cache_dir = 34))
  expect_snapshot(error = TRUE, gb_set_cache_dir(overwrite = "a"))
  expect_snapshot(error = TRUE, gb_set_cache_dir(install = "a"))
  expect_snapshot(error = TRUE, gb_set_cache_dir(quiet = "a"))
})

test_that("sf helper casts polygon geometries to multipolygons", {
  skip_if_not_installed("sf")

  poly <- sf::st_polygon(list(rbind(
    c(0, 0),
    c(1, 0),
    c(1, 1),
    c(0, 1),
    c(0, 0)
  )))

  data_sf <- sf::st_sf(name = "test", geometry = sf::st_sfc(poly, crs = 4326))

  out <- gbnds_dev_sf_helper(data_sf)

  expect_s3_class(out, "sf")
  expect_identical(
    unique(as.character(sf::st_geometry_type(out))),
    "MULTIPOLYGON"
  )
})
