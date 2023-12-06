#
# Get forest gain rasters
#
# Input:
#     Mapbiomas Bolivia
# Output:
#     Binary raster indicating a transition from non-forest to forest, annual
#

ParGetForestGain <- function(raster_pair_path, out_folder) {

    # Read rasters
    r1 <- terra::rast(raster_pair_path[1])
    r2 <- terra::rast(raster_pair_path[2])

    # Ensure that the years are correct by checking that their difference equals one
    year1 <- as.numeric(sub(".+_(\\d{4}).tif", "\\1", basename(raster_pair_path[1])))
    year2 <- as.numeric(sub(".+_(\\d{4}).tif", "\\1", basename(raster_pair_path[2])))

    if ((year2 - year1) == 1) {
        as.numeric( !(r1 %in% c(3,6)) & (r2 %in% c(3,6)) ) |> terra::writeRaster(paste0(out_folder, "forest_gain_", year2, ".tif"), overwrite = TRUE)
        return(0)
    } else {
        return(1)
    }
}


### Parallelize

raster_pairs_paths <- list()
for (i in 1:(length(filenames$raster$mapbiomas) - 1)) {
    raster_pairs_paths[[i]] <- c(filenames$raster$mapbiomas[[i]], filenames$raster$mapbiomas[[i+1]])
}

output_folder <- paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-gain/")
if (!dir.exists(output_folder)) dir.create(output_folder)

registerDoParallel(cores = 4)

    foreach(raster_pair_path = raster_pairs_paths, .packages = c("terra")) %dopar% {
        ParGetForestLoss(raster_pair_path = raster_pair_path, out_folder = output_folder)
    }

stopImplicitCluster()

