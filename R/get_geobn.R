#' Get geoBoundaries data
#'
#' @description
#' Return an spatial object using \CRANpkg{sf}.
#'
#' @export
#'
#' @param release_type One of `"gbOpen"`, `"gbHumanitarian"`,
#'   "gbAuthoritative"`. Source of the spatial data. See **Details**.
#' @param country A character vector of country codes. It could be either
#'   `"ALL"` (that would return the data for all countries), a vector of country
#'   names or a vector of ISO3 country codes. Mixed types (as
#'   `c("Italy","ES","FRA")`) would not work. See also
#'   [countrycode::countrycode()].
#' @param boundary_type Type of boundary Accepted values are `"ALL"` (all
#'   available boundaries) or the ADM level (`"ADM0"` is the country boundary,
#'   `"ADM1"` is the first level of sub national boundaries, `"ADM2"` is the
#'   second level and so on.
#' @param simplified Logical. Return the simplified boundary or not.
#' @param metadata Should the result be the metadata of the boundary?
#'   See **Details**.
#' @param verbose Logical, displays information. Useful for debugging,
#'   default is `FALSE`.
#'
#' @param cache A logical whether to do caching. Default is `TRUE`. See
#'   **About caching**.
#'
#' @param update_cache A logical whether to update cache. Default is `FALSE`.
#'  When set to `TRUE` it would force a fresh download of the source
#'  `.geojson` file.
#'
#' @param cache_dir A path to a cache directory. See [geobn_set_cache_dir()].
#'
#'
#' @return
#' When `metadata = FALSE`: A [`sf`][sf::st_sf] object, otherwise a tibble.
#'
#' @references
#' geoboundaries API Service <https://www.geoboundaries.org/api.html>.
#'
#' @details
#'  TODO....
#'
#' @examplesIf httr2::is_online()
#'
#' # Metadata
#' library(dplyr)
#' get_geobn(country = "Spain", boundary_type = "ADM0", metadata = TRUE) %>%
#'   glimpse()
#'
get_geobn <- function(
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  country = "ALL",
  boundary_type = c("ADM0", "ADM1", "ADM2", "ADM3", "ADM4", "ALL"),
  simplified = FALSE,
  metadata = FALSE,
  verbose = FALSE,
  cache = TRUE,
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
  urls <- paste("https://www.geoboundaries.org/api/current",
    release_type, country, boundary_type,
    sep = "/"
  )


  res <- lapply(urls, function(x) {
    get_geobn_meta(url = x)
  })

  meta_df <- dplyr::bind_rows(res)

  if (metadata) {
    return(meta_df)
  }
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
    err <- paste0(c(
      httr2::resp_status(resp),
      httr2::resp_status_desc(resp)
    ), collapse = " - ")

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

  tb
}
