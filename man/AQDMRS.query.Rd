\name{AQDMRS.query}
\alias{AQDMRS.query}
\title{AQDMRS.query}
\usage{
  AQDMRS.query(...)
}
\arguments{
  \item{}{}
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
  Other AQDMRS: \code{\link{AQDMRS.data}}
}

