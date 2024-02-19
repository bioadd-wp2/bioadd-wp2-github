



parDistance <- function(i, r_agg_paths, out_folder) {

    r <- rast(r_agg_paths[i])

    # Mask pixels outside of Bolivia. Mask values are set to an integer since distances are calculated for NA values
    v <- vect(filenames$vector$gadm, layer = "ADM_ADM_0")
    r_mask <- rasterize(v, r, touches = TRUE)
    r[is.na(r_mask)] <- 99

    r_dist <- terra::distance(r, target = dt$target[i], exclude = 99)

    r_dist |> writeRaster(paste0(out_folder, "/", dt$out_filename[i]))

    return(0)

}



r <- rast(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/forest/bolivia_coverage_1985.tif"))

plot(r)


dt <- data.table(filepath = filenames$raster, out_filename = "", target = 0, exclude = 99, )



out_folder <- paste0(project_path, "data/constructed/raster/misc/ml-demo/distances/")
if (!dir.exists(out_folder)) dir.create(out_folder)




