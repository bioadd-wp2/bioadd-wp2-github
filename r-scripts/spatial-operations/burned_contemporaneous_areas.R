library(sf)
library(terra)
library(tidyverse)
library(exactextractr)

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
output = file.path("bioadd/burned_municipality_extracts")


# Import bolivia grid 
bolivia3 = read_sf(file.path(bolivia_shapefiles, "gadm41_BOL_3.shp"))

# Create empty list
extracted_list = list()

# Run extraction loop
for (year in 2001:2021){

  # Construct the raster name
  raster_name <- paste0("masked_contemporaneous_", year)
  
  # Construct the full raster path
  raster_path <- file.path(burned_rasters, paste0(raster_name, ".tif"))
  
  # Read the raster using the terra package
  raster <- rast(raster_path)

  # Extract and manipulate
  extracted <- exact_extract(raster, bolivia3, function(df) {
    df %>%
      group_by(GID_3, value) %>%
      summarize(area_km2 = sum(coverage_area) / 1e6)
  }, max_cells_in_memory = 3e+09,
  summarize_df = TRUE, coverage_area = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value,
                values_from = area_km2,
                names_prefix = "mapbiomas_burned_") %>%
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>%
    mutate(year = year) %>%
    relocate(year, .after = GID_3) %>%
    transmute(GID_3 = GID_3,
              year = year, 
              forest = mapbiomas_burned_3 + mapbiomas_burned_6,
              wetland = mapbiomas_burned_11,
              grassland = mapbiomas_burned_12,
              other_NFNF = mapbiomas_burned_13,
              pasture = mapbiomas_burned_15,
              agriculture = mapbiomas_burned_18,
              mosaic = mapbiomas_burned_21,
              mixed_category = mapbiomas_burned_24 + mapbiomas_burned_25  + mapbiomas_burned_30 + mapbiomas_burned_33 + mapbiomas_burned_34,
              NA_cat = mapbiomas_burned_NaN + mapbiomas_burned_0) 
  
  # Assign to list
  extracted_list[[year-2000]] <- extracted
  
}


# Combine in a single dataframe
combined_extracted <- bind_rows(extracted_list)

# Save to disk
save(combined_extracted, file = file.path(output, "burned_contemporaneous_areas.RData"))



