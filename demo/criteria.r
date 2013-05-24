# How to fetch and plot criteria pollutant data for multiple sites
library(airdata)

# If you don't supply user="..." and pw="...", you'll be prompted
q <- AQDMRS.query(
    state = "06",           # California
    county = "001",         # Alameda County
    pc = "CRITERIA",
    bdate = "2012-01-01",
    edate = "2012-01-07"
)

# Run the query
crit_data <- eval(q)

# Quick plot by site and pollutant
library(ggplot2)
fig <- qplot(GMT, value, data=crit_data, color=site, geom="line", alpha=I(0.5))
fig <- fig + facet_grid(units + description ~ ., scales="free_y")
show(fig)