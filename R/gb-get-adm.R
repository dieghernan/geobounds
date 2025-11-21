#' Get country files from geoBoundaries for a given administration level
#'
#' @description
#'
#' [Attribution](https://www.geoboundaries.org/index.html#usage) is required
#' for all uses of this dataset.
#'
#' These functions are wrappers of [gb_get()] for extracting any
#' given administration level:
#'
#' - `gb_get_adm0()` returns the country boundary.
#' - `gb_get_adm1()` returns first-level administration
#'   boundaries (e.g. States in the United States).
#' - `gb_get_adm2()` returns second-level administration
#'   boundaries (e.g. Counties in the United States).
#' - `gb_get_adm3()` returns third-level administration
#'   boundaries (e.g. towns or cities in some countries).
#' - `gb_get_adm4()` returns fourth-level administration
#'   boundaries.
#' - `gb_get_adm5()` returns fifth-level administration
#'   boundaries.
#'
#' Note that not all countries have the same number of levels. Check
#' [gb_get_max_adm_lvl].
#'
#' @rdname gb_get_adm
#' @name gb_get_adm
#'
#' @return
#' A [`sf`][sf::st_sf] object.
#'
#' @family API functions
#'
#' @inheritParams gb_get
#'
#' @inherit get_gb source references
#'
#' @seealso [gb_get_max_adm_lvl()].
#'
#' @export
#'
#' @details
#'
#' Individual data files in the geoBoundaries database are governed by the
#' license or licenses identified within the metadata for each respective
#' boundary (see [gb_get_metadata()]. Users using individual boundary files
#' from geoBoundaries should additionally ensure that they are citing the
#' sources provided in the metadata for each file.
#'
#' @examplesIf httr2::is_online()
#'
#' \donttest{
#' lev2 <- gb_get_adm2(
#'   c("Italia", "Suiza", "Austria"),
#'   simplified = TRUE
#' )
#'
#'
#' library(ggplot2)
#'
#' ggplot(lev2) +
#'   geom_sf(aes(fill = shapeGroup)) +
#'   labs(
#'     title = "Second-level administration",
#'     subtitle = "Selected countries",
#'     caption = "Source: www.geoboundaries.org"
#'   )
#' }
#'
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
