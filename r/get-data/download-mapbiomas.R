# Download URLs
years <- 1985:2021
download_urls <- paste0("https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_", years,".tif")

# Output folder
output_folder <- paste0(project_path, "data/raw/raster/mapbiomas/")

# Download
for (i in 1:length(download_urls)) {
	output_file <- paste0(output_folder, basename(download_urls[i]))
	download.file(download_urls[i], destfile = output_file, mode = "wb")
	cat(basename(download_urls[i]), "downloaded to ", output_folder, "\n")
}


# Garbage collection
rm(download_urls, output_folder, output_file)
gc()

cat("download-mapbiomas.R done\n")
