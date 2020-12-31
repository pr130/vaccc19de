mapping <- vaccc19de::BUNDESLAND_TO_ISO

test_that("Getting cumulative data works", {
  withr::with_file("tests/testthat/impfquotenmonitoring_kumulativ.xlsx", {
    cumulative <- rki_extract_cumulative_data("test_data/impfquotenmonitoring.xlsx", ".")
    expect_equal(nrow(cumulative), 16)
    expect_equal(colnames(cumulative), c("ts_datenstand", "ts_download", "bundesland", "bundesland_iso", "impfungen_kumulativ", "differenz_zum_vortag", "indikation_nach_alter", "berufliche_indikation", "medizinische_indikation", "pflegeheim_bewohner_in", "notes"))
    expect_setequal(cumulative$bundesland, mapping$bundesland)
    expect_setequal(cumulative$bundesland_iso, mapping$bundesland_iso)
  })
})



