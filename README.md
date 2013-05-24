README
======

Use this package to import official U.S. air quality data from [AirData] into R. Seeking comment!

Installation
------------

Install directly from GitHub using [devtools]:

    if (!require("devtools")) install.packages("devtools")
    library("devtools")
    install_github("airdata", "holstius")

Example usage
-------------

A typical query might start with a pollutant of interest. Here's how to identify the *parameter code* for such a pollutant:

    # Fetch all existing parameter codes
    params <- AQDMRS.list(name="param")
    
    # Find just the one(s) corresponding to a search phrase
    library(stringr)
    phrase <- "black carbon"
    show(subset(params, str_detect(tolower(name), phrase)))

There are two such codes. `LC (88313)` means "local conditions" and `STP (84313)` means "standard temperature and pressure". You can use either, although a particular site might record data for only one of the two. In this case, `STP` is what we want.

Before executing a query, you'll need an [AirData username and password](http://www.epa.gov/airdata/tas_Data_Mart_Registration.html). Then you can do the following:

    # If you don't supply user="..." and pw="...", you'll be prompted
    q <- AQDMRS.query(
        state = "06",           # California
        county = "001",         # Alameda County
        site = "0011",          # West Oakland site
        bdate = "2012-04-15",   
        edate = "2012-04-23",
        param = "84313"
    )
    BC_STP <- eval(q)

Queries are *lazy* and can me modified before being evaluated, or recycled after evaluation. This is handy, because you don't have to type common parameters more than once:

    q$param <- "88313"
    BC_LC <- eval(q)

And, if you like, you can specify `user=...` and `pw=...` in the query, rather than entering them interactively.
 
A quick time-series plot:

    with(BC_STP, plot(GMT, value, main="West Oakland BC", ylab="ug/m3 (STP)"))

More demos:

    demo("criteria", package="airdata")
    demo("black_carbon", package="airdata")

[R]: http://r-project.org "R"
[AirData]: https://ofmext.epa.gov/AQDMRS/aqdmrs.html "AQDMRS"
[devtools]: https://github.com/hadley/devtools "devtools"