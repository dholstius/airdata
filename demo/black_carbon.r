library(airdata)

# 1. Find parameter codes corresponding to "black carbon"
data(AQDMRS)
library(stringr)
subset(AQDMRS.params, str_detect(tolower(name), "black carbon"))

# 2. Construct a query for a week's worth of hourly data from one site
BC_data <- AQDMRS.data(
    state = "06",           # California
    county = "001",         # Alameda County
    site = "0011",          # West Oakland site
    param = "84313",        # Black carbon (from step #1 above)
    bdate = "2012-04-15",   
    edate = "2012-04-23"
)

# Plot as a timeseries
with(BC_data, plot(GMT, Sample.Measurement, main="West Oakland Black Carbon", ylab="ug/m3"))