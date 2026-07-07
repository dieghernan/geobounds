#' Download country boundaries for one ADM level
#'
#' @description
#' These functions call [gb_get()] for a single ADM level. [gb_get_adm0()]
#' returns country boundaries, [gb_get_adm1()] returns first-level subnational
#' boundaries (for example, states in the United States) and [gb_get_adm2()]
#' returns second-level subnational boundaries (for example, counties in the
#' United States). [gb_get_adm3()], [gb_get_adm4()] and [gb_get_adm5()] return
#' third-, fourth- and fifth-level administrative boundaries, respectively.
#'
#' Not all countries have the same number of ADM levels. Use
#' [gb_get_max_adm_lvl()] to check availability.
#'
#' Boundaries downloaded through these functions are not covered by the
#' package's MIT license.
#' [Attribution](https://www.geoboundaries.org/index.html#usage) to
#' **geoBoundaries** and the original sources is required when sharing the
#' boundaries or derived products.
#'
#' @details
#' Each individual country boundary layer is governed by the original license
#' identified in its boundary metadata. See [gb_get_metadata()]. Users should
#' cite the sources listed in the metadata and comply with any attribution,
#' share-alike or non-commercial terms.
#'
#' @name gb_get_adm
#' @rdname gb_get_adm
#'
#' @inherit gb_get return source references
#' @inheritParams gb_get
#'
#' @seealso
#' - [gb_get_metadata()] inspects boundary metadata and licensing.
#' - [gb_get_max_adm_lvl()] checks available ADM levels.
#'
#' @family api
#'
#' @export
#' @encoding UTF-8
#'
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") || interactive()
#' \donttest{
#' lev2 <- gb_get_adm2(
#'   c("Italia", "Suiza", "Austria"),
#'   simplified = TRUE
#' )
#'
#' library(ggplot2)
#'
#' ggplot(lev2) +
#'   geom_sf(aes(fill = shapeGroup)) +
#'   labs(
#'     title = "Second-level administrative boundaries",
#'     subtitle = "Selected countries",
#'     caption = paste(
#'       "Sources: geoBoundaries and the original boundary providers,",
#'       "check gb_get_metadata() for licenses"
#'     )
#'   )
#' }
gb_get_adm0 <- function(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  gb_get(
    country = country,
    release_type = release_type,
    adm_lvl = "ADM0",
    simplified = simplified,
    quiet = quiet,
    overwrite = overwrite,
    cache_dir = cache_dir
  )
}

#' @rdname gb_get_adm
#' @export
gb_get_adm1 <- function(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  gb_get(
    country = country,
    release_type = release_type,
    adm_lvl = "ADM1",
    simplified = simplified,
    quiet = quiet,
    overwrite = overwrite,
    cache_dir = cache_dir
  )
}

#' @rdname gb_get_adm
#' @export
gb_get_adm2 <- function(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  gb_get(
    country = country,
    release_type = release_type,
    adm_lvl = "ADM2",
    simplified = simplified,
    quiet = quiet,
    overwrite = overwrite,
    cache_dir = cache_dir
  )
}

#' @rdname gb_get_adm
#' @export
gb_get_adm3 <- function(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  gb_get(
    country = country,
    release_type = release_type,
    adm_lvl = "ADM3",
    simplified = simplified,
    quiet = quiet,
    overwrite = overwrite,
    cache_dir = cache_dir
  )
}

#' @rdname gb_get_adm
#' @export
gb_get_adm4 <- function(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  gb_get(
    country = country,
    release_type = release_type,
    adm_lvl = "ADM4",
    simplified = simplified,
    quiet = quiet,
    overwrite = overwrite,
    cache_dir = cache_dir
  )
}

#' @rdname gb_get_adm
#' @export
gb_get_adm5 <- function(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  gb_get(
    country = country,
    release_type = release_type,
    adm_lvl = "ADM5",
    simplified = simplified,
    quiet = quiet,
    overwrite = overwrite,
    cache_dir = cache_dir
  )
}
