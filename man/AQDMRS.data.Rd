\name{AQDMRS.data}
\alias{AQDMRS.data}
\title{AQDMRS.data}
\usage{
  AQDMRS.data(state, county, site, param, bdate, edate,
    dur = 1, user = readline("AQDMRS username: "),
    pw = readline("AQDMRS password: "))
}
\arguments{
  \item{state}{Two-digit FIPS state code}

  \item{county}{Three-digit FIPS county code}

  \item{site}{Four-digit AQS site code}

  \item{bdate}{beginning date (see \link{as.Date})}

  \item{edate}{ending date}

  \item{dur}{temporal resolution (1=hourly)}

  \item{user}{AQRDMS username}

  \item{password}{AQRDMS password}
}
\description{
  Fetch data from the AQDMRS gateway.
}
\note{
  Use \link{AQDMRS.query} to construct a lazy query (which
  you can then modify as needed).
}
\examples{
\dontrun{
  AQDMRS.data(
    state = "06",      # California
    county = "001",    # Alameda
    site = "0011",     # West Oakland
    param = "42601"    # NO2
  )
}
}
\references{
  \url{http://www.epa.gov/airdata/tas_URL_Query_Construction_Details_list.html}
}
\seealso{
  Other AQDMRS: \code{\link{AQDMRS.query}}
}

