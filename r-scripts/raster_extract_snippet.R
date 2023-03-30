# IMPORT LIBRARIES
library(sf)
library(tidyverse)
library(exactextractr)
library(mapview)
library(terra)

# Set up file paths
data1 = file.path("~/Downloads")
data2 = file.path("~/Dropbox/PHD/spatial-regressivity-april22/NTL/")

# read base shapefile and transform to metric
bolivia = read_sf(file.path(data1, "gadm41_BOL_shp/gadm41_BOL_0.shp")) %>% 
  st_transform(5356)

# make grid
grid = st_make_grid(bolivia, cellsize = c(1200,1200))

# plot quickly --> it's square
mapview::mapview(grid)

# crop it to base shape and transform to sf object
grid_cropped = grid %>% 
  st_intersection(., bolivia)  %>% 
  st_as_sf()

# plot to check it has worked
mapview(grid_cropped)

# import a raster (Hansen/EUTF will probably be heavier on RAM)
ntl2000 <- rast(file.path(data2, "Harmonized_DN_NTL_2000_calDMSP.tif"))

# crop it onto bolivia (leaving the terra:: call because raster also has these functions)
bolivia_wgs84 = read_sf(file.path(data1, "gadm41_BOL_shp/gadm41_BOL_0.shp"))
ntl2000_bolivia = terra::crop(ntl2000, bolivia_wgs84)
ntl2000_bolivia = terra::mask(ntl2000_bolivia,bolivia_wgs84 )

# plot it to check it's worked
terra::plot(ntl2000_bolivia)

# warp it to bolivia's CRS
ntl2000_warped = terra::project(ntl2000_bolivia, "EPSG:5356")

# extract on grid 
system.time({
  bolivia_ntl = grid_cropped %>%
    mutate(
      ntl2000 = exact_extract(ntl2000_warped, grid_cropped, function(values, coverage_fraction)
        mean(values * coverage_fraction, na.rm=TRUE)))
})

# plot to check it has worked
ggplot() +
  geom_sf(data = bolivia_ntl, aes(fill = ntl2000)) +
  scale_fill_viridis_c()
