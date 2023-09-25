








# Combine Hansen to one file

raster_list <- list()
for (layer in names(links)) raster_list[[layer]] <- lapply(list.files(paste0("C:/data/Hansen/", layer, "/"), pattern = "*.tif", full.names = TRUE), rast)
for (layer in names(raster_list)) terra::mosaic(sprc(raster_list[[layer]]), filename = paste0(project_path, "data/tif/hansen_", layer ,".tif"))




