#' read.DMCSV
#'
#' Parse a DMCSV-formatted file
#'
#' @param file 			filename
#' @param timestamp 	logical: parse timestamps?
#' @param rename 		logical: rename columns?
#' @param simplify		logical: drop uninformative columns (all NA, for example)
#'
#' @export
read.DMCSV <- function(file, timestamp=TRUE, rename=TRUE, simplify=TRUE) {

	require(data.table)
	require(fasttime)
	require(stringr)

    # Drop last two lines (just contains "END OF FILE" and "")
    lines <- readLines(file)
    txt <- paste(lines[-(length(lines) - 1)], sep="\n")
    
    # Parse, treating "numeric" codes as factors
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

    # Parse timestamps, then erase redundant fields
    if (timestamp) {
	    dat <- within(dat, {
	        GMT <- paste(Date.GMT, X24.Hour.GMT, sep=" ")
	        GMT <- fastPOSIXct(GMT)
	        Date.Local <- X24.Hour.Local <- NULL
	        Date.GMT <- X24.Hour.GMT <- Day.In.Year.GMT <- Year.GMT <- NULL
	        Horizontal.Accuracy <- NULL
	    })
	}

	dat <- data.table(dat)
	if (timestamp) 
		setkey(dat, "GMT")
	
	if (rename) {
		setnames(dat, 
			old = c("State.Code", "County.Code", "Site.Num"),
			new = c("State", "County", "Site")
		)
		setnames(dat,
		 	old = c("Parameter.Code", "POC", "AQS.Parameter.Desc", "Sample.Measurement"),
		 	new = c("Param", "POC", "Description", "value")
		)
		setnames(dat,
			old = c("Units.of.Measure", "Sample.Duration", "Sample.Frequency"),
			new = c("Units", "Duration", "Frequency")
		)
		setnames(dat,
			old = c("Detection.Limit", "Measurement.Uncertainty", "Qualifier.Description"),
			new = c("LOD", "Uncertainty", "Qualifier")
		)
		setnames(dat, 
			old = c("Method.Description"),
			new = c("Method")
		)
		dat$Method.Type <- NULL
		dat$Units <- str_replace(dat$Units, "Parts per billion", "ppb")
	}
	
	if (simplify) {
		i <- sapply(dat, function(x) all(is.na(x)))
		attr(dat, "metadata") <- lapply(as.list(dat[1,which(i),with=FALSE]), as.character)
		for (j in which(i)) {
			dat[,j] <- NULL
		}
	}

	return(dat)
}