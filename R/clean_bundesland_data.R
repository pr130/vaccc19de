#' clean data
#' @param .data raw data frame of sheet "Presse"
#' @return cleaned data in wide format
#' @description cleans column names, removes * from Bundesland column, merges Bundesland ISO code and removes "Gesamt"
#' and comment rows at the end of the table. Returns one row for each Bundesland.
#' @importFrom rlang .data
#' @importFrom tidyr unite
rki_clean_bundesland <- function(.data) {

    if("row" %in% colnames(.data)){

      gesamt_dat <<- .data %>%
        dplyr::filter(stringr::str_detect(sheet, "Gesamt_bis")) %>%
        rki_tidyfy_header_dat(sheet = "gesamt")

      indik_dat <<- .data %>%
        dplyr::filter(stringr::str_detect(sheet, "Indik_bis")) %>%
        rki_tidyfy_header_dat(sheet = "indikation")

      indik_dat$notes <- dplyr::case_when(
        gesamt_dat$notes != "" & indik_dat$notes == "" ~ gesamt_dat$notes,
        gesamt_dat$notes == "" & indik_dat$notes != "" ~ indik_dat$notes,
        gesamt_dat$notes != "" & indik_dat$notes != "" ~  stringr::str_c(gesamt_dat$notes, ", ", indik_dat$notes)  %>% stringr::str_trim())

      bundeslaender <- gesamt_dat %>%
        dplyr::select(-notes) %>%
        dplyr::left_join(indik_dat)  %>%
        dplyr::mutate(notes = ifelse(notes == "", NA, notes)) %>%
        dplyr::select(bundesland, impfungen_kumulativ = gesamtzahl_bisher_verabreichter_impfstoffdosen, everything())

  } else if (!"row" %in% colnames(.data)){

    # clean column names
    tmp <- .data %>%
      janitor::clean_names()


    # bundeslaender
    bundeslaender <- tmp %>%
      dplyr::slice_head(n = 16)

    gesamt_row <- tmp %>%
      dplyr::filter(.data$bundesland == "Gesamt" | .data$bundesland == "gesamt")
    bundeslaender$gesamt_kumulativ <- gesamt_row %>% dplyr::pull(impfungen_kumulativ)
    bundeslaender$gesamt_differenz_zum_vortag <- gesamt_row %>% dplyr::pull(differenz_zum_vortag)

    ## get annotations
    annotations <- tmp %>%
      dplyr::filter(stringr::str_starts(.data$bundesland, "\\*")) %>%
      janitor::remove_empty("cols")

    if (nrow(annotations) > 0) {
      annotations <- annotations %>%
        dplyr::rename(annotation = .data$bundesland) %>%
        dplyr::mutate(star_count = stringr::str_count(.data$annotation, "\\*"),
                      annotation = stringr::str_trim(stringr::str_replace_all(.data$annotation, "\\*", "")))
      # join annotations
      bundeslaender <- bundeslaender %>%
        dplyr::mutate(star_count = stringr::str_count(.data$bundesland, "\\*")) %>%
        dplyr::left_join(annotations, by = "star_count")
      # remove * from bundesland name column and clean up after join
      bundeslaender <- bundeslaender  %>%
        dplyr::mutate(bundesland = stringr::str_trim(stringr::str_replace_all(.data$bundesland, "\\*", ""))) %>%
        dplyr::rename(notes = annotation) %>%
        dplyr::select(-star_count)
    } else {
      # no annotations, add empty notes column
      bundeslaender$notes <- NA
    }

    # treat all "x" columns as additional, unnamed notes columns
    if (any(stringr::str_detect(colnames(bundeslaender), "^x\\d{1,}$"))) {
      bundeslaender <- bundeslaender  %>%
        tidyr::unite("notes_col", dplyr::matches("^x\\d{1,}$"), remove = TRUE, na.rm = TRUE, sep = "\n") %>%
        tidyr::unite("notes", notes, notes_col, remove = TRUE, na.rm = TRUE, sep = "\n") %>%
        dplyr::mutate(notes = dplyr::if_else(notes == "", NA_character_, stringr::str_trim(notes)))
    }

  }


  # join iso code
  mapping <- vaccc19de::BUNDESLAND_TO_ISO
  merged <- dplyr::inner_join(mapping, bundeslaender, by = "bundesland")

  if (any(is.na(merged$bundesland_iso))) {
    usethis::ui_warn("Not all Bundeslaender could be matched to ISO codes.")
  }
  return(merged)
}


#' clean data
#' @param xl raw data frame
#' @param sheet "gesamt" or indikation"
#' @return cleaned data in wide format
rki_tidyfy_header_dat <- function(xl, sheet) {

  bundesland_col <- 2

  raw_first <-  xl %>%
    ## check columns for notes and all blank values
    dplyr::group_by(col) %>%
    dplyr::mutate(col_blank = all(data_type == "blank"),
                  col_any_numeric = any(data_type == "numeric")) %>%
    dplyr::ungroup() %>%
    ## remove cols that are all blank
    dplyr::filter(!col_blank) %>%
    ## if a column has no numeric values and is not the second column (which holds the   Bundesländer then its likely the notes column)
    dplyr::mutate(notes_column = !col_any_numeric & col != bundesland_col)


  if(sheet == "gesamt"){
    raw_second <- raw_first %>%
      ## parse first header
      behead("up-left", "first") %>%
      ## parse second header
      behead("up-left", "second") %>%
      ## parse third header
      behead("up", "third") %>%
      ## beyond row twenty there are only notes so remove that
      dplyr::filter(row <= 20)
  } else if (sheet == "indikation"){
    raw_second <- raw_first %>%
      ## parse first header
      behead("up-left", "first") %>%
      ## parse second header
      behead("up", "second") %>%
      ## init third header for later compatability
      dplyr::mutate(third = "") %>%
      ## beyond row twenty there are only notes so remove that
      dplyr::filter(row <= 20)
  }

  raw_final <- raw_second %>%
    ## combine chr + num cols
    dplyr::mutate(value = ifelse(is.na(numeric), character, numeric)) %>%
    janitor::remove_empty("rows") %>%
    dplyr::select(-date) %>%
    dplyr::mutate_all(~tidyr::replace_na(.x, "")) %>%
    ## create header and remove vars
    dplyr::mutate(header = paste(first, second, third))

  clean_dat <- raw_final %>%
    ## remove notes column for now
    dplyr::filter(!as.logical(notes_column)) %>%
    ## only keep necessary columns
    dplyr::select(header, value) %>%
    ## create tidy data
    tidyr::pivot_wider(names_from = header, values_from = value) %>%
    janitor::clean_names() %>%
    tidyr::unnest()

  if(any(as.logical(raw_final$notes_column))){
    notes_dat <- raw_final %>%
      ## keep notes column and bundesland for merging
      dplyr::filter(as.logical(notes_column) | col == bundesland_col) %>%
      dplyr::mutate(notes_column = ifelse(notes_column, "notes", "bundesland")) %>%
      dplyr::select(row, value, notes_column) %>%
      tidyr::pivot_wider(id_cols = row,
                         names_from = notes_column,
                         values_from = value) %>%
      dplyr::select(-row) %>%
      dplyr::mutate(notes = ifelse(is.na(notes), "", notes))

    clean_dat <- clean_dat %>%
      dplyr::left_join(notes_dat)

  } else {
    clean_dat$notes <- ""
  }

  return(clean_dat)
}
