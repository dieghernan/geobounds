#' Clear your \pkg{tidygeoboundaries} cache dir
#'
#' @family cache utilities
#'
#' @return Invisible. This function is called for its side effects.
#'
#' @description
#' **Use this function with caution**. This function would clear your cached
#' data and configuration, specifically:
#'
#' - Deletes the \pkg{tidygeoboundaries} config directory
#'   (`rappdirs::user_config_dir("tidygeobn", "R")`).
#' - Deletes the `cache_dir` directory.
#' - Deletes the values on stored on `Sys.getenv("GEOBN_CACHE_DIR")` and
#'   `options(mapSpain_cache_dir)`.
#'
#' @param config Logical. If `TRUE`, will delete the configuration folder of
#'   \pkg{tidygeoboundaries}.
#' @param cached_data Logical. If `TRUE`, it will delete your `cache_dir` and
#'   all its content.
#' @inheritParams geobn_set_cache_dir
#'
#' @details
#' This is an overkill function that is intended to reset your status
#' as it you would never have installed and/or used \pkg{tidygeoboundaries}.
#'
#' @examples
#'
#' # Don't run this! It would modify your current state
#' \dontrun{
#' geobn_clear_cache(verbose = TRUE)
#' }
#'
#' Sys.getenv("GEOBN_CACHE_DIR")
#' @export
geobn_clear_cache <- function(config = FALSE, cached_data = TRUE,
                              verbose = FALSE) {
  config_dir <- rappdirs::user_config_dir("tidygeobn", "R")
  data_dir <- geobn_hlp_detect_cache_dir()

  # nocov start
  if (config && dir.exists(config_dir)) {
    unlink(config_dir, recursive = TRUE, force = TRUE)

    if (verbose) {
      cli::cli_alert_warning("{.pkg tidygeoboundaries} cache config deleted")
    }
  }
  # nocov end

  if (cached_data && dir.exists(data_dir)) {
    unlink(data_dir, recursive = TRUE, force = TRUE)
    if (verbose) {
      cli::cli_alert_warning(
        "{.pkg tidygeoboundaries} data deleted: {.file {data_dir}}"
      )
    }
  }

  Sys.setenv(GEOBN_CACHE_DIR = "")

  # Reset cache dir
  return(invisible())
}
