#' clean data
#' @param .data raw data frame of sheet "Presse"
#' @return cleaned data in wide format
#' @description cleans column names, removes * from Bundesland column, merges Bundesland ISO code and removes "Gesamt"
#' and comment rows at the end of the table. Returns one row for each Bundesland.
#' @importFrom rlang .data
rki_clean_bundesland <- function(.data) {
  mapping <- vaccc19de::BUNDESLAND_TO_ISO
  tmp <- .data %>%
    janitor::clean_names() %>%
    dplyr::slice_head(n = 16) %>%
    dplyr::mutate(bundesland = stringr::str_replace_all(.data$bundesland, "\\*", "")) # replace ** in data

  # merge
  merged <- dplyr::inner_join(mapping, tmp, by = "bundesland")

  if (any(is.na(merged$bundesland_iso))) {
    usethis::ui_warn("Not all Bundeslaender could be matched to ISO codes.")
  }
  return(merged)
}
