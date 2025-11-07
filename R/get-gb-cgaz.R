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
#' administrative boundaries. *PLOS ONE* 15(4): e0231866.
#' \doi{10.1371/journal.pone.0231866}.
#'
#' @family API functions
#'
#' @return
#' A [`sf`][sf::st_sf] object.
#'
#' @inheritParams get_gb
#'
#' @param adm_lvl Type of boundary Accepted values are the ADM level
#'  (`"ADM0"` is the country boundary, `"ADM1"` is the first level of sub
#'  national boundaries, `"ADM2"` is the second level).
#' @param overwrite A logical whether to update cache. Default is `FALSE`.
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
#' world <- get_gb_cgaz()
#'
#' library(ggplot2)
#'
#' ggplot(world) +
#'   geom_sf() +
#'   coord_sf(expand = FALSE) +
#'   labs(caption = "Source: www.geoboundaries.org")
#' }
#'
get_gb_cgaz <- function(
  country = "ALL",
  adm_lvl = c("ADM0", "ADM1", "ADM2"),
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  # Get info of distro in GitHub (commit) and change url
  level <- match.arg(adm_lvl)

  # Lightweight, we only need here the url
  metadat <- get_gb_adm0("Vatican City", metadata = TRUE)

  baseurl <- metadat$gjDownloadURL[1]
  baseurl <- gsub("/gbOpen.*", "", baseurl)

  fname <- paste0("geoBoundariesCGAZ_", level, ".gpkg")

  urlend <- paste(baseurl, "CGAZ", fname, sep = "/")

  # Here we need the country, we would use it to filter

  # Country
  if (any(toupper(country) == "ALL")) {
    cgaz_country <- "ALL"
  } else {
    cgaz_country <- gb_helper_countrynames(country)
  }

  verbose <- isFALSE(quiet)

  world <- hlp_get_gb_sf_single(
    urlend,
    subdir = "CGAZ",
    cache_dir = cache_dir,
    overwrite = overwrite,
    verbose = verbose,
    format = "gpkg",
    cgaz_country = cgaz_country
  )

  tokeep <- setdiff(names(world), "id")

  world <- world[, tokeep]

  world
}


# Helper to read gpkg file
read_gpkg_query <- function(file_local, cgaz_country) {
  outsf <- sf::read_sf(file_local)

  if (!("ALL" %in% cgaz_country)) {
    outsf <- outsf[outsf$shapeGroup %in% cgaz_country, ]
  }

  # Adjust CRS just in case, in some OS seems to be problematic
  # nocov start
  if (is.na(sf::st_is_longlat(outsf))) {
    outsf <- sf::st_set_crs(outsf, sf::st_crs(4326))
  }

  # nocov end

  outsf
}
