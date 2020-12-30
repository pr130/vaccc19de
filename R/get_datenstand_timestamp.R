#' get timestamp of "Datenstand"
#' @param .data raw data frame of sheet "Erlaeuterung"
#' @return timestamp of Datenstand
rki_get_timestamp <- function(.data) {
  if (ncol(.data) == 1) {
    ts_string <- rki_extract_ts_string(.data)
    ts <- rki_parse_ts(ts_string)
    return(ts)
  } else if (ncol(.data) == 3) {
    # column B contains date and column C contains time (e.g. 2020-12-30)
    i <- stringr::str_which(.data  %>% dplyr::pull(1), "^Datenstand:")
    date <- lubridate::ymd(.data[[i, 2]])
    time <- lubridate::hm(.data[[i, 3]])
    return(lubridate::ymd_hms(paste(date, time), tz = "Europe/Berlin"))
  }
}



# parse German timestamp with "Uhr" at the end - thankfully lubridate is clever like that
rki_parse_ts <- function(s) {
  ts <- lubridate::dmy_hm(s, tz = "Europe/Berlin")
  return(ts)
}

# find the row with "Datenstand"
# hopefully they don't change the format of this!!
rki_extract_ts_string <- function(raw) {
  # only one column in this sheet
  # row needs to start with Datenstand and needs to be the first row to do so
  i <- stringr::str_which(raw  %>% dplyr::pull(1), "^Datenstand:")
  s <- raw[[i, 1]]
  ts_string <- stringr::str_trim(stringr::str_split(s, ":", n = 2)[[1]][2])
  return(ts_string)
}
