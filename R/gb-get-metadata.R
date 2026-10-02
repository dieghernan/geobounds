#' Retrieve boundary metadata from **geoBoundaries**
#'
#' @description
#' Returns boundary metadata from the
#' [**geoBoundaries** API](https://www.geoboundaries.org/api.html).
#'
#' @details
#' This function queries `/api/current` and does not select historical versions.
#' See `vignette("metadata", package = "geobounds")` for column definitions,
#' type conversions, availability, licensing and reproducible workflows.
#'
#' @inheritParams gb_get country adm_lvl release_type
#'
#' @returns
#' A [tibble][tibble::tbl_df] from \CRANpkg{tibble} with one row per matching
#' boundary. Numeric statistics are converted to numeric values,
#' `sourceDataUpdateDate` to [POSIXlt][base::DateTimeClasses] in GMT and
#' `buildDate` to [Date][base::Dates]. Literal `"nan"` values become `NA`.
#'
#' @inherit gb_get source
#' @inherit geobounds-package references
#'
#' @seealso
#' [gb_get()] downloads the boundaries described by the metadata. The
#' [ADM wrappers][gb_get_adm] request a single administrative level.
#' This metadata describes individual country boundaries, not the CGAZ layers
#' returned by [gb_get_world()].
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

#' Query one **geoBoundaries** metadata endpoint
#'
#' @param url A **geoBoundaries** API metadata URL.
#'
#' @returns
#' A [tibble][tibble::tbl_df] from \CRANpkg{tibble} or [`NULL`][base::NULL] when
#' the request fails.
#'
#' @noRd
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
