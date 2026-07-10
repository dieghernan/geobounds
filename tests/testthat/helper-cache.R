local_test_cache <- function(pattern = "geobounds-test-cache-") {
  cache_dir <- withr::local_tempdir(pattern)
  withr::local_envvar(GEOBOUNDS_CACHE_DIR = cache_dir)
  cache_dir
}

local_test_user_config_dir <- function(
  pattern = "geobounds-test-config-",
  tmpdir = tempdir()
) {
  local_envir <- parent.frame()
  config_dir <- withr::local_tempdir(
    pattern,
    tmpdir = tmpdir,
    .local_envir = local_envir
  )
  withr::local_envvar(
    GEOBOUNDS_CACHE_DIR = "",
    .local_envir = local_envir
  )
  testthat::local_mocked_bindings(
    gb_hlp_user_dir = function(...) {
      config_dir
    },
    .env = local_envir
  )
  config_dir
}
