#' Set the \CRANpkg{geobounds} cache directory
#'
#' @description
#' Sets the active cache directory and optionally saves it for future sessions.
#' Use [gb_detect_cache_dir()] to find the active cache directory.
#'
#' @details
#' By default, when no `cache_dir` is set, the package uses a directory inside
#' [base::tempdir()]. Files in this directory are removed when the \R session
#' ends. To reuse a cache directory across \R sessions, use
#' `gb_set_cache_dir(cache_dir = "a/path/here", install = TRUE)`. This saves the
#' directory in a configuration file under
#' `tools::R_user_dir("geobounds", "config")`.
#'
#' @section Cache strategies:
#'
#' - For occasional use, use the default temporary cache directory.
#' - Set the cache directory for the current session with
#'   `gb_set_cache_dir(cache_dir = "a/path/here")`.
#' - Save a persistent cache directory for future \R sessions with
#'   `gb_set_cache_dir(cache_dir = "a/path/here", install = TRUE)`.
#' - Set the cache directory for an individual download with the `cache_dir`
#'   argument. See [gb_get()].
#'
#' @inheritParams gb_get
#' @param cache_dir A path to a cache directory. If missing, the function stores
#'   cache files in a temporary directory. See [base::tempdir()].
#' @param install Logical. If `TRUE`, save the cache directory for use in future
#'   sessions. Defaults to `FALSE`. If `cache_dir` is missing or empty, this
#'   parameter is set to `FALSE` automatically.
#' @param overwrite Logical. If `TRUE`, replace a cache directory already saved
#'   in the configuration file.
#'
#' @returns
#' An invisible character vector containing the path to the cache directory.
#'
#' @seealso [tools::R_user_dir()].
#'
#' @family cache
#'
#' @export
#' @encoding UTF-8
#'
#' @examples
#'
#' # Caution: this may modify your current state.
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
gb_set_cache_dir <- function(
  cache_dir,
  overwrite = FALSE,
  install = FALSE,
  quiet = FALSE
) {
  cli_abort_if_not(
    "{.arg quiet} must be a {.cls logical}." = is.logical(quiet),
    "{.arg overwrite} must be a {.cls logical}." = is.logical(overwrite),
    "{.arg install} must be a {.cls logical}." = is.logical(install)
  )

  verbose <- isFALSE(quiet)
  # Use a temporary cache directory when none is provided.
  if (missing(cache_dir) || !nzchar(cache_dir)) {
    if (verbose) {
      cli::cli_alert_info(paste0(
        "Using a temporary cache directory. ",
        "Set {.arg cache_dir} to choose where files are stored this session."
      ))
    }
    # Create a directory in `tempdir()`.
    cache_dir <- file.path(tempdir(), "geobounds")
    is_temp <- TRUE
    install <- FALSE
  } else {
    is_temp <- FALSE
  }

  # Validate `cache_dir` argument.
  cli_abort_if_not(
    "{.arg cache_dir} must be a {.cls character}." = is.character(cache_dir)
  )

  # Expand the cache directory path.
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

  # Save the cache directory in the user configuration.
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
        "A value for {.arg cache_dir} is already saved.",
        "Use {.code overwrite = TRUE} to replace it."
      ))
    }
    # nocov end
  } else {
    if (verbose && !is_temp) {
      cli::cli_alert_info(paste0(
        "To use this cache directory in future sessions, ",
        "run this function with {.code install = TRUE}."
      ))
    }
  }

  Sys.setenv(GEOBOUNDS_CACHE_DIR = cache_dir)
  invisible(cache_dir)
}

#' Detect the \CRANpkg{geobounds} cache directory
#'
#' @description
#' Detects the active cache directory. See [gb_set_cache_dir()].
#'
#' @rdname gb_detect_cache_dir
#'
#' @param x Ignored.
#'
#' @returns
#' A character vector containing the path to the active cache directory. It also
#' appears in a clickable message. See [cli::inline-markup].
#'
#' @family cache
#'
#' @export
#' @encoding UTF-8
#'
#' @examples
#' gb_detect_cache_dir()
gb_detect_cache_dir <- function(x = NULL) {
  # Keep the unused argument visible to linters.
  cd <- x
  cd <- gb_hlp_detect_cache_dir()
  cli::cli_alert_info("{.path {cd}}")
  cd
}

#' Clear the \CRANpkg{geobounds} cache directory
#'
#' @description
#' **Use this function with caution**. It clears cached data and configuration
#' by deleting the \CRANpkg{geobounds} configuration directory
#' (`tools::R_user_dir("geobounds", "config")`), deleting the active cache
#' directory and clearing `Sys.getenv("GEOBOUNDS_CACHE_DIR")`.
#'
#' @details
#' This reset restores the cache state of a fresh \CRANpkg{geobounds}
#' installation.
#'
#' @rdname gb_clear_cache
#'
#' @inheritParams gb_set_cache_dir
#' @param config Logical. If `TRUE`, delete the \CRANpkg{geobounds}
#'   configuration directory.
#' @param cached_data Logical. If `TRUE`, delete the active cache directory and
#'   all its contents.
#'
#' @returns
#' [invisible()]. This function is called for its side effects.
#'
#' @family cache
#'
#' @export
#' @encoding UTF-8
#'
#' @examples
#'
#' # Caution: this may modify your current state.
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
gb_clear_cache <- function(config = FALSE, cached_data = TRUE, quiet = TRUE) {
  verbose <- isFALSE(quiet)

  config_dir <- tools::R_user_dir("geobounds", "config")
  data_dir <- gb_hlp_detect_cache_dir()

  # nocov start
  if (config && dir.exists(config_dir)) {
    unlink(config_dir, recursive = TRUE, force = TRUE)

    if (verbose) {
      cli::cli_alert_warning(
        "Deleted the {.pkg geobounds} cache configuration."
      )
    }
  }
  # nocov end

  if (cached_data && dir.exists(data_dir)) {
    unlink(data_dir, recursive = TRUE, force = TRUE)
    if (verbose) {
      cli::cli_alert_warning(
        "Deleted the {.pkg geobounds} cache directory {.path {data_dir}}."
      )
    }
  }

  Sys.setenv(GEOBOUNDS_CACHE_DIR = "")

  # Reset the active cache directory.
  invisible()
}

#' Internal, silent version of `gb_detect_cache_dir()`
#'
#' @noRd
gb_hlp_detect_cache_dir <- function() {
  # Try the environment variable first.
  getvar <- Sys.getenv("GEOBOUNDS_CACHE_DIR")

  if (is.null(getvar) || is.na(getvar) || !nzchar(getvar)) {
    # Read the cache directory from the configuration file when available.
    cache_config <- file.path(
      tools::R_user_dir("geobounds", "config"),
      "GEOBOUNDS_CACHE_DIR"
    )

    # nocov start
    if (file.exists(cache_config)) {
      cached_path <- readLines(cache_config)

      # Fall back to the default cache when the config file is empty.
      if (any(is.null(cached_path), is.na(cached_path), !nzchar(cached_path))) {
        cache_dir <- gb_set_cache_dir(overwrite = TRUE, quiet = TRUE)
        return(cache_dir)
      }

      # Return the cached path.
      Sys.setenv(GEOBOUNDS_CACHE_DIR = cached_path)
      cached_path
      # nocov end
    } else {
      # Use the default cache directory.
      cache_dir <- gb_set_cache_dir(overwrite = TRUE, quiet = TRUE)
      cache_dir
    }
  } else {
    getvar
  }
}

#' Create the cache directory
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
