library(httr)
library(stringr)

AQDMRS.params <- local({
	response <- GET(
    	'https://ofmext.epa.gov/AQDMRS/ws/list', 
    	query = list(name="param", resource="rawData")
	)	
	read.csv(
    	textConnection(content(response, as="text")),
    	sep="\t", header=FALSE, col.names=c("code", "name")
	)
})