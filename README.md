
# vaccc19de

<!-- badges: start -->

[![R-CMD-check](https://github.com/friep/vaccc19de/workflows/R-CMD-check/badge.svg)](https://github.com/friep/vaccc19de/actions)
[![Lifecycle:
archived](https://img.shields.io/badge/lifecycle-archived-red.svg)](https://www.tidyverse.org/lifecycle/#archived)
<!-- badges: end -->

⚠️ we have stopped the development of the package and the accompanying
[dashboard](https://github.com/favstats/vaccc19de_dashboard). Functions
in this package most likely do not work anymore. ⚠️

**Why are we retiring the package / dashboard?**

This project was a spontaneous collaboration between
[Fabio](https://github.com/favstats) and me when we realized at the end
of December 2020 that

1)  data was not published as time series data but instead was being
    overwritten each day, i.e. no history was available to the public
2)  no official dashboard or visualization existed

Re 1) there is [this daily-updated
archive](https://github.com/ard-data/2020-rki-impf-archive) which we
have used for the dashboard in the past weeks

Re 2) Although the [official dashboard](https://impfdashboard.de/) is
lacking in certain areas (e.g. no Bundesland-level analyses), it
provides a good overview over the progress of the vaccinations.

Finally, given that the constantly changing format and quality of the
Excel download requires constant adaptation of the code, we cannot
realistically guarantee the integrity and correctness of our dashboard
with our limited time resources.

-----

The goal of vaccc19de (**vacc**inations **c**ovid **19**
**de**utschland) was to provide functions to easily get and extract data
on the progress of vaccinations in German Bundesländer that is provided
daily by the Robert-Koch-Institut (RKI) on [this
page](https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Impfquotenmonitoring.html).
The package is used to automatically collect data in the accompanying
[vaccc19de\_rki\_data
repository](https://github.com/friep/vaccc19de_rki_data).

The package was used in the
[vaccc19de\_dashboard](https://github.com/favstats/vaccc19de_dashboard)
repository where you can also find the current version of the following
two datasets:

  - [cumulative
    data](https://github.com/favstats/vaccc19de_dashboard/blob/main/data/cumulative_time_series.csv)
  - [“decumulated” data of daily
    differences](https://github.com/favstats/vaccc19de_dashboard/blob/main/data/diffs_time_series.csv)

Please refer to the README of the
[vaccc19de\_dashboard](https://github.com/favstats/vaccc19de_dashboard)
for more information on the data.

## Installation

vaccc19de is not on CRAN. You can install the development version from
GitHub with:

``` r
remotes::install_github("friep/vaccc19de")
```

## Usage

Download the currently available data from the RKI:

``` r
library(vaccc19de)
path <- rki_download_xlsx() # returns path to xlsx invisibly
```

<<<<<<< Updated upstream
    ## Scraping: https://www.rki.de//DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Impfquotenmonitoring.xlsx;jsessionid=1ED848D013B4843A358E88800BDEFC7F.internet061?__blob=publicationFile
=======
    ## Scraping: https://www.rki.de//DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Impfquotenmonitoring.xlsx;jsessionid=40579341F95A474CE7F9B6F086B4250F.internet072?__blob=publicationFile
>>>>>>> Stashed changes

``` r
# rki_extract_sheet_csvs(path) # optional to store the raw sheets as csvs
cumulative <- rki_extract_cumulative_data(path)
```

    ## New names:
    ## * `` -> ...5
    ## * `` -> ...6
    ## * `` -> ...7
    ## * `` -> ...8
    ## * `` -> ...10
    ## * ...

Or download the full time series from
[GitHub](https://github.com/favstats/vaccc19de_dashboard/tree/main/data):

``` r
cumulative_ts <- rki_download_cumulative_ts()
```

    ## 
    ## ── Column specification ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ## cols(
    ##   ts_datenstand = col_datetime(format = ""),
    ##   ts_download = col_datetime(format = ""),
    ##   bundesland = col_character(),
    ##   bundesland_iso = col_character(),
    ##   impfungen_kumulativ = col_double(),
    ##   differenz_zum_vortag = col_double(),
    ##   indikation_nach_alter = col_double(),
    ##   berufliche_indikation = col_double(),
    ##   medizinische_indikation = col_double(),
    ##   pflegeheim_bewohner_in = col_double(),
    ##   notes = col_character(),
    ##   impfungen_pro_1_000_einwohner = col_double()
    ## )

``` r
cumulative_ts
```

    ## # A tibble: 128 x 12
    ##    ts_datenstand       ts_download         bundesland bundesland_iso
    ##    <dttm>              <dttm>              <chr>      <chr>         
    ##  1 2020-12-28 15:15:00 2020-12-28 14:39:57 Baden-Wür… BW            
    ##  2 2020-12-28 15:15:00 2020-12-28 14:39:57 Bayern     BY            
    ##  3 2020-12-28 15:15:00 2020-12-28 14:39:57 Berlin     BE            
    ##  4 2020-12-28 15:15:00 2020-12-28 14:39:57 Brandenbu… BB            
    ##  5 2020-12-28 15:15:00 2020-12-28 14:39:57 Bremen     HB            
    ##  6 2020-12-28 15:15:00 2020-12-28 14:39:57 Hamburg    HH            
    ##  7 2020-12-28 15:15:00 2020-12-28 14:39:57 Hessen     HE            
    ##  8 2020-12-28 15:15:00 2020-12-28 14:39:57 Mecklenbu… MV            
    ##  9 2020-12-28 15:15:00 2020-12-28 14:39:57 Niedersac… NI            
    ## 10 2020-12-28 15:15:00 2020-12-28 14:39:57 Nordrhein… NW            
    ## # … with 118 more rows, and 8 more variables: impfungen_kumulativ <dbl>,
    ## #   differenz_zum_vortag <dbl>, indikation_nach_alter <dbl>,
    ## #   berufliche_indikation <dbl>, medizinische_indikation <dbl>,
    ## #   pflegeheim_bewohner_in <dbl>, notes <chr>,
    ## #   impfungen_pro_1_000_einwohner <dbl>

“decumulate” it / create the time series of differences:

``` r
diffs_ts <- rki_extract_diffs(cumulative_ts)
diffs_ts
```

Finally, you can also download the “decumulated” data directly from
[GitHub](https://github.com/favstats/vaccc19de_dashboard/tree/main/data):

``` r
cumulative_ts <- rki_download_diffs_ts()
```

## Roadmap

  - function to “longify” the data by indication
  - more robust data cleaning

## Contribute

Before filing an issue, please check the list of issues. When forking,
please create your PR against the `dev` branch.

## Licensing information

Data in folder `tests/testthat/test_data` was downloaded from the Robert
Koch Institut’s website on 2020-12-30:
<https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Impfquotenmonitoring.html>
