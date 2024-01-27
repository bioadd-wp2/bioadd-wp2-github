
# Read data

r_gain <- lapply(list.files(paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-gain/"), full.names = TRUE), rast)
r_mb <- rast(filenames$raster$mapbiomas[[1]])

# Edits

names(r_gain) <- gsub(".tif", "", list.files(paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-gain/")))


# Ever gain raster for years of analysis

years <- 2000:2011

r_ever_gain <- app(rast(r_gain[paste0("forest_gain_", years)]), fun = sum, na.rm = TRUE)

r_ever_gain <- subst(r_ever_gain, 1:max(minmax(r_ever_gain)), 1)
r_ever_gain <- mask(r_ever_gain, r_mb, maskvalue = 0, updatevalue = NA)

# Save

r_ever_gain |> writeRaster(filenames$ml_demo$ever_gain_2000_2011, overwrite = TRUE)
