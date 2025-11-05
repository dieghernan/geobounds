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
#' would load it for future sessions. Type
#' `Sys.getenv("GEOBN_CACHE_DIR")` to find your cached path.
#'
#' Alternatively, you can store the `cache_dir` manually with the following
#' options:
#'  - Run `Sys.setenv(GEOBN_CACHE_DIR = "cache_dir")`. You would need to
#'    run this command on each session (Similar to `install = FALSE`).
#'  - Write this line on your .Renviron file:
#'    `GEOBN_CACHE_DIR = "value_for_cache_dir"` (same behavior than
#'    `install = TRUE`). This would store your `cache_dir` permanently.
#'
#' @param cache_dir A path to a cache directory. On missing value the function
#'   would store the cached files on a temporary dir (See [base::tempdir()]).
#' @param install Logical. If `TRUE`, will install the key in your local
#'   machine for use in future sessions.  Defaults to `FALSE.` If `cache_dir`
#'   is `FALSE` this parameter is set to `FALSE` automatically.
#' @param overwrite Logical. If this is set to `TRUE`, it will overwrite an
#'   existing `GEOBN_CACHE_DIR` that you already have in local machine.
#' @param verbose Logical, displays information. Useful for debugging, default
#'   is `FALSE`.
#' @examples
#'
#' # Don't run this! It would modify your current state
#' \dontrun{
#' geobn_set_cache_dir(verbose = TRUE)
#' }
#'
#' Sys.getenv("GEOBN_CACHE_DIR")
#' @export
geobn_set_cache_dir <- function(
  cache_dir,
  overwrite = FALSE,
  install = FALSE,
  verbose = TRUE
) {
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
    cli::cli_alert_info(
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

    geobounds_file <- file.path(config_dir, "GEOBN_CACHE_DIR")

    if (!file.exists(geobounds_file) || overwrite == TRUE) {
      # Create file if it doesn't exist
      writeLines(cache_dir, con = geobounds_file)
    } else {
      cli::cli_abort(
        paste0(
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

  Sys.setenv(GEOBN_CACHE_DIR = cache_dir)
  invisible(cache_dir)
}

#' Detect cache dir for \pkg{geobounds}
#'
#' @noRd
geobn_hlp_detect_cache_dir <- function() {
  # Try from getenv
  getvar <- Sys.getenv("GEOBN_CACHE_DIR")

  if (is.null(getvar) || is.na(getvar) || getvar == "") {
    # Not set - tries to retrieve from cache
    cache_config <- file.path(
      tools::R_user_dir("geobounds", "config"),
      "GEOBN_CACHE_DIR"
    )

    # nocov start
    if (file.exists(cache_config)) {
      cached_path <- readLines(cache_config)

      # Case on empty cached path - would default
      if (any(is.null(cached_path), is.na(cached_path), cached_path == "")) {
        cache_dir <- geobn_set_cache_dir(overwrite = TRUE, verbose = FALSE)
        return(cache_dir)
      }

      # 3. Return from cached path
      Sys.setenv(GEOBN_CACHE_DIR = cached_path)
      cached_path
      # nocov end
    } else {
      # 4. Default cache location

      cache_dir <- geobn_set_cache_dir(overwrite = TRUE, verbose = FALSE)
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
geobn_hlp_cachedir <- function(cache_dir = NULL) {
  # Check cache dir from options if not set
  if (is.null(cache_dir)) {
    cache_dir <- geobn_hlp_detect_cache_dir()
  }

  # Create cache dir if needed
  if (isFALSE(dir.exists(cache_dir))) {
    dir.create(cache_dir, recursive = TRUE)
  }
  cache_dir
}

#' Detect cache dir for \pkg{geobounds}
#'
#' @description
#'
#' Helper function to detect the current cache folder. See
#' [geobn_set_cache_dir()].
#'
#'
#' @param x Ignored.
#'
#' @return A character with the path to your `cache_dir`.
#'
#' @export
#'
#' @rdname geobn_detect_cache_dir
#' @family cache utilities
#' @examples
#' geobn_detect_cache_dir()
#'
geobn_detect_cache_dir <- function(x = NULL) {
  # Cheat linters
  cd <- x
  cd <- geobn_hlp_detect_cache_dir()
  cd
}
