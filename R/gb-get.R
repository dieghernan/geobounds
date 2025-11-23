#' Get individual country files from geoBoundaries
#'
#' @description
#' [Attribution](https://www.geoboundaries.org/index.html#usage) is required
#' for all uses of this dataset.
#'
#' This function returns data of individual countries "as they would represent
#' themselves", with no special identification of disputed areas.
#'
#' If you would prefer data that explicitly includes disputed areas, please use
#' [gb_get_cgaz()].
#'
#' @export
#'
#' @param country A character vector of country codes. It could be either
#'   `"all"` (that would return the data for all countries), a vector of country
#'   names or ISO3 country codes. See also [countrycode::countrycode()].
#' @param adm_lvl Type of boundary Accepted values are `"all"` (all
#'   available boundaries) or the ADM level (`"adm0"` is the country boundary,
#'   `"adm1"` is the first level of sub national boundaries, `"adm2"` is the
#'   second level and so on. Upper case version (`"ADM1"`) and the number of
#'   the level (`1, 2, 3, 4, 5`) and also accepted.
#' @param simplified logical. Return the simplified boundary or not. The default
#'   `FALSE` would use the premier geoBoundaries release.
#' @param release_type One of `"gbOpen"`, `"gbHumanitarian"`,
#'   `"gbAuthoritative"`. For most users, we suggest using `"gbOpen"`
#'   (the default), as it is CC-BY 4.0 compliant and can be used for most
#'   purposes so long as attribution is provided:
#'  - `"gbHumanitarian"` files are mirrored from
#'    [UN OCHA](https://www.unocha.org/), but may have less open licensure.
#'  - `"gbAuthoritative"` files are mirrored from
#'    [UN SALB](https://salb.un.org/en), and cannot  be used for commercial
#'    purposes, but are verified through in-country processes.
#' @param quiet logical. If `TRUE` suppresses informational messages.
#' @param overwrite logical. When set to `TRUE` it would force a fresh
#'    download of the source `.zip` file.
#' @param cache_dir A path to a cache directory. If not set (the default
#'   `NULL`), the data would be stored in the default cache directory (see
#'   [gb_set_cache_dir()]). If no cache directory has been set, files would be
#'   stored in the temporary directory (see `base::tempdir()`). See caching
#'   strategies in [gb_set_cache_dir()].
#'
#' @details
#'
#' Individual data files in the geoBoundaries database are governed by the
#' license or licenses identified within the metadata for each respective
#' boundary (see [gb_get_metadata()]. Users using individual boundary files
#' from geoBoundaries should additionally ensure that they are citing the
#' sources provided in the metadata for each file. See **Examples**.
#'
#' The following wrappers are also available:
#'
#' - [gb_get_adm0()] returns the country boundary.
#' - [gb_get_adm1()] returns first-level administration
#'   boundaries (e.g. States in the United States).
#' - [gb_get_adm2()] returns second-level administration
#'   boundaries (e.g. Counties in the United States).
#' - [gb_get_adm3()] returns third-level administration
#'   boundaries (e.g. towns or cities in some countries).
#' - [gb_get_adm4()] returns fourth-level administration
#'   boundaries.
#' - [gb_get_adm5()] returns fifth-level administration
#'   boundaries.
#'
#' @return
#' A [`sf`][sf::st_sf] object.
#'
#' @source
#' geoBoundaries API Service <https://www.geoboundaries.org/api.html>.
#'
#' @references
#' Runfola, D. et al. (2020) geoBoundaries: A global database of political
#' administrative boundaries. *PLoS ONE* 15(4): e0231866.
#' \doi{10.1371/journal.pone.0231866}.
#'
#' @family API functions
#'
#' @examplesIf httr2::is_online()
#'
#' \donttest{
#' # Map level 2 in Sri Lanka
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
#' # Metadata
#' library(dplyr)
#' gb_get_metadata(
#'   "Sri Lanka",
#'   adm_lvl = 2
#' ) %>%
#'   # Check individual license
#'   select(boundaryISO, boundaryType, licenseDetail, licenseSource) %>%
#'   glimpse()
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
  # Input params
  source <- match.arg(release_type)
  adm_lvl <- assert_adm_lvl(adm_lvl)
  country <- gbnds_dev_country2iso(country)

  meta_df <- gb_get_metadata(
    country = country,
    adm_lvl = adm_lvl,
    release_type = release_type
  )

  if (nrow(meta_df) == 0) {
    cli::cli_alert_danger("Nothing to download, returning {.code NULL}")
    return(NULL)
  }

  url_bound <- meta_df$staticDownloadLink

  # CleanUp
  url_bound <- unique(url_bound)
  url_bound <- url_bound[!is.na(url_bound)]
  url_bound <- url_bound[!is.null(url_bound)]

  # Call and bind
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
  # Prepare cache
  path <- gb_hlp_cachedir(cache_dir)
  path <- gb_hlp_cachedir(file.path(path, subdir))

  # Create destfile and clean
  file_local <- file.path(path, filename)
  file_local <- gsub("//", "/", file_local)

  fileoncache <- file.exists(file_local)

  # Check if cached
  if (isFALSE(overwrite) && fileoncache) {
    if (!quiet) {
      cli::cli_alert_success("File {.file {file_local}} already cached")
    }
  } else {
    # Download
    if (!quiet) {
      cli::cli_alert_info("Downloading file from {.url {url}}")
      cli::cli_alert("Cache dir is {.path {path}}")
    }

    # Prepare download
    q <- httr2::request(url)
    q <- httr2::req_error(q, is_error = function(x) {
      FALSE
    })
    q <- httr2::req_retry(q, max_tries = 3, is_transient = function(resp) {
      httr2::resp_status(resp) %in% c(429, 500, 503)
    })
    if (!quiet) {
      q <- httr2::req_progress(q)
    }
    get <- httr2::req_perform(q, path = file_local) # nolint

    # In error inform and return NULL
    if (httr2::resp_is_error(get)) {
      unlink(file_local, force = TRUE)
      # nolint start: Error code for message
      err <- paste0(
        c(
          httr2::resp_status(get),
          httr2::resp_status_desc(get)
        ),
        collapse = " - "
      )

      # nolint end
      cli::cli_alert_danger("{.url {url}} gives error {err}")

      return(NULL)
    }
  }

  # Read file names
  shp_zip <- unzip(file_local, list = TRUE)
  shp_zip <- shp_zip$Name
  shp_zip <- shp_zip[grepl("shp$", shp_zip)]
  if (simplified) {
    shp_end <- shp_zip[grepl("simplified", shp_zip)]
  } else {
    shp_end <- shp_zip[!grepl("simplified", shp_zip)]
  }

  # Read with vszip
  shp_read <- file.path("/vsizip/", file_local, shp_end)
  shp_read <- gsub("//", "/", shp_read)
  outsf <- sf::read_sf(shp_read)

  if (subdir == "CGAZ" && !("ALL" %in% cgaz_country)) {
    outsf <- outsf[outsf$shapeGroup %in% cgaz_country, ]
  }
  outsf <- gbnds_dev_sf_helper(outsf)
}
