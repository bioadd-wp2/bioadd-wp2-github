library(terra)
library(tidyverse)
library(sf)
library(exactextractr)
library(tmap)

# Define Paths
bolivia_shapefiles = file.path("~/Dropbox/BIOADD/shapefiles/gadm41_BOL_shp")

# Import Bolivia shapefile & make grid
bolivia <- read_sf(file.path(bolivia_shapefiles, "gadm41_BOL_0.shp")) 
#mapview::mapview(bolivia)

grid <- bolivia %>%
  st_transform(5356) %>% # for a metric grid
  st_make_grid(., cellsize = c(1200,1200)) %>%
  st_as_sf() %>% 
  st_transform(4326) %>% # back to Mercator for raster aggregation
  st_intersection(., bolivia) %>% # crop on Bolivia shapefile
  mutate(id = row_number(.)) %>% 
  rename(geometry = x) %>% 
  st_transform(5356) %>% 
  dplyr::mutate(area = units::drop_units(st_area(.) / 1e6)) %>% 
  st_transform(4326) # back to Mercator for raster aggregation

write_sf(grid, file.path(bolivia_shapefiles, "bolivia_grid.shp"))

