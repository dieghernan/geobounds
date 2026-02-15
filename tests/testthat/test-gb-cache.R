test_that("Test cache online", {
  # Get current cache dir
  current <- gb_detect_cache_dir()

  # Set a temp cache dir
  expect_message(gb_set_cache_dir(quiet = FALSE))
  testdir <- expect_silent(gb_set_cache_dir(
    file.path(current, "testthat"),
    quiet = TRUE
  ))

  expect_identical(gb_detect_cache_dir(), testdir)

  # Clean
  expect_silent(gb_clear_cache(config = FALSE, quiet = TRUE))
  # Cache dir should be deleted now
  expect_false(dir.exists(testdir))

  # Reset just for testing all cases
  testdir <- file.path(tempdir(), "geobounds", "testthat")
  expect_message(gb_set_cache_dir(testdir))

  expect_true(dir.exists(testdir))

  expect_message(gb_clear_cache(config = FALSE, quiet = FALSE))

  # Cache dir should be deleted now
  expect_false(dir.exists(testdir))

  # Restore cache
  expect_message(gb_set_cache_dir(current, quiet = FALSE))
  expect_silent(gb_set_cache_dir(current, quiet = TRUE))
  expect_equal(current, Sys.getenv("GEOBOUNDS_CACHE_DIR"))
  expect_true(dir.exists(current))
})
