#' Get geoBoundaries data for a given administration level
#'
#' @description
#'
#' [Attribution](https://www.geoboundaries.org/index.html#usage) is required
#' for all uses of this dataset.
#'
#' These functions are wrappers of [get_geobn()] for extracting any
#' given administration level:
#'
#' - `get_geobn_adm0()` returns the country boundary.
#' - `get_geobn_adm1()` returns first-level administration
#'   boundaries (e.g. States in the United States).
#' - `get_geobn_adm2()` returns second-level administration
#'   boundaries (e.g. Counties in the United States).
#' - `get_geobn_adm3()` returns third-level administration
#'   boundaries (e.g. towns or cities in some countries).
#' - `get_geobn_adm3()` returns fourth-level administration
#'   boundaries.
#'
#' Note that not all countries have the same number of levels.
#'
#' @rdname get_geobn_adm
#' @references
#' geoboundaries API Service <https://www.geoboundaries.org/api.html>.
#'
#' Runfola, D. et al. (2020) geoBoundaries: A global database of political
#' administrative boundaries. *PLoS ONE* **15**(4): e0231866.
#' \doi{10.1371/journal.pone.0231866}.
#'
#' @family API functions
#'
#' @inheritParams get_geobn
#'
#' @export
#'
#' @details
#'
#' See **Details** in [get_geobn()].
#'
#' @examplesIf httr2::is_online()
#'
#' \donttest{
#' lev2 <- get_geobn_adm2(
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
get_geobn_adm0 <- function(
  country,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  simplified = FALSE,
  metadata = FALSE,
  verbose = FALSE,
  update_cache = FALSE,
  cache_dir = NULL
) {
  get_geobn(
    country = country,
    release_type = release_type,
    boundary_type = "ADM0",
    simplified = simplified,
    metadata = metadata,
    verbose = verbose,
    update_cache = update_cache,
    cache_dir = cache_dir
  )
}

#' @rdname get_geobn_adm
#' @export
get_geobn_adm1 <- function(
  country,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  simplified = FALSE,
  metadata = FALSE,
  verbose = FALSE,
  update_cache = FALSE,
  cache_dir = NULL
) {
  get_geobn(
    country = country,
    release_type = release_type,
    boundary_type = "ADM1",
    simplified = simplified,
    metadata = metadata,
    verbose = verbose,
    update_cache = update_cache,
    cache_dir = cache_dir
  )
}

#' @rdname get_geobn_adm
#' @export
get_geobn_adm2 <- function(
  country,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  simplified = FALSE,
  metadata = FALSE,
  verbose = FALSE,
  update_cache = FALSE,
  cache_dir = NULL
) {
  get_geobn(
    country = country,
    release_type = release_type,
    boundary_type = "ADM2",
    simplified = simplified,
    metadata = metadata,
    verbose = verbose,
    update_cache = update_cache,
    cache_dir = cache_dir
  )
}

#' @rdname get_geobn_adm
#' @export
get_geobn_adm3 <- function(
  country,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  simplified = FALSE,
  metadata = FALSE,
  verbose = FALSE,
  update_cache = FALSE,
  cache_dir = NULL
) {
  get_geobn(
    country = country,
    release_type = release_type,
    boundary_type = "ADM3",
    simplified = simplified,
    metadata = metadata,
    verbose = verbose,
    update_cache = update_cache,
    cache_dir = cache_dir
  )
}

#' @rdname get_geobn_adm
#' @export
get_geobn_adm4 <- function(
  country,
  release_type = c("gbOpen", "gbHumanitarian", "gbAuthoritative"),
  simplified = FALSE,
  metadata = FALSE,
  verbose = FALSE,
  update_cache = FALSE,
  cache_dir = NULL
) {
  get_geobn(
    country = country,
    release_type = release_type,
    boundary_type = "ADM4",
    simplified = simplified,
    metadata = metadata,
    verbose = verbose,
    update_cache = update_cache,
    cache_dir = cache_dir
  )
}
