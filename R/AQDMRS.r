#' AQDMRS.list
#'
#' Metadata interface to the AQDMRS gateway.
#'
#' @param \dots       query arguments
#'
#' @family  AQDMRS
#' @references
#'   \url{http://www.epa.gov/airdata/tas_URL_Query_Construction_Details_list.html}
#'
#' @export
AQDMRS.list <- function (...) {
    require(httr)
    response <- GET(
        'https://ofmext.epa.gov/AQDMRS/ws/list', 
        query = list(resource="rawData", ...)
    )   
    read.csv(
        textConnection(content(response, as="text")),
        sep = "\t", 
        header = FALSE,
        col.names = c("code", "name")
    )
}

#' AQDMRS.query
#'
#' Lazy query-building constructor.
#'
#' @family AQDMRS
#'
#' @param state     Two-digit FIPS state code
#' @param county    Three-digit FIPS county code
#' @param bdate     beginning date (see \link{as.Date})
#' @param edate     ending date
#' @param dur       temporal resolution (1=hourly)
#' @param \dots     (optional) additional query parameters
#' @param user      AQRDMS username
#' @param pw        AQRDMS password
#' @param verbose   logical
#' 
#' @examples \dontrun{
#'   query <- AQDMRS.query(
#'     state = "06",      # California
#'     county = "001",    # Alameda
#'     site = "0011",     # West Oakland
#'   )
#'   WestOakland_NO <- as.data.frame(query, param = "42601")
#'   WestOakland_NO2 <- as.data.frame(query, param = "42602")
#' }
#'
#' @export
AQDMRS.query <- function (
    state,
    county,
    bdate,
    edate = as.Date(bdate) + 1,
    dur = 1,
    ...,
    user = readline("AQDMRS username: "),
    pw = readline("AQDMRS password: "),
    verbose = TRUE
) {
    argnames <- setdiff(names(formals()), list("..."))
    args <- mget(argnames, sys.frame(sys.nframe()))
    dotargs <- as.list(substitute(list(...)))[-1L]
    promise <- as.call(c(quote(AQDMRS.data), c(args, dotargs)))
    class(promise) <- c(class(promise), "AQDMRS.query")
    return(promise)
}

#' AQDMRS.data
#'
#' Fetch data from the AQDMRS gateway.
#'
#' @inheritParams AQDMRS.data
#'
#' @family  AQDMRS
#' @note    Use \link{AQDMRS.query} to construct a lazy query (which you can then modify as needed).
#' @references
#'   \url{http://www.epa.gov/airdata/tas_URL_Query_Construction_Details_list.html}
#'
#' @examples \dontrun{
#'   AQDMRS.data(
#'     state = "06",      # California
#'     county = "001",    # Alameda
#'     site = "0011",     # West Oakland
#'     param = "42601"    # NO2
#'   )
#' }
#'
#' @export
AQDMRS.data <- function(
    ...,
    verbose = TRUE
) {

    # Build query from arguments
    args <- as.list(substitute(list(...)))[-1L]
    args$bdate <- format(as.Date(args$bdate), "%Y%m%d")
    args$edate <- format(as.Date(args$edate), "%Y%m%d")
    args$format <- "DMCSV"
    
    if (verbose) {
        message("Downloading data from ", args$bdate, " to ", args$edate)
    }
    
    # Hit the website, and make sure the response was OK
    require(httr)
    response <- GET('https://ofmext.epa.gov/AQDMRS/ws/rawData', query=args)
    if (verbose) {
        message("URL: ", response$url)
    }
    if (response$status_code != 200) {
        warning("response not OK")
        return(response)
    }

    # Write to a temporary file, then parse
    tmp <- tempfile()
    cat(content(response, as="text"), file=tmp)
    dat <- read.DMCSV(tmp)

    # Tag with URL, and return
    attr(dat, "url") <- response$url
    return(dat)
}