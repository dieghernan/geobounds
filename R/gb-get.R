#' Download individual country boundaries from **geoBoundaries**
#'
#' @description
#' Returns individual country boundaries that reflect how countries represent
#' their own boundaries, without special identification of disputed areas.
#'
#' Use [gb_get_world()] for global composite boundaries that standardize
#' disputed areas and fill gaps between borders.
#'
#' Always acknowledge **geoBoundaries** and follow the boundary's license.
#' See `vignette("metadata", package = "geobounds")` for sources and licensing.
#'
#' The wrappers [gb_get_adm0()], [gb_get_adm1()], [gb_get_adm2()],
#' [gb_get_adm3()], [gb_get_adm4()] and [gb_get_adm5()] are also available for
#' requesting a single ADM level.
#'
#' @details
#' These are terrestrial boundaries, not maritime boundaries. For product
#' selection and mapping workflows, see
#' `vignette("geobounds", package = "geobounds")`.
#'
#' This function uses current API metadata and reuses cached archives without
#' checking for upstream changes. Historical versions cannot be selected. See
#' `vignette("metadata", package = "geobounds")` for cache limitations
#' and provenance.
#'
#' @param country A character vector of country names or ISO 3166-1 alpha-3
#'   country codes. Use `"all"` to return boundaries for all countries. See
#'   also [countrycode::countrycode()] from \CRANpkg{countrycode}.
#' @param adm_lvl ADM level. Accepted values are `"all"` (all available
#'   boundaries) or the ADM level (`"adm0"` is the country boundary,
#'   `"adm1"` is the first level of subnational boundaries, `"adm2"` is the
#'   second level and so on). Uppercase versions (`"ADM1"`) and level numbers
#'   (`0`, `1`, `2`, `3`, `4`, `5`) are also accepted, including numbers
#'   supplied as text (for example, `"1"`).
#' @param simplified A logical value. If `TRUE`, read simplified boundaries
#'   that are faster to render. Both options download the complete ZIP archive.
#' @param release_type A character string, one of `"gbOpen"` (the default),
#'   `"gbHumanitarian"` or `"gbAuthoritative"`. Selects a product, not a dataset
#'   version. `"gbAuthoritative"` is restricted to non-commercial use. See
#'   `vignette("metadata", package = "geobounds")` for product sources
#'   and licenses.
#' @param quiet A logical value. If `TRUE`, suppress informational messages.
#' @param overwrite A logical value. If `TRUE`, force a fresh download of the
#'   source `.zip` archive.
#' @param cache_dir A path to a cache directory. If `NULL`, use the configured
#'   directory, or a temporary directory when none is configured. See
#'   [gb_set_cache_dir()].
#'
#' @returns
#' An [sf][sf::st_sf] object from \CRANpkg{sf} containing the requested
#' boundaries. Returns [`NULL`][base::NULL] if no boundaries match the request
#' or the downloads return no geometries.
#'
#' @source
#' [**geoBoundaries** API](https://www.geoboundaries.org/api.html).
#'
#' @inherit geobounds-package references
#'
#' @seealso
#' [gb_get_metadata()] inspects boundary metadata and licensing.
#' [gb_get_max_adm_lvl()] checks the ADM levels available for individual
#' country boundaries.
#' [gb_set_cache_dir()] configures where downloaded archives are cached.
#'
#' @family api
#'
#' @export
#' @encoding UTF-8
#'
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") || interactive()
#' \donttest{
#' # Map ADM2 in Sri Lanka.
#' sri_lanka <- gb_get(
#'   "Sri Lanka",
#'   adm_lvl = 2,
#'   simplified = TRUE
#' )
#'
#' sri_lanka
#'
#' library(ggplot2)
#' ggplot(sri_lanka) +
#'   geom_sf() +
#'   labs(
#'     caption = paste(
#'       "Sources: geoBoundaries, OpenStreetMap and Wambacher,",
#'       "license: ODbL 1.0"
#'     )
#'   )
#' }
#'
gb_get <- function(
  country,
  adm_lvl = "adm0",
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  # Prepare input parameters.
  source <- match_arg_pretty(release_type)
  adm_lvl <- assert_adm_lvl(adm_lvl)
  valid_cache_dir <- is.null(cache_dir)
  if (!valid_cache_dir) {
    valid_cache_dir <- is.character(cache_dir) &&
      length(cache_dir) == 1L &&
      !is.na(cache_dir) &&
      nzchar(cache_dir)
  }
  valid_simplified <- isTRUE(simplified) || isFALSE(simplified)
  valid_overwrite <- isTRUE(overwrite) || isFALSE(overwrite)
  valid_quiet <- isTRUE(quiet) || isFALSE(quiet)

  gb_abort_if_not(
    "{.arg simplified} must be TRUE or FALSE." = valid_simplified,
    "{.arg overwrite} must be TRUE or FALSE." = valid_overwrite,
    "{.arg quiet} must be TRUE or FALSE." = valid_quiet,
    "{.arg cache_dir} must be NULL or nonempty text, not NA." = valid_cache_dir
  )

  country <- gbnds_dev_country2iso(country)
  gb_hlp_license_notice(source)

  meta_df <- gb_get_metadata(
    country = country,
    adm_lvl = adm_lvl,
    release_type = release_type
  )

  if (nrow(meta_df) == 0) {
    cli::cli_alert_warning(
      "No matching boundaries found. Returning {.code NULL}."
    )
    return(NULL)
  }

  url_bound <- gb_hlp_unique_values(meta_df$staticDownloadLink)

  # Download and combine boundaries.
  res_sf <- lapply(url_bound, function(x) {
    gbnds_dev_shp_query(
      url = x,
      subdir = source,
      quiet = quiet,
      overwrite = overwrite,
      cache_dir = cache_dir,
      simplified = simplified
    )
  })

  meta_sf <- dplyr::bind_rows(res_sf)
  if (nrow(meta_sf) == 0L) {
    return(NULL)
  }

  meta_sf
}

#' Show the UN SALB license notice
#'
#' @param source The selected **geoBoundaries** release type.
#'
#' @inherit gb_clear_cache return
#'
#' @noRd
gb_hlp_license_notice <- function(source) {
  if (!identical(source, "gbAuthoritative")) {
    return(invisible())
  }

  # nolint start
  terms <- paste0(
    "https://salb.un.org/sites/default/files/wysiwyg_uploads/",
    "docs_uploads/TermsOfUseSALB2021.pdf"
  )
  # nolint end

  cli::cli_bullets(c(
    "!" = "{.strong UN SALB} boundaries are restricted to non-commercial use.",
    "i" = "Review the terms at {.url {terms}} before reusing the boundaries."
  ))
}

#' Download and read one boundary archive
#'
#' @param url A boundary archive URL.
#' @param subdir The cache subdirectory for the archive.
#' @inheritParams gb_get quiet overwrite
#' @param cache_dir A path to a cache directory.
#' @param cgaz_country A character vector of country codes to keep for CGAZ
#'   boundaries.
#' @param simplified A logical value. If `TRUE`, read simplified boundaries.
#'
#' @returns
#' An [sf][sf::st_sf] object from \CRANpkg{sf} or [`NULL`][base::NULL] when the
#' archive download fails.
#'
#' @noRd
gbnds_dev_shp_query <- function(
  url,
  subdir,
  quiet,
  overwrite,
  cache_dir,
  cgaz_country = "ALL",
  simplified = FALSE
) {
  filename <- basename(url)
  # Prepare the cache directory.
  path <- gb_hlp_cachedir(cache_dir)
  path <- gb_hlp_cachedir(file.path(path, subdir))

  # Create the destination path.
  file_local <- file.path(path, filename)
  file_local <- gsub("//", "/", file_local, fixed = TRUE)

  fileoncache <- file.exists(file_local)

  # Reuse cached files when available.
  if (isFALSE(overwrite) && fileoncache) {
    if (!quiet) {
      cli::cli_alert_success("Using cached file {.file {file_local}}.")
    }
  } else {
    # Download the source archive.
    if (!quiet) {
      cli::cli_alert_info("Downloading source archive from {.url {url}}.")
      cli::cli_alert_info("Cache directory is {.path {path}}.")
    }

    q <- gb_hlp_request(url, quiet = quiet)
    get <- httr2::req_perform(q, path = file_local) # nolint

    # Report download errors and return `NULL`.
    if (httr2::resp_is_error(get)) {
      unlink(file_local, force = TRUE)
      gb_hlp_alert_http_error(url, get)

      return(NULL)
    }
  }

  # Select the requested shapefile from the archive.
  shp_zip <- gb_hlp_list_archive(file_local)
  shp_end <- gb_hlp_select_shapefile(shp_zip$Name, simplified = simplified)

  # Read through GDAL's `/vsizip/` virtual file system.
  shp_read <- file.path("/vsizip/", file_local, shp_end)
  shp_read <- gsub("//", "/", shp_read, fixed = TRUE)
  outsf <- sf::read_sf(shp_read)

  if (subdir == "CGAZ" && !("ALL" %in% cgaz_country)) {
    outsf <- outsf[outsf$shapeGroup %in% cgaz_country, ]
  }
  gbnds_dev_sf_helper(outsf)
}

#' List a boundary archive or remove it when invalid
#'
#' @param path A path to a ZIP archive.
#' @param call The call to display in the error message.
#'
#' @returns
#' A [data frame][base::data.frame] describing the files in the archive.
#'
#' @noRd
gb_hlp_list_archive <- function(path, call = parent.frame()) {
  invalid_archive <- function(cnd = NULL) {
    status <- gb_hlp_unlink(path, recursive = FALSE, force = TRUE)
    if (!identical(status, 0L) || file.exists(path)) {
      cli::cli_abort(
        c(
          "Invalid boundary archive {.file {path}} could not be removed.",
          "i" = "Delete the file manually before retrying the request."
        ),
        call = call,
        parent = cnd
      )
    }

    cli::cli_abort(
      c(
        "Boundary archive {.file {path}} is invalid and was removed.",
        "i" = "Retry the request to download a fresh copy."
      ),
      call = call,
      parent = cnd
    )
  }

  archive <- tryCatch(
    gb_hlp_unzip_list(path),
    error = invalid_archive,
    warning = invalid_archive
  )

  if (!is.data.frame(archive) || !("Name" %in% names(archive))) {
    invalid_archive()
  }

  archive
}

#' List files in a ZIP archive
#'
#' @param path A path to a ZIP archive.
#'
#' @returns
#' A [data frame][base::data.frame] describing the files in the archive.
#'
#' @noRd
gb_hlp_unzip_list <- function(path) {
  unzip(path, list = TRUE)
}
