#' @param cumulative_data
rki_decumulate_data <- function(cumulative_data) {

    # grouped lag 
    calc_lag <- function(col) {
        lag_col <- dplyr::lag(col)
        diff <- col - lag_col
        return(dplyr::coalesce(diff, col))
    }

    decumulated_data <- cumulative_data %>% 
        dplyr::arrange(bundesland, bundesland_iso, ts_datenstand) %>% 
        dplyr::group_by(bundesland, bundesland_iso) %>% 
        dplyr::mutate(dplyr::across(dplyr::starts_with("indikation"), calc_lag, .names = "{.col}_neu")) 

    decumulated_data <- decumulated_data %>% 
        dplyr::rename(impfungen_seit_lupdate = differenz_zum_vortag) %>% 
        dplyr::select(-impfungen_kumulativ)
    return(decumulated_data)
}