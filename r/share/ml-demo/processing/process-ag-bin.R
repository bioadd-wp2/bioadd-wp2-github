

parAg <- function(i, r_paths, out_folder) {

    r <- rast(r_paths[[i]])
    r_ag <- as.numeric(r %in% c(14,15,18,21))
    r_ag[r == 0] <- NA

    r_ag |> writeRaster(paste0(out_folder, "/", names(r), ".tif"))

    return(0)
}

r_paths <- filenames$raster$mapbiomas

out_folder <- paste0(project_path, "data/constructed/raster/mapbiomas-ag-bin/")
if (!dir.exists(out_folder)) dir.create(out_folder)

registerDoParallel(cores = 5)

    foreach(ii = 1:length(r_paths), .packages = c("terra")) %dopar% {
        parAg(i = ii, r_paths = r_paths, out_folder = out_folder)
    }

stopImplicitCluster()


