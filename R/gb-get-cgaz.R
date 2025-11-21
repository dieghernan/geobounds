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
#' @inherit get_gb source references
#'
#' @family API functions
#'
#' @return
#' A [`sf`][sf::st_sf] object.
#'
#' @inheritParams gb_get
#'
#' @param adm_lvl Type of boundary Accepted values are administrative
#'  levels 0, 1 and 2 (`"adm0"` is the country boundary,
#'  `"adm1"` is the first level of sub national boundaries, `"adm2"` is the
#'  second level and so on. Upper case version (`"ADM1"`) and the number of
#'  the level (`0, 1, 2`) and also accepted.
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
#'   Department of State definitions.
#'
#' @examplesIf httr2::is_online()
#'
#' # This download may take some time
#' \dontrun{
#' world <- gb_get_cgaz()
#'
#' library(ggplot2)
#'
#' ggplot(world) +
#'   geom_sf() +
#'   coord_sf(expand = FALSE) +
#'   labs(caption = "Source: www.geoboundaries.org")
#' }
#'
gb_get_cgaz <- function(
  country = "all",
  adm_lvl = "adm0",
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  adm_lvl <- assert_adm_lvl(adm_lvl, dict = c(paste0("adm", 0:2), 0:2))
  country <- gbnds_dev_country2iso(country)

  # Get from repo
  baseurl <- paste0(
    "https://github.com/wmgeolab/geoBoundaries/",
    "raw/main/releaseData"
  )

  fname <- paste0("geoBoundariesCGAZ_", adm_lvl, ".zip")

  urlend <- paste(baseurl, "CGAZ", fname, sep = "/")

  world <- gbnds_dev_shp_query(
    urlend,
    subdir = "CGAZ",
    cache_dir = cache_dir,
    overwrite = overwrite,
    quiet = quiet,
    cgaz_country = country,
    simplified = FALSE
  )

  tokeep <- setdiff(names(world), "id")

  world <- world[, tokeep]

  world
}
