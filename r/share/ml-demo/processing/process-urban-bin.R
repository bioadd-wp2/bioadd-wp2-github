
parUrban <- function(i, r_paths, out_folder) {

    r <- rast(r_paths[[i]])
    r_f <- as.numeric(r %in% c(24))
    r_f[r == 0] <- NA

    r_f |> writeRaster(paste0(out_folder, "/", names(r), ".tif"))

    return(0)
}

r_paths <- filenames$raster$mapbiomas

out_folder <- paste0(project_path, "data/constructed/raster/mapbiomas-urban-bin/")
if (!dir.exists(out_folder)) dir.create(out_folder)

registerDoParallel(cores = 6)

    foreach(ii = 1:length(r_paths), .packages = c("terra")) %dopar% {
        parUrban(i = ii, r_paths = r_paths, out_folder = out_folder)
    }

stopImplicitCluster()


