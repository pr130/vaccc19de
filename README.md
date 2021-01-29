
# vaccc19de

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/friep/vaccc19de/workflows/R-CMD-check/badge.svg)](https://github.com/friep/vaccc19de/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/vaccc19de)](https://CRAN.R-project.org/package=vaccc19de)
<!-- badges: end -->

:warning: most functions will be retired / deleted soon because they do not work anymore after the RKI adapted their excel and we do not parse the data ourselves anymore for the dashboard. If you want to work on the package to update the functions, please let me know. :warning: 


The goal of vaccc19de (**vacc**inations **c**ovid **19**
**de**utschland) is to provide functions to easily get and extract data
on the progress of vaccinations in German Bundesländer that is provided
daily by the Robert-Koch-Institut (RKI) on [this
page](https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Impfquotenmonitoring.html).

The package is used in the
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

    ## Scraping: https://www.rki.de//DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Impfquotenmonitoring.xlsx;jsessionid=1ED848D013B4843A358E88800BDEFC7F.internet061?__blob=publicationFile

``` r
# rki_extract_sheet_csvs(path) # optional to store the raw sheets as csvs
cumulative <- rki_extract_cumulative_data(path)
```

    ## New names:
    ## * `` -> ...2
    ## * `` -> ...3

    ## New names:
    ## * `` -> ...9

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

    ## # A tibble: 128 x 10
    ## # Groups:   bundesland, bundesland_iso [16]
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
    ## # … with 118 more rows, and 6 more variables: impfungen_neu <dbl>,
    ## #   indikation_nach_alter_neu <dbl>, medizinische_indikation_neu <dbl>,
    ## #   berufliche_indikation_neu <dbl>, pflegeheim_bewohner_in_neu <dbl>,
    ## #   notes <chr>

Finally, you can also download the “decumulated” data directly from
[GitHub](https://github.com/favstats/vaccc19de_dashboard/tree/main/data):

``` r
cumulative_ts <- rki_download_diffs_ts()
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
