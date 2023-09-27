### DMSP

# Download URLs
dmsp_files <- c(
	"F101992", "F101993", "F101994", "F121994", "F121995", 
    "F121996", "F121997", "F121998", "F121999", "F141997", 
    "F141998", "F141999", "F142000", "F142001", "F142002", 
    "F142003", "F152000", "F152001", "F152002", "F152003", 
    "F152004", "F152005", "F152006", "F152007", "F152008", 
    "F162004", "F162005", "F162006", "F162007", "F162008", 
    "F162009", "F182010", "F182011", "F182012", "F182013")

download_urls <- paste0("https://www.ngdc.noaa.gov/eog/data/web_data/v4composites/", dmsp_files, ".v4.tar")

download_folder <- paste0(project_path, "data/raw/raster/nightlights/dmsp/tar/")

# Download
for (i in 1:length(download_urls)) {
	output_file <- paste0(download_folder, basename(download_urls[i]))
	download.file(download_urls[i], destfile = output_file, mode = "wb")
	cat(basename(download_urls[i]), "downloaded to ", download_folder, "\n")
}

# Extract downloaded files to a separate folder

tar_files <- list.files(download_folder, full.names = TRUE)
extracted_folder <- paste0(project_path, "data/raw/raster/nightlights/dmsp/extracted/")
for (i in 1:length(tar_files)) untar(tar_files[i], exdir = extracted_folder)

# Extract .gz files within the folder; this removes the .gz file
gz_files <- list.files(extracted_folder, pattern = ".gz", full.names = TRUE)
for (i in 1:length(gz_files)) R.utils::gunzip(gz_files[i], overwrite = TRUE)

# Garbage collection
rm(dmsp_files, download_urls, download_folder, output_file, tar_files, extracted_folder, gz_files)
gc()

cat("download-dmsp-ols.R done\n")