
# Download URLs
years <- 2000:2022
download_urls <- paste0("https://firms.modaps.eosdis.nasa.gov/data/country/zips/modis_", years, "_all_countries.zip")

# Output folder
download_folder <- paste0(project_path, "data/raw/csv/firms/")

# Download
for (i in 1:length(download_urls)) {
    output_file <- paste0(download_folder, basename(download_urls[i]))
    download.file(download_urls[i], destfile = output_file, mode = "wb")
    cat(basename(download_urls[i]), "downloaded to ", download_folder, "\n")
}

# Unzip

for (year in years) unzip(
    zipfile = paste0(download_folder, "modis_", year, "_all_countries.zip"),
    files = paste0("modis/", year, "/modis_", year, "_Bolivia.csv"),
    exdir = download_folder
    )

# Collect to gpkg and save

firms_files <- list.files(paste0(download_folder, "modis/"), full.names = TRUE, recursive = TRUE, pattern = "*.csv")
dt_list <- lapply(firms_files, fread)
dt <- data.table::rbindlist(dt_list)
firms <- vect(dt, geom = c("longitude", "latitude"), crs = "EPSG:4326", keepgeom = TRUE)

firms |> writeVector(filenames$vector$firms, layer = "firms", overwrite = TRUE)

# Garbage collection
rm(years, download_urls, download_folder, output_file, firms)
gc()
