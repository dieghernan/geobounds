#' Set your \pkg{geobounds} cache dir
#'
#' @family cache utilities
#' @seealso [tools::R_user_dir()]
#'
#' @return
#' An (invisible) character with the path to your `cache_dir`.
#'
#' @description
#' This function will store your `cache_dir` path on your local machine and
#' would load it for future sessions. Type `gb_detect_cache_dir()` to find
#' your cached path.
#'
#' @param cache_dir A path to a cache directory. On missing value the function
#'   would store the cached files on a temporary dir (See [base::tempdir()]).
#' @param install Logical. If `TRUE`, will install the key in your local
#'   machine for use in future sessions.  Defaults to `FALSE.` If `cache_dir`
#'   is `FALSE` this parameter is set to `FALSE` automatically.
#' @param overwrite Logical. If this is set to `TRUE`, it will overwrite an
#'   existing `cache_dir`.
#'
#'
#' @details
#' By default, when no cache `cache_dir` is set the package uses a folder inside
#' [base::tempdir()] (so files are temporary and are removed when the **R**
#' session ends). To persist a cache across **R** sessions, use
#' `gb_set_cache(path, install = TRUE)` which writes the chosen path to a small
#' configuration file under `tools::R_user_dir("geobounds", "config")`.
#'
#' @section Caching strategies:
#'
#' - For occasional use, rely on the default [tempdir()]-based cache (no
#'   install).
#' - Modify the cache for a single session setting
#'   `gb_set_cache_dir(cache_dir = "a/path/here)`.
#' - For reproducible workflows, install a persistent cache with
#'   `gb_set_cache_dir(cache_dir = "a/path/here, install = TRUE)` that would be
#'   kept across **R** sessions.
#' - For caching specific files, use the `cache_dir` argument in the
#'   corresponding function. See [gb_get()].
#'
#' @inheritParams gb_get
#' @examples
#'
#' # Caution! This may modify your current state
#'
#' \dontrun{
#' my_cache <- gb_detect_cache_dir()
#'
#' # Set an example cache
#' ex <- file.path(tempdir(), "example", "cachenew")
#' gb_set_cache_dir(ex)
#'
#' gb_detect_cache_dir()
#'
#' # Restore initial cache
#' gb_set_cache_dir(my_cache)
#' identical(my_cache, gb_detect_cache_dir())
#' }
#'
#' gb_detect_cache_dir()
#' @export
gb_set_cache_dir <- function(
  cache_dir,
  overwrite = FALSE,
  install = FALSE,
  quiet = FALSE
) {
  verbose <- isFALSE(quiet)
  # Default if not provided
  if (missing(cache_dir) || cache_dir == "") {
    if (verbose) {
      cli::cli_alert_info(
        paste0(
          "Using a temporary cache directory. ",
          "Set {.arg cache_dir} to a value for store permanently"
        )
      )
    }
    # Create a folder on tempdir
    cache_dir <- file.path(tempdir(), "geobounds")
    is_temp <- TRUE
    install <- FALSE
  } else {
    is_temp <- FALSE
  }

  # Validate
  stopifnot(is.character(cache_dir), is.logical(overwrite), is.logical(install))

  # Expand
  cache_dir <- path.expand(cache_dir)

  # Create cache dir if it doesn't exists
  if (!dir.exists(cache_dir)) {
    dir.create(cache_dir, recursive = TRUE)
  }

  if (verbose) {
    cli::cli_alert_success(
      "{.pkg geobounds} cache dir is {.path {cache_dir}}."
    )
  }

  # Install path on environ var.
  # nocov start

  if (install) {
    config_dir <- tools::R_user_dir("geobounds", "config")
    # Create cache dir if not presente
    if (!dir.exists(config_dir)) {
      dir.create(config_dir, recursive = TRUE)
    }

    geobounds_file <- file.path(config_dir, "GEOBOUNDS_CACHE_DIR")

    if (!file.exists(geobounds_file) || overwrite == TRUE) {
      # Create file if it doesn't exist
      writeLines(cache_dir, con = geobounds_file)
    } else {
      cli::cli_abort(
        c(
          "A {.arg cache_dir}, path already exists. You can overwrite it with ",
          "the argument {.arg overwrite = TRUE}"
        )
      )
    }
    # nocov end
  } else {
    if (verbose && !is_temp) {
      cli::cli_alert_info(
        paste0(
          "To install your {.arg cache_dir} path for use in future sessions ",
          "run this function with {.arg install = TRUE}."
        )
      )
    }
  }

  Sys.setenv(GEOBOUNDS_CACHE_DIR = cache_dir)
  invisible(cache_dir)
}

#' Detect cache dir for \pkg{geobounds}
#'
#' @description
#'
#' Helper function to detect the current cache folder. See
#' [gb_set_cache_dir()].
#'
#'
#' @param x Ignored.
#'
#' @return
#' A character with the path to your `cache_dir`. The same path would appear
#' also as a clickable message, see [`cli::inline-markup`].
#'
#' @export
#'
#' @rdname gb_detect_cache_dir
#' @family cache utilities
#' @examples
#' gb_detect_cache_dir()
#'
gb_detect_cache_dir <- function(x = NULL) {
  # Cheat linters
  cd <- x
  cd <- gb_hlp_detect_cache_dir()
  cli::cli_alert_info("{.path {cd}}")
  cd
}

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
#' @rdname gb_clear_cache
#' @details
#' This is an overkill function that is intended to reset your status
#' as it you would never have installed and/or used \pkg{geobounds}.
#'
#' @examples
#'
#' # Caution! This may modify your current state
#'
#' \dontrun{
#' my_cache <- gb_detect_cache_dir()
#' # Set an example cache
#' ex <- file.path(tempdir(), "example", "cache")
#' gb_set_cache_dir(ex, quiet = TRUE)
#'
#' gb_clear_cache(quiet = FALSE)
#'
#' # Restore initial cache
#' gb_set_cache_dir(my_cache)
#' identical(my_cache, gb_detect_cache_dir())
#' }
#'
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

#' Internal (and silent) version of `gb_detect_cache_dir()`
#' @noRd
gb_hlp_detect_cache_dir <- function() {
  # Try from getenv
  getvar <- Sys.getenv("GEOBOUNDS_CACHE_DIR")

  if (is.null(getvar) || is.na(getvar) || getvar == "") {
    # Not set - tries to retrieve from cache
    cache_config <- file.path(
      tools::R_user_dir("geobounds", "config"),
      "GEOBOUNDS_CACHE_DIR"
    )

    # nocov start
    if (file.exists(cache_config)) {
      cached_path <- readLines(cache_config)

      # Case on empty cached path - would default
      if (any(is.null(cached_path), is.na(cached_path), cached_path == "")) {
        cache_dir <- gb_set_cache_dir(overwrite = TRUE, quiet = TRUE)
        return(cache_dir)
      }

      # 3. Return from cached path
      Sys.setenv(GEOBOUNDS_CACHE_DIR = cached_path)
      cached_path
      # nocov end
    } else {
      # 4. Default cache location

      cache_dir <- gb_set_cache_dir(overwrite = TRUE, quiet = TRUE)
      cache_dir
    }
  } else {
    getvar
  }
}


#' Creates `cache_dir`
#'
#'
#' @noRd
gb_hlp_cachedir <- function(cache_dir = NULL) {
  # Check cache dir from options if not set
  if (is.null(cache_dir)) {
    cache_dir <- gb_hlp_detect_cache_dir()
  }

  # Create cache dir if needed
  if (isFALSE(dir.exists(cache_dir))) {
    dir.create(cache_dir, recursive = TRUE)
  }
  cache_dir
}
