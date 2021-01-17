mapping <- vaccc19de::BUNDESLAND_TO_ISO

test_that("Bundesland data cleaning works", {
  df <- readxl::read_excel("test_data/2020-12-31T131123_impfquotenmonitoring.xlsx", sheet = 2)
  cleaned <- rki_clean_bundesland(df)
  expect_equal(nrow(cleaned), 16)
  expect_equal(colnames(cleaned), c("bundesland", "bundesland_iso", "RS", "impfungen_kumulativ", "differenz_zum_vortag", "indikation_nach_alter", "berufliche_indikation", "medizinische_indikation", "pflegeheim_bewohner_in", "gesamt_kumulativ", "gesamt_differenz_zum_vortag", "notes"))
  expect_setequal(cleaned$bundesland, mapping$bundesland)
  expect_setequal(cleaned$bundesland_iso, mapping$bundesland_iso)
})

test_that("note extraction works", {
  df <- readxl::read_excel("test_data/2020-12-31T131123_impfquotenmonitoring.xlsx", sheet = 2)
  cleaned <- rki_clean_bundesland(df)

  expect_equal(dplyr::filter(cleaned, !is.na(.data$notes)) %>% nrow, 3)
  # general note not part of notes column
  expect_equal(length(stringr::str_subset(cleaned$notes, "in einigen Bundesländern werden nicht alle der in der Tabelle aufgeführten Indikationen einzeln ausgewiesen")), 0)
  expect_equal(length(stringr::str_subset(cleaned$notes, "einschl. Korrekturmeldung vom 27.12.20")),  3)

})


test_that("note extraction works with more than 2 notes", {
  df <- readxl::read_excel("test_data/impfmonitoring_three_notes.xlsx", sheet = 2)
  cleaned <- rki_clean_bundesland(df)
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
  cleaned <- rki_clean_bundesland(df)
  expect_true(all(is.na(cleaned$notes)))
})