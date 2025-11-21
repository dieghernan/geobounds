#' Get metadata of individual country files from geoBoundaries
#'
#' @description
#'
#' This function returns metadata of the
#' [geoBoundaries API](https://www.geoboundaries.org/api.html).
#'
#' @source
#' geoBoundaries API Service <https://www.geoboundaries.org/api.html>.
#'
#'
#' @family metadata functions
#'
#' @inheritParams gb_get
#'
#' @export
#'
#' @seealso [gb_get()]
#' @return
#' A tibble with class [`tbl_df`][tibble::tbl_df-class].
#'
#' @details
#'
#' The result would be a tibble with the following columns:
#'
#' - `boundaryID`: The ID for this layer, which is a combination of the ISO
#'    code, the boundary type, and a unique identifier for the boundary
#'    generated based on the input metadata and geometry. This only changes if
#'    the underlying data changes.
#' - `boundaryName`: The name of the country the layer represents.
#' - `boundaryISO`: ISO-3166-1 (Alpha 3) code for the country.
#' - `boundaryYearRepresented`: The year, or range of years in `"START to END"`
#'    format, which the boundary layers represent.
#' - `boundaryType`: The type of boundary.
#' - `boundaryCanonical`: The canonical name of a given boundary.
#' - `boundarySource`: A comma-separated list of the primary sources for the
#'    boundary.
#' - `boundarySource`: A comma-separated list of the primary sources for the
#'    boundary.
#' - `boundaryLicense`: The original license that the dataset was released
#'   under by the primary source.
#' - `licenseDetail`: Any notes regarding the license.
#' - `licenseSource`: The URL of the primary source.
#' - `sourceDataUpdateDate`: The date the source information was integrated
#'    into the geoBoundaries repository.
#' - `buildDate`: The date the source data was most recently standardized and
#'    built into a geoBoundaries release.
#' - `Continent`: The continent the country is associated with.
#' - `UNSDG-region`: The United Nations Sustainable Development Goals (SDG)
#'   region the country is associated with.
#' - `UNSDG-subregion`: The United Nations Sustainable Development Goals (SDG)
#'   subregion the country is associated with.
#' - `worldBankIncomeGroup`: The World Bank income group the country is
#'   associated with.
#' - `admUnitCount`: Count of administrative units in the file.
#' - `meanVertices`: Mean number of vertices defining the boundaries of each
#'   administrative unit in the layer.
#' - `minVertices`: Minimum number of vertices defining a boundary.
#' - `maxVertices`: Maximum number of vertices defining a boundary.
#' - `minPerimeterLengthKM`: The minimum perimeter length of an administrative
#'    unit in the layer, measured in kilometers (based on a World Equidistant
#'    Cylindrical projection).
#' - `meanPerimeterLengthKM`: The mean perimeter length of an administrative
#'    unit in the layer, measured in kilometers (based on a World Equidistant
#'    Cylindrical projection).
#' - `maxPerimeterLengthKM`: The maximum perimeter length of an administrative
#'    unit in the layer, measured in kilometers (based on a World Equidistant
#'    Cylindrical projection).
#' - `meanAreaSqKM`: The mean area of all administrative units in the layer,
#'    measured in square kilometers (based on a EASE-GRID 2 projection).
#' - `minAreaSqKM`: The minimum area of an administrative unit in the layer,
#'    measured in square kilometers (based on a EASE-GRID 2 projection).
#' - `maxAreaSqKM`: The maximum area of an administrative unit in the layer,
#'    measured in square kilometers (based on a EASE-GRID 2 projection).
#' - `staticDownloadLink`: The static download link for the aggregate zip file
#'    containing all boundary information.
#' - `gjDownloadURL`: The static download link for the `geoJSON`.
#' - `tjDownloadURL`: The static download link for the `topoJSON`.
#' - `imagePreview`: The static download link for the automatically rendered
#'   `PNG` of the layer.
#' - `simplifiedGeometryGeoJSON`: The static download link for the
#'    simplified `geoJSON`.
#'
#' @examplesIf httr2::is_online()
#' # Get metadata of ADM4 levels
#'
#' library(dplyr)
#'
#' gb_get_meta(adm_lvl = "ADM4") %>%
#'   glimpse()
#'
gb_get_meta <- function(
  country = "all",
  adm_lvl = "all",
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative")
) {
  # Prepare inputs
  release_type <- match.arg(release_type)
  adm_lvl <- assert_adm_lvl(adm_lvl)

  country <- gbnds_dev_country2iso(country)

  # Prepare query urls
  urls <- paste(
    "https://www.geoboundaries.org/api/current",
    release_type,
    country,
    adm_lvl,
    sep = "/"
  )

  res <- lapply(urls, gbnds_dev_meta_query)

  meta_df <- dplyr::bind_rows(res)
  dplyr::as_tibble(meta_df)
}


gbnds_dev_meta_query <- function(url) {
  # Prepare query
  q <- httr2::request(url)
  q <- httr2::req_error(q, is_error = function(x) {
    FALSE
  })
  q <- httr2::req_retry(q, max_tries = 3, is_transient = function(resp) {
    httr2::resp_status(resp) %in% c(429, 500, 503)
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
  iter <- seq_along(mabb)
  mnum <- sprintf("%02d", iter)

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
#' @export
#' @rdname gb_get_meta
#' @usage NULL
gb_get_metadata <- gb_get_meta
