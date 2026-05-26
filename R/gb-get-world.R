#' Get global composite files (CGAZ) from geoBoundaries
#'
#' @description
#' [Attribution](https://www.geoboundaries.org/index.html#usage) is required
#' for all uses of this dataset.
#'
#' This function returns global composite files for the required administrative
#' level, clipped to international boundaries, with gaps filled between borders.
#'
#' @details
#' Comprehensive Global Administrative Zones (CGAZ) are global composites for
#' administrative boundaries. Compared with individual country files, the
#' global product uses extensive simplification so file sizes are small enough
#' for most desktop software, removes disputed areas and replaces them with
#' polygons following US Department of State definitions, and fills gaps between
#' borders.
#'
#' @inherit gb_get
#' @inheritParams gb_get
#' @param adm_lvl Type of boundary. Accepted values are administrative
#'   levels 0, 1 and 2 (`"adm0"` is the country boundary, `"adm1"` is the
#'   first level of subnational boundaries, `"adm2"` is the second level and
#'   so on). Upper-case versions (`"ADM1"`) and the number of the level
#'   (`0, 1, 2`) are also accepted.
#'
#' @family API functions
#'
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") || interactive()
#' # This download may take some time.
#' \dontrun{
#' world <- gb_get_world()
#'
#' library(ggplot2)
#'
#' ggplot(world) +
#'   geom_sf() +
#'   coord_sf(expand = FALSE) +
#'   labs(caption = "Source: www.geoboundaries.org")
#' }
#'
#' @export
#' @encoding UTF-8
gb_get_world <- function(
  country = "all",
  adm_lvl = "adm0",
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  adm_lvl <- assert_adm_lvl(adm_lvl, dict = c(paste0("adm", 0:2), 0:2))
  country <- gbnds_dev_country2iso(country)

  # Build the CGAZ download URL.
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

#' @rdname gb_get_world
#' @usage NULL
#' @export
gb_get_cgaz <- gb_get_world
