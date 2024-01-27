#
# This script produces layers that indicate forest gain in the Mapbiomas transitions layers. The transition layers have a spatial filter applied to them (see documentation for details).
# The spatial filter is absent in the transition layers that we have constructed ourselves.
#
# Input: Mapbiomas transition layers
# Output: Rasters that indicate a transition to forest cover

rasters <- lapply(filenames$raster$mapbiomas_transitions, rast)

# The data come in four digits, AABB, with AA indicating land cover at t-1 and BB indicating land cover at t
# The fastest way to do this will be to evaluate against the entire vector of possible forest transitions. This requires only one evaluation of each layer.

classes <- fread(filenames$csv$mapbiomas_colors)

forest_gain_transitions <- sort(c(
    classes$value[!(classes$value %in% c(3,6))]*100 + 3,
    classes$value[!(classes$value %in% c(3,6))]*100 + 6
    ))

ParGetForestGain <- function(r_path) {

    r <- terra::rast(r_path)
    r_name <- names(r)

    r_gain <- r %in% forest_gain_transitions

    output_filename <- paste0("forest_gain_transitions_", substr(r_name, nchar(r_name)-3, nchar(r_name)), ".tif")

    r_gain |> terra::writeRaster(filename = paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-gain-transitions/", output_filename), overwrite = TRUE)

    return(0)

}


t0 <- Sys.time()
registerDoParallel(cores = 6)

    r_paths <- unlist(filenames$raster$mapbiomas_transitions)

    foreach(r_path = r_paths, .packages = c("terra")) %dopar% {
        ParGetForestGain(r_path = r_path)
    }

stopImplicitCluster()
t1 <- Sys.time()
t1-t0
