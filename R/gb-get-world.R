#' Download global composite boundaries from **geoBoundaries**
#'
#' @description
#' Returns global composite boundaries for the requested ADM level. Boundaries
#' are clipped to international borders, with gaps between borders filled.
#'
#' CGAZ data are not covered by the package's MIT license.
#' [Attribution](https://www.geoboundaries.org/index.html#usage) is required
#' when sharing the data or derived products.
#'
#' @details
#' Comprehensive Global Administrative Zones (CGAZ) are global composites for
#' administrative boundaries. Compared with individual country boundary files,
#' global composite boundaries use extensive simplification so file sizes are
#' small enough for most desktop software. They remove disputed areas, replace
#' them with polygons following US Department of State definitions and fill
#' gaps between borders.
#'
#' Follow the citation and use information included in the downloaded CGAZ
#' archive. CGAZ and figures derived from it are not relicensed under the
#' package's MIT License.
#'
#' @inherit gb_get return source references
#' @inheritParams gb_get
#' @param adm_lvl ADM level. Accepted values are levels 0, 1 and 2 (`"adm0"` is
#'   the country boundary, `"adm1"` is the first level of subnational
#'   boundaries and `"adm2"` is the second level). Uppercase versions
#'   (`"ADM1"`) and level numbers (`0`, `1`, `2`) are also accepted.
#'
#' @seealso
#' - [gb_get_metadata()] inspects boundary metadata and licensing.
#' - [gb_get_max_adm_lvl()] checks the ADM levels available for individual
#'   country boundaries.
#'
#' @family api
#'
#' @export
#' @encoding UTF-8
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
#'   labs(caption = "Source: geoBoundaries (CGAZ)")
#' }
gb_get_world <- function(
  country = "all",
  adm_lvl = "adm0",
  quiet = TRUE,
  overwrite = FALSE,
  cache_dir = NULL
) {
  adm_lvl <- assert_adm_lvl(adm_lvl, dict = c(paste0("adm", 0:2), 0:2))
  country <- gbnds_dev_country2iso(country)

  gb_abort_if_not(
    "{.arg overwrite} must be a {.cls logical}." = is.logical(overwrite),
    "{.arg quiet} must be a {.cls logical}." = is.logical(quiet)
  )

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
