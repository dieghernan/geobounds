test_that("cache helpers stay inside test-owned directories", {
  test_root <- withr::local_tempdir("geobounds-test-cache-")

  current <- file.path(test_root, "initial")
  dir.create(current, recursive = TRUE)
  withr::local_envvar(GEOBOUNDS_CACHE_DIR = current)

  # Set a temporary cache directory without touching user configuration.
  expect_message(gb_set_cache_dir(current, quiet = FALSE))
  testdir <- file.path(test_root, "quiet-cache")
  detected <- expect_silent(gb_set_cache_dir(testdir, quiet = TRUE))

  expect_identical(detected, testdir)
  expect_identical(gb_detect_cache_dir(), testdir)

  # Clean only the test-owned cache directory.
  expect_silent(gb_clear_cache(config = FALSE, quiet = TRUE))
  expect_false(dir.exists(testdir))

  # Exercise the verbose clear path on a second test-owned cache directory.
  testdir <- file.path(test_root, "verbose-cache")
  expect_message(gb_set_cache_dir(testdir))

  expect_true(dir.exists(testdir))

  expect_message(gb_clear_cache(config = FALSE, quiet = FALSE))

  expect_false(dir.exists(testdir))

  # Restore the test-scoped initial cache before leaving the test.
  expect_message(gb_set_cache_dir(current, quiet = FALSE))
  expect_silent(gb_set_cache_dir(current, quiet = TRUE))
  expect_equal(current, Sys.getenv("GEOBOUNDS_CACHE_DIR"))
  expect_true(dir.exists(current))
})

test_that("default cache stays isolated from user configuration", {
  default_cache <- file.path(tempdir(), "geobounds")
  default_cache_existed <- dir.exists(default_cache)
  if (!default_cache_existed) {
    withr::defer(unlink(default_cache, recursive = TRUE, force = TRUE))
  }

  expect_message(detected <- gb_set_cache_dir(quiet = FALSE))

  expect_identical(detected, default_cache)

  withr::local_envvar(GEOBOUNDS_CACHE_DIR = "")

  # Mock an empty configuration directory.
  local_test_user_config_dir()
  expect_identical(gb_hlp_detect_cache_dir(), default_cache)
  expect_true(dir.exists(default_cache))
})

test_that("persistent cache configuration stays inside mocked user directory", {
  test_root <- withr::local_tempdir("geobounds-test-config-")
  config_dir <- local_test_user_config_dir(tmpdir = test_root)
  first_cache <- file.path(test_root, "first-cache")
  second_cache <- file.path(test_root, "second-cache")
  config_file <- file.path(config_dir, "GEOBOUNDS_CACHE_DIR")

  expect_silent(gb_set_cache_dir(first_cache, install = TRUE, quiet = TRUE))

  expect_true(file.exists(config_file))
  expect_identical(readLines(config_file), first_cache)

  expect_error(
    gb_set_cache_dir(second_cache, install = TRUE, quiet = TRUE),
    "already saved"
  )

  expect_silent(gb_set_cache_dir(
    second_cache,
    install = TRUE,
    overwrite = TRUE,
    quiet = TRUE
  ))

  expect_identical(readLines(config_file), second_cache)
})

test_that("cache configuration can be cleared from mocked user directory", {
  test_root <- withr::local_tempdir("geobounds-test-clear-config-")
  config_dir <- local_test_user_config_dir(tmpdir = test_root)
  cache_dir <- file.path(test_root, "cache")
  dir.create(cache_dir, recursive = TRUE)
  writeLines(cache_dir, file.path(config_dir, "GEOBOUNDS_CACHE_DIR"))
  withr::local_envvar(GEOBOUNDS_CACHE_DIR = cache_dir)

  expect_message(gb_clear_cache(
    config = TRUE,
    cached_data = FALSE,
    quiet = FALSE
  ))

  expect_false(dir.exists(config_dir))
  expect_true(dir.exists(cache_dir))
  expect_identical(Sys.getenv("GEOBOUNDS_CACHE_DIR"), "")
})

test_that("cache directory helper creates the active cache directory", {
  test_root <- withr::local_tempdir("geobounds-test-helper-cache-")
  cache_dir <- file.path(test_root, "nested-cache")
  withr::local_envvar(GEOBOUNDS_CACHE_DIR = cache_dir)

  expect_false(dir.exists(cache_dir))
  expect_identical(gb_hlp_cachedir(), cache_dir)
  expect_true(dir.exists(cache_dir))
})

test_that("cache directory helper follows order", {
  config_dir <- local_test_user_config_dir("geobounds-test-config-order-")
  cache_dir <- file.path(config_dir, "configured-cache")

  writeLines(
    cache_dir,
    file.path(config_dir, "GEOBOUNDS_CACHE_DIR")
  )

  expect_identical(gb_hlp_detect_cache_dir(), cache_dir)
})

test_that("cache detection falls back when configuration file is empty", {
  default_cache <- file.path(tempdir(), "geobounds")
  default_cache_existed <- dir.exists(default_cache)
  if (!default_cache_existed) {
    withr::defer(unlink(default_cache, recursive = TRUE, force = TRUE))
  }

  config_dir <- local_test_user_config_dir("geobounds-test-empty-config-")
  writeLines(character(), file.path(config_dir, "GEOBOUNDS_CACHE_DIR"))

  expect_identical(gb_hlp_detect_cache_dir(), default_cache)
  expect_true(dir.exists(default_cache))
})
