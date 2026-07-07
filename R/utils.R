#' Validate an ADM level
#'
#' @param adm_lvl An ADM level to validate.
#' @param dict Accepted values for `adm_lvl`.
#' @param call The call to display in the error message.
#'
#' @returns
#' A character scalar containing the validated ADM level in uppercase format.
#'
#' @noRd
assert_adm_lvl <- function(
  adm_lvl,
  dict = c("all", paste0("adm", 0:5), 0:5),
  call = parent.frame()
) {
  if (length(adm_lvl) > 1) {
    cli::cli_abort(
      "Use a single {.arg adm_lvl} value. You supplied {.val {adm_lvl}}.",
      call = call
    )
  }
  adm_lvl_clean <- tolower(as.character(adm_lvl))
  if (!adm_lvl_clean %in% dict) {
    cli::cli_abort(
      c(
        "Invalid {.arg adm_lvl} value: {.val {adm_lvl_clean}}.",
        "Accepted values are {.or {.val {dict}}}."
      ),
      call = call
    )
  }

  # Convert numeric levels to the ADM code format.
  if (is.numeric(adm_lvl)) {
    adm_lvl <- paste0("ADM", adm_lvl)
  }
  toupper(adm_lvl)
}

#' Build an HTTP request
#'
#' @param url A URL to request.
#' @param quiet A logical value. If `TRUE`, do not show request progress.
#'
#' @returns
#' An \CRANpkg{httr2} request object.
#'
#' @noRd
gb_hlp_request <- function(url, quiet = TRUE) {
  q <- httr2::request(url)
  q <- httr2::req_error(q, is_error = function(x) {
    FALSE
  })
  q <- httr2::req_retry(q, max_tries = 3, is_transient = function(resp) {
    httr2::resp_status(resp) %in% c(429, 500, 503)
  })

  if (quiet) {
    return(q)
  }

  httr2::req_progress(q)
}

#' Format an HTTP status
#'
#' @param resp An \CRANpkg{httr2} response object.
#'
#' @returns
#' A character scalar containing the HTTP status code and description.
#'
#' @noRd
gb_hlp_http_error <- function(resp) {
  paste0(
    c(httr2::resp_status(resp), httr2::resp_status_desc(resp)),
    collapse = " - "
  )
}

#' Report an HTTP request error
#'
#' @param url The URL used for the failed request.
#' @param resp An \CRANpkg{httr2} response object.
#'
#' @returns
#' Invisibly returns `NULL`. This function is called for its side effects.
#'
#' @noRd
gb_hlp_alert_http_error <- function(url, resp) {
  cli::cli_alert_danger(paste0(
    "Request to {.url {url}} failed with HTTP status ",
    "{.field {gb_hlp_http_error(resp)}}."
  ))
}

#' Return unique non-missing values
#'
#' @param x A vector.
#'
#' @returns
#' A vector containing the unique non-missing values in `x`.
#'
#' @noRd
gb_hlp_unique_values <- function(x) {
  x <- unique(x)
  x[!is.na(x)]
}

#' Select a shapefile from an archive listing
#'
#' @param files A character vector of file paths.
#' @param simplified A logical value. If `TRUE`, select simplified shapefiles.
#'
#' @returns
#' A character vector containing matching shapefile paths.
#'
#' @noRd
gb_hlp_select_shapefile <- function(files, simplified = FALSE) {
  shp_files <- files[grepl("shp$", files)]
  simplified_file <- grepl("simplified", shp_files, fixed = TRUE)

  if (simplified) {
    return(shp_files[simplified_file])
  }

  shp_files[!simplified_file]
}

#' Convert selected columns to numeric
#'
#' @param data A data frame.
#' @param cols A character vector of column names to convert.
#'
#' @returns
#' `data` with matching columns converted to numeric vectors.
#'
#' @noRd
gb_hlp_as_numeric <- function(data, cols) {
  cols <- intersect(cols, names(data))
  data[cols] <- lapply(data[cols], as.numeric)
  data
}

#' Parse API date-time values
#'
#' @param x A character vector of date-time values returned by the API.
#'
#' @returns
#' A `POSIXlt` vector parsed in the GMT time zone.
#'
#' @noRd
gb_hlp_parse_api_datetime <- function(x) {
  x <- trimws(gsub("Mon|Tue|Wed|Thu|Fri|Sat|Sun", "", x))
  x <- gb_hlp_replace_month_abbr(x)
  strptime(x, "%m %d %H:%M:%S %Y", tz = "GMT")
}

#' Parse API date values
#'
#' @param x A character vector of date values returned by the API.
#'
#' @returns
#' A `Date` vector.
#'
#' @noRd
gb_hlp_parse_api_date <- function(x) {
  x <- gb_hlp_replace_month_abbr(x)
  x <- gsub(",", "", x, fixed = TRUE)
  as.Date(x, "%m %d %Y")
}

#' Replace month abbreviations with numbers
#'
#' @param x A character vector containing English month abbreviations.
#'
#' @returns
#' A character vector with month abbreviations replaced by two-digit month
#' numbers.
#'
#' @noRd
gb_hlp_replace_month_abbr <- function(x) {
  mnum <- sprintf("%02d", seq_along(month.abb))

  for (i in seq_along(month.abb)) {
    x <- gsub(month.abb[i], mnum[i], x)
  }

  x
}

#' Convert country names to codes
#'
#' @param names A vector of country names or codes.
#' @param out The output code format.
#' @param call The call to display in the error message.
#'
#' @returns
#' A vector of country codes.
#'
#' @noRd
gbnds_dev_country2iso <- function(names, out = "iso3c", call = parent.frame()) {
  names[tolower(names) == "antartica"] <- "Antarctica"
  out <- "iso3c"
  if (any(tolower(names) == "all")) {
    return("ALL")
  }

  # Vectorize country name conversion.
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
        paste0(
          "Invalid values for {.arg country}. Use country names or ",
          "ISO 3166-1 alpha-3 codes."
        ),
        call = call
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
    cli::cli_alert_warning(paste0(
      "Some values supplied to {.arg country} could not be matched ",
      "unambiguously: ",
      "{.val {ff}}."
    ))
    cli::cli_alert_info(paste0(
      "Review the values or use ISO 3166-1 alpha-3 ",
      "codes."
    ))
  }

  outnames2
}

#' Standardize a simple features object
#'
#' @param data_sf An [sf][sf::st_sf] object from \CRANpkg{sf}.
#'
#' @returns
#' An [sf][sf::st_sf] object from \CRANpkg{sf} with character fields encoded as
#' UTF-8 and polygon geometries cast to multipolygons.
#'
#' @noRd
gbnds_dev_sf_helper <- function(data_sf) {
  # Adapted from sf/read.R:
  # https://github.com/r-spatial/sf/blob/master/R/read.R
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
  # End adapted code.

  # Convert names and character columns to UTF-8.
  names <- names(data_sf)
  g <- sf::st_geometry(data_sf)
  # Cast polygon geometries to multipolygons.

  geomtype <- sf::st_geometry_type(g)

  if (any(geomtype == "POLYGON")) {
    g <- sf::st_cast(g, "MULTIPOLYGON")
  }

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

  # Regenerate the simple features object with the corrected encoding.
  data_sf <- sf::st_as_sf(data_utf8, g)

  # Restore the original geometry column name.
  newnames <- names(data_sf)
  newnames[newnames == "g"] <- nm
  colnames(data_sf) <- newnames
  data_sf <- sf::st_set_geometry(data_sf, nm)

  data_sf
}

#' Match an argument with a clear error message
#'
#' @param arg The argument to match.
#' @param choices The possible choices for the argument.
#' @param call The call to display in the error message.
#'
#' @returns
#' The matched argument.
#'
#' @noRd
match_arg_pretty <- function(arg, choices, call = parent.frame()) {
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
  # Compute a suggested match for the error message.
  aproxmatch <- pmatch(arg, choices)[1]

  if (length(arg) > 1 || is.na(lmatch)) {
    # Create the expected value error message.
    if (length(choices) == 1) {
      msg <- paste0("{.str ", choices, "}")
    } else {
      l_choices <- length(choices)
      msg <- paste0("{.str ", choices[-l_choices], "}", collapse = ", ")
      msg <- paste0(msg, " or {.str ", choices[l_choices], "}")
      # Add "one of" before multiple valid choices.
      msg <- paste0("one of ", msg)
    }

    msg <- paste0(msg, ", not ")
    bad_arg <- paste0("{.str ", arg, "}", collapse = " or ")
    msg <- paste0(msg, bad_arg, ".")

    # Suggest a partial match when possible.
    reg_msg <- NULL
    if (!is.na(aproxmatch)) {
      aprox <- choices[aproxmatch]
      aprox_val <- paste0("{.str ", aprox, "}", collapse = " or ")
      reg_msg <- paste0("Did you mean ", aprox_val, "?")
    }

    cli::cli_abort(
      c(paste0("{.arg {arg_name}} must be ", msg), "i" = reg_msg),
      call = call
    )
  }

  choices[lmatch]
}

#' Abort unless every condition is true
#'
#' @param ... Named logical conditions. Each name is the error message emitted
#'   when that condition is not true.
#' @param call The call to display in the error message.
#' @param .envir The environment used to evaluate \CRANpkg{cli} expressions.
#' @param .frame The throwing context passed to [cli::cli_abort()] from
#'   \CRANpkg{cli}.
#'
#' @returns
#' `NULL`, invisibly, when every condition is true.
#'
#' @noRd
gb_abort_if_not <- function(
  ...,
  call = .envir,
  .envir = parent.frame(),
  .frame = .envir
) {
  checks <- list(...)
  messages <- names(checks)

  if (length(checks) == 0L) {
    return(invisible(NULL))
  }

  if (is.null(messages) || !all(nzchar(messages))) {
    cli::cli_abort(
      "Every condition supplied to {.fn gb_abort_if_not} must be named.",
      call = call,
      .envir = .envir,
      .frame = .frame
    )
  }

  passed <- vapply(
    checks,
    function(condition) {
      length(condition) > 0L && isTRUE(all(condition))
    },
    logical(1)
  )

  failed <- which(!passed)
  if (length(failed) > 0L) {
    cli::cli_abort(
      messages[[failed[[1L]]]],
      call = call,
      .envir = .envir,
      .frame = .frame
    )
  }

  invisible(NULL)
}
