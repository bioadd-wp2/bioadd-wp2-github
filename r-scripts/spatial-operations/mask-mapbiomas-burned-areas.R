library(sf)
library(terra)
library(tidyverse)

# Define Paths
# forest_rasters = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/raw-data/mapbiomas")
# burned_areas = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/constructed-data/burned_areas")
# bolivia_shapefiles = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/raw-data/shapefiles/gadm41_BOL_shp")
# output_rasters = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/constructed-data/burned_rasters")

# Define Fabian Paths
forest_rasters = file.path("bioadd/mapbiomas")
burned_rasters = file.path("bioadd/burned_rasters")
burned_areas = file.path("bioadd/burned_areas")
bolivia_shapefiles = file.path("bioadd/shapefiles/gadm41_BOL_shp")

##### Contemporaneous burned areas #####
# Loop over the years from 2001 to 2021
for (year in 2001:2021) {
  # Generate the shapefile name based on the year
  shapefile_name <- paste0("burned_", year)
  
  # Construct the full path to the shapefile
  shapefile_path <- file.path(burned_areas, paste0(shapefile_name, ".shp"))
  
  # Import the shapefile using the sf package
  shapefile <- read_sf(shapefile_path) %>% 
    st_union() %>% 
    st_as_sf() %>% 
    rename(geometry = x) %>% 
    mutate(ID = paste0("Burned Area ", year)) %>% 
    relocate(ID)
  
  # Generate the raster file name based on the year
  raster_name <- paste0("mapbiomas_", year, ".tif")
  
  # Construct the full path to the raster
  raster_path <- file.path(forest_rasters, raster_name)
  
  # Import the raster using the terra package
  raster <- rast(raster_path)
  
  # Mask the raster using the shapefile
  masked_raster <- mask(raster, shapefile)
  
  writeRaster(masked_raster, file.path(burned_rasters, paste0("masked_contemporaneous_",year,".tif")))
  
}

##### Lagged burned areas #####
# Loop over the years from 2001 to 2021
for (year in 2001:2021) {
  # Generate the shapefile name based on the year
  shapefile_name <- paste0("burned_", year)
  
  # Construct the full path to the shapefile
  shapefile_path <- file.path(burned_areas, paste0(shapefile_name, ".shp"))
  
  # Import the shapefile using the sf package
  shapefile <- read_sf(shapefile_path) %>% 
    st_union() %>% 
    st_as_sf() %>% 
    rename(geometry = x) %>% 
    mutate(ID = paste0("Burned Area ", year)) %>% 
    relocate(ID)
  
  # Generate the raster file name based on the year
  raster_name <- paste0("mapbiomas_", year+1, ".tif")
  
  # Construct the full path to the raster
  raster_path <- file.path(forest_rasters, raster_name)
  
  # Import the raster using the terra package
  raster <- rast(raster_path)
  
  # Mask the raster using the shapefile
  masked_raster <- mask(raster, shapefile)
  
  writeRaster(masked_raster, file.path(burned_rasters, paste0("masked_lagged_",year+1,".tif")))
  
}

