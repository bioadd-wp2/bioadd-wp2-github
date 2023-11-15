# Download URLs
years <- 1985:2021
download_urls <- paste0("https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/transitions/bolivia_transitions_", years[-length(years)], "_", years[-1], ".tif")

# Output folder
output_folder <- paste0(project_path, "data/raw/raster/mapbiomas-transitions/")

# Download
for (i in 1:length(download_urls)) {
	output_file <- paste0(output_folder, basename(download_urls[i]))
	download.file(download_urls[i], destfile = output_file, mode = "wb")
	cat(basename(download_urls[i]), "downloaded to ", output_folder, "\n")
}

# Garbage collection
rm(download_urls, output_folder, output_file)
gc()

cat("download-mapbiomas-transitions.R done\n")
