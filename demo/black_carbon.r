# How to find and query the code for a particular pollutant ("black carbon")
library(airdata)
library(stringr)

# If you don't supply user="..." and pw="...", you'll be prompted
q <- AQDMRS.query(
    state = "06",           # California
    county = "001",         # Alameda County
    site = "0011",          # West Oakland site
    bdate = "2012-04-15",   
    edate = "2012-04-23"
)

# Find parameter codes corresponding to "black carbon"
AQDMRS.params <- AQDMRS.list(name="param")
subset(AQDMRS.list(name="param"), str_detect(tolower(name), "black carbon"))

# Queries are lazy and can be modified before being evaluated
q$param <- "84313"
BC_data <- eval(q)

# Plot as a timeseries
with(BC_data, plot(GMT, value, main="West Oakland Black Carbon", ylab="ug/m3"))