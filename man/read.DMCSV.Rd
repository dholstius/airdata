\name{read.DMCSV}
\alias{read.DMCSV}
\title{read.DMCSV}
\usage{
  read.DMCSV(file,
    columns = list(state = "State Code", county = "County Code", site = "Site Num", longitude = "Longitude", latitude = "Latitude", datum = "Datum", parameter = "Parameter Code", description = "AQS Parameter Desc", units = "Units of Measure", value = "Sample Measurement"),
    omit.EOF = TRUE, verbose = FALSE)
}
\arguments{
  \item{file}{filename}

  \item{columns}{list: old fieldnames are values; new
  fieldnames are keys}

  \item{omit.EOF}{logical: exclude "END OF FILE" line
  (requires grep)?}

  \item{verbose}{logical: narrate progress?}
}
\description{
  Parse a DMCSV-formatted file
}

