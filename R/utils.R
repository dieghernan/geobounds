assert_adm_lvl <- function(
  adm_lvl,
  dict = c("all", paste0("adm", 0:5), 0:5)
) {
  if (length(adm_lvl) > 1) {
    cli::cli_abort(
      "You can't mix different {.arg adm_lvl}. You entered {.val {adm_lvl}}."
    )
  }
  adm_lvl_clean <- tolower(as.character(adm_lvl))
  if (!adm_lvl_clean %in% dict) {
    cli::cli_abort(
      c(
        "Not a valid {.arg adm_lvl} level code ({.val {adm_lvl_clean}}).",
        "Accepted values are {.val {dict}}."
      )
    )
  }

  # Check if number and return correct adm_lvl format
  if (is.numeric(adm_lvl)) {
    adm_lvl <- paste0("ADM", adm_lvl)
  }
  toupper(adm_lvl)
}

#' Helper function to convert country names to codes
#'
#' @param names A vector of country names or codes.
#'
#' @param out The output code format.
#'
#' @return A vector of country codes.
#'
#' @noRd
gbnds_dev_country2iso <- function(names, out = "iso3c") {
  names[tolower(names) == "antartica"] <- "Antarctica"
  out <- "iso3c"
  if (any(tolower(names) == "all")) {
    return("ALL")
  }

  # Vectorize
  outnames <- lapply(names, function(x) {
    if (grepl("Kosovo", x, ignore.case = TRUE)) {
      return("XKX")
    }
    if (grepl("XKX", x, ignore.case = TRUE)) {
      return("XKX")
    }
    maxname <- max(nchar(x))
    if (maxname > 3) {
      outnames <- countrycode::countryname(x, out, warn = FALSE)
    } else if (maxname == 3) {
      outnames <- countrycode::countrycode(x, "iso3c", out, warn = FALSE)
    } else {
      cli::cli_abort(
        "Invalid country names. Try a vector of names or  ISO3 codes"
      )
    }
    outnames
  })

  outnames <- unlist(outnames)
  linit <- length(outnames)
  outnames2 <- outnames[!is.na(outnames)]
  lend <- length(outnames2)
  if (linit != lend) {
    ff <- names[is.na(outnames)] # nolint
    cli::cli_alert_warning("Some values were not matched unambiguously: {ff}")
    cli::cli_alert_info("Review the names or switch to ISO3 codes.")
  }

  outnames2
}

gbnds_dev_sf_helper <- function(data_sf) {
  # From sf/read.R - https://github.com/r-spatial/sf/blob/master/R/read.R
  set_utf8 <- function(x) {
    n <- names(x)
    Encoding(n) <- "UTF-8"
    to_utf8 <- function(x) {
      if (is.character(x)) {
        Encoding(x) <- "UTF-8"
      }
      x
    }
    structure(lapply(x, to_utf8), names = n)
  }
  # end

  # To UTF-8
  names <- names(data_sf)
  g <- sf::st_geometry(data_sf)
  # Everything as MULTIPOLYGON

  geomtype <- sf::st_geometry_type(g)
  # nocov start
  if (any(geomtype == "POLYGON")) {
    g <- sf::st_cast(g, "MULTIPOLYGON")
  }
  # nocov end

  which_geom <- which(vapply(
    data_sf,
    function(f) {
      inherits(f, "sfc")
    },
    TRUE
  ))

  nm <- names(which_geom)

  data_utf8 <- as.data.frame(
    set_utf8(sf::st_drop_geometry(data_sf)),
    stringsAsFactors = FALSE
  )
  data_utf8 <- dplyr::as_tibble(data_utf8)

  # Regenerate with right encoding
  data_sf <- sf::st_as_sf(data_utf8, g)

  # Rename geometry to original value
  newnames <- names(data_sf)
  newnames[newnames == "g"] <- nm
  colnames(data_sf) <- newnames
  data_sf <- sf::st_set_geometry(data_sf, nm)

  data_sf
}

#' Match argument with pretty error message
#'
#' @param arg The argument to match.
#' @param choices The possible choices for the argument.
#'
#' @returns
#' The matched argument.
#'
#' @noRd
match_arg_pretty <- function(arg, choices) {
  arg_name <- as.character(substitute(arg)) # nolint

  if (missing(choices)) {
    formal_args <- formals(sys.function(sys_par <- sys.parent()))
    choices <- eval(
      formal_args[[as.character(substitute(arg))]],
      envir = sys.frame(sys_par)
    )
  }
  choices <- as.character(choices)

  if (is.null(arg)) {
    return(choices[1L])
  }

  arg <- as.character(arg)

  if (identical(arg, choices)) {
    return(arg[1])
  }

  lmatch <- match(arg, choices)
  # Hint
  aproxmatch <- pmatch(arg, choices)[1]

  if (length(arg) > 1 || is.na(lmatch)) {
    # Create error message
    if (length(choices) == 1) {
      msg <- paste0("{.str ", choices, "}")
    } else {
      l_choices <- length(choices)
      msg <- paste0("{.str ", choices[-l_choices], "}", collapse = ", ")
      msg <- paste0(msg, " or {.str ", choices[l_choices], "}")
      # Add one of at the beginning
      msg <- paste0("one of ", msg)
    }

    msg <- paste0(msg, ", not ")
    bad_arg <- paste0("{.str ", arg, "}", collapse = " or ")
    msg <- paste0(msg, bad_arg, ".")

    # Maybe is a regex?
    reg_msg <- NULL
    if (!is.na(aproxmatch)) {
      aprox <- choices[aproxmatch]
      aprox_val <- paste0("{.str ", aprox, "}", collapse = " or ")
      reg_msg <- paste0("Did you mean ", aprox_val, "?")
    }

    cli::cli_abort(
      c(
        paste0("{.arg {arg_name}} should be ", msg),
        "i" = reg_msg
      ),
      call = NULL
    )
  }

  choices[lmatch]
}
