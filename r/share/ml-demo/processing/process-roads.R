# ==============================================================================
# 2024/02/08
# Sarah Meier
# BIOADD Work Package 2
# This script rasterises the roads data and creates
#       - (i) binary variable road occurrence
#       - (ii) distance to road (for primary, secondary, and trails) in meters
#       - (iii) road density within 1km buffer (nr. of pixels)
# ==============================================================================

# Read data
roads <- st_read("C:/Users/sm1383/Dropbox/NERC BIG BOI/Work Packages/WP2/data/Caminos/Caminos.shp")
r_s <- rast(paste0(project_path, "/data/constructed/raster/misc/ml-demo/ml_demo_sample_mask.tif"))
test <- st_read("C:/Users/sm1383/Dropbox/BioAdd/Data/Yapacani.shp")


# ==============================================================================
# Bolivia
# ==============================================================================

  # Buffer road vectors
  roads_buff <- st_buffer(roads, dist = 100)
  
  # (i) Rasterise 
  r_roads <- terra::rasterize(roads_buff, r_s, touches=TRUE)
  
  # Save raster file
  outpath <- "C:/GitHub/bioadd-wp2-github/r/share/ml-demo/r_roads.tif"
  terra::writeRaster(r_roads, outpath,  overwrite = TRUE)

# ==============================================================================
# Test municipality: Yapacani
# ==============================================================================

  # Clip raster and road file to Yapacani Municipality
  roads_test <- st_intersection(roads, test)
  plot(roads_test)
  r_s_test <- crop(r_s, test)
  
  # Buffer road vectors
  roads_buff_test <- st_buffer(roads_test, dist = 100)

# (i) Rasterise all roads and calculate (ii) Distance
  r_roads_test <- terra::rasterize(roads_buff_test, r_s_test, touches=TRUE)
  plot(r_roads_test)
  writeRaster(r_roads_test, "C:/GitHub/bioadd-wp2-github/r/share/ml-demo/r_roads_test.tif", overwrite = TRUE)
  r_ds <- aggregate(r_roads_test, 40, "max", na.rm = TRUE)
  roads_ds <- terra::distance(x = r_ds)
  plot(roads_ds)
  writeRaster(roads_ds, "C:/GitHub/bioadd-wp2-github/r/share/ml-demo/roads_dist_test.tif", overwrite = TRUE)


# (i) Rasterise road types and calculate (ii) Distance
  
  # Define road types 
  road_types <- c("Principal o Carretero", "Secundario o Vecinal", "Senda, Rodera o Vereda")
  
  # Loop over each road type
  for (road_type in road_types) {
    # Filter roads by type
    roads_filtered <- roads[roads$NBVIALIDAD == road_type, ]
    
    # Perform intersection
    roads_test_filtered <- st_intersection(roads_filtered, test)
    
    # Buffer the roads
    roads_buff_test_filtered <- st_buffer(roads_test_filtered, dist = 100)
    
    # Rasterise the buffered roads
    r_roads_test_filtered <- terra::rasterize(roads_buff_test_filtered, r_s_test, touches=TRUE)
    
    # Aggregate the raster
    r_ds_filtered <- aggregate(r_roads_test_filtered, 40, "max", na.rm = TRUE)
    
    # Calculate distance
    roads_ds_filtered <- terra::distance(x = r_ds_filtered)
    
    # Plot the distance raster 
    #plot(roads_ds_filtered)
    
    # Construct the output file name based on road type
    output_file_name <- sprintf("C:/GitHub/bioadd-wp2-github/r/share/ml-demo/roads_dist_%s.tif", substr(road_type, 1, 1))
    
    # Write the raster to file
    writeRaster(roads_ds_filtered, output_file_name, overwrite = TRUE)
  }
  

# (iii) Calculate road density (1km) all roads
  
  # Diameter in meters divided by cell size for 1km radius
  diameter_cells <- (2000 / 30)
  radius_cells <- diameter_cells / 2
  
  # Create square window
  win_size <- ceiling(diameter_cells) 
  
  # Create a matrix to represent the circular window
  win_matrix <- matrix(0, nrow = win_size, ncol = win_size)
  center <- floor(win_size / 2) + 1
  
  # Fill the matrix to approximate a circle
  for (row in 1:win_size) {
    for (col in 1:win_size) {
      # Calculate the distance from the center of the matrix
      distance <- sqrt((row - center)^2 + (col - center)^2)
      # Mark cells within the radius as part of the window
      if (distance <= radius_cells) {
        win_matrix[row, col] <- 1
      }
    }
  }
  
  # Calculate road density using the circular window
  road_density <- focal(r_roads_test, w = win_matrix, fun = sum, na.rm = TRUE)
  plot(road_density)
  writeRaster(road_density, "C:/GitHub/bioadd-wp2-github/r/share/ml-demo/road_dens_test.tif", overwrite = TRUE)
  
  
# (iii) Calculate road density (1km) for road types
  
  # Loop over each road type
  for (road_type in road_types) {
    # Diameter in meters divided by cell size for 1km radius
    diameter_cells <- (2000 / 30)
    radius_cells <- diameter_cells / 2
    
    # Create square window
    win_size <- ceiling(diameter_cells)
    
    # Create a matrix to represent the circular window
    win_matrix <- matrix(0, nrow = win_size, ncol = win_size)
    center <- floor(win_size / 2) + 1
    
    # Fill the matrix to approximate a circle
    for (row in 1:win_size) {
      for (col in 1:win_size) {
        distance <- sqrt((row - center)^2 + (col - center)^2)
        if (distance <= radius_cells) {
          win_matrix[row, col] <- 1
        }
      }
    }
    
    # Calculate road density using the circular window
    road_density_filtered <- focal(r_roads_test_filtered, w = win_matrix, fun = sum, na.rm = TRUE)
    
    # Construct the output file name for road density based on road type
    output_file_density_name <- sprintf("C:/GitHub/bioadd-wp2-github/r/share/ml-demo/road_dens_%s.tif", substr(road_type, 1, 1))
    
    # Write the road density raster to file
    writeRaster(road_density_filtered, output_file_density_name, overwrite = TRUE)
  }







