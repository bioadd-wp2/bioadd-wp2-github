
r <- rast(filenames$ml_demo$ever_gain_2000_2011)
v <- vect(filenames$vector$gadm, layer = "ADM_ADM_1")

v_aoi <- v[v$NAME_1 == "Santa Cruz",]

r_mask <- terra::rasterize(v_aoi, r, field = 1)
r_sample <- r_mask * r

r_sample |> writeRaster(filenames$ml_demo$sampling_raster, overwrite = TRUE)
