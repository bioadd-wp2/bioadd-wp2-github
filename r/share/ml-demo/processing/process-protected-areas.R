
parRasterize <- function(i, v_paths, r_path, out_folder) {

    v <- vect(v_paths[[i]])
    r <- rast(r_path)

    r_out <- terra::rasterize(v, r, touches = TRUE, fields = )

    r_out |> writeRaster(paste0(out_folder, names(v_paths[i]), ".tif"), overwrite = TRUE)

    return(0)

}

plot(vect(filenames$vector$protected_areas$polygons$national))


out_folder <- paste0(project_path, "data/constructed/raster/protected-areas/")
if (!dir.exists(out_folder)) dir.create(out_folder)

registerDoParallel(cores = 3)

    foreach(ii = 1:length(v_paths), .packages = c("terra")) %dopar% {
        parRasterize(i = ii, v_paths = filenames$vector$protected_areas$polygon, r_path = filenames$raster$mapbiomas[[1]], out_folder = out_folder)
    }

stopImplicitCluster()

