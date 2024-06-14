

mapPrediction <- function(y, in_folder, r_path, pred_t, crop_raster = TRUE, out_folder, overlay_forest = FALSE)  {

    r <- terra::rast(r_path)

    if (overlay_forest == TRUE) r_f <- rast(paste0(project_path, "data/constructed/raster/mapbiomas-forest-bin/bolivia_coverage_", i, ".tif"))
    if (overlay_forest == TRUE) r_f_agg <- aggregate(r_f, 100, fun = "modal")


    p_dt <- data.table::fread(paste0(in_folder, "pred_", y, ".csv"))
    s_dt <- data.table::fread(filenames$ml_demo$sample)

    update_cols <- paste0("V", pred_t)
    new_cols <- paste0("pred")

    s_dt[p_dt, (new_cols) := setDT(mget(paste0('i.', update_cols))), on = .(cell)]

    # Crop to Santa Cruz
    if (crop_raster == TRUE) {

        v <- terra::vect(filenames$vector$gadm, layer = "ADM_ADM_1")
        v <- v[v$NAME_1 %in% c("Santa Cruz"),]

        r <- terra::crop(r, v)
        if (overlay_forest == TRUE) r_f_agg <- terra::crop(r_f_agg, v)

    }

    # Get cell position in the target raster
    s_dt$cell_in_r <- terra::cellFromXY(r, s_dt[,.(x, y)])

    # Average pixels within the same pixel
    s_agg <- s_dt[!is.na(pred), .(pred = mean(pred, na.rm = TRUE)), .(cell_in_r)]

    # Replace value in target raster
    r[as.numeric(s_agg[!is.na(pred)]$cell_in_r)] <- as.numeric(s_agg[!is.na(pred)]$pred)

    # Overlay risk on forest

    if (overlay_forest == TRUE) r[!is.na(r) & r_f_agg == 0] <- 0

    
    # Save
    out_path <- paste0(out_folder, "pred_", y, ".tif")
    r |> writeRaster(out_path, overwrite = TRUE)

}


