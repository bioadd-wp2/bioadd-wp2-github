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


































# ==============================================================================
# (ii) Calculate distance
# ==============================================================================


r_roads <- terra::rast(paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001.tif"))

r_list <- list()
r_list_ds <- list()

# Aggregate and save to disk

for (i in 1:3) {

    r_list[[i]] <- r_roads
    r_list[[i]][r_list[[i]] != i] <- NA

    r_list_ds[[i]] <- terra::aggregate(r_list[[i]], 40, "max", na.rm = TRUE)

    r_list_ds[[i]] |> writeRaster(paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001_agg_", i, ".tif")) 

}



# Parallelize the distance calculation

parDistance <- function(i, r_agg_paths, out_folder) {

    r <- rast(r_agg_paths[i])

    # Mask pixels outside of Bolivia. Mask values are set to 0 since distances are calculated for NA values
    v <- vect(filenames$vector$gadm, layer = "ADM_ADM_0")
    r_mask <- rasterize(v, r, touches = TRUE)
    r[is.na(r_mask)] <- 0

    r_dist <- terra::distance(r, exclude = 0)

    r_dist |> writeRaster(paste0(out_folder, "/roads_2001_dist_", i, ".tif"))

    return(0)

}


r_agg_paths <- paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001_agg_", c(1:3), ".tif")

out_folder <- paste0(project_path, "data/constructed/raster/misc/ml-demo/distances/")
if (!dir.exists(out_folder)) dir.create(out_folder)

registerDoParallel(cores = length(r_agg_paths))

    foreach(ii = 1:length(r_agg_paths), .packages = c("terra")) %dopar% {
        parDistance(i = ii, r_agg_paths = r_agg_paths, out_folder = out_folder)
    }

stopImplicitCluster()


# ==============================================================================
# (ii) Calculate distance with whitebox
# ==============================================================================

.libPaths() # Make sure there are no whitespaces in the library path

install.packages("whitebox", repos="http://R-Forge.R-project.org")

whitebox::wbt_init()

library(whitebox)

whitebox::wbt_version()


whitebox::wbt_euclidian_distance

funs <- ls(getNamespace("whitebox"), all.names=TRUE)
funs[grepl("dist", funs)]


r <- rast(paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001_agg_1.tif")) 
r[is.na(r)] <- 0
r |> writeRaster(paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001_agg_1_temp.tif"))

wbt_euclidean_distance(
    input = paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001_agg_1_temp.tif"),
    output = paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001_agg_1_distance.tif"),
    verbose_mode = TRUE
    )

r <- rast(paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001_agg_1_distance.tif")) 
plot(r)


r_roads <- terra::rast(paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001.tif"))
r_mask  <- rast(filenames$ml_demo$bolivia_mask)

r_roads[r_mask == 1 & is.na(r_roads)] <- 0
r_roads_all <- as.numeric(r_roads > 0)

r_roads_all |> writeRaster(paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001_all_temp.tif"))

r_roads_all |> writeRaster(paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001_all_temp_noncomp.tif"), gdal="COMPRESS=NONE")


wbt_euclidean_distance(
    input = paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001_all_temp.tif"),
    output = paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001_all_temp_distance.tif"),
    verbose_mode = TRUE
    )






# ==============================================================================
# (iii) Road density within 1km buffer
# ==============================================================================

r_roads <- terra::rast(paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001.tif"))

# Diameter and radius
d <- 2000
diameter_cells <- (d / 30)
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


v <- vect(filenames$vector$gadm, layer = "ADM_ADM_3")
v <- v[v$NAME_3 == "El Torno", ]
r_roads <- crop(r_roads, v)


# Calculate road density using the circular window
road_density <- focal(as.numeric(!is.na(r_roads)), w = win_matrix, fun = sum, na.rm = TRUE)
plot(road_density)
road_density |> writeRaster(paste0(project_path, "data/constructed/raster/misc/ml-demo/road_density_2001.tif"), overwrite = TRUE)


t0 <- Sys.time()
terra::focal(as.numeric(!is.na(r_roads)), w = win_matrix, fun = sum, na.rm = TRUE)
t1 <- Sys.time()

t2 <- Sys.time()
raster::focal(as.numeric(!is.na(r_roads)), w = win_matrix, fun = sum, na.rm = TRUE)
t3 <- Sys.time()

t4 <- Sys.time()
fasterFocal::fasterFocal(as.numeric(!is.na(r_roads)), w = win_matrix, fun = sum, na.rm = TRUE)
t5 <- Sys.time()



t1-t0
t3-t2
t5-t4


# Create a grid
# Iterate over grid cells
# buffer and crop
# focal
# mosaic



# Grid:

r <- rast(filenames$ml_demo$bolivia_mask)

r_agg <- aggregate(r, 5000, fun = sum, na.rm = TRUE)
v_grid <- as.polygons(r_agg, aggregate = FALSE, values = FALSE)


v_grid_b <- buffer(v_grid, d+60) # Add a margin to d to ensure sufficient coverage

ggplot() + geom_spatraster(data = r_agg) + geom_spatvector(data = v_grid_b, fill = NA)


# Iterate over the cells
# This is very memory intensive; cannot parallelize over layers; might want to parallelize this loop instead

r_roads <- terra::rast(paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001.tif"))
r_roads <- as.numeric(r_roads > 0)


r_focal_list <- list()

for (i in 1:length(v_grid_b)) {

    print(paste0(Sys.time(), " | ", i))

    r_crop <- crop(r_roads, v_grid_b[i,])

    r_focal_list[[i]] <- terra::focal(r_crop, w = win_matrix, fun = sum, na.policy = "omit", na.rm = TRUE)

}


# recursive mosaic?

r_mosaic_list <- list()
for (i in seq(1, length(r_focal_list), 2)) {
    print(paste0(Sys.time(), " | ", i, " | ", length(r_focal_list)))
    if (i+1 <= length(r_focal_list)) r_mosaic_list[[i]] <- mosaic(r_focal_list[[i]], r_focal_list[[i+1]], fun = "max")
    if (i+1 > length(r_focal_list)) r_mosaic_list[[i]] <- r_focal_list[[i]]
}
r_mosaic_list[sapply(r_mosaic_list, is.null)] <- NULL


r_mosaic_list_2 <- list()
for (i in seq(1, length(r_mosaic_list), 2)) {
    print(paste0(Sys.time(), " | ", i, " | ", length(r_mosaic_list)))
    if (i+1 <= length(r_mosaic_list)) r_mosaic_list_2[[i]] <- mosaic(r_mosaic_list[[i]], r_mosaic_list[[i+1]], fun = "max")
    if (i+1 > length(r_mosaic_list)) r_mosaic_list_2[[i]] <- r_mosaic_list[[i]]
}
r_mosaic_list_2[sapply(r_mosaic_list_2, is.null)] <- NULL




r_mosaic_list_3 <- list()
for (i in seq(1, length(r_mosaic_list_2), 2)) {
    print(paste0(Sys.time(), " | ", i, " | ", length(r_mosaic_list_2)))
    if (i+1 <= length(r_mosaic_list_2)) r_mosaic_list_3[[i]] <- mosaic(r_mosaic_list_2[[i]], r_mosaic_list_2[[i+1]], fun = "max")
    if (i+1 > length(r_mosaic_list_2)) r_mosaic_list_3[[i]] <- r_mosaic_list_2[[i]]
}
r_mosaic_list_3[sapply(r_mosaic_list_3, is.null)] <- NULL

origin(r_mosaic_list_2[[1]])

origin(r_mosaic_list_2[[7]])

r[breaks$start[i]:breaks$end[i], ,drop=FALSE]


[row_start:row_end, col_start:col_end]

#


r_mosaic <- r_focal_list[[1]]

for (i in 2:length(v_grid_b)) {

    print(paste0(Sys.time(), " | ", i))

    r_mosaic <- mosaic(r_mosaic, r_focal_list[[i]], fun = "max")

}

# Mosaic is too slow






r <- terra::rast(paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001.tif"))
r <- as.numeric(r > 0)

r_dims <- dim(r)[1:2]

s_px <- 5000
margin_px <- ceiling(win_size / 2)
iters <- ceiling(r_dims / s_px)

iter <- 0

r_list <- list()

for (i in 1:iters[1]) {

    row_start <- max(s_px*(i-1) + 1 - margin_px, 1)
    row_end   <- min(row_start + s_px + margin_px - 1, r_dims[1])

    for (j in 1:iters[2]) {

        #r_temp <- r_init

        iter <- iter + 1
        print(paste0(Sys.time(), " | ", iter))

        col_start <- max(s_px*(j-1) + 1 - margin_px, 1)
        col_end   <- min(col_start + s_px + margin_px - 1, r_dims[2])

        r_list[[iter]] <- r[row_start:row_end, col_start:col_end, drop = FALSE]

    }

}

idx <- sapply(r_list, function(x) sum(minmax(x), na.rm = TRUE) > 0)

r_list[idx]


focal_parallel<- function(x, ...){
  wrap(focal(unwrap(x),...)) #unwrap for processing and then wrap output
}


#In Parallel
plan(strategy = "multisession", workers = 20) #Set up parallel
out_list <- future_lapply(r_list, FUN = focal_parallel, fun = "mean", w = win_matrix, na.rm = TRUE)
plan(strategy = "sequential")


parallel<- combine_raster_chunks(out_list, buffer) #merge chunks into single raster



# ==============================================================================
# Test municipality: Yapacani
# ==============================================================================




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







