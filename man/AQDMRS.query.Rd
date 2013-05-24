\name{AQDMRS.query}
\alias{AQDMRS.query}
\title{AQDMRS.query}
\usage{
  AQDMRS.query(state, county, bdate,
    edate = as.Date(bdate) + 1, dur = 1, ...,
    user = readline("AQDMRS username: "),
    pw = readline("AQDMRS password: "), verbose = TRUE)
}
\arguments{
  \item{state}{Two-digit FIPS state code}

  \item{county}{Three-digit FIPS county code}

  \item{bdate}{beginning date (see \link{as.Date})}

  \item{edate}{ending date}

  \item{dur}{temporal resolution (1=hourly)}

  \item{\dots}{(optional) additional query parameters}

  \item{user}{AQRDMS username}

  \item{pw}{AQRDMS password}

  \item{verbose}{logical}
}
\description{
  Lazy query-building constructor.
}
\examples{
\dontrun{
  query <- AQDMRS.query(
    state = "06",      # California
    county = "001",    # Alameda
    site = "0011",     # West Oakland
  )
  WestOakland_NO <- as.data.frame(query, param = "42601")
  WestOakland_NO2 <- as.data.frame(query, param = "42602")
}
}
\seealso{
  Other AQDMRS: \code{\link{AQDMRS.data}},
  \code{\link{AQDMRS.list}}
}

