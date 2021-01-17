## code to prepare `DATASET` dataset goes here
BUNDESLAND_TO_ISO <- tibble::tribble(
    ~bundesland, ~bundesland_iso, ~RS,
    "Baden-Württemberg", "BW", "08",
    "Bayern", "BY", "09",
    "Berlin", "BE", "11",
    "Brandenburg", "BB", "12",
    "Bremen", "HB", "04",
    "Hamburg", "HH", "02",
    "Hessen", "HE", "06",
    "Mecklenburg-Vorpommern", "MV", "13",
    "Niedersachsen", "NI", "03",
    "Nordrhein-Westfalen", "NW", "05",
    "Rheinland-Pfalz", "RP", "07",
    "Saarland", "SL", "10",
    "Sachsen", "SN", "14",
    "Sachsen-Anhalt", "ST", "15",
    "Schleswig-Holstein", "SH", "01",
    "Thüringen", "TH", "16"
)

usethis::use_data(BUNDESLAND_TO_ISO, overwrite = TRUE)

