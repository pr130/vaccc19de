# vaccc19de 0.3.4
* `rki_download_diffs_ts` and `rki_download_cumulative_ts` now download data from [https://github.com/favstats/vaccc19de_dashboard](https://github.com/favstats/vaccc19de_dashboard)
# vaccc19de 0.3.3
* `rki_clean_bundesland` integrates unnamed columns into the `notes` column (#9)
# vaccc19de 0.3.2
* `rki_extract_diffs` drops "cumulative" columns
# vaccc19de 0.3.1
* `rki_extract_diffs` arranges data by ts_datenstand and bundesland
# vaccc19de 0.3.0
* `rki_extract_diffs` to extract "*decumulated*" time series data with the differences since the last update (#1)
* `rki_download_diffs_ts` to download the data frame from GitHub
* `rki_extract_cumulative_data` does not save csv anymore (#4)
* `rki_extract_cumulative_data` uses `ts_download` from xlsx file path (#5)

# vaccc19de 0.2.0
* `rki_extract_cumulative_data` now parses comments (indicated by `*` in the excel sheet) into a separate column `notes`

# vaccc19de 0.1.0
* functions `rki_download_xlsx` to download the xlsx file from the RKI website and store it in ia given folder
* function `rki_extract_sheet_csvs` to extract the two sheets from the xlsx and store them as csvs in a given folder
* function `rki_extract_cumulative_data` to extract, clean and enrich the data from the excel file and return it as a tibble
* utility function `get_common_path` to get the element of the path that is common to all files, i.e. `{timestamp}_impfmonitoring`
* Added a `NEWS.md` file to track changes to the package.
* GitHub action to automatically run tests and R CMD Check. 

