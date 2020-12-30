# vaccc19de 0.1.0
* functions `rki_download_xlsx` to download the xlsx file from the RKI website and store it in ia given folder
* function `rki_extract_sheet_csvs` to extract the two sheets from the xlsx and store them as csvs in a given folder
* function `rki_extract_cumulative_data` to extract, clean and enrich the data from the excel file and return it as a tibble
* utility function `get_common_path` to get the element of the path that is common to all files, i.e. `{timestamp}_impfmonitoring`
* Added a `NEWS.md` file to track changes to the package.
* GitHub action to automatically run tests and R CMD Check. 

