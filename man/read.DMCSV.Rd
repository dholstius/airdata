\name{read.DMCSV}
\alias{read.DMCSV}
\title{read.DMCSV}
\usage{
  read.DMCSV(file, timestamp = TRUE, rename = TRUE,
    simplify = TRUE)
}
\arguments{
  \item{file}{filename}

  \item{timestamp}{logical: parse timestamps?}

  \item{rename}{logical: rename columns?}

  \item{simplify}{logical: drop uninformative columns (all
  NA, for example)}
}
\description{
  Parse a DMCSV-formatted file
}

