\name{read.DMCSV}
\alias{read.DMCSV}
\title{read.DMCSV}
\usage{
  read.DMCSV(file,
    columns = list(latitude = "Latitude", longitude = "Longitude", datum = "Datum", geo_accuracy = "Horizontal Accuracy", state = "State Code", county = "County Code", site = "Site Num", parameter = "Parameter Code", POC = "POC", description = "AQS Parameter Desc", units = "Units of Measure", duration = "Sample Duration", frequency = "Sample Frequency", LOD = "Detection Limit", uncertainty = "Measurement Uncertainty", qualifier = "Qualifier Description", type = "Method Type", method = "Method Description", value = "Sample Measurement"),
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

