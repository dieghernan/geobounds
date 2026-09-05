#' Set the \CRANpkg{geobounds} cache directory
#'
#' @description
#' Sets the active cache directory and optionally saves it for future sessions.
#' Use [gb_detect_cache_dir()] to find the active cache directory.
#'
#' @details
#' By default, when no `cache_dir` is set, \CRANpkg{geobounds} uses a directory
#' inside [base::tempdir()]. Cached archives in this directory are removed when
#' the \R session ends. To reuse a cache directory across \R sessions, use
#' `gb_set_cache_dir(cache_dir = "a/path/here", install = TRUE)`. This saves the
#' directory in the user configuration path returned by
#' [tools::R_user_dir()].
#'
#' @inheritParams gb_get
#' @param cache_dir A path to a cache directory. If `NULL`, the function stores
#'   cached archives in a temporary directory. See [base::tempdir()].
#' @param install A logical value. If `TRUE`, save the cache directory for use
#'   in future sessions. Defaults to `FALSE`. If `cache_dir` is `NULL`, this
#'   parameter is set to `FALSE` automatically.
#' @param overwrite A logical value. If `TRUE`, replace a cache directory
#'   already saved in the configuration file.
#'
#' @returns
#' An invisible character scalar containing the path to the cache directory.
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
#' @seealso
#' [gb_get()] and [gb_get_world()] use the configured cache directory for
#' downloaded boundary archives.
#' [tools::R_user_dir()] identifies standard locations for user-specific files.
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
#' # Set an example cache directory.
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
  cache_dir = NULL,
  overwrite = FALSE,
  install = FALSE,
  quiet = FALSE
) {
  gb_abort_if_not(
    "{.arg quiet} must be TRUE or FALSE." = isTRUE(quiet) ||
      isFALSE(quiet),
    "{.arg overwrite} must be TRUE or FALSE." = isTRUE(
      overwrite
    ) ||
      isFALSE(overwrite),
    "{.arg install} must be TRUE or FALSE." = isTRUE(install) ||
      isFALSE(install)
  )

  verbose <- isFALSE(quiet)
  # Use a temporary cache directory when none is provided.
  if (is.null(cache_dir)) {
    if (verbose) {
      cli::cli_alert_info(paste0(
        "Using a temporary cache directory. ",
        "Set {.arg cache_dir} to choose where boundaries are stored."
      ))
    }
    # Create the temporary cache directory.
    cache_dir <- file.path(tempdir(), "geobounds")
    is_temp <- TRUE
    install <- FALSE
  } else {
    is_temp <- FALSE
  }

  # Validate the `cache_dir` argument.
  valid_cache_dir <- is.character(cache_dir) &&
    length(cache_dir) == 1L &&
    !is.na(cache_dir) &&
    nzchar(cache_dir)
  gb_abort_if_not(
    "{.arg cache_dir} must be a non-empty string, not NA." = valid_cache_dir
  )

  # Expand the cache directory path.
  cache_dir <- path.expand(cache_dir)

  # Create the cache directory if it does not exist.
  gb_hlp_create_dir(cache_dir)

  if (verbose) {
    cli::cli_alert_success(
      "{.pkg geobounds} cache directory is {.path {cache_dir}}."
    )
  }

  # Save the cache directory in the user configuration.
  if (install) {
    config_dir <- gb_hlp_user_dir("geobounds", "config")
    # Create the configuration directory if needed.
    gb_hlp_create_dir(config_dir, arg = "configuration directory")

    geobounds_file <- file.path(config_dir, "GEOBOUNDS_CACHE_DIR")

    if (!file.exists(geobounds_file) || overwrite) {
      # Write the cache directory to the configuration file.
      writeLines(cache_dir, con = geobounds_file)
    } else {
      cli::cli_abort(c(
        "A cache directory is already saved in the configuration file.",
        "i" = "Set {.arg overwrite} to {.code TRUE} to replace it."
      ))
    }
  } else {
    if (verbose && !is_temp) {
      cli::cli_alert_info(paste0(
        "To use this cache directory in future sessions, ",
        "call {.fn gb_set_cache_dir} with {.code install = TRUE}."
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
#' @param x An object. Ignored.
#'
#' @returns
#' A character scalar containing the path to the active cache directory. The
#' path is also printed as a clickable message. See [cli::inline-markup] from
#' \CRANpkg{cli}.
#'
#' @family cache
#'
#' @rdname gb_detect_cache_dir
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
#' **Use this function with caution**. It clears cached archives and
#' configuration by deleting the \CRANpkg{geobounds} configuration directory
#' returned by [tools::R_user_dir()], deleting the active cache directory and
#' clearing the `GEOBOUNDS_CACHE_DIR` environment variable. See
#' [base::Sys.getenv()].
#'
#' @details
#' This reset restores the cache state of a fresh \CRANpkg{geobounds}
#' installation. For safety, the function refuses to recursively delete a cache
#' path that contains the home, working, temporary or package configuration
#' directory. Use a dedicated cache subdirectory.
#' Inspect the active directory with [gb_detect_cache_dir()] before clearing
#' it. Use [gb_set_cache_dir()] to configure a cache directory again.
#'
#' @inheritParams gb_get quiet
#' @param config A logical value. If `TRUE`, delete the \CRANpkg{geobounds}
#'   configuration directory.
#' @param cached_data A logical value. If `TRUE`, delete the active cache
#'   directory and all its contents.
#'
#' @returns
#' Invisibly returns `NULL`. This function is called for its side effects.
#'
#' @family cache
#'
#' @rdname gb_clear_cache
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
#' # Set an example cache directory.
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
  gb_abort_if_not(
    "{.arg config} must be TRUE or FALSE." = isTRUE(config) ||
      isFALSE(config),
    "{.arg cached_data} must be TRUE or FALSE." = isTRUE(
      cached_data
    ) ||
      isFALSE(cached_data),
    "{.arg quiet} must be TRUE or FALSE." = isTRUE(quiet) ||
      isFALSE(quiet)
  )

  verbose <- isFALSE(quiet)

  config_dir <- gb_hlp_user_dir("geobounds", "config")
  data_dir <- gb_hlp_detect_cache_dir()

  if (config && dir.exists(config_dir)) {
    gb_hlp_delete_dir(config_dir, arg = "cache configuration")

    if (verbose) {
      cli::cli_alert_success(
        "Deleted the {.pkg geobounds} cache configuration."
      )
    }
  }

  if (cached_data && dir.exists(data_dir)) {
    data_dir <- gb_hlp_assert_safe_cache_dir(data_dir)
    gb_hlp_delete_dir(data_dir, arg = "cache directory")
    if (verbose) {
      cli::cli_alert_success(
        "Deleted the {.pkg geobounds} cache directory {.path {data_dir}}."
      )
    }
  }

  Sys.setenv(GEOBOUNDS_CACHE_DIR = "")

  # Reset the cache directory environment variable.
  invisible()
}

#' Detect the cache directory without messages
#'
#' @returns
#' A character scalar containing the active cache directory.
#'
#' @noRd
gb_hlp_detect_cache_dir <- function() {
  # Try the environment variable first.
  getvar <- Sys.getenv("GEOBOUNDS_CACHE_DIR")

  if (is.null(getvar) || is.na(getvar) || !nzchar(getvar)) {
    # Read the cache directory from the configuration file when available.
    cache_config <- file.path(
      gb_hlp_user_dir("geobounds", "config"),
      "GEOBOUNDS_CACHE_DIR"
    )

    if (file.exists(cache_config)) {
      cached_path <- readLines(cache_config, warn = FALSE)

      # Fall back when the configuration does not contain one usable path.
      if (
        length(cached_path) != 1L ||
          anyNA(cached_path) ||
          !nzchar(cached_path)
      ) {
        cache_dir <- gb_set_cache_dir(overwrite = TRUE, quiet = TRUE)
        return(cache_dir)
      }

      # Return the cached path.
      Sys.setenv(GEOBOUNDS_CACHE_DIR = cached_path)
      cached_path
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
#' @param cache_dir A path to a cache directory. If `NULL`, detect the active
#'   cache directory.
#'
#' @returns
#' A character scalar containing the cache directory.
#'
#' @noRd
gb_hlp_cachedir <- function(cache_dir = NULL) {
  # Detect the cache directory when none is provided.
  if (is.null(cache_dir)) {
    cache_dir <- gb_hlp_detect_cache_dir()
  }

  # Create the cache directory if needed.
  gb_hlp_create_dir(cache_dir)
  cache_dir
}

#' Create a directory or abort
#'
#' @param path A directory path.
#' @param arg A label for the path in an error message.
#' @param call The call to display in the error message.
#'
#' @returns
#' `path`, invisibly.
#'
#' @noRd
gb_hlp_create_dir <- function(
  path,
  arg = "cache directory",
  call = parent.frame()
) {
  if (dir.exists(path)) {
    return(invisible(path))
  }

  created <- dir.create(path, recursive = TRUE, showWarnings = FALSE)
  if (!isTRUE(created) || !dir.exists(path)) {
    cli::cli_abort(
      "Cannot create the {arg} at {.path {path}}.",
      call = call
    )
  }

  invisible(path)
}

#' Reject cache directories that contain protected locations
#'
#' @param path An existing cache directory path.
#' @param call The call to display in the error message.
#'
#' @returns
#' The normalized cache directory path.
#'
#' @noRd
gb_hlp_assert_safe_cache_dir <- function(path, call = parent.frame()) {
  path <- normalizePath(path, winslash = "/", mustWork = TRUE)
  protected <- c(
    path.expand("~"),
    getwd(),
    tempdir(),
    gb_hlp_user_dir("geobounds", "config")
  )
  protected <- normalizePath(protected, winslash = "/", mustWork = FALSE)

  path_cmp <- gb_hlp_path_comparison(path)
  protected_cmp <- gb_hlp_path_comparison(protected)

  contains_protected <- vapply(
    protected_cmp,
    \(protected_path) {
      identical(path_cmp, protected_path) ||
        startsWith(protected_path, paste0(path_cmp, "/"))
    },
    logical(1)
  )

  if (any(contains_protected)) {
    cli::cli_abort(
      c(
        "Refusing to recursively delete unsafe cache directory {.path {path}}.",
        "i" = "Choose a dedicated cache subdirectory."
      ),
      call = call
    )
  }

  path
}

#' Normalize paths for platform-specific comparison
#'
#' @param path A character vector of normalized paths.
#' @param os_type An operating system type from [base::.Platform].
#'
#' @returns
#' `path`, converted to lowercase on Windows.
#'
#' @noRd
gb_hlp_path_comparison <- function(path, os_type = .Platform$OS.type) {
  if (identical(os_type, "windows")) {
    return(tolower(path))
  }

  path
}

#' Recursively delete a directory or abort
#'
#' @param path An existing directory path.
#' @param arg A label for the directory in an error message.
#' @param call The call to display in the error message.
#'
#' @returns
#' `NULL`, invisibly.
#'
#' @noRd
gb_hlp_delete_dir <- function(path, arg, call = parent.frame()) {
  status <- gb_hlp_unlink(path, recursive = TRUE, force = TRUE)
  if (!identical(status, 0L) || dir.exists(path)) {
    cli::cli_abort(
      "Cannot delete the {arg} at {.path {path}}.",
      call = call
    )
  }

  invisible(NULL)
}

#' Remove files or directories
#'
#' @param path A path to remove.
#' @param recursive A logical value passed to [base::unlink()].
#' @param force A logical value passed to [base::unlink()].
#'
#' @returns
#' The status code returned by [base::unlink()].
#'
#' @noRd
gb_hlp_unlink <- function(path, recursive, force) {
  unlink(path, recursive = recursive, force = force)
}

#' Find the user-specific package directory
#'
#' @param package The package name.
#' @param which The type of user-specific directory to find.
#'
#' @returns
#' A character scalar containing the user-specific directory.
#'
#' @noRd
gb_hlp_user_dir <- function(package, which) {
  tools::R_user_dir(package, which)
}
