airdata
=======

Use this package to import official U.S. air quality data from [AirData] into R. You'll need [an AirData username and password](http://www.epa.gov/airdata/tas_Data_Mart_Registration.html).

Seeking comment!

Installation
------------

Install directly from GitHub using [devtools]:

    if (!require("devtools")) install.packages("devtools")
    library("devtools")
    install_github("airdata", "holstius")

Example usage
-------------

    library(airdata)
    
    # 1. Find parameter codes corresponding to "black carbon"
    data(AQDMRS)
    library(stringr)
    subset(AQDMRS.params, str_detect(tolower(name), "black carbon"))

    # 2. Construct a query for a week's worth of hourly data from one site
    query <- AQDMRS.query(
        state = "06",           # California
        county = "001",         # Alameda County
        site = "0011",          # West Oakland site
        bdate = "2012-04-15",   
        edate = "2012-04-23"
    )

    # Modify and evaluate the query for two different parameter codes
    BC_STP <- as.data.frame(query, param = "84313")
    BC_LC  <- as.data.frame(query, param = "88313")

    # Bind the results together
    BC <- rbind(BC_STP, BC_LC)

    # Plot as a timeseries
    library(ggplot2)
    local_tz <- "America/Los_Angeles"
    fig_timeseries <- qplot(
        x = with_tz(GMT, local_tz),
        y = Sample.Measurement, 
        color = AQS.Parameter.Desc, 
        data = BC,
        geom = "line"
    )
    show(fig_timeseries)

    # A little more polished
    library(scales)
    scale_timestamp <- function (
        ...,
        breaks = "1 day", 
        labels = date_format("%a\n%b %d")
    ) {
        scale_x_datetime(..., breaks=breaks, labels=labels)
    }
    show(
        fig_timeseries + 
        ggtitle("West Oakland (AQDMRS #06-001-0011)") +
        scale_timestamp(local_tz) +
        scale_y_continuous(unique(fig_timeseries$data$Units.of.Measure)) +
        theme(legend.position="bottom")
    )

[R]: http://r-project.org "R"
[AQDMRS]: https://ofmext.epa.gov/AQDMRS/aqdmrs.html "AQDMRS"
[devtools]: https://github.com/hadley/devtools "devtools"