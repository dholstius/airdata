#' AQDMRS.list
#'
#' Request metadata
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
#' Build a query (and, optionally, evaluate it)
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
#' @param verbose   logical: be chatty?
#' @param eval      logical: be lazy (default) or force immediate evaluation?
#' 
#' @examples \dontrun{
#'   q <- AQDMRS.query(
#'     state = "06",          # California
#'     county = "001",        # Alameda
#'     site = "0011",         # West Oakland
#'     param = "42601",       # Nitric oxide (NO)
#'     bdate = "2012-01-01"
#'   )
#'   NO_data <- eval(q)
#'   q$param <- "42602"
#'   NO2_data <- eval(q)
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
    verbose = TRUE,
    eval = FALSE
) {
    
    # Be lazy, unless eval=TRUE
    args <- expand.args()
    if (!eval) {
        args$eval <- TRUE
        return(as.call(c(AQDMRS.query, args)))
    }
    
    # Convert date arguments to Date objects
    args <- update.list(
        args,
        bdate = format(as.Date(args$bdate), "%Y%m%d"),
        edate = format(as.Date(args$edate), "%Y%m%d")
    )
    
    # Hit the website, and make sure the response was OK
    require(httr)
    args$format <- "DMCSV"
    response <- GET('https://ofmext.epa.gov/AQDMRS/ws/rawData', query=args)
    if (verbose) {
        message("Date range: ", args$bdate, " to ", args$edate)
        message("URL: ", response$url)
    }
    if (response$status_code != 200) {
        warning("Response not OK")
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