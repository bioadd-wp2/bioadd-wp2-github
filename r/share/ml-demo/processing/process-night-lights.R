
# Resample night lights data

# Function

parResample <- function(i, r_paths, r_s_path, out_folder) {

	r <- rast(r_paths[[i]])
	r_name <- basename(r_paths[[i]])
	r_s <- rast(r_s_path)

	r_resampled <- resample(r, r_s, method = "near", threads = FALSE) # Do not use multiple threads as this function will be parallelized over
	r_resampled |> writeRaster(paste0(out_folder, "/", r_name), overwrite = TRUE)

	return(0)

}

# Parallelize

out_folder <- paste0(project_path, "data/constructed/raster/misc/ml-demo/nightlights-resampled/")
if (!dir.exists(out_folder)) dir.create(out_folder)

registerDoParallel(cores = 10)

    foreach(ii = 1:length(filenames$raster$nightlights), .packages = c("terra")) %dopar% {
        parResample(i = ii, r_paths = filenames$raster$nightlights, r_s_path = filenames$ml_demo$sampling_raster, out_folder = out_folder)
    }

stopImplicitCluster()

