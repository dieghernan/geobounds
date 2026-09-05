test_that("missing boundaries return NULL", {
  skip_on_cran()
  skip_if_offline()
  tmpd <- local_test_cache("geobounds-test-get-null-")

  expect_snapshot(
    err2 <- gb_get(country = "ATA", adm_lvl = "ADM2", cache_dir = tmpd)
  )

  expect_null(err2)
})

test_that("authoritative boundaries display their license notice", {
  expect_silent(gb_hlp_license_notice("gbOpen"))
  expect_snapshot(gb_hlp_license_notice("gbAuthoritative"))
})

test_that("boundary downloads reject non-scalar options", {
  expect_error(gb_get("ESP", simplified = NA), class = "rlang_error")
  expect_error(gb_get("ESP", overwrite = logical()), class = "rlang_error")
  expect_error(
    gb_get("ESP", quiet = c(TRUE, FALSE)),
    class = "rlang_error"
  )
  expect_error(
    gb_get("ESP", cache_dir = c("first", "second")),
    class = "rlang_error"
  )
  expect_error(gb_get("ESP", cache_dir = ""), class = "rlang_error")
})

test_that("invalid boundary archives are removed", {
  archive <- withr::local_tempfile(lines = "not a ZIP archive")

  expect_error(gb_hlp_list_archive(archive), class = "rlang_error")
  expect_false(file.exists(archive))
})

test_that("invalid boundary archives report deletion failures", {
  archive <- withr::local_tempfile(lines = "not a ZIP archive")
  local_mocked_bindings(
    gb_hlp_unlink = function(...) 1L
  )

  expect_error(
    gb_hlp_list_archive(archive),
    "could not be removed",
    class = "rlang_error"
  )
})

test_that("boundary archives reject malformed file listings", {
  archive <- withr::local_tempfile(lines = "placeholder")
  local_mocked_bindings(
    gb_hlp_unzip_list = function(...) data.frame(Size = 1L)
  )

  expect_error(gb_hlp_list_archive(archive), class = "rlang_error")
  expect_false(file.exists(archive))
})

test_that("boundary downloads return simplified or full sf objects", {
  skip_on_cran()
  skip_if_offline()

  tmpd <- local_test_cache("geobounds-test-get-")
  expect_silent(
    che <- gb_get(
      country = "San Marino",
      adm_lvl = "ADM0",
      cache_dir = tmpd,
      simplified = TRUE
    )
  )

  expect_s3_class(che, "sf")
  expect_equal(nrow(che), 1)

  # Not simplified
  expect_silent(
    chefull <- gb_get(
      country = "San Marino",
      adm_lvl = "ADM0",
      cache_dir = tmpd,
      simplified = FALSE
    )
  )

  expect_lt(object.size(che), object.size(chefull))
})

test_that("boundary downloads report download and cache messages", {
  skip_on_cran()
  skip_if_offline()

  tmpd <- local_test_cache("geobounds-test-get-messages-")
  expect_message(
    che <- gb_get(
      country = "San Marino",
      adm_lvl = "ADM0",
      cache_dir = tmpd,
      simplified = TRUE,
      quiet = FALSE
    ),
    "Downloading source archive"
  )

  expect_s3_class(che, "sf")
  expect_equal(nrow(che), 1)

  # Cached
  expect_message(
    che <- gb_get(
      country = "San Marino",
      adm_lvl = "ADM0",
      cache_dir = tmpd,
      simplified = TRUE,
      quiet = FALSE
    ),
    "Using cached file"
  )
})

test_that("failed boundary downloads return NULL", {
  local_mocked_bindings(
    gb_get_metadata = function(...) {
      dplyr::tibble(staticDownloadLink = c("failed", "also-failed"))
    },
    gbnds_dev_shp_query = function(...) NULL
  )

  result <- gb_get("ESP")

  expect_null(result)
})

test_that("failed HTTP downloads remove the archive and preserve other files", {
  cache_dir <- local_test_cache("geobounds-test-http-failure-")
  release_dir <- file.path(cache_dir, "gbOpen")
  dir.create(release_dir)
  archive <- file.path(release_dir, "boundary.zip")
  writeLines("old archive", archive)
  sentinel <- file.path(release_dir, "other.zip")
  writeLines("keep", sentinel)
  withr::local_options(
    httr2_mock = function(req) {
      httr2::response(
        status_code = 404L,
        url = req$url,
        body = charToRaw("Not found")
      )
    }
  )

  expect_message(
    result <- gbnds_dev_shp_query(
      url = "https://example.com/boundary.zip",
      subdir = "gbOpen",
      quiet = TRUE,
      overwrite = TRUE,
      cache_dir = cache_dir
    ),
    "failed with HTTP status.*404"
  )

  expect_null(result)
  expect_false(file.exists(archive))
  expect_identical(readLines(sentinel), "keep")
})

test_that("mixed downloads retain successes when the failure is first", {
  expected <- sf::st_sf(
    shapeGroup = c("AND", "VAT"),
    geometry = sf::st_sfc(
      sf::st_point(c(1, 2)),
      sf::st_point(c(3, 4)),
      crs = 4326
    )
  )
  local_mocked_bindings(
    gb_get_metadata = function(...) {
      dplyr::tibble(staticDownloadLink = c("failed", "AND", "VAT"))
    },
    gbnds_dev_shp_query = function(url, ...) {
      if (url == "failed") {
        return(NULL)
      }
      expected[expected$shapeGroup == url, ]
    }
  )

  result <- gb_get(c("AND", "VAT", "ESP"), simplified = TRUE)

  expect_s3_class(result, "sf")
  expect_identical(result$shapeGroup, c("AND", "VAT"))
  expect_equal(sf::st_geometry(result), sf::st_geometry(expected))
})

test_that("mixed downloads retain successes when the failure is last", {
  expected <- sf::st_sf(
    shapeGroup = c("AND", "VAT"),
    geometry = sf::st_sfc(
      sf::st_point(c(1, 2)),
      sf::st_point(c(3, 4)),
      crs = 4326
    )
  )
  local_mocked_bindings(
    gb_get_metadata = function(...) {
      dplyr::tibble(staticDownloadLink = c("AND", "VAT", "failed"))
    },
    gbnds_dev_shp_query = function(url, ...) {
      if (url == "failed") {
        return(NULL)
      }
      expected[expected$shapeGroup == url, ]
    }
  )

  result <- gb_get(c("AND", "VAT", "ESP"), simplified = TRUE)

  expect_s3_class(result, "sf")
  expect_identical(result$shapeGroup, c("AND", "VAT"))
  expect_equal(sf::st_geometry(result), sf::st_geometry(expected))
})
