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
#' [get_gb_cgaz()].
#'
#' @export
#'
#' @param country A character vector of country codes. It could be either
#'   `"ALL"` (that would return the data for all countries), a vector of country
#'   names or a vector of ISO3 country codes. Mixed types (as
#'   `c("Italy","ES","FRA")`) would not work. See also
#'   [countrycode::countrycode()].
#' @param adm_lvl Type of boundary Accepted values are `"ALL"` (all
#'   available boundaries) or the ADM level (`"ADM0"` is the country boundary,
#'   `"ADM1"` is the first level of sub national boundaries, `"ADM2"` is the
#'   second level and so on.
#' @param simplified Logical. Return the simplified boundary or not.
#' @param release_type One of `"gbOpen"`, `"gbHumanitarian"`,
#'   `"gbAuthoritative"`. Source of the spatial data. See **Details**.
#' @param metadata Should the result be the metadata of the boundary?
#' @param quiet Logical, on `FALSE` it displays information of the call. Useful
#'   for debugging, default is no messages `quiet = TRUE`.
#'
#' @param overwrite A logical whether to update cache. Default is `FALSE`.
#'  When set to `TRUE` it would force a fresh download of the source
#'  `.geojson` file.
#'
#' @param cache_dir A path to a cache directory. If not set (the default
#'   `NULL`), the data would be stored in the default cache directory (see
#'   [gb_set_cache_dir()]). If no cache directory has been set, files would be
#'   stored in the temporary directory (see `base::tempdir()`).
#'
#'
#' @return
#'
#' - With `metadata = FALSE`: A [`sf`][sf::st_sf] object.
#' - With `metadata = TRUE`: A tibble.
#'
#' @source
#' geoboundaries API Service <https://www.geoboundaries.org/api.html>.
#'
#' @references
#' Runfola, D. et al. (2020) geoBoundaries: A global database of political
#' administrative boundaries. *PLOS ONE* 15(4): e0231866.
#' \doi{10.1371/journal.pone.0231866}.
#'
#' @family API functions
#'
#' @details
#'
#'  For most users, we suggest using `"gbOpen"`, as it is CC-BY 4.0 compliant,
#'  and can be used for most purposes so long as attribution is provided.
#'
#'  - `"gbHumanitarian"` files are mirrored from
#'    [UN OCHA](https://www.unocha.org/), but may have less open licensure.
#'  - `"gbAuthoritative"` files are mirrored from
#'    [UN SALB](https://salb.un.org/en), and cannot  be used for commercial
#'    purposes, but are verified through in-country processes.
#'
#' @examplesIf httr2::is_online()
#'
#' \donttest{
# Map municipalities in Sri Lanka
#' sri_lanka <- get_gb(
#'   "Sri Lanka",
#'   adm_lvl = "ADM3",
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
#' get_gb(
#'   "Sri Lanka",
#'   adm_lvl = "ADM3",
#'   metadata = TRUE
#' ) %>%
#'   glimpse()
#'
get_gb <- function(
  country,
  adm_lvl = c("ADM0", "ADM1", "ADM2", "ADM3", "ADM4", "ALL"),
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  metadata = FALSE,
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  # Input params
  source <- match.arg(release_type)
  level <- match.arg(adm_lvl)

  verbose <- isFALSE(quiet)

  if (any(toupper(country) == "ALL")) {
    country <- "ALL"
  } else {
    country <- gb_helper_countrynames(country)
  }

  # Prepare query urls
  urls <- paste(
    "https://www.geoboundaries.org/api/current",
    source,
    country,
    level,
    sep = "/"
  )

  res <- lapply(urls, function(x) {
    hlp_get_gb_meta(url = x)
  })

  meta_df <- dplyr::bind_rows(res)

  if (metadata) {
    return(meta_df)
  }

  if (nrow(meta_df) == 0) {
    cli::cli_alert_danger("Nothing to download, returning {.code NULL}")
    return(NULL)
  }

  bnd_type <- ifelse(simplified, "simplifiedGeometryGeoJSON", "gjDownloadURL")
  url_bound <- as.vector(meta_df[[bnd_type]])

  # CleanUp
  url_bound <- unique(url_bound)
  url_bound <- url_bound[!is.na(url_bound)]
  url_bound <- url_bound[!is.null(url_bound)]

  url_bound
  # Call and bind
  res_sf <- lapply(url_bound, function(x) {
    hlp_get_gb_sf_single(
      url = x,
      subdir = source,
      verbose = verbose,
      overwrite = overwrite,
      cache_dir = cache_dir
    )
  })

  meta_sf <- dplyr::bind_rows(res_sf)

  meta_sf
}


hlp_get_gb_meta <- function(url) {
  # Prepare query
  q <- httr2::request(url)
  q <- httr2::req_error(q, is_error = function(x) {
    FALSE
  })
  resp <- httr2::req_perform(q)

  # In error inform and return NULL
  if (httr2::resp_is_error(resp)) {
    # nolint start: Error code for message
    err <- paste0(
      c(
        httr2::resp_status(resp),
        httr2::resp_status_desc(resp)
      ),
      collapse = " - "
    )

    # nolint end
    cli::cli_alert_danger("{.url {url}} gives error {err}")

    return(NULL)
  }

  # Get the metadata
  resp_body <- httr2::resp_body_json(resp)

  # Check if single or several responses
  if ("boundaryID" %in% names(resp_body)) {
    tb <- dplyr::as_tibble(resp_body)
  } else {
    tb <- lapply(resp_body, dplyr::as_tibble)
    tb <- dplyr::bind_rows(tb)
  }
  tb[tb == "nan"] <- NA
  tb$admUnitCount <- as.numeric(tb$admUnitCount)
  tb$meanVertices <- as.numeric(tb$meanVertices)
  tb$minVertices <- as.numeric(tb$minVertices)
  tb$maxVertices <- as.numeric(tb$maxVertices)
  tb$minVertices <- as.numeric(tb$minVertices)
  tb$meanPerimeterLengthKM <- as.numeric(tb$meanPerimeterLengthKM)
  tb$minPerimeterLengthKM <- as.numeric(tb$minPerimeterLengthKM)
  tb$maxPerimeterLengthKM <- as.numeric(tb$maxPerimeterLengthKM)
  tb$meanAreaSqKM <- as.numeric(tb$meanAreaSqKM)
  tb$minAreaSqKM <- as.numeric(tb$minAreaSqKM)
  tb$maxAreaSqKM <- as.numeric(tb$maxAreaSqKM)

  # Convert dates
  up <- tb$sourceDataUpdateDate
  up <- trimws(gsub("Mon|Tue|Wed|Thu|Fri|Sat|Sun", "", up))
  mabb <- month.abb
  mnum <- sprintf("%02d", seq_len(length(mabb)))
  iter <- seq_len(length(mabb))
  for (i in iter) {
    up <- gsub(mabb[i], mnum[i], up)
  }
  upconv <- strptime(up, "%m %d %H:%M:%S %Y", tz = "GMT")
  tb$sourceDataUpdateDate <- upconv

  bd <- tb$buildDate
  for (i in iter) {
    bd <- gsub(mabb[i], mnum[i], bd)
  }
  bd <- gsub(",", "", bd)
  bdate <- as.Date(bd, "%m %d %Y")
  tb$buildDate <- bdate

  tb
}


hlp_get_gb_sf_single <- function(
  url,
  subdir,
  verbose,
  overwrite,
  cache_dir,
  format = "geojson",
  cgaz_country = "ALL"
) {
  filename <- basename(url)
  # Prepare cache
  cache_dir <- gb_hlp_cachedir(cache_dir)
  cache_dir <- gb_hlp_cachedir(file.path(cache_dir, subdir))

  # Create destfile and clean
  file_local <- file.path(cache_dir, filename)
  file_local <- gsub("//", "/", file_local)

  fileoncache <- file.exists(file_local)

  num <- sf::st_crs(4326)

  # Check if cached
  if (isFALSE(overwrite) && fileoncache) {
    if (verbose) {
      cli::cli_alert_success("File {.file {file_local}} already cached")
    }
  } else {
    # Download
    if (verbose) {
      cli::cli_alert_info("Downloading file from {.url {url}}")
      cli::cli_alert("Cache dir is {.path {cache_dir}}")
    }

    # Prepare download
    q <- httr2::request(url)
    if (verbose) {
      q <- httr2::req_progress(q)
    }
    get <- httr2::req_perform(q, path = file_local) # nolint
  }

  if (format == "geojson") {
    outsf <- geojsonsf::geojson_sf(file_local, input = num$input, wkt = num$wkt)
  } else {
    # Geopackage

    outsf <- read_gpkg_query(file_local, cgaz_country)
  }

  outsf <- gb_helper_utf8(outsf)
}
