#' Download global composite boundaries from **geoBoundaries**
#'
#' @description
#' Returns global composite boundaries for the requested ADM level. Boundaries
#' are clipped to international borders, with gaps between borders filled.
#'
#' Always acknowledge **geoBoundaries** and follow the terms in the
#' CGAZ archive.
#'
#' @details
#' CGAZ uses extensive simplification and standardizes disputed areas. See
#' `vignette("geobounds", package = "geobounds")` for product differences.
#' Archives come from the repository's `main` branch and historical versions
#' cannot be selected. See
#' `vignette("metadata", package = "geobounds")` for provenance.
#'
#' @inheritParams gb_get quiet overwrite cache_dir
#' @param country A character vector of country names or ISO 3166-1 alpha-3
#'   codes. Use `"all"` to return all countries. The complete global layer is
#'   downloaded and read before filtering, so country selection does not reduce
#'   the initial download size or the memory needed to read it.
#' @param adm_lvl ADM level. Accepted values are levels 0, 1 and 2 (`"adm0"` is
#'   the country boundary, `"adm1"` is the first level of subnational
#'   boundaries and `"adm2"` is the second level). Uppercase versions
#'   (`"ADM1"`) and level numbers (`0`, `1`, `2`) are also accepted, including
#'   numbers supplied as text (for example, `"1"`).
#'
#' @inherit gb_get return
#'
#' @source
#' - **geoBoundaries** global downloads:
#'   <https://www.geoboundaries.org/globalDownloads.html>.
#' - CGAZ release files:
#'   <https://github.com/wmgeolab/geoBoundaries/tree/main/releaseData/CGAZ>.
#'
#' @inherit geobounds-package references
#'
#' @seealso
#' [gb_get()] downloads individual country boundaries instead of CGAZ layers.
#' [gb_set_cache_dir()] configures where downloaded archives are cached.
#' See `vignette("geobounds", package = "geobounds")` for a comparison
#' of individual country boundaries and global composites.
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
  valid_cache_dir <- is.null(cache_dir)
  if (!valid_cache_dir) {
    valid_cache_dir <- is.character(cache_dir) &&
      length(cache_dir) == 1L &&
      !is.na(cache_dir) &&
      nzchar(cache_dir)
  }
  valid_overwrite <- isTRUE(overwrite) || isFALSE(overwrite)
  valid_quiet <- isTRUE(quiet) || isFALSE(quiet)

  gb_abort_if_not(
    "{.arg overwrite} must be TRUE or FALSE." = valid_overwrite,
    "{.arg quiet} must be TRUE or FALSE." = valid_quiet,
    "{.arg cache_dir} must be NULL or nonempty text, not NA." = valid_cache_dir
  )

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

  if (is.null(world) || nrow(world) == 0L) {
    return(NULL)
  }

  tokeep <- setdiff(names(world), "id")

  world <- world[, tokeep]

  world
}

#' @rdname gb_get_world
#' @usage NULL
#' @export
gb_get_cgaz <- gb_get_world
