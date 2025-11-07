#' Clear your \pkg{geobounds} cache dir
#'
#' @family cache utilities
#'
#' @return Invisible. This function is called for its side effects.
#'
#' @description
#' **Use this function with caution**. This function would clear your cached
#' data and configuration, specifically:
#'
#' - Deletes the \pkg{geobounds} config directory
#'   (`tools::R_user_dir("geobounds", "config")`).
#' - Deletes the `cache_dir` directory.
#' - Deletes the values on stored on `Sys.getenv("GEOBOUNDS_CACHE_DIR")`.
#'
#' @param config Logical. If `TRUE`, will delete the configuration folder of
#'   \pkg{geobounds}.
#' @param cached_data Logical. If `TRUE`, it will delete your `cache_dir` and
#'   all its content.
#' @inheritParams gb_set_cache_dir
#'
#' @details
#' This is an overkill function that is intended to reset your status
#' as it you would never have installed and/or used \pkg{geobounds}.
#'
#' @examples
#'
#' # Don't run this! It would modify your current state
#' \dontrun{
#' gb_clear_cache(quiet = FALSE)
#' }
#'
#' @export
gb_clear_cache <- function(
  config = FALSE,
  cached_data = TRUE,
  quiet = TRUE
) {
  verbose <- isFALSE(quiet)

  config_dir <- tools::R_user_dir("geobounds", "config")
  data_dir <- gb_hlp_detect_cache_dir()

  # nocov start
  if (config && dir.exists(config_dir)) {
    unlink(config_dir, recursive = TRUE, force = TRUE)

    if (verbose) {
      cli::cli_alert_warning("{.pkg geobounds} cache config deleted")
    }
  }
  # nocov end

  if (cached_data && dir.exists(data_dir)) {
    unlink(data_dir, recursive = TRUE, force = TRUE)
    if (verbose) {
      cli::cli_alert_warning(
        "{.pkg geobounds} data deleted: {.file {data_dir}}"
      )
    }
  }

  Sys.setenv(GEOBOUNDS_CACHE_DIR = "")

  # Reset cache dir
  invisible()
}
