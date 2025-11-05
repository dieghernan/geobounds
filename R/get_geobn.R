#' Get geoBoundaries data
#'
#' @description
#' Return an spatial object using \CRANpkg{sf}.
#' [Attribution](https://www.geoboundaries.org/index.html#usage) is required
#' for all uses of this dataset.
#'
#' @export
#'
#' @param country A character vector of country codes. It could be either
#'   `"ALL"` (that would return the data for all countries), a vector of country
#'   names or a vector of ISO3 country codes. Mixed types (as
#'   `c("Italy","ES","FRA")`) would not work. See also
#'   [countrycode::countrycode()].
#' @param release_type One of `"gbOpen"`, `"gbHumanitarian"`,
#'   "gbAuthoritative"`. Source of the spatial data. See **Details**.
#' @param boundary_type Type of boundary Accepted values are `"ALL"` (all
#'   available boundaries) or the ADM level (`"ADM0"` is the country boundary,
#'   `"ADM1"` is the first level of sub national boundaries, `"ADM2"` is the
#'   second level and so on.
#' @param simplified Logical. Return the simplified boundary or not.
#' @param metadata Should the result be the metadata of the boundary?
#' @param verbose Logical, displays information. Useful for debugging,
#'   default is `FALSE`.
#'
#' @param update_cache A logical whether to update cache. Default is `FALSE`.
#'  When set to `TRUE` it would force a fresh download of the source
#'  `.geojson` file.
#'
#' @param cache_dir A path to a cache directory. See [geobn_set_cache_dir()].
#'
#'
#' @return
#'
#' - With `metadata = FALSE`: A [`sf`][sf::st_sf] object.
#' - With `metadata = TRUE`: A tibble.
#'
#' @references
#' geoboundaries API Service <https://www.geoboundaries.org/api.html>.
#'
#' Runfola, D. et al. (2020) geoBoundaries: A global database of political
#' administrative boundaries. *PLoS ONE* **15**(4): e0231866.
#' \doi{10.1371/journal.pone.0231866}.
#'
#' @family API functions
#'
#' @details
#'
#'  For most users, we suggest using `"gbOpen"`, as it is CC-BY 4.0 compliant,
#'  and can be used for most purposes so long as attribution is provided.
#'  `"gbHumanitarian"` files are mirrored from
#'  [UN OCHA](https://www.unocha.org/), but may have less open licensure.
#'  `"gbAuthoritative"` files are mirrored from
#'  [UN SALB](https://salb.un.org/), and cannot  be used for commercial
#'  purposes, but are verified through in-country processes.
#'
#' @examplesIf httr2::is_online()
#'
#' \donttest{
# Map municipalities in Sri Lanka
#' sri_lanka <- get_geobn(
#'   "Sri Lanka",
#'   boundary_type = "ADM3",
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
#' get_geobn(
#'   "Sri Lanka",
#'   boundary_type = "ADM3",
#'   metadata = TRUE
#' ) %>%
#'   glimpse()
#'
get_geobn <- function(
  country,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  boundary_type = c("ADM0", "ADM1", "ADM2", "ADM3", "ADM4", "ALL"),
  simplified = FALSE,
  metadata = FALSE,
  verbose = FALSE,
  update_cache = FALSE,
  cache_dir = NULL
) {
  # Input params
  release_type <- match.arg(release_type)
  boundary_type <- match.arg(boundary_type)
  if (any(toupper(country) == "ALL")) {
    country <- "ALL"
  } else {
    country <- geobn_helper_countrynames(country)
  }

  # Prepare query urls
  urls <- paste(
    "https://www.geoboundaries.org/api/current",
    release_type,
    country,
    boundary_type,
    sep = "/"
  )

  res <- lapply(urls, function(x) {
    get_geobn_meta(url = x)
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
    get_geobn_sf_single(
      url = x,
      subdir = release_type,
      verbose = verbose,
      update_cache = update_cache,
      cache_dir = cache_dir
    )
  })

  meta_sf <- dplyr::bind_rows(res_sf)

  meta_sf
}


get_geobn_meta <- function(url) {
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


get_geobn_sf_single <- function(url, subdir, verbose, update_cache, cache_dir) {
  filename <- basename(url)
  # Prepare cache
  cache_dir <- geobn_hlp_cachedir(cache_dir)
  cache_dir <- geobn_hlp_cachedir(file.path(cache_dir, subdir))

  # Create destfile and clean
  file_local <- file.path(cache_dir, filename)
  file_local <- gsub("//", "/", file_local)

  fileoncache <- file.exists(file_local)

  num <- sf::st_crs(4326)

  # Check if cached
  if (isFALSE(update_cache) && fileoncache) {
    if (verbose) cli::cli_alert_info("File {.file {file_local}} already cached")
  } else {
    # Download
    if (verbose) {
      cli::cli_alert_info("Downloading file from {.url {url}}")
      cli::cli_alert_info("Cache dir is {.path {cache_dir}}")
    }

    # Prepare download
    q <- httr2::request(url)
    if (verbose) {
      q <- httr2::req_progress(q)
    }
    get <- httr2::req_perform(q, path = file_local) # nolint
  }

  outsf <- geojsonsf::geojson_sf(file_local, input = num$input, wkt = num$wkt)
  outsf <- geobn_helper_utf8(outsf)
}
