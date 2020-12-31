#' get common part of path from excel file path
#' @param xlsx_path character. path to excel file.
#' @return character. common part for all files related to one download, i.e. {timestamp}_impfmonitoring
#' @export 
get_common_path <- function(xlsx_path) {
  return(xlsx_path %>% fs::path_file() %>% fs::path_ext_remove())
}

# get download_ts from xlsx path
get_download_ts_from_path <- function(xlsx_path) {
  common <- xlsx_path %>% fs::path_file() %>% fs::path_ext_remove()
  ts <- lubridate::ymd_hms(common, tz = "Europe/Berlin")
  ts
}