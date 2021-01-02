test_that("decumulating cumulative time series works", {
  cum_ts <- readr::read_csv("test_data/cumulative_ts.csv")
  decum_ts <- rki_decumulate_data(cum_ts)

  expect_true(all(c("indikation_nach_alter_neu", "berufliche_indikation_neu", "medizinische_indikation_neu", "pflegeheim_bewohner_in_neu", "impfungen_neu") %in% colnames(decum_ts)))
  berlin_alter <- decum_ts %>% 
    dplyr::filter(bundesland_iso == "BE") %>% 
    dplyr::pull(indikation_nach_alter_neu)
  expect_equal(berlin_alter, c(3340, 1578, 1636))

  hh_mediz <- decum_ts %>% 
    dplyr::filter(bundesland_iso == "HH") %>% 
    dplyr::pull(medizinische_indikation_neu)

  expect_equal(hh_mediz, c(NA, 0, NA))

  rlp_alter <- decum_ts %>% 
    dplyr::filter(bundesland_iso == "RP") %>% 
    dplyr::pull(indikation_nach_alter_neu)

  expect_equal(rlp_alter, c(NA, 0, NA))
})
