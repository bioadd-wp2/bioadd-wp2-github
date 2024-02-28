
# Protected area data from Protected Planet
# The polygons are identical to those found earlier in GeoBolivia
# Should discard the GeoBolivia data and use the Protected Planet collection

# There are two sets: polygons and points 
# The points are Ramsar wetland sites and they are mostly unimplemented -> ignore

v_polys_list <- lapply(filenames$vector$protected_areas$polygons, vect)
v_points_list <- lapply(filenames$vector$protected_areas$points, vect)

# This script only extracts the object ids to a raster; parsing later in editing. I can't think of a downside to this approach (vs parsing bevore rasterizing)

parRasterize <- function(i, v_paths, r_path, out_folder) {

    v <- vect(v_paths[[i]])
    r <- rast(r_path)

    r_out <- terra::rasterize(v, r, touches = TRUE, field = "WDPAID")

    r_out |> writeRaster(paste0(out_folder, names(v_paths[i]), ".tif"), overwrite = TRUE)

    return(0)

}


out_folder <- paste0(project_path, "data/constructed/raster/protected-areas/")
if (!dir.exists(out_folder)) dir.create(out_folder)

v_paths <- filenames$vector$protected_areas$polygon

registerDoParallel(cores = 3)

    foreach(ii = 1:length(v_paths), .packages = c("terra")) %dopar% {
        parRasterize(i = ii, v_paths = v_paths, r_path = filenames$raster$mapbiomas[[1]], out_folder = out_folder)
    }

stopImplicitCluster()

