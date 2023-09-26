# These tiles intersect with Bolivia
tiles <- c(
	"00N_070W",
    "10S_070W", "10S_060W",
	"20S_070W", "20S_060W"
	)

# Download URLs
download_urls <- list()
download_urls$gain <- paste0("https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_gain_", tiles, ".tif")
download_urls$lossyear <- paste0("https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_lossyear_", tiles, ".tif")
download_urls$treecover <- paste0("https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_treecover2000_", tiles, ".tif")

# Output folders
output_folders <- list()
output_folders$gain       <- paste0(project_path, "data/raw/raster/hansen/gain/")
output_folders$lossyear   <- paste0(project_path, "data/raw/raster/hansen/lossyear/")
output_folders$treecover  <- paste0(project_path, "data/raw/raster/hansen/treecover/")

# Download
for (layer in names(download_urls)) {

	for (i in 1:length(download_urls[[layer]])) {

		output_file <- paste0(output_folders[[layer]], basename(download_urls[[layer]][i]))
		download.file(download_urls[[layer]][i], destfile = output_file, mode = "wb")

	}

}


# Garbage collection
rm(tiles, download_urls, output_folders, output_file)
gc()

cat("download-hansen.R done\n")
