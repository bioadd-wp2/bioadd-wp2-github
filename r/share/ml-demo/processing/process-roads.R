

# Rasterise roads data

# Read data
roads_sf <- st_read("C:/Users/sm1383/Dropbox/NERC BIG BOI/Work Packages/WP2/data/Caminos/Caminos.shp")
#r_s <- rast(filenames$ml_demo$sampling_raster)
r_s <- rast("C:/GitHub/bioadd-wp2-github/data/constructed/raster/misc/ml-demo/ml_demo_sample_mask.tif")


############################# Bolivia ##########################################

# Create buffer around road vectors
roads_sf_buffered <- st_buffer(roads_sf, dist = 100)

# Rasterise 
r_roads <- terra::rasterize(roads_sf_buffered, r_s, touches=TRUE)

# Plot rasterised and original roads
plot(r_roads)
lines(roads_sf_buffered, col="gray", lwd=1, alpha = .01)

# Save raster file
r_roads |> writeRaster(filenames$ml_demo$r_roads, overwrite = TRUE)



################### Test Yapacani Municipality #################################

# Read shapefile Yapacani
clip_boundary_sf <- st_read("C:/Users/sm1383/Dropbox/BioAdd/Data/Yapacani.shp")

# Clip raster and road files to Yapacani Municipality
roads_sf_clipped <- st_intersection(roads_sf, clip_boundary_sf)
r_s_clipped <- crop(r_s, clip_boundary_sf)

# Create buffer around road vectors
roads_buffered_sf <- st_buffer(roads_sf_clipped, dist = 100)

# Rasterise
roads_raster_Yapacani <- terra::rasterize(roads_buffered_sf, r_s_clipped, touches=TRUE)

# Plot rasterised and original roads
plot(roads_raster_Yapacani)
lines(roads_buffered_sf, col="gray", lwd=1, alpha = .2)

# Distance to road
distance_to_road <- terra::distance(x = roads_raster_Yapacani)

# Road density

# Adjusted for a 1 km radius
cell_size <- 30 # meters
radius_meters <- 1000 # 1 km in meters

# Calculate the number of cells to cover the radius, then diameter, then add 1 for the center cell
cells_in_radius <- radius_meters / cell_size
win_size <- ceiling(cells_in_radius * 2) + 1

# Create a matrix representing the focal window, all 1s, with dimensions calculated above
focal_window <- matrix(1, nrow = win_size, ncol = win_size)

# Calculate road density using the focal function
road_density <- focal(roads_raster_Yapacani, w = focal_window, fun = sum, na.rm = TRUE)

# Normalize road density by the number of cells in the focal window to get a density measure
total_cells_in_window <- win_size^2
road_density_norm <- road_density / total_cells_in_window

# Plot road density
plot(road_density_norm, main="Road Density within 1 km Radius")





