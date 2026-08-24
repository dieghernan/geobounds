test_that("setting a cache directory updates the active cache", {
  test_root <- withr::local_tempdir("geobounds-test-cache-")
  cache_dir <- file.path(test_root, "active-cache")
  withr::local_envvar(GEOBOUNDS_CACHE_DIR = "")

  expect_message(detected <- gb_set_cache_dir(cache_dir, quiet = FALSE))

  expect_identical(detected, cache_dir)
  expect_identical(gb_detect_cache_dir(), cache_dir)
  expect_identical(Sys.getenv("GEOBOUNDS_CACHE_DIR"), cache_dir)
  expect_true(dir.exists(cache_dir))
})

test_that("quiet cache operations suppress messages", {
  test_root <- withr::local_tempdir("geobounds-test-cache-quiet-")
  cache_dir <- file.path(test_root, "quiet-cache")
  withr::local_envvar(GEOBOUNDS_CACHE_DIR = "")

  expect_silent(gb_set_cache_dir(cache_dir, quiet = TRUE))
  expect_silent(gb_clear_cache(config = FALSE, quiet = TRUE))

  expect_false(dir.exists(cache_dir))
})

test_that("clearing cached data removes the active cache directory", {
  test_root <- withr::local_tempdir("geobounds-test-cache-clear-")
  cache_dir <- file.path(test_root, "verbose-cache")
  withr::local_envvar(GEOBOUNDS_CACHE_DIR = "")

  expect_message(gb_set_cache_dir(cache_dir, quiet = FALSE))
  expect_message(gb_clear_cache(config = FALSE, quiet = FALSE))

  expect_false(dir.exists(cache_dir))
  expect_identical(Sys.getenv("GEOBOUNDS_CACHE_DIR"), "")
})

test_that("default cache is used when no user configuration exists", {
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

test_that("persistent cache configuration supports overwrite", {
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

test_that("clearing cache configuration preserves cached data", {
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

test_that("cache directory helper creates the active directory", {
  test_root <- withr::local_tempdir("geobounds-test-helper-cache-")
  cache_dir <- file.path(test_root, "nested-cache")
  withr::local_envvar(GEOBOUNDS_CACHE_DIR = cache_dir)

  expect_false(dir.exists(cache_dir))
  expect_identical(gb_hlp_cachedir(), cache_dir)
  expect_true(dir.exists(cache_dir))
})

test_that("cache detection uses the configured directory", {
  config_dir <- local_test_user_config_dir("geobounds-test-config-order-")
  cache_dir <- file.path(config_dir, "configured-cache")

  writeLines(cache_dir, file.path(config_dir, "GEOBOUNDS_CACHE_DIR"))

  expect_identical(gb_hlp_detect_cache_dir(), cache_dir)
})

test_that("cache detection falls back when configuration is empty", {
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

test_that("installed cache paths are detected from configuration", {
  test_root <- file.path(tempfile("geobounds"))
  withr::defer(unlink(test_root, force = TRUE, recursive = TRUE))
  withr::local_envvar(GEOBOUNDS_CACHE_DIR = "")

  expect_false(dir.exists(test_root))
  # Mock an empty configuration directory.

  local_mocked_bindings(gb_hlp_user_dir = function(...) test_root)

  test_cache_dir <- withr::local_tempdir("mocked_cache")
  # Mock a installed cache dir
  expect_message(
    gb_set_cache_dir(test_cache_dir, quiet = FALSE, install = TRUE),
    "cache directory is"
  )

  detected <- gb_hlp_detect_cache_dir()

  expect_identical(detected, test_cache_dir)

  config_file <- readLines(file.path(test_root, "GEOBOUNDS_CACHE_DIR"))

  expect_identical(config_file, test_cache_dir)
})
