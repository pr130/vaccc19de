#' extract cumulative / original data
#' @param xlsx_path character. path to excel
#' @param out_folder character. path to store cumulative data. defaults to here::here().
#' @return tibble. the data as displayed in sheet 2 enriched with the Datenstand timestamp from sheet 1.
#' @description returns the data as displayed in sheet 2 enriched with the Datenstand timestamp from sheet 1.
#' When collected over multiple days, this will result in cumulative data because the individual columns do not display the difference but total numbers
#' (except for column "differenz_zum_vortag").
#' @export
#' @importFrom rlang .data
rki_extract_cumulative_data <- function(xlsx_path, out_folder = here::here()) {

  erlaeuterung <- readxl::read_excel(xlsx_path, sheet = 1)
  bundesland_data <- readxl::read_excel(xlsx_path, sheet = 2)
  bundesland_data_cleaned <- rki_clean_bundesland(bundesland_data)
  ts_datenstand <- rki_get_timestamp(erlaeuterung)
  bundesland_data_cleaned$ts_datenstand <- ts_datenstand

  # get {timestamp}_impfmonitoring part of path
  without_ext <- get_common_path(xlsx_path)
  bundesland_data_cleaned <- bundesland_data_cleaned %>%
    dplyr::mutate(ts_download = lubridate::now(tz = "Europe/Berlin")) %>%
    dplyr::select(.data$ts_datenstand, .data$ts_download, dplyr::everything())

  bundesland_data_cleaned %>%  readr::write_csv(fs::path(out_folder, glue::glue("{without_ext}_kumulativ.csv")))

  bundesland_data_cleaned
}
