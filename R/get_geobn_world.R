#' Get global composites data (CGAZ) from geoBoundaries
#'
#' @description
#'
#' [Attribution](https://www.geoboundaries.org/index.html#usage) is required
#' for all uses of this dataset.
#'
#' This function returns a global composite of the required administration
#' level, clipped to international boundaries, with gaps filled between
#' borders.
#'
#' @source
#' geoboundaries API Service <https://www.geoboundaries.org/api.html>.
#'
#' @references
#' Runfola, D. et al. (2020) geoBoundaries: A global database of political
#' administrative boundaries. *PLoS ONE* **15**(4): e0231866.
#' \doi{10.1371/journal.pone.0231866}.
#'
#' @family API functions
#'
#' @return
#' A [`sf`][sf::st_sf] object.
#'
#' @inheritParams get_geobn
#'
#' @param boundary_type Type of boundary Accepted values are the ADM level
#'  (`"ADM0"` is the country boundary, `"ADM1"` is the first level of sub
#'  national boundaries, `"ADM2"` is the second level).
#' @param update_cache A logical whether to update cache. Default is `FALSE`.
#'  When set to `TRUE` it would force a fresh download of the source
#'  `.gpkg` file.
#'
#' @export
#'
#' @details
#' Comprehensive Global Administrative Zones (CGAZ) is a set of global
#' composites for administrative boundaries. There are two important
#' distinctions between our global product and individual country downloads.
#'
#' - Extensive simplification is performed to ensure that file sizes are
#'   small enough to be used in most traditional desktop software.
#' - Disputed areas are removed and replaced with polygons following US
#' Department of State definitions.
#'
#' @examplesIf httr2::is_online()
#'
#' # This download may take some time
#' \dontrun{
#' world <- get_geobn_world()
#'
#' library(ggplot2)
#'
#' ggplot(world) +
#'   geom_sf() +
#'   coord_sf(expand = FALSE) +
#'   labs(caption = "Source: www.geoboundaries.org")
#' }
#'
get_geobn_world <- function(
  boundary_type = c("ADM0", "ADM1", "ADM2"),
  verbose = FALSE,
  update_cache = FALSE,
  cache_dir = NULL
) {
  # Get info of distro in GitHub (commit) and change url
  boundary_type <- match.arg(boundary_type)

  metadat <- get_geobn_adm0("Vatican City", metadata = TRUE)

  baseurl <- metadat$gjDownloadURL[1]
  baseurl <- gsub("/gbOpen.*", "", baseurl)

  fname <- paste0("geoBoundariesCGAZ_", boundary_type, ".gpkg")

  urlend <- paste(baseurl, "CGAZ", fname, sep = "/")

  world <- hlp_get_geobn_sf_single(
    urlend,
    subdir = "CGAZ",
    cache_dir = cache_dir,
    update_cache = update_cache,
    verbose = verbose,
    format = "gpkg"
  )

  tokeep <- setdiff(names(world), "id")

  world <- world[, tokeep]

  world
}
