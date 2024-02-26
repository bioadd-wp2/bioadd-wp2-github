

url <- "https://d1gam3xoknrgr2.cloudfront.net/current/WDPA_WDOECM_Feb2024_Public_BOL_shp.zip"
destination_path <- paste0(project_path, "data/raw/shp/", basename(url))

download.file(
    url = url,
    destfile = destination_path,
    mode = "wb"
    )

ex_dir <- gsub(".zip", "/", destination_path)
unzip(zipfile = destination_path, exdir = ex_dir)

zip_files <- list.files(ex_dir, full.names = TRUE, pattern = "*.zip")
extracted_folders <- gsub(".zip", "/", zip_files)
for (i in 1:length(zip_files)) unzip(zipfile = zip_files[i], exdir = extracted_folders[i])
