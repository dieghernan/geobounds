metadata_record <- function(iso = "PRT", adm = "ADM0") {
  list(
    boundaryID = paste(iso, adm, sep = "-"),
    boundaryISO = iso,
    boundaryType = adm,
    boundaryLicense = "CC BY 4.0",
    admUnitCount = "2",
    meanAreaSqKM = "nan",
    sourceDataUpdateDate = "Mon Jan 02 03:04:05 2023",
    buildDate = "Jan 03, 2023"
  )
}

local_metadata_responses <- function(responses, env = parent.frame()) {
  withr::local_options(
    httr2_mock = function(req) {
      key <- sub(
        "https://www.geoboundaries.org/api/current/",
        "",
        req$url,
        fixed = TRUE
      )
      if (!key %in% names(responses)) {
        stop("Unexpected metadata request: ", key, call. = FALSE)
      }
      payload <- responses[[key]]
      httr2::response(
        status_code = if (is.null(payload)) 404L else 200L,
        url = req$url,
        headers = list(`content-type` = "application/json"),
        body = charToRaw(jsonlite::toJSON(payload, auto_unbox = TRUE))
      )
    },
    .local_envir = env
  )
}
