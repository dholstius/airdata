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

#' AQDMRS.data
#'
#' Fetch data from the AQDMRS gateway.
#'
#' @param state     Two-digit FIPS state code
#' @param county    Three-digit FIPS county code
#' @param site      Four-digit AQS site code
#' @param bdate     beginning date (see \link{as.Date})
#' @param edate     ending date
#' @param dur       temporal resolution (1=hourly)
#' @param user      AQRDMS username
#' @param password  AQRDMS password
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
    state,
    county, 
    site, 
    param,
    bdate,
    edate,
    dur = 1,
    user = readline("AQDMRS username: "), 
    pw = readline("AQDMRS password: ")
) {
    require(httr)
    message("Downloading data from ", bdate, " to ", edate)
    response <- GET(
        'https://ofmext.epa.gov/AQDMRS/ws/rawData',
        query = list(
            bdate = format(as.Date(bdate), "%Y%m%d"),
            edate = format(as.Date(edate), "%Y%m%d"),
            state = state,
            county = county,
            site = site,
            param = param,
            dur = dur,
            user = user,
            pw = pw,
            format = 'DMCSV'
        )
    )
    if (response$status_code != 200) {
        warning("response not OK")
        return(response)
    }
    txt <- sub("END OF FILE", "", content(response, as="text"))
    dat <- read.csv(
        textConnection(txt), 
        colClasses = list(
            State.Code = "factor",
            County.Code = "factor",
            Site.Num = "factor",
            Parameter.Code = "factor",
            POC = "factor"
        )
    )
    dat <- within(dat, {
        GMT <- as.POSIXct(
            paste(Date.GMT, X24.Hour.GMT, sep=" "), 
            tz = "GMT",
            format = '%Y-%m-%d %H:%M'
        )
        Date.Local <- X24.Hour.Local <- NULL
        Date.GMT <- X24.Hour.GMT <- Day.In.Year.GMT <- NULL
    })
    class(dat) <- c(class(dat), "AQDMRS")
    attr(dat, "url") <- response$url
    return(dat)
}

#' AQDMRS.query
#'
#' Lazy query-building constructor.
#'
#' @inheritParams AQDMRS.data
#'
#' @family AQDMRS
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
AQDMRS.query <- function (...) {
    args <- as.list(substitute(list(...)))[-1L]
    promise <- as.call(c(quote(AQDMRS.data), args))
    class(promise) <- c(class(promise), "AQDMRS.query")
    return(promise)
}

#' @family AQDMRS
#' 
#' @export
as.data.frame.AQDMRS.query <- function(x, ...) {
    args <- as.list(substitute(list(...)))[-1L]
    for (key in names(args)) {
        x[[key]] <- args[[key]]
    } 
    return(eval(x))
}