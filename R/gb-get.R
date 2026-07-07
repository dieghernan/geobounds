#' Download individual country boundaries from **geoBoundaries**
#'
#' @description
#' Returns individual country boundaries that reflect how countries represent
#' their own boundaries, without special identification of disputed areas.
#'
#' Use [gb_get_world()] for global composite boundaries that standardize
#' disputed areas and fill gaps between borders.
#'
#' Boundaries downloaded through this function are not covered by the package's
#' MIT license. [Attribution](https://www.geoboundaries.org/index.html#usage)
#' to **geoBoundaries** and the original sources is required when sharing the
#' boundaries or derived products.
#'
#' @details
#' Each individual country boundary layer is governed by the original license
#' identified in its boundary metadata. See [gb_get_metadata()]. The
#' `"gbOpen"` release contains multiple open licenses, including ODbL and
#' CC BY-SA. Do not assume every boundary is licensed only under CC BY 4.0.
#' Users should cite the sources listed in the metadata and comply with any
#' attribution, share-alike or non-commercial terms.
#'
#' The wrappers [gb_get_adm0()], [gb_get_adm1()], [gb_get_adm2()],
#' [gb_get_adm3()], [gb_get_adm4()] and [gb_get_adm5()] are also available for
#' requesting a single ADM level.
#'
#' @param country A character vector of country names or ISO 3166-1 alpha-3
#'   country codes. Use `"all"` to return boundaries for all countries. See
#'   also [countrycode::countrycode()] from \CRANpkg{countrycode}.
#' @param adm_lvl ADM level. Accepted values are `"all"` (all available
#'   boundaries) or the ADM level (`"adm0"` is the country boundary,
#'   `"adm1"` is the first level of subnational boundaries, `"adm2"` is the
#'   second level and so on). Uppercase versions (`"ADM1"`) and level numbers
#'   (`0`, `1`, `2`, `3`, `4`, `5`) are also accepted.
#' @param simplified A logical value. If `TRUE`, return simplified boundaries.
#'   The default `FALSE` uses the primary **geoBoundaries** layer. See
#'   simplified boundaries at <https://www.geoboundaries.org/>.
#' @param release_type A character string, one of `"gbOpen"`,
#'   `"gbHumanitarian"` or `"gbAuthoritative"`. For most users, use `"gbOpen"`
#'   (the default), which contains openly licensed boundaries suitable for most
#'   purposes when their individual license terms are followed.
#'   `"gbHumanitarian"` boundaries are mirrored from
#'   [UN OCHA](https://www.unocha.org/) and may have additional conditions.
#'   `"gbAuthoritative"` boundaries are mirrored from
#'   [UN SALB](https://salb.un.org/en), verified through in-country processes
#'   and cannot be used for commercial purposes.
#' @param quiet A logical value. If `TRUE`, suppress informational messages.
#' @param overwrite A logical value. If `TRUE`, force a fresh download of the
#'   source `.zip` archive.
#' @param cache_dir A path to a cache directory. If not set (the default
#'   `NULL`), boundary archives are stored in the default cache directory (see
#'   [gb_set_cache_dir()]). If no cache directory has been set, archives are
#'   stored in a temporary cache directory. See [base::tempdir()] and the cache
#'   strategies in [gb_set_cache_dir()].
#'
#' @returns
#' An [sf][sf::st_sf] object from \CRANpkg{sf} containing the requested
#' boundaries. If no boundaries match the request, the function returns
#' `NULL`.
#'
#' @source
#' [**geoBoundaries** API](https://www.geoboundaries.org/api.html).
#'
#' @references
#' Runfola et al. (2020) "geoBoundaries: A global database of political
#' administrative boundaries." *PLOS ONE*, **15**(4), 1--9.
#' \doi{10.1371/journal.pone.0231866}.
#'
#' @seealso
#' - [gb_get_metadata()] inspects boundary metadata and licensing.
#' - [gb_get_max_adm_lvl()] checks available ADM levels.
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
#' # Inspect boundary metadata.
#' library(dplyr)
#' gb_get_metadata(
#'   "Sri Lanka",
#'   adm_lvl = 2
#' ) |>
#'   # Check the individual license.
#'   select(boundaryISO, boundaryType, licenseDetail, licenseSource) |>
#'   glimpse()
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
  country <- gbnds_dev_country2iso(country)

  gb_hlp_license_notice(source)

  gb_abort_if_not(
    "{.arg simplified} must be a {.cls logical}." = is.logical(simplified),
    "{.arg overwrite} must be a {.cls logical}." = is.logical(overwrite),
    "{.arg quiet} must be a {.cls logical}." = is.logical(quiet)
  )

  meta_df <- gb_get_metadata(
    country = country,
    adm_lvl = adm_lvl,
    release_type = release_type
  )

  if (nrow(meta_df) == 0) {
    cli::cli_alert_danger(
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

  meta_sf
}

#' Show the UN SALB license notice
#'
#' @param source The selected **geoBoundaries** release type.
#'
#' @returns
#' Invisibly returns `NULL`. This function is called for its side effects.
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
#' @param quiet A logical value. If `TRUE`, suppress informational messages.
#' @param overwrite A logical value. If `TRUE`, force a fresh download of the
#'   source `.zip` archive.
#' @param cache_dir A path to a cache directory.
#' @param cgaz_country A character vector of country codes to keep for CGAZ
#'   boundaries.
#' @param simplified A logical value. If `TRUE`, read simplified boundaries.
#'
#' @returns
#' An [sf][sf::st_sf] object from \CRANpkg{sf} or `NULL` when the archive
#' download fails.
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
      cli::cli_alert("Cache directory is {.path {path}}.")
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
  shp_zip <- unzip(file_local, list = TRUE)
  shp_end <- gb_hlp_select_shapefile(shp_zip$Name, simplified = simplified)

  # Read through GDAL's `/vsizip/` virtual file system.
  shp_read <- file.path("/vsizip/", file_local, shp_end)
  shp_read <- gsub("//", "/", shp_read, fixed = TRUE)
  outsf <- sf::read_sf(shp_read)

  if (subdir == "CGAZ" && !("ALL" %in% cgaz_country)) {
    outsf <- outsf[outsf$shapeGroup %in% cgaz_country, ]
  }
  outsf <- gbnds_dev_sf_helper(outsf)
}
