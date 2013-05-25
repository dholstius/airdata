\name{expand.args}
\alias{expand.args}
\title{expand.args}
\usage{
  expand.args()
}
\description{
  Return positional, named, and optional (...) arguments
  from within a function
}
\examples{
f <- function(a, b=2, ..., z=26) {
   expand.args()
}
> f(1, j=10)
}

