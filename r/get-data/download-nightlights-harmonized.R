# Harmonized night lights data 1992-2020

download_urls <- "https://figshare.com/ndownloader/articles/9828827/versions/8"
download_folder <- paste0(project_path, "data/raw/raster/nightlights/harmonized/")
output_file <- paste0(download_folder, "9828827.zip")

download.file(
	url = download_urls,
	destfile = output_file,
	mode = "wb"
	)

unzip(output_file, exdir = download_folder)

# Garbage collection
rm(download_urls, download_folder, output_file)
gc()

cat("download-nightlights-harmonized.R done\n")
