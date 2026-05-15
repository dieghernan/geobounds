#' Set your \pkg{geobounds} cache directory
#'
#' @family cache utilities
#' @seealso [tools::R_user_dir()]
#' @encoding UTF-8
#'
#' @return
#' An ([invisible()]) character with the path to your `cache_dir`.
#'
#' @description
#' This function stores your `cache_dir` path on your local machine and
#' loads it for future sessions. Type `gb_detect_cache_dir()` to find your
#' cache directory path.
#'
#' @param cache_dir A path to a cache directory. If missing, the function
#'   will store the cache files in a temporary directory (see
#'   [base::tempdir()]).
#' @param install Logical. If `TRUE`, install the key on your local machine
#'   for use in future sessions. Defaults to `FALSE`. If `cache_dir`
#'   is `FALSE` this parameter is set to `FALSE` automatically.
#' @param overwrite Logical. If `TRUE`, overwrite an existing `cache_dir`.
#'
#' @details
#' By default, when no `cache_dir` is set the package uses a folder inside
#' [base::tempdir()] (so files are temporary and are removed when the **R**
#' session ends). To persist a cache across **R** sessions, use
#' `gb_set_cache_dir(path, install = TRUE)`, which writes the chosen path to a
#' small configuration file under `tools::R_user_dir("geobounds", "config")`.
#'
#' @section Caching strategies:
#'
#' - For occasional use, rely on the default [tempdir()]-based cache (no
#'   install).
#' - Modify the cache for a single session with
#'   `gb_set_cache_dir(cache_dir = "a/path/here")`.
#' - For reproducible workflows, install a persistent cache with
#'   `gb_set_cache_dir(cache_dir = "a/path/here", install = TRUE)` that will be
#'   kept across **R** sessions.
#' - For caching specific files, use the `cache_dir` argument in the
#'   corresponding function. See [gb_get()].
#'
#' @inheritParams gb_get
#' @examples
#'
#' # Caution! This may modify your current state.
#'
#' \dontrun{
#' my_cache <- gb_detect_cache_dir()
#'
#' # Set an example cache.
#' ex <- file.path(tempdir(), "example", "cachenew")
#' gb_set_cache_dir(ex)
#'
#' gb_detect_cache_dir()
#'
#' # Restore the initial cache.
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
  # Use a temporary cache directory when no path is provided.
  if (missing(cache_dir) || cache_dir == "") {
    if (verbose) {
      cli::cli_alert_info(paste0(
        "Using a temporary cache directory. ",
        "Set {.arg cache_dir} to a value to store permanently."
      ))
    }
    # Create a folder in `tempdir()`.
    cache_dir <- file.path(tempdir(), "geobounds")
    is_temp <- TRUE
    install <- FALSE
  } else {
    is_temp <- FALSE
  }

  # Validate inputs.
  stopifnot(is.character(cache_dir), is.logical(overwrite), is.logical(install))

  # Expand the cache path.
  cache_dir <- path.expand(cache_dir)

  # Create the cache directory if it does not exist.
  if (!dir.exists(cache_dir)) {
    dir.create(cache_dir, recursive = TRUE)
  }

  if (verbose) {
    cli::cli_alert_success(
      "{.pkg geobounds} cache directory is {.path {cache_dir}}."
    )
  }

  # Install the path in the user configuration.
  # nocov start

  if (install) {
    config_dir <- tools::R_user_dir("geobounds", "config")
    # Create the config directory if needed.
    if (!dir.exists(config_dir)) {
      dir.create(config_dir, recursive = TRUE)
    }

    geobounds_file <- file.path(config_dir, "GEOBOUNDS_CACHE_DIR")

    if (!file.exists(geobounds_file) || overwrite) {
      # Create the config file if it does not exist.
      writeLines(cache_dir, con = geobounds_file)
    } else {
      cli::cli_abort(c(
        "A {.arg cache_dir} path already exists.",
        "Use {.arg overwrite = TRUE} to replace it."
      ))
    }
    # nocov end
  } else {
    if (verbose && !is_temp) {
      cli::cli_alert_info(paste0(
        "To install your {.arg cache_dir} path for use in future sessions ",
        "run this function with {.arg install = TRUE}."
      ))
    }
  }

  Sys.setenv(GEOBOUNDS_CACHE_DIR = cache_dir)
  invisible(cache_dir)
}

#' Detect cache directory for \pkg{geobounds}
#'
#' @description
#' Helper function to detect the current cache folder. See
#' [gb_set_cache_dir()].
#'
#' @param x Ignored.
#'
#' @return
#' A character with the path to your `cache_dir`. The same path will also
#' appear as a clickable message, see [`cli::inline-markup`].
#'
#' @export
#' @encoding UTF-8
#'
#' @rdname gb_detect_cache_dir
#' @family cache utilities
#' @examples
#' gb_detect_cache_dir()
#'
gb_detect_cache_dir <- function(x = NULL) {
  # Keep the unused argument visible to linters.
  cd <- x
  cd <- gb_hlp_detect_cache_dir()
  cli::cli_alert_info("{.path {cd}}")
  cd
}

#' Clear your \pkg{geobounds} cache directory
#'
#' @family cache utilities
#'
#' @return [invisible()] This function is called for its side effects.
#' @encoding UTF-8
#'
#' @description
#' **Use this function with caution**. This function will clear your cached
#' data and configuration, specifically:
#'
#' - Deletes the \pkg{geobounds} config directory
#'   (`tools::R_user_dir("geobounds", "config")`).
#' - Deletes the `cache_dir` directory.
#' - Deletes the values stored in `Sys.getenv("GEOBOUNDS_CACHE_DIR")`.
#'
#' @param config Logical. If `TRUE`, delete the configuration folder of
#'   \pkg{geobounds}.
#' @param cached_data Logical. If `TRUE`, delete your `cache_dir` and all its
#'   contents.
#' @inheritParams gb_set_cache_dir
#' @rdname gb_clear_cache
#' @details
#' This is a comprehensive reset function intended to reset your status as if
#' you had never installed or used \pkg{geobounds}.
#'
#' @examples
#'
#' # Caution! This may modify your current state.
#'
#' \dontrun{
#' my_cache <- gb_detect_cache_dir()
#' # Set an example cache.
#' ex <- file.path(tempdir(), "example", "cache")
#' gb_set_cache_dir(ex, quiet = TRUE)
#'
#' gb_clear_cache(quiet = FALSE)
#'
#' # Restore the initial cache.
#' gb_set_cache_dir(my_cache)
#' identical(my_cache, gb_detect_cache_dir())
#' }
#'
#' @export
gb_clear_cache <- function(config = FALSE, cached_data = TRUE, quiet = TRUE) {
  verbose <- isFALSE(quiet)

  config_dir <- tools::R_user_dir("geobounds", "config")
  data_dir <- gb_hlp_detect_cache_dir()

  # nocov start
  if (config && dir.exists(config_dir)) {
    unlink(config_dir, recursive = TRUE, force = TRUE)

    if (verbose) {
      cli::cli_alert_warning("{.pkg geobounds} cache config deleted.")
    }
  }
  # nocov end

  if (cached_data && dir.exists(data_dir)) {
    unlink(data_dir, recursive = TRUE, force = TRUE)
    if (verbose) {
      cli::cli_alert_warning(
        "{.pkg geobounds} data deleted: {.file {data_dir}}."
      )
    }
  }

  Sys.setenv(GEOBOUNDS_CACHE_DIR = "")

  # Reset the active cache directory.
  invisible()
}

#' Internal (and silent) version of `gb_detect_cache_dir()`
#' @noRd
gb_hlp_detect_cache_dir <- function() {
  # Try the environment variable first.
  getvar <- Sys.getenv("GEOBOUNDS_CACHE_DIR")

  if (is.null(getvar) || is.na(getvar) || getvar == "") {
    # Retrieve the cache directory from the config file when available.
    cache_config <- file.path(
      tools::R_user_dir("geobounds", "config"),
      "GEOBOUNDS_CACHE_DIR"
    )

    # nocov start
    if (file.exists(cache_config)) {
      cached_path <- readLines(cache_config)

      # Fall back to the default cache when the config file is empty.
      if (any(is.null(cached_path), is.na(cached_path), cached_path == "")) {
        cache_dir <- gb_set_cache_dir(overwrite = TRUE, quiet = TRUE)
        return(cache_dir)
      }

      # Return the cached path.
      Sys.setenv(GEOBOUNDS_CACHE_DIR = cached_path)
      cached_path
      # nocov end
    } else {
      # Use the default cache location.

      cache_dir <- gb_set_cache_dir(overwrite = TRUE, quiet = TRUE)
      cache_dir
    }
  } else {
    getvar
  }
}


#' Create `cache_dir`
#'
#' @noRd
gb_hlp_cachedir <- function(cache_dir = NULL) {
  # Detect the cache directory when none is provided.
  if (is.null(cache_dir)) {
    cache_dir <- gb_hlp_detect_cache_dir()
  }

  # Create the cache directory if needed.
  if (isFALSE(dir.exists(cache_dir))) {
    dir.create(cache_dir, recursive = TRUE)
  }
  cache_dir
}
