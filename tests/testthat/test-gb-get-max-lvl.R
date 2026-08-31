test_that("maximum ADM levels are returned by country and release type", {
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

test_that("maximum ADM levels do not assume consecutive metadata", {
  local_mocked_bindings(
    gb_get_metadata = function(...) {
      dplyr::tibble(
        boundaryISO = c("ESP", "ESP"),
        boundaryType = c("ADM0", "ADM2")
      )
    }
  )

  result <- gb_get_max_adm_lvl("ESP")

  expect_identical(result$boundaryISO, "ESP")
  expect_identical(result$maxBoundaryType, 2L)
})

test_that("maximum ADM levels return stable empty results", {
  local_mocked_bindings(
    gb_get_metadata = function(...) dplyr::tibble()
  )

  result <- gb_get_max_adm_lvl("ESP")

  expect_named(result, c("boundaryISO", "maxBoundaryType"))
  expect_identical(nrow(result), 0L)
  expect_type(result$boundaryISO, "character")
  expect_type(result$maxBoundaryType, "integer")
})

test_that("maximum ADM levels reject malformed metadata", {
  local_mocked_bindings(
    gb_get_metadata = function(...) {
      dplyr::tibble(boundaryISO = "ESP", boundaryType = "LEVEL2")
    }
  )

  expect_error(gb_get_max_adm_lvl("ESP"), class = "rlang_error")
})
