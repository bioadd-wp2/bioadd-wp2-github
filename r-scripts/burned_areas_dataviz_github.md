Burned Areas Analysis for Bolivia
================
true
13 July, 2023

### Extraction of burned area rasters from Google Earth Engine

The first step consists in extracting all burned areas for Bolivia from
the [MODIS Burned Area
product](https://developers.google.com/earth-engine/datasets/catalog/MODIS_061_MCD64A1).
To do so, I use the `rgee` package in R which allows to interact with
Google Earth Engine and exploit its cloud computing power.

I wrote the `convertToPolygons` function to transmute the MODIS rasters
into vectors, since we are interested in understanding the composition
of the **MapBiomas** rasters within burn scars. Since the conversion to
polygons is fast (\<1 second) on the GEE cloud, but it is
computationally intensive to bring the GEE files to local and convert
them into shapefiles, I export them to an intermediate Google Drive
bucket. I have already transferred them to Dropbox (in the
`~/data/constructed-data/burned_areas` folder).

``` r
# Load required libraries
library(rgee)

# Initialize Earth Engine (note: needs an account)
ee_Authenticate()
ee_Initialize()

# Set the MODIS product and date range
modis_product <- "MODIS/006/MCD64A1"

# Define the region of interest (Bolivia)
bolivia <- ee$FeatureCollection("FAO/GAUL/2015/level0")$filter(ee$Filter$eq("ADM0_NAME", "Bolivia"))

# Function to convert burned area data to polygons
convertToPolygons <- function(image) {
  burnedArea <- image$select("BurnDate")$neq(0) # selects correct band and exclude zeros (not burned)
  burnedAreas <- burnedArea$reduceToVectors( # polygonise to bolivia 
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
  
  # Export features to Google Drive 
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
```

We can see how the polygonisation process was a success by comparing a
QGIS map of burned areas in 2019, obtained by plotting the shapefiles
resulting from the process above, to the simple GEE map of MODIS Burned
Areas for 2019, obtained with the [GEE code
editor](https://code.earthengine.google.com/cef5ea4b0ebb187b1ae764b56b3d7d3e).

| ![Image 1 Caption](~/Dropbox/BIOADD/Work_Packages/WP2/data/maps/burned_area_2019_qgis.png) | ![Image 2 Caption](~/Dropbox/BIOADD/Work_Packages/WP2/data/maps/burned_area_2019_GEE.png) |
|:------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------:|
|                                  Polygonised Burned Area                                   |                                      GEE Burned Area                                      |

### Distribution of Land Use within MODIS Burned Areas

Next, let’s check the distribution of land use pixels from MapBiomas
within the burned areas. The first step here is to `mask` the MapBiomas
rasters with the MODIS burned areas as calculated above. The computing
power requirements to do this are quite hefty since the MODIS burned
areas are irregular in shape and have hundred of thousands of vertices.
Hence I run this in LSE’s Fabian. Notably, I need to create two sets of
cropped rasters, one where the land use is calculated contemporaneously
with the burned areas, and one where it is lagged by one year. It would
be best practice not to save intermediate rasters and move on, but since
disk space on Fabian is abundant I opted to do so.

``` r
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
  
  # Generate the raster file name based on the lagged year
  raster_name <- paste0("mapbiomas_", year+1, ".tif")
  
  # Construct the full path to the raster
  raster_path <- file.path(forest_rasters, raster_name)
  
  # Import the raster using the terra package
  raster <- rast(raster_path)
  
  # Mask the raster using the shapefile
  masked_raster <- mask(raster, shapefile)
  
  writeRaster(masked_raster, file.path(burned_rasters, paste0("masked_lagged_",year+1,".tif")))
  
}
```

After this, we can simply calculate the frequency of each pixel value
within the burned areas, reclassify to some neater categories (the 1-8
split that Ville and Diana are already using) and plot the results in a
stacked histogram. I only report code for the lagged graph for
simplicity, but both plots are below.

``` r
library(sf)
library(terra)
library(tidyverse)
library(exactextractr)
library(tmap)

# Define Paths
burned_rasters = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/constructed-data/burned_rasters")

# Create empty list
frequency_list = list()

# Run extraction loop
for (year in 2002:2021){
  
  # Construct the raster name
  raster_name <- paste0("masked_lagged_", year)
  
  # Construct the full raster path
  raster_path <- file.path(burned_rasters, paste0(raster_name, ".tif"))
  
  # Read the raster using the terra package
  raster <- rast(raster_path)
  
  frequency = freq(raster) %>% 
    mutate(year = year)
  
  frequency_list[[year-2001]] <- frequency
  
}

# Combine in a single dataframe
combined_frequencies <- bind_rows(frequency_list) %>% 
  select(-layer) %>% 
  filter(!value == 0) %>% 
  mutate(land_use = case_when(
    value == 3 | value == 6 ~ 1,
    value == 11  ~ 2,
    value == 12  ~ 3,
    value == 13  ~ 4,
    value == 15  ~ 5,
    value == 18  ~ 6,
    value == 21  ~ 7,
    value == 24 | value == 25  | value == 26 | value == 27 | value == 30 | value == 33  | value == 34 | value == 61  ~ 8,
    TRUE ~ value
  )) %>% 
  group_by(year, land_use) %>% 
  summarise(count = sum(count, na.rm = T)) %>% 
  ungroup() %>% 
  mutate(land_use_desc = case_when(
    land_use == 1 ~ "Forest",
    land_use == 2 ~ "Wetland",
    land_use == 3 ~ "Grassland/herbaceous",
    land_use == 4 ~ "Other non-forest natural formation",
    land_use == 5 ~ "Pasture",
    land_use == 6 ~ "Agriculture",
    land_use == 7 ~ "Mosaic of uses",
    land_use == 8 ~ "Residual Category",
    TRUE ~ ""
    
  ))

ggplot(combined_frequencies, aes(fill=factor(land_use_desc), y=count, x=year)) + 
  geom_bar(position="stack", stat="identity") +
  theme_minimal() +
  ggtitle("Distribution of Pixels in MODIS Burned Areas for all of Bolivia (1-year lag)") +
  xlab("Year") + ylab("Pixel count") +
  scale_fill_discrete(name = "Land Use Type")
```

##### Contemporaneous Land Use

![](~/Dropbox/BIOADD/Work_Packages/WP2/data/maps/contemporaneous.png)
