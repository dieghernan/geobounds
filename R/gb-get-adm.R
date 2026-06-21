#' Get individual country files for an ADM level
#'
#' @description
#' These functions wrap [gb_get()] for a single ADM level. [gb_get_adm0()]
#' returns country boundaries, [gb_get_adm1()] returns first-level subnational
#' boundaries (for example, states in the United States) and [gb_get_adm2()]
#' returns second-level subnational boundaries (for example, counties in the
#' United States). [gb_get_adm3()], [gb_get_adm4()] and [gb_get_adm5()] return
#' third-, fourth- and fifth-level administrative boundaries, respectively.
#'
#' Not all countries have the same number of ADM levels. Use
#' [gb_get_max_adm_lvl()] to check availability.
#'
#' [Attribution](https://www.geoboundaries.org/index.html#usage) is required
#' whenever these data are used.
#'
#' @details
#' Each individual country file is governed by the license identified in its
#' boundary metadata. See [gb_get_metadata()]. Users should also cite the
#' sources listed in the boundary metadata for each file.
#'
#' @name gb_get_adm
#' @rdname gb_get_adm
#'
#' @inherit gb_get return source references
#' @inheritParams gb_get
#'
#' @seealso [gb_get_metadata()], [gb_get_max_adm_lvl()].
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
#'     caption = "Source: www.geoboundaries.org"
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
