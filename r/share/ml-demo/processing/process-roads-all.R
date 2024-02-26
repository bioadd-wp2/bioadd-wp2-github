# ==============================================================================
# 2024/02/08
# Sarah Meier
# BIOADD Work Package 2
# This script rasterises the roads data and creates
#       - (i) binary variable road occurrence
#       - (ii) distance to road (for primary, secondary, and trails) in meters
#       - (iii) road density within 1km buffer (nr. of pixels)
#
# 2023/02/10: Edits to process entire Bolivia
#
# ==============================================================================

# Read data
roads <- vect(filenames$vector$roads_2001)
r_mask <- rast(filenames$ml_demo$bolivia_mask)
r_s <- rast(paste0(project_path, "/data/constructed/raster/misc/ml-demo/ml_demo_sample_mask.tif"))

# ==============================================================================
# (i) Rasterize the vector data
# ==============================================================================

# Rasterize the vector data
# Differentiate by road category

roads[, "cat"] <- as.numeric(NA)
roads[roads$NBVIALIDAD == "Principal o Carretero", "cat"] <- 1
roads[roads$NBVIALIDAD == "Secundario o Vecinal", "cat"] <- 2
roads[roads$NBVIALIDAD == "Senda, Rodera o Vereda", "cat"] <- 3

r_roads <- terra::rasterize(roads, r_s, touches = TRUE, field = "cat")

r_roads[is.na(r_mask)] <- NA

outpath <- paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001.tif")
r_roads |> terra::writeRaster(outpath, overwrite = TRUE)




# ==============================================================================
# (ii) Distances
# ==============================================================================

# distances calculated in QGIS, see process-distances.py
# Whitebox may be an alternative. It is very fast, but it has considerable memory requirements (should anticipate 4 x size on disk, uncompressed)






# ==============================================================================
# (iii) Road density within 1km
# ==============================================================================

# Again, only 1km grid, not focal density

r_roads <- terra::rast(paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001.tif"))

out_folder <- paste0(project_path, "data/constructed/raster/misc/ml-demo/road_density/")
if (!dir.exists(out_folder)) dir.create(out_folder)

for (i in 1:3) terra::aggregate(as.numeric(r_roads %in% i), 40, na.rm = TRUE) |> writeRaster(paste0(out_folder, "road_density_", i, ".tif"))




