
parAgg <- function(r_path, classes, out_folder) {

    r <- terra::rast(r_path)
    r_agg <- terra::aggregate(r, fact = 5, fun = mean, na.rm = TRUE)
    r_agg |> terra::writeRaster(paste0(out_folder, basename(r_path)), overwrite = TRUE)

    return(0)

}

fread(filenames$csv$mapbiomas_colors)

registerDoParallel(cores = 6)

r_paths <- list.files(paste0(project_path, "/data/constructed/raster/mapbiomas-aggregated/forest/"), full.names = TRUE)
output_folder <- paste0(project_path, "/data/constructed/raster/mapbiomas-aggregated/forest-200/")
if (!dir.exists(output_folder)) dir.create(output_folder)

    foreach(path = r_paths, .packages = c("terra")) %dopar% {
        parAgg(r_path = path,  out_folder = output_folder)
    }


r_paths <- list.files(paste0(project_path, "/data/constructed/raster/mapbiomas-aggregated/farming/"), full.names = TRUE)
output_folder <- paste0(project_path, "/data/constructed/raster/mapbiomas-aggregated/farming-200/")
if (!dir.exists(output_folder)) dir.create(output_folder)

    foreach(path = r_paths, .packages = c("terra")) %dopar% {
        parAgg(r_path = path, out_folder = output_folder)
    }


r_paths <- list.files(paste0(project_path, "/data/constructed/raster/mapbiomas-aggregated/water/"), full.names = TRUE)
output_folder <- paste0(project_path, "/data/constructed/raster/mapbiomas-aggregated/water-200/")
if (!dir.exists(output_folder)) dir.create(output_folder)

    foreach(path = r_paths, .packages = c("terra")) %dopar% {
        parAgg(r_path = path, out_folder = output_folder)
    }


r_paths <- list.files(paste0(project_path, "/data/constructed/raster/mapbiomas-aggregated/24/"), full.names = TRUE)
output_folder <- paste0(project_path, "/data/constructed/raster/mapbiomas-aggregated/urban-200/")
if (!dir.exists(output_folder)) dir.create(output_folder)

    foreach(path = r_paths, .packages = c("terra")) %dopar% {
        parAgg(r_path = path, out_folder = output_folder)
    }


r_paths <- list.files(paste0(project_path, "/data/constructed/raster/misc/ml-demo/road_density/"), full.names = TRUE)
output_folder <- paste0(project_path,      "/data/constructed/raster/misc/ml-demo/road_density_200/")
if (!dir.exists(output_folder)) dir.create(output_folder)

    foreach(path = r_paths, .packages = c("terra")) %dopar% {
        parAgg(r_path = path, out_folder = output_folder)
    }


stopImplicitCluster()


