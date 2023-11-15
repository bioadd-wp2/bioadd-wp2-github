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

  ggsave("~/Dropbox/BIOADD/output/lagged.pdf", width = 12, height = 8, units = "in")