test_that("Test cache online", {
  # Get current cache dir
  current <- geobn_detect_cache_dir()

  # Set a temp cache dir
  expect_message(geobn_set_cache_dir(verbose = TRUE))
  testdir <- expect_silent(geobn_set_cache_dir(
    file.path(current, "testthat"),
    verbose = FALSE
  ))

  expect_identical(geobn_detect_cache_dir(), testdir)

  # Clean
  expect_silent(geobn_clear_cache(config = FALSE, verbose = FALSE))
  # Cache dir should be deleted now
  expect_false(dir.exists(testdir))

  # Reset just for testing all cases
  testdir <- file.path(tempdir(), "geobounds", "testthat")
  expect_message(geobn_set_cache_dir(testdir))

  expect_true(dir.exists(testdir))

  expect_message(geobn_clear_cache(config = FALSE, verbose = TRUE))

  # Cache dir should be deleted now
  expect_false(dir.exists(testdir))

  # Restore cache
  expect_message(geobn_set_cache_dir(current, verbose = TRUE))
  expect_silent(geobn_set_cache_dir(current, verbose = FALSE))
  expect_equal(current, Sys.getenv("GEOBN_CACHE_DIR"))
  expect_true(dir.exists(current))
})
