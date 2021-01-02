#' 'decumulate' cumulative data to get diffs
#' @param cumulative_data tibble. the cumulative time series. 
#' @return tibble. "decumulated" time series with the diffs, i.e. where values represent the difference since the previous update. 
#' @export
rki_extract_diffs <- function(cumulative_data) {

    # grouped lag 
    calc_lag <- function(col) {
        lag_col <- dplyr::lag(col)
        # NA handling 
        # replace NA's in lag_col with 0 so that subtracting NA from a number does not result in NA
        # we keep NAs in the original column so that when a value is NA, it is kept as such in the decumulated
        # data (could be meaningful)
        lag_col[is.na(lag_col)] <- 0
        diff <- col - lag_col # subtract
        diff[1] <- col[1] # so that first value is the "baseline" and not NA
        return(diff)
    }

    decumulated_data <- cumulative_data %>% 
        dplyr::arrange(bundesland, bundesland_iso, ts_datenstand) %>% 
        dplyr::group_by(bundesland, bundesland_iso) %>% 
        dplyr::mutate(dplyr::across(dplyr::starts_with(c("indikation", "medizinische_indikation", "berufliche_indikation", "pflegeheim")), calc_lag, .names = "{.col}_neu")) 

    decumulated_data <- decumulated_data %>% 
        dplyr::rename(impfungen_neu = differenz_zum_vortag) %>% 
        dplyr::select(-impfungen_kumulativ) %>% 
        dplyr::arrange(ts_datenstand, bundesland)

    return(decumulated_data)
}


#' download diffs time series from GitHub
#' @export
#' @return tibble. Diffs time series with the diffs (created by `rki_diffs`)
#' @description Downloads the diffs / 'decumulated' time series from the `vaccc19de_rki_data` repository, more specifically https://raw.githubusercontent.com/friep/vaccc19de_rki_data/main/data/decumulated_time_series.csv
rki_download_diffs_ts <- function() {
    readr::read_csv("https://raw.githubusercontent.com/friep/vaccc19de_rki_data/main/data/diffs_time_series.csv")
}