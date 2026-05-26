#' Get individual country files from geoBoundaries
#'
#' @description
#' [Attribution](https://www.geoboundaries.org/index.html#usage) is required
#' for all uses of this dataset.
#'
#' This function returns individual country files "as they would represent
#' themselves", without special identification of disputed areas.
#'
#' Use [gb_get_world()] for global composite files that include disputed areas.
#'
#' @details
#' Individual country files in the geoBoundaries database are governed by the
#' license or licenses identified within the metadata for each respective
#' boundary. See [gb_get_metadata()]. Users of individual boundary files from
#' geoBoundaries should also cite the sources provided in the metadata for each
#' file. See **Examples**.
#'
#' The wrappers [gb_get_adm0()], [gb_get_adm1()], [gb_get_adm2()],
#' [gb_get_adm3()], [gb_get_adm4()] and [gb_get_adm5()] are also available for
#' requesting a single administrative level.
#'
#' @param country A character vector of country codes. It can be either
#'   `"all"` (which returns the data for all countries), a vector of country
#'   names or ISO 3166-1 alpha-3 country codes. See also
#'   [countrycode::countrycode()].
#' @param adm_lvl Type of boundary. Accepted values are `"all"` (all
#'   available boundaries) or the ADM level (`"adm0"` is the country boundary,
#'   `"adm1"` is the first level of subnational boundaries, `"adm2"` is the
#'   second level and so on). Upper-case versions (`"ADM1"`) and the number of
#'   the level (`1, 2, 3, 4, 5`) are also accepted.
#' @param simplified Logical. If `TRUE`, return the simplified boundary. The
#'   default `FALSE` uses the primary geoBoundaries release. See simplified
#'   boundaries at <https://www.geoboundaries.org/>.
#' @param release_type One of `"gbOpen"`, `"gbHumanitarian"` or
#'   `"gbAuthoritative"`. For most users, we suggest using `"gbOpen"`
#'   (the default), as it is CC BY 4.0 compliant and suitable for most purposes
#'   so long as attribution is provided. `"gbHumanitarian"` files are mirrored
#'   from [UN OCHA](https://www.unocha.org/) and may have less open licensure.
#'   `"gbAuthoritative"` files are mirrored from UN SALB, verified through
#'   in-country processes and cannot be used for commercial purposes.
#' @param quiet Logical. If `TRUE`, suppress informational messages.
#' @param overwrite Logical. If `TRUE`, force a fresh download of the source
#'   `.zip` file.
#' @param cache_dir A path to a cache directory. If not set (the default
#'   `NULL`), the data will be stored in the default cache directory (see
#'   [gb_set_cache_dir()]). If no cache directory has been set, files will be
#'   stored in the temporary directory. See [base::tempdir()] and caching
#'   strategies in [gb_set_cache_dir()].
#'
#' @returns A [`sf`][sf::st_sf] object.
#'
#' @source
#' geoBoundaries API service <https://www.geoboundaries.org/api.html>.
#'
#' @references
#' Runfola, D. et al. (2020) geoBoundaries: A global database of political
#' administrative boundaries. *PLOS ONE* *15*(4), 1-9.
#' \doi{10.1371/journal.pone.0231866}.
#'
#' @family API functions
#'
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") || interactive()
#' \donttest{
#' # Map level 2 in Sri Lanka.
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
#'   labs(caption = "Source: www.geoboundaries.org")
#' }
#'
#' # Metadata.
#' library(dplyr)
#' gb_get_metadata(
#'   "Sri Lanka",
#'   adm_lvl = 2
#' ) |>
#'   # Check the individual license.
#'   select(boundaryISO, boundaryType, licenseDetail, licenseSource) |>
#'   glimpse()
#'
#' @export
#' @encoding UTF-8
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

  meta_df <- gb_get_metadata(
    country = country,
    adm_lvl = adm_lvl,
    release_type = release_type
  )

  if (nrow(meta_df) == 0) {
    cli::cli_alert_danger(
      "No matching boundary files found. Returning {.code NULL}."
    )
    return(NULL)
  }

  url_bound <- gb_hlp_unique_values(meta_df$staticDownloadLink)

  # Download and combine boundary files.
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
      cli::cli_alert_success("File {.file {file_local}} already cached.")
    }
  } else {
    # Download the source archive.
    if (!quiet) {
      cli::cli_alert_info("Downloading file from {.url {url}}.")
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
