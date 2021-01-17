#' extract cumulative / original data
#' @param xlsx_path character. path to excel
#' @return tibble. the data as displayed in sheet 2 enriched with the Datenstand timestamp from sheet 1.
#' @description returns the data as displayed in sheet 2 enriched with the Datenstand timestamp from sheet 1.
#' When collected over multiple days, this will result in cumulative data because the individual columns do not display the difference but total numbers
#' (except for column "differenz_zum_vortag").
#' @export
#' @importFrom rlang .data
rki_extract_cumulative_data <- function(xlsx_path) {

  erlaeuterung <- readxl::read_excel(xlsx_path, sheet = 1)
  bundesland_data <- readxl::read_excel(xlsx_path, sheet = 2)
  bundesland_data_cleaned <- rki_clean_bundesland(bundesland_data)
  ts_datenstand <- rki_get_timestamp(erlaeuterung)
  bundesland_data_cleaned$ts_datenstand <- ts_datenstand

  # get download_ts from xlsx path
  ts_download <- get_download_ts_from_path(xlsx_path)
  bundesland_data_cleaned <- bundesland_data_cleaned %>%
    dplyr::mutate(ts_download = ts_download) %>%
    dplyr::select(.data$ts_datenstand, .data$ts_download, dplyr::everything())
  
  # we merge regionalschlüssel as "RS" in rki_clean_bundesland, remove lowercase version if it exists
  # (backwards compatability for older data)
  if ("rs" %in% colnames(bundesland_data_cleaned)) {
    bundesland_data_cleaned$rs <- NULL
  }
  bundesland_data_cleaned

}


#' download time series from GitHub
#' @export
#' @return tibble. Cumulative time series
#' @description Downloads cumulative time series from the `vaccc19de_rki_data` repository, more specifically https://raw.githubusercontent.com/friep/vaccc19de_rki_data/main/data/cumulative_time_series.csv
rki_download_cumulative_ts <- function() {
  readr::read_csv("https://raw.githubusercontent.com/friep/vaccc19de_rki_data/main/data/cumulative_time_series.csv")
}