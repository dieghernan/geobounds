test_that("world downloads return valid sf objects and filter countries", {
  skip_on_cran()
  skip_if_offline()
  tmpd <- local_test_cache("geobounds-test-world-")

  expect_silent(wrld <- gb_get_world(cache_dir = tmpd))

  expect_identical(
    unique(as.character(sf::st_geometry_type(wrld))),
    "MULTIPOLYGON"
  )
  expect_true(sf::st_is_longlat(wrld))
  expect_s3_class(wrld, "sf")
  expect_gt(nrow(wrld), 150)

  and <- gb_get_world("Andorra", cache_dir = tmpd)

  expect_s3_class(and, "sf")
  expect_equal(nrow(and), 1)
  expect_identical(and$shapeName, "Andorra")

  # What about level 2?
  lvl2 <- gb_get_world("Andorra", adm_lvl = "adm1", cache_dir = tmpd)
  expect_true(sf::st_is_longlat(lvl2))
  expect_s3_class(lvl2, "sf")
  expect_gt(nrow(lvl2), 1)
  expect_identical(unique(lvl2$shapeGroup), "AND")
  expect_identical(unique(lvl2$shapeType), "ADM1")
})

test_that("world downloads reject unsupported ADM levels", {
  tmpd <- local_test_cache("geobounds-test-world-levels-")

  expect_snapshot(
    gb_get_world("Andorra", adm_lvl = "4", cache_dir = tmpd),
    error = TRUE
  )
})

test_that("world downloads reject non-scalar options", {
  expect_error(gb_get_world(overwrite = NA), class = "rlang_error")
  expect_error(
    gb_get_world(quiet = c(TRUE, FALSE)),
    class = "rlang_error"
  )
  expect_error(
    gb_get_world(cache_dir = character()),
    class = "rlang_error"
  )
})

test_that("world downloads return NULL after a failed request", {
  local_mocked_bindings(
    gbnds_dev_shp_query = function(...) NULL
  )

  expect_null(gb_get_world("Andorra"))
})

test_that("world downloads return NULL when no country matches", {
  empty_world <- sf::st_sf(
    shapeGroup = character(),
    geometry = sf::st_sfc(crs = 4326)
  )
  local_mocked_bindings(
    gbnds_dev_shp_query = function(...) empty_world
  )

  expect_null(gb_get_world("Andorra"))
})
