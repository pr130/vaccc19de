#' download excel file from rki website
#' @param out_folder character. folder to store the excel file. defaults to here::here()
#' @export
#' @description uses rvest and curl to download the excel from rki
#' @return character. path to excel file, invisibly.
rki_download_xlsx <- function(out_folder = here::here()) {
    BASE_URL <- "https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Impfquotenmonitoring.html"
    hrefs <- BASE_URL %>% 
        xml2::read_html() %>% 
        rvest::html_nodes("a.downloadLink") %>% 
        rvest::html_attr("href")
    # assumes that the file is called Impfquotenmonitoring.xlsx
    impf_path <- hrefs %>% stringr::str_subset("Impfquotenmonitoring.xlsx")
    impf_url <- paste0("https://www.rki.de/", impf_path)[1] # only download first one

    # use curl to download to file 
    # timestamp for file
    ts_file <- lubridate::now(tz = "Europe/Berlin") %>% 
        lubridate::format_ISO8601() %>% 
        stringr::str_replace_all(":", "")
    xlsx_path <- fs::path(out_folder, glue::glue("{ts_file}_impfmonitoring.xlsx"))
    curl::curl_download(impf_url, xlsx_path)
    invisible(xlsx_path)
}

#' store sheets from xlsx as csvs 
#' @param xlsx_path character. path to xlsx file
#' @param out_folder folder to store the csv files. defaults to here::here()
#' @description store sheets from xlsx as csvs (for easier debugging).
#' @export
rki_extract_sheet_csvs <- function(xlsx_path, out_folder = here::here()) {
    xlsx_file <- fs::path_file(xlsx_path)
    common <- fs::path_ext_remove(xlsx_file)
    sheets <- readxl::excel_sheets(xlsx_path)
    purrr::imap(sheets, function(sheet, i) {
        raw <- readxl::read_excel(xlsx_path, sheet)
        sheet_name <- tolower(sheet)
        path <- fs::path(out_folder, glue::glue("{common}_sheet{i}_{sheet_name}.csv"))
        readr::write_csv(raw, path)
    })
}