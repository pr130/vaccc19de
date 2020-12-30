
# vaccc19de

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/friep/vaccc19de/workflows/R-CMD-check/badge.svg)](https://github.com/friep/vaccc19de/actions)
<!-- badges: end -->

The goal of vaccc19de (**vacc**inations **c**ovid **19** **de**utschland) is to provide functions to easily get and extract data on the progress of vaccinations in German Bundesländer that is provided daily by the Robert-Koch-Institut (RKI) on [this page](https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Impfquotenmonitoring.html). The package is used to automatically collect data in the accompanying [vaccc19de_rki_data repository](https://github.com/friep/vaccc19de_rki_data).

## Installation

vaccc19de is not on CRAN. You can install the development version from GitHub with:

``` r
remotes::install_github("friep/vaccc19de")
```


## Usage

Download the currently available data from the RKI:

``` r
library(vaccc19de)
path <- rki_download_xlsx() # returns path to xlsx invisibly
# rki_extract_sheet_csvs(path) # optional to store the raw sheets as csvs
rki_extract_cumulative_data(path)
```

## Roadmap
- function to "longify" the data by indication
- more robust data cleaning

## Licensing information

Data in folder `tests/testthat/test_data` was downloaded from the Robert Koch Institut's website on 2020-12-30: https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Impfquotenmonitoring.html 
