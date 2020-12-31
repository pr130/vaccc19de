test_that("decumulating cumulative time series works", {
  cum_ts <- readr::read_csv("test_data/cumulative_ts.csv")
  decum_ts <- rki_decumulate_data(cum_ts)
  berlin_alter <- decum_ts %>% 
    dplyr::filter(bundesland_iso == "BE") %>% 
    dplyr::pull(indikation_nach_alter_neu)
  expect_equal(berlin_alter, c(3340, 1578, 1636))
})

# TODO: test for NA columns / what happens with NA