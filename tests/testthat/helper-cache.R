local_test_cache <- function(pattern = "geobounds-test-cache-") {
  cache_dir <- withr::local_tempdir(pattern)
  withr::local_envvar(GEOBOUNDS_CACHE_DIR = cache_dir)
  cache_dir
}
