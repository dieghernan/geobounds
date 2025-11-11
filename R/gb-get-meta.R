#' Get metadata of individual country files from geoBoundaries
#'
#' @description
#'
#' This function returns metadadata of the
#' [geoBoundaries API](https://www.geoboundaries.org/api.html).
#'
#' @return
#' A tibble.
#'
#' @source
#' geoboundaries API Service <https://www.geoboundaries.org/api.html>.
#'
#'
#' @family metadata functions
#'
#' @inheritParams gb_get
#'
#' @export
#'
#' @seealso [gb_get()]
#' @details
#'
#' Equivalent to `gb_get(..., metadata = TRUE)`. See **Details** in [gb_get()].
#'
#' @examplesIf httr2::is_online()
#' # Get ADM4 levels
#'
#' library(dplyr)
#'
#' gb_get_meta(adm_lvl = "ADM4") %>%
#'   glimpse()
#'
gb_get_meta <- function(
  country = "ALL",
  adm_lvl = c("ALL", "ADM0", "ADM1", "ADM2", "ADM3", "ADM4"),
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative")
) {
  release_type <- match.arg(release_type)
  adm_lvl <- match.arg(adm_lvl)

  metadata <- gb_get(
    country = country,
    release_type = release_type,
    adm_lvl = adm_lvl,
    metadata = TRUE
  )

  metadata
}
