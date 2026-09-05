#' Find the highest available ADM level
#'
#' @description
#' Returns a summary of selected country codes and their highest available ADM
#' level in **geoBoundaries**.
#'
#' @inheritParams gb_get country release_type
#'
#' @returns
#' A [tibble][tibble::tbl_df] from \CRANpkg{tibble} containing ISO 3166-1
#' alpha-3 country codes and their highest available ADM levels.
#'
#' @inherit gb_get source
#'
#' @seealso
#' [gb_get()] downloads boundaries for the available ADM levels.
#' The [ADM wrappers][gb_get_adm] request a single administrative level.
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
#' # Countries whose highest available level is ADM1.
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

  if (nrow(df) == 0L) {
    return(dplyr::tibble(
      boundaryISO = character(),
      maxBoundaryType = integer()
    ))
  }

  required_cols <- c("boundaryISO", "boundaryType")
  valid_cols <- all(required_cols %in% names(df))
  valid_levels <- valid_cols &&
    is.character(df$boundaryType) &&
    !anyNA(df$boundaryType) &&
    all(grepl("^ADM[0-9]+$", df$boundaryType))
  valid_iso <- valid_cols &&
    is.character(df$boundaryISO) &&
    !anyNA(df$boundaryISO) &&
    all(nzchar(df$boundaryISO))
  gb_abort_if_not(
    "Boundary metadata contains invalid country codes." = valid_iso,
    "Boundary metadata contains invalid ADM levels." = valid_levels
  )

  adm_number <- as.integer(sub("^ADM", "", df$boundaryType))
  max_level <- tapply(adm_number, df$boundaryISO, max)
  dplyr::tibble(
    boundaryISO = names(max_level),
    maxBoundaryType = as.integer(max_level)
  )
}
