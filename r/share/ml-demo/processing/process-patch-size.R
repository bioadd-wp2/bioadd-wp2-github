


r <- rast(paste0(project_path, "data/constructed/raster/mapbiomas-forest-bin/bolivia_coverage_1985.tif"))


v <- vect(filenames$vector$gadm, layer = "ADM_ADM_3")
v <- v[v$NAME_3 == "El Torno", ]

r_crop <- crop(r, v)


r_p <- patches(r_crop, directions=4, zeroAsNA=TRUE, allowGaps=TRUE)





















