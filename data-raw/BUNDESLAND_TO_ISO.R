## code to prepare `DATASET` dataset goes here
BUNDESLAND_TO_ISO <- tibble::tribble(
    ~bundesland, ~bundesland_iso, 
    "Baden-Württemberg", "BW", 
    "Bayern", "BY", 
    "Berlin", "BE", 
    "Brandenburg", "BB", 
    "Bremen", "HB",
    "Hamburg", "HH",
    "Hessen", "HE",
    "Mecklenburg-Vorpommern", "MV",
    "Niedersachsen", "NI",
    "Nordrhein-Westfalen", "NW",
    "Rheinland-Pfalz", "RP",
    "Saarland", "SL",
    "Sachsen", "SN",
    "Sachsen-Anhalt", "ST",
    "Schleswig-Holstein", "SH",
    "Thüringen", "TH"
)

usethis::use_data(BUNDESLAND_TO_ISO, overwrite = TRUE)
