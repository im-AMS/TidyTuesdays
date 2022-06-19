### [2022 Week 24:](https://github.com/im-AMS/TidyTuesdays/blob/main/Plots/2022/W24) Drought Conditions in the US

![./Plots/2022/W24/W24.gif](https://github.com/im-AMS/TidyTuesdays/blob/main/Plots/2022/W24/W24.gif)


# Drought Conditions in the US

The data this week comes from the [National Integrated Drought Information System](https://www.drought.gov/). 

This [web page](https://www.drought.gov/historical-information?dataset=1&selectedDateUSDM=20110301&selectedDateSpi=19580901) provides more information about the drought conditions data.

> The Standardized Precipitation Index (SPI) is an index to characterize meteorological drought on a range of timescales, ranging from 1 to 72 months, for the lower 48 U.S. states. The SPI is the number of standard deviations that observed cumulative precipitation deviates from the climatological average. NOAA's National Centers for Environmental Information produce the 9-month SPI values below on a monthly basis, going back to 1895.*

Credit: [Spencer Schien](https://twitter.com/MrPecners)

Additional data from the [Drought Monitor](https://droughtmonitor.unl.edu/DmData/DataDownload/DSCI.aspx) with API access from: https://droughtmonitor.unl.edu/DmData/DataDownload/WebServiceInfo.aspx#comp

> The Drought Severity and Coverage Index is an experimental method for converting drought levels from the U.S. Drought Monitor map to a single value for an area. DSCI values are part of the U.S. Drought Monitor data tables. Possible values of the DSCI are from 0 to 500. Zero means that none of the area is abnormally dry or in drought, and 500 means that all of the area is in D4, exceptional drought.

This dataset was covered by the [NY Times](https://www.nytimes.com/interactive/2021/06/11/climate/california-western-drought-map.html) and [CNN](https://www.cnn.com/2021/06/17/weather/west-california-drought-maps/index.html).

The dataset for today ranges from 2001 to 2021, but again more data is available at the [Drought Monitor](https://droughtmonitor.unl.edu/DmData/DataDownload/ComprehensiveStatistics.aspx).

Drought classification can be found on the [US Drought Monitor site](https://droughtmonitor.unl.edu/About/AbouttheData/DroughtClassification.aspx).

Please [reference the data](https://droughtmonitor.unl.edu/About/Permission.aspx) as seen below:

> The U.S. Drought Monitor is jointly produced by the National Drought Mitigation Center at the University of Nebraska-Lincoln, the United States Department of Agriculture, and the National Oceanic and Atmospheric Administration. Map courtesy of NDMC.

Some maps and other interesting summaries can be found on the [Drought Monitor site](https://droughtmonitor.unl.edu/ConditionsOutlooks/CurrentConditions.aspx) and their [Map Collection](https://droughtmonitor.unl.edu/Maps.aspx).

Some limitations of the data expanded on the [Drought Monitor site](https://droughtmonitor.unl.edu/About/AbouttheData/PopulationStatistics.aspx).


### Data Dictionary

# `drought.csv`

|variable         |class     |description |
|:----------------|:---------|:-----------|
|0                |double    |  |
|DATE             |character | Date |
|D0               |double    | Abnormally dry |
|D1               |double    | Moderate drought |
|D2               |double    | Severe drought|
|D3               |double    | Extreme drought |
|D4               |double    | Exceptional drought |
|-9               |double    |  |
|W0               |double    | Abnormally wet |
|W1               |double    | Moderate wet |
|W2               |double    | Severe wet |
|W3               |double    | Extreme wet |
|W4               |double    | Exceptional wet |
|state            |character | State |

# `drought-fips.csv`

FIPS can be processed via `tidycensus` or `tigris` R packages. Note that the FIPS code needs to be split for processing.

See: https://walker-data.com/tidycensus/reference/fips_codes.html

|variable |class     |description |
|:--------|:---------|:-----------|
|State    |character |State name    |
|FIPS     |character | FIPS id (first two digits = state, last 3 digits = county)    |
|DSCI     |double    | Drought Score (0 to 500) Zero means that none of the area is abnormally dry or in drought, and 500 means that all of the area is in D4, exceptional drought.    |
|date     |double    | date in ISO    |

