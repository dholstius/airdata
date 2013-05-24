#' read.DMCSV
#'
#' Parse a DMCSV-formatted file
#'
#' @param file          filename
#' @param columns       list: old fieldnames are values; new fieldnames are keys
#' @param omit.EOF      logical: exclude "END OF FILE" line (requires grep)?
#' @param verbose       logical: narrate progress?
#'
#' @export
read.DMCSV <- function(
    file, 
    columns = list(
        latitude = "Latitude",
        longitude = "Longitude",
        datum = "Datum",
        #geo_accuracy = "Horizontal Accuracy",
        state = "State Code",
        county = "County Code",
        site = "Site Num",
        parameter = "Parameter Code",
        #POC = "POC",
        description = "AQS Parameter Desc",
        units = "Units of Measure",
        duration = "Sample Duration",
        #frequency = "Sample Frequency",
        LOD = "Detection Limit",
        uncertainty = "Measurement Uncertainty",
        #qualifier = "Qualifier Description",
        #type = "Method Type",
        method = "Method Description",
        value = "Sample Measurement"
    ), 
    omit.EOF = TRUE,
    verbose = FALSE
) {
    
    require(data.table)
    require(fasttime)
    require(stringr)
    require(plyr)
    
    if (verbose) message("Reading file into memory")
    if (omit.EOF) {
        # Copy to tempfile, excluding "END OF FILE" line
        tmp <- tempfile()
        system(sprintf("grep -v 'END OF FILE' %s > %s", file, tmp))
        dat <- fread(tmp)
        file.remove(tmp)
    } else {
        dat <- fread(file)
    }
    
    # Parse timestamps
    if (verbose) message("Parsing timestamps")
    dat$GMT <- fastPOSIXct(paste(dat$`Date GMT`, dat$`24 Hour GMT`, sep=" "))
    
    # Drop columns
    if (verbose) message("Dropping non-requested columns")
    `%nin%` <- Negate(`%in%`)
    dat[ , which(names(dat) %nin% c("GMT", columns)) := NULL, with=FALSE]
    
    # Rename remaining columns
    if (verbose) message("Renaming columns")
    setnames(dat, old=as.character(columns), new=names(columns))
    
    # Recast remaining columns from character to factor
    # FIXME: requires casting to data.frame and back
    dat <- as.data.frame(dat)
    j <- unname(which(sapply(dat, is.character)))
    dat[,j] <- lapply(dat[,j], factor)
    dat <- data.table(dat)
    
    # Use timestamp column as key
    setkey(dat, "GMT")
    
    return(dat)
}