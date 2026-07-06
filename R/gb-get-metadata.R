#' Retrieve boundary metadata from **geoBoundaries**
#'
#' @description
#' Returns boundary metadata from the
#' [**geoBoundaries** API](https://www.geoboundaries.org/api.html).
#'
#' @details
#' The result is a [tibble][tibble::tbl_df] from \CRANpkg{tibble} with the
#' following columns:
#'
#' - `boundaryID`: The ID for this layer. It combines the ISO code, boundary
#'   type and a unique identifier generated from the input metadata and
#'   geometry. This only changes if the underlying data changes.
#' - `boundaryName`: The name of the country represented by the layer.
#' - `boundaryISO`: The ISO 3166-1 alpha-3 code for the country.
#' - `boundaryYearRepresented`: The year or range of years in `"START to END"`
#'   format that the boundary layers represent.
#' - `boundaryType`: The type of boundary.
#' - `boundaryCanonical`: The canonical name of the boundary.
#' - `boundarySource`: A comma-separated list of the primary sources for the
#'   boundary.
#' - `boundaryLicense`: The original license under which the primary source
#'   released the boundary data.
#' - `licenseDetail`: Notes about the license.
#' - `licenseSource`: The URL of the primary source.
#' - `sourceDataUpdateDate`: The date the source information was integrated
#'   into the **geoBoundaries** repository.
#' - `buildDate`: The date the source data was most recently standardized and
#'   built into a **geoBoundaries** release.
#' - `Continent`: The continent the country is associated with.
#' - `UNSDG-region`: The United Nations Sustainable Development Goals (SDG)
#'   region the country is associated with.
#' - `UNSDG-subregion`: The United Nations Sustainable Development Goals (SDG)
#'   subregion the country is associated with.
#' - `worldBankIncomeGroup`: The World Bank income group the country is
#'   associated with.
#' - `admUnitCount`: The number of administrative units in the file.
#' - `meanVertices`: The mean number of vertices defining the boundaries of each
#'   administrative unit in the layer.
#' - `minVertices`: The minimum number of vertices defining a boundary.
#' - `maxVertices`: The maximum number of vertices defining a boundary.
#' - `minPerimeterLengthKM`: The minimum perimeter length of an administrative
#'   unit in the layer, measured in kilometers and based on a World Equidistant
#'   Cylindrical projection.
#' - `meanPerimeterLengthKM`: The mean perimeter length of an administrative
#'   unit in the layer, measured in kilometers and based on a World Equidistant
#'   Cylindrical projection.
#' - `maxPerimeterLengthKM`: The maximum perimeter length of an administrative
#'   unit in the layer, measured in kilometers and based on a World Equidistant
#'   Cylindrical projection.
#' - `meanAreaSqKM`: The mean area of all administrative units in the layer,
#'   measured in square kilometers and based on an EASE-GRID 2 projection.
#' - `minAreaSqKM`: The minimum area of an administrative unit in the layer,
#'   measured in square kilometers and based on an EASE-GRID 2 projection.
#' - `maxAreaSqKM`: The maximum area of an administrative unit in the layer,
#'   measured in square kilometers and based on an EASE-GRID 2 projection.
#' - `staticDownloadLink`: The static download link for the aggregate ZIP file
#'   containing all boundary information.
#' - `gjDownloadURL`: The static download link for the GeoJSON.
#' - `tjDownloadURL`: The static download link for the TopoJSON.
#' - `imagePreview`: The static download link for an automatically rendered PNG
#'   image of the layer.
#' - `simplifiedGeometryGeoJSON`: The static download link for the
#'   simplified GeoJSON.
#'
#' @inherit gb_get source
#' @inheritParams gb_get
#'
#' @returns
#' A [tibble][tibble::tbl_df] from \CRANpkg{tibble} with one row per matching
#' boundary file and the columns described in **Details**.
#'
#' @seealso [gb_get()] downloads the boundaries described by the metadata.
#'
#' @family metadata
#'
#' @export
#' @encoding UTF-8
#'
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") || interactive()
#' # Get boundary metadata for ADM4.
#'
#' library(dplyr)
#'
#' gb_get_metadata(adm_lvl = "ADM4") |>
#'   glimpse()
gb_get_metadata <- function(
  country = "all",
  adm_lvl = "all",
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative")
) {
  # Prepare inputs.
  release_type <- match_arg_pretty(release_type)
  adm_lvl <- assert_adm_lvl(adm_lvl)

  country <- gbnds_dev_country2iso(country)

  # Prepare query URLs.
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
  q <- gb_hlp_request(url)
  resp <- httr2::req_perform(q)

  # Report request errors and return `NULL`.
  if (httr2::resp_is_error(resp)) {
    gb_hlp_alert_http_error(url, resp)

    return(NULL)
  }

  # Parse the metadata.
  resp_body <- httr2::resp_body_json(resp)

  # Handle single-response and multi-response API payloads.
  if ("boundaryID" %in% names(resp_body)) {
    tb <- dplyr::as_tibble(resp_body)
  } else {
    tb <- lapply(resp_body, dplyr::as_tibble)
    tb <- dplyr::bind_rows(tb)
  }
  tb[tb == "nan"] <- NA
  numeric_cols <- c(
    "admUnitCount",
    "meanVertices",
    "minVertices",
    "maxVertices",
    "meanPerimeterLengthKM",
    "minPerimeterLengthKM",
    "maxPerimeterLengthKM",
    "meanAreaSqKM",
    "minAreaSqKM",
    "maxAreaSqKM"
  )
  tb <- gb_hlp_as_numeric(tb, numeric_cols)

  # Convert date fields.
  tb$sourceDataUpdateDate <- gb_hlp_parse_api_datetime(tb$sourceDataUpdateDate)
  tb$buildDate <- gb_hlp_parse_api_date(tb$buildDate)

  tb
}

#' @rdname gb_get_metadata
#' @usage NULL
#' @export
gb_get_meta <- gb_get_metadata
