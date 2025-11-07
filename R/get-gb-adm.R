#' Get country files from geoBoundaries for a given administration level
#'
#' @description
#'
#' [Attribution](https://www.geoboundaries.org/index.html#usage) is required
#' for all uses of this dataset.
#'
#' These functions are wrappers of [get_gb()] for extracting any
#' given administration level:
#'
#' - `get_gb_adm0()` returns the country boundary.
#' - `get_gb_adm1()` returns first-level administration
#'   boundaries (e.g. States in the United States).
#' - `get_gb_adm2()` returns second-level administration
#'   boundaries (e.g. Counties in the United States).
#' - `get_gb_adm3()` returns third-level administration
#'   boundaries (e.g. towns or cities in some countries).
#' - `get_gb_adm4()` returns fourth-level administration
#'   boundaries.
#'
#' Note that not all countries have the same number of levels.
#'
#' @rdname get_gb_adm
#' @name get_gb_adm
#'
#' @return
#'
#' - With `metadata = FALSE`: A [`sf`][sf::st_sf] object.
#' - With `metadata = TRUE`: A tibble.
#'
#' @source
#' geoboundaries API Service <https://www.geoboundaries.org/api.html>.
#'
#' @references
#' Runfola, D. et al. (2020) geoBoundaries: A global database of political
#' administrative boundaries. *PLOS ONE* 15(4): e0231866.
#' \doi{10.1371/journal.pone.0231866}.
#'
#' @family API functions
#'
#' @inheritParams get_gb
#'
#' @export
#'
#' @details
#'
#' See **Details** in [get_gb()].
#'
#' @examplesIf httr2::is_online()
#'
#' \donttest{
#' lev2 <- get_gb_adm2(
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
get_gb_adm0 <- function(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  metadata = FALSE,
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  get_gb(
    country = country,
    release_type = release_type,
    adm_lvl = "ADM0",
    simplified = simplified,
    metadata = metadata,
    quiet = quiet,
    overwrite = overwrite,
    cache_dir = cache_dir
  )
}

#' @rdname get_gb_adm
#' @export
get_gb_adm1 <- function(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  metadata = FALSE,
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  get_gb(
    country = country,
    release_type = release_type,
    adm_lvl = "ADM1",
    simplified = simplified,
    metadata = metadata,
    quiet = quiet,
    overwrite = overwrite,
    cache_dir = cache_dir
  )
}

#' @rdname get_gb_adm
#' @export
get_gb_adm2 <- function(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  metadata = FALSE,
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  get_gb(
    country = country,
    release_type = release_type,
    adm_lvl = "ADM2",
    simplified = simplified,
    metadata = metadata,
    quiet = quiet,
    overwrite = overwrite,
    cache_dir = cache_dir
  )
}

#' @rdname get_gb_adm
#' @export
get_gb_adm3 <- function(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  metadata = FALSE,
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  get_gb(
    country = country,
    release_type = release_type,
    adm_lvl = "ADM3",
    simplified = simplified,
    metadata = metadata,
    quiet = quiet,
    overwrite = overwrite,
    cache_dir = cache_dir
  )
}

#' @rdname get_gb_adm
#' @export
get_gb_adm4 <- function(
  country,
  simplified = FALSE,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  metadata = FALSE,
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  get_gb(
    country = country,
    release_type = release_type,
    adm_lvl = "ADM4",
    simplified = simplified,
    metadata = metadata,
    quiet = quiet,
    overwrite = overwrite,
    cache_dir = cache_dir
  )
}
