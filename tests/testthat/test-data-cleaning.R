mapping <- vaccc19de::BUNDESLAND_TO_ISO

test_that("Bundesland data cleaning works", {
  df <- readxl::read_excel("test_data/impfquotenmonitoring.xlsx", sheet = 2)
  cleaned <- rki_clean_bundesland(df)
  expect_equal(nrow(cleaned), 16)
  expect_equal(colnames(cleaned), c("bundesland", "bundesland_iso", "impfungen_kumulativ", "differenz_zum_vortag", "indikation_nach_alter", "berufliche_indikation", "medizinische_indikation", "pflegeheim_bewohner_in"))
  expect_setequal(cleaned$bundesland, mapping$bundesland)
  expect_setequal(cleaned$bundesland_iso, mapping$bundesland_iso)
})
