library(sf)
sf_use_s2(F)
library(terra)
library(tidyverse)

# Define Paths
forest_rasters = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/raw-data/mapbiomas")
burned_areas = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/constructed-data/burned_areas")
bolivia_shapefiles = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/raw-data/shapefiles/gadm41_BOL_shp")
burned_rasters = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/constructed-data/burned_rasters/sjdc")

# Define Fabian Paths
# forest_rasters = file.path("bioadd/mapbiomas")
# burned_rasters = file.path("bioadd/burned_rasters")
# burned_areas = file.path("bioadd/burned_areas")
# bolivia_shapefiles = file.path("bioadd/shapefiles/gadm41_BOL_shp")

# Import San Jose de Chiquitos shapefile
sjdc = read_sf(file.path(bolivia_shapefiles, "gadm41_BOL_3.shp")) %>% 
  filter(GID_3 == "BOL.8.3.3_2")

# Check shape
ggplot() +
  geom_sf(data = sjdc)

# Create empty list
frequency_list = list()

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
  
  shapefile = st_intersection(shapefile, sjdc)
  
  # Generate the raster file name based on the year
  raster_name <- paste0("mapbiomas_", year, ".tif")
  
  # Construct the full path to the raster
  raster_path <- file.path(forest_rasters, raster_name)
  
  # Import the raster using the terra package
  raster <- rast(raster_path)
  
  # Mask the raster using the shapefile
  masked_raster <- mask(raster, shapefile)
  
  #writeRaster(masked_raster, file.path(burned_rasters, paste0("masked_contemporaneous_sjdc_", year,".tif")))
  
  frequency = freq(masked_raster) %>% 
    mutate(year = year)
  
  frequency_list[[year-2000]] <- frequency
  
}



# Combine in a single dataframe
combined_frequencies <- bind_rows(frequency_list)%>% 
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
  ggtitle("Distribution of Pixels in MODIS Burned Areas for San Josè de Chiquitos") +
  xlab("Year") + ylab("Pixel count") +
  scale_fill_discrete(name = "Land Use Type")

ggsave("~/Dropbox/BIOADD/output/contemporaneous_sjdc.pdf", width = 12, height = 8, units = "in")