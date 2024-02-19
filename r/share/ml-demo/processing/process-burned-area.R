
parRasterize <- function(i, v_paths, r_path, out_folder) {

    v <- vect(v_paths[i])
    r <- rast(r_path)

    r_out <- terra::rasterize(v, r, touches = TRUE)

    r_out |> writeRaster(paste0(out_folder, gsub(".shp", ".tif", basename(v_paths[i]))), overwrite = TRUE)

    return(0)

}

v_paths <- list.files(paste0(project_path, "data/constructed/shp/modis-burned-area/"), full.names = TRUE, pattern = "*.shp")

out_folder <- paste0(project_path, "data/constructed/raster/modis-burned-area/")
if (!dir.exists(out_folder)) dir.create(out_folder)

registerDoParallel(cores = 7)

    foreach(ii = 1:length(v_paths), .packages = c("terra")) %dopar% {
        parRasterize(i = ii, v_paths = v_paths, r_path = filenames$raster$mapbiomas[[1]], out_folder = out_folder)
    }

stopImplicitCluster()


