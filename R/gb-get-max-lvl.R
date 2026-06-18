#' Get the highest available ADM level
#'
#' @description
#' Returns a summary of selected country codes and their highest available ADM
#' level in **geoBoundaries**.
#'
#' @inherit gb_get source
#' @inheritParams gb_get_metadata
#'
#' @returns
#' A [tibble][tibble::tbl_df] containing ISO 3166-1 alpha-3 country codes and
#' their highest available ADM levels.
#'
#' @family metadata
#'
#' @export
#' @encoding UTF-8
#'
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") || interactive()
#' all <- gb_get_max_adm_lvl()
#' library(dplyr)
#'
#' # Countries with only one ADM level available.
#' all |>
#'   filter(maxBoundaryType == 1)
#'
#' # Countries with ADM4 available.
#' all |>
#'   filter(maxBoundaryType == 4)
gb_get_max_adm_lvl <- function(
  country = "all",
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative")
) {
  release_type <- match_arg_pretty(release_type)
  country <- gbnds_dev_country2iso(country)
  df <- gb_get_metadata(
    country = country,
    adm_lvl = "all",
    release_type = release_type
  )
  df$rank <- as.integer(as.factor(df$boundaryType))
  res <- tapply(df$rank, df$boundaryISO, max)
  tib <- dplyr::tibble(boundaryISO = names(res), maxBoundaryType = res - 1)
  tib$maxBoundaryType <- as.integer(tib$maxBoundaryType)
  tib
}
