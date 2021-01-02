

test_that("getting timestamp from xlsx path works", {
    ts <- get_download_ts_from_path("vaccc19de_rki_data/data/raw/2020-12-30T110936_impfmonitoring.xlsx")
    expect_equal(ts, as.POSIXct(strptime("2020-12-30 11:09:36", "%Y-%m-%d %H:%M:%S"), tz = "Europe/Berlin"))
})

