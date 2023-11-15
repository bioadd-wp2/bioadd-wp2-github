# Load required libraries
library(rgee)
library(sf)
library(terra)
library(tidyverse)
library(exactextractr)
library(tmap)

# Initialize Earth Engine
ee_Authenticate()
ee_Initialize()

# Set the MODIS product and date range
modis_product <- "MODIS/006/MCD64A1"

# Define the region of interest (Bolivia)
bolivia <- ee$FeatureCollection("FAO/GAUL/2015/level0")$filter(ee$Filter$eq("ADM0_NAME", "Bolivia"))


# Function to convert burned area data to polygons
convertToPolygons <- function(image) {
  burnedArea <- image$select("BurnDate")$neq(0)
  burnedAreas <- burnedArea$reduceToVectors(
    geometry = bolivia,
    scale = 500,
    geometryType = 'polygon',
    eightConnected = FALSE,
    labelProperty = "BurnDate",
    maxPixels = 1e13
  )
  return(burnedAreas)
}


# Create a sequence of years
years <- c(2001:2021)

# Use a for loop to read, crop, and write each file
for(year in years) {
  
  start_date <- paste0(year, "-01-01")
  end_date <- paste0(year, "-12-31")
  
  # Create an Earth Engine image collection
  collection <- ee$ImageCollection(modis_product)$filterDate(start_date, end_date)$filterBounds(bolivia)
  
  # Map the function over the image collection
  burned_areas <- collection$map(convertToPolygons)
  
  # Merge the feature collections into a single feature collection
  merged_features <- burned_areas$flatten()
  
  
  task_vector <- ee_table_to_drive(
    collection = merged_features,
    fileFormat = "SHP",
    folder = "bolivia",
    description = paste0("burned_", year),
    timePrefix=F
  )
  task_vector$start()
  ee_monitoring(task_vector) # optional

  
}



# Define Paths
forest_rasters = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/raw-data/mapbiomas")
burned_areas = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/constructed-data/burned_areas")



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
  
  writeRaster(masked_raster, file.path(burned_areas, paste0("masked_contemporaneous",year,".tif")))

}


burned_contemporaneous_2001 <- terra::rast(file.path(burned_areas, "masked_contemporaneous_2001.tif")





list2env(shapefiles, envir = .GlobalEnv)
rm(shapefiles)

masked_contemporaneous <- list()
masked_lag <- list()



# Loop over the years from 2000 to 2021
for (year in 2001:2021) {
  # Generate the shapefile name based on the year
  shapefile_name <- paste0("burned_union_", year, ".shp")
  
  # Construct the full path to the shapefile
  shapefile_path <- file.path(burned_areas, shapefile_name)
  
  # Import the shapefile using the terra package
  shapefile <- read_sf(shapefile_path)
  
  # Generate the raster file name based on the year
  raster_name <- paste0("mapbiomas_", year, ".tif")
  
  # Construct the full path to the raster
  raster_path <- file.path(forest_rasters, raster_name)
  
  # Import the raster using the terra package
  raster <- rast(raster_path)
  
  # Mask the raster using the shapefile
  masked_raster <- mask(raster, shapefile)
  
  writeRaster(masked_raster, file.path(paste0(burned_areas, "masked_contemporaneous",year,".tif")))
  
}


prova = terra::mask(mapbiomas_2002, burned_2001)
prova2 = terra::mask(mapbiomas_2001, burned_2001)

terra::freq(prova)
terra::freq(prova2)

