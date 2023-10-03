### VIIRS

download_urls <- c(
	"https://eogdata.mines.edu/nighttime_light/annual/v21/2012/VNL_v21_npp_201204-201303_global_vcmcfg_c202205302300.average_masked.dat.tif.gz",
	"https://eogdata.mines.edu/nighttime_light/annual/v21/2013/VNL_v21_npp_2013_global_vcmcfg_c202205302300.average_masked.dat.tif.gz",
	paste0("https://eogdata.mines.edu/nighttime_light/annual/v21/", 2014:2021, "/VNL_v21_npp_", 2014:2021, "_global_vcmslcfg_c202205302300.average_masked.dat.tif.gz")
	)

download_folder <- paste0(project_path, "data/raw/raster/nightlights/viirs/extracted/")

# Download
for (i in 1:length(download_urls)) {
	output_file <- paste0(download_folder, basename(download_urls[i]))
	download.file(download_urls[i], destfile = output_file, mode = "wb")
	cat(basename(download_urls[i]), "downloaded to ", download_folder, "\n")
}

# Extract .gz files within the folder; this removes the .gz file
gz_files <- list.files(download_folder, pattern = ".gz", full.names = TRUE)
for (i in 1:length(gz_files)) R.utils::gunzip(gz_files[i], overwrite = TRUE)

# Garbage collection
rm(download_urls, download_folder, output_file, gz_files)
gc()

cat("download-viirs.R done\n")