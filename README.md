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

    demo("black_carbon", package="airdata")

[R]: http://r-project.org "R"
[AQDMRS]: https://ofmext.epa.gov/AQDMRS/aqdmrs.html "AQDMRS"
[devtools]: https://github.com/hadley/devtools "devtools"