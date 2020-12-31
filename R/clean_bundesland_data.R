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
    dplyr::mutate(bundesland_notes = "")

  ## get annotations
  annotations <- tmp %>%
    dplyr::filter(stringr::str_starts(.data$bundesland, "\\*")) %>%
    janitor::remove_empty("cols") %>%
    dplyr::rename(annotation = .data$bundesland) %>%
    dplyr::mutate(star_count = stringr::str_count(.data$annotation, "\\*"),
                  annotation = stringr::str_replace_all(.data$annotation, "\\*", ""))


  if(any(stringr::str_detect(tmp$bundesland, "\\*"))){ ## if there are any annotations for a bundesland

    if(nrow(annotations)==2){  ## if there are exactly two annotations

      tmp <- tmp %>%
        dplyr::mutate(bundesland_notes = ifelse(stringr::str_detect(.data$bundesland, "\\*\\*"),
                                               annotations$annotation[2],
                                               NA_character_))

    } else if(nrow(annotations)>2){ ## if there are more than two annotations
      for (jj in 2:nrow(annotations)) { ## go through all annotations and paste them together with a \n
        tmp <- tmp %>%
          dplyr::mutate(bundesland_notes = ifelse(stringr::str_detect(.data$bundesland, strrep("\\*", jj)),
                                                 paste0(.data$bundesland_notes, annotations$annotation[jj], "\n"),
                                                 .data$bundesland_notes))
      }
    }
  }


  tmp2 <- tmp %>%
    dplyr::slice_head(n = 16) %>%
    dplyr::mutate(bundesland = stringr::str_replace_all(.data$bundesland, "\\*", ""),  # replace ** in data
                  bundesland_notes = ifelse(.data$bundesland_notes == "", NA_character_, .data$bundesland_notes)) # empty strings are NA

  # merge
  merged <- dplyr::inner_join(mapping, tmp2, by = "bundesland")

  if (any(is.na(merged$bundesland_iso))) {
    usethis::ui_warn("Not all Bundeslaender could be matched to ISO codes.")
  }
  return(merged)
}
