mapping <- vaccc19de::BUNDESLAND_TO_ISO

test_that("note extraction works with more than 2 notes", {
  df <- readxl::read_excel("test_data/impfmonitoring_three_notes.xlsx", sheet = 2)
  cleaned <- rki_extract_annotations(df)
  expect_equal(dplyr::filter(cleaned, !is.na(.data$notes)) %>% nrow, 6)
  # general note not part of notes column
  expect_equal(length(stringr::str_subset(cleaned$notes, "in einigen Bundesländern werden nicht alle der in der Tabelle aufgeführten Indikationen einzeln ausgewiesen")), 0)
  expect_equal(length(stringr::str_subset(cleaned$notes, "a second note")),  3)
  expect_equal(length(stringr::str_subset(cleaned$notes, "a third note")),  1)

  expect_equal(cleaned$notes[cleaned$bundesland_iso == "BW"], "blabla\nanother note")
  expect_equal(cleaned$notes[cleaned$bundesland_iso == "SN"], "a third note\ntest")
})

test_that("note extraction works with no note", {
  df <- readxl::read_excel("test_data/impfmonitoring_no_notes.xlsx", sheet = 2)
  cleaned <- rki_extract_annotations(df)
  expect_equal(ncol(cleaned), 3)
  expect_true(all(is.na(cleaned$notes)))
})