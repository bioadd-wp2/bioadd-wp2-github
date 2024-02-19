
# Required in further processing tasks

r <- rast(filenames$raster$mapbiomas[[1]])
r[r == 0] <- NA
r[r != 0] <- 1
r |> writeRaster(filenames$ml_demo$bolivia_mask, overwrite = TRUE)

v <- vect(filenames$vector$gadm, layer = "ADM_ADM_0")
v |> writeVector(filenames$ml_demo$bolivia_mask_polygon, overwrite = TRUE)
