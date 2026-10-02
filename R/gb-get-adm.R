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
#' Use [gb_get_metadata()] to check availability for the requested country,
#' ADM level and release type.
#'
#' See [gb_get()] for download behavior and licensing, and
#' `vignette("geobounds", package = "geobounds")` for worked examples.
#'
#' @inheritParams gb_get country simplified release_type
#' @inheritParams gb_get quiet overwrite cache_dir
#'
#' @inherit gb_get return
#'
#' @inherit gb_get source
#' @inherit geobounds-package references
#'
#' @seealso
#' [gb_get_metadata()] lists the layers available for a country and release
#' type. [gb_get_max_adm_lvl()] summarizes the highest available ADM level.
#'
#' @name gb_get_adm
#' @rdname gb_get_adm
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
