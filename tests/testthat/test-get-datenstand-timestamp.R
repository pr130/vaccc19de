
test_that("extract timestamp string", {
  raw <- readxl::read_excel("test_data/2020-12-31T131123_impfquotenmonitoring.xlsx", sheet = 1)
  expect_equal(rki_extract_ts_string(raw), "29.12.2020, 08:00 Uhr")
})


test_that("parse timestamp", {
  expect_equal(rki_parse_ts("29.12.2020, 08:00 Uhr"), as.POSIXct(strptime("2020-12-29 08:00:00", "%Y-%m-%d %H:%M:%S"), tz = "Europe/Berlin"))
})


test_that("get timestamp", {
  raw <- readxl::read_excel("test_data/2020-12-31T131123_impfquotenmonitoring.xlsx", sheet = 1)
  ts <- rki_get_timestamp(raw)
  expect_equal(ts, as.POSIXct(strptime("2020-12-29 08:00:00", "%Y-%m-%d %H:%M:%S"), tz = "Europe/Berlin"))
})


test_that("get timestamp - new format in two columns", {
  raw <- readxl::read_excel("test_data/impfmonitoring_new_datenstand_format.xlsx", sheet = 1)
  ts <- rki_get_timestamp(raw)
  expect_equal(ts, as.POSIXct(strptime("2020-12-30 11:00:00", "%Y-%m-%d %H:%M:%S"), tz = "Europe/Berlin"))
})