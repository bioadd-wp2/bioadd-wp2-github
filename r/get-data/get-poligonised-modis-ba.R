################################################################################
# Author: Sarah Meier
# Date: 05-12-2023
# Script: get MODIS burned area data (2001-2021) through GEE & convert to polygons
################################################################################

#libraries
library(rgee)

# initializing GEE
rgee::ee_Initialize(drive = T)

# Set the MODIS product 
modis_product <- "MODIS/061/MCD64A1"

# Define the region of interest (Conterminous US)
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


# Create a sequence for years of interest
years <- c(2001:2021)

# Polygonise burned area
for(year in years) {
  
  start_date <- paste0(year, "-01-01")
  end_date <- paste0(year, "-12-31")
  
  # Create an Earth Engine image collection
  collection <- ee$ImageCollection(modis_product)$filterDate(start_date, end_date)$filterBounds(bolivia)
  
  # Map the function over the image collection
  burned_areas <- collection$map(convertToPolygons)
  
  # Merge the feature collections into a single feature collection
  merged_features <- burned_areas$flatten()
  
  # Export to folder
  task_vector <- ee_table_to_drive(
    collection = merged_features,
    fileFormat = "SHP",
    folder = "Bolivia",
    description = paste0("burnt_", year),
    timePrefix=F
  )
  task_vector$start()
  ee_monitoring(task_vector) # optional
  
}

# Set the source and destination paths
source_path <- "G:/My Drive/Bolivia"
destination_path <- "C:/GitHub/bioadd-wp2-github/data/constructed/shp/modis-burned-area"

# Get a list of files in the source directory
files_to_copy <- list.files(source_path)

# Create the destination directory if it doesn't exist
if (!dir.exists(destination_path)) {
  dir.create(destination_path, recursive = TRUE)
}

# Copy each file from the source to the destination
for (file in files_to_copy) {
  source_file <- file.path(source_path, file)
  destination_file <- file.path(destination_path, file)
  
  # Check if the file already exists in the destination
  if (!file.exists(destination_file)) {
    # Copy the file
    file.copy(source_file, destination_file)
    print(paste("Copied", source_file, "to", destination_file))
  } else {
    print(paste("File", destination_file, "already exists. Skipping."))
  }
}





