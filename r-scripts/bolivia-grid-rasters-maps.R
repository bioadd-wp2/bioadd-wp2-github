library(terra)
library(tidyverse)
library(sf)
library(exactextractr)
library(tmap)

# Define Paths
datafolder = file.path("~/Dropbox/Work/BIOADD/Transition_Map_Main")
shapefiles = file.path("~/Dropbox/Work/BIOADD/shapefiles/gadm41_BOL_shp")
output = file.path("~/Dropbox/Work/BIOADD/output")


##### Data #####

# Import tiles
tile_1 = rast(file.path(datafolder, "JRC_TMF_TransitionMap_MainClasses_v2_1982_2021_SAM_ID30_N0_W60.tif"))
tile_2 = rast(file.path(datafolder, "JRC_TMF_TransitionMap_MainClasses_v2_1982_2021_SAM_ID29_N0_W70.tif"))
tile_3 = rast(file.path(datafolder, "JRC_TMF_TransitionMap_MainClasses_v2_1982_2021_SAM_ID13_S10_W60.tif"))
tile_4 = rast(file.path(datafolder, "JRC_TMF_TransitionMap_MainClasses_v2_1982_2021_SAM_ID12_S10_W70.tif"))
tile_5 = rast(file.path(datafolder, "JRC_TMF_TransitionMap_MainClasses_v2_1982_2021_SAM_ID4_S20_W60.tif"))
tile_6 = rast(file.path(datafolder, "JRC_TMF_TransitionMap_MainClasses_v2_1982_2021_SAM_ID3_S20_W70.tif"))

# Merge tiles
transition = merge(tile_1,
                   tile_2,
                   tile_3,
                   tile_4,
                   tile_5,
                   tile_6)

# Remove individual tiles
rm(tile_1,
   tile_2,
   tile_3,
   tile_4,
   tile_5,
   tile_6)


# Import Bolivia adm3 shapefile
bolivia_municipios <- read_sf(file.path(shapefiles, "gadm41_BOL_3.shp")) %>% 
  st_transform(5356) %>% 
  select(one_of(c("NAME_3", "geometry"))) %>% 
  rename(district = NAME_3)

# Import Bolivia shapefile & make grid
bolivia <- read_sf(file.path(shapefiles, "gadm41_BOL_0.shp")) 

grid <- bolivia %>% 
  st_transform(5356) %>% # for a metric grid
  st_make_grid(., cellsize = c(1200,1200)) %>% 
  st_transform(4326) %>% # back to Mercator for raster aggregation
  st_intersection(., bolivia) %>% # crop on Bolivia shapefile
  st_as_sf() %>%# transform in sf object
  st_transform(5356) #for a metric grid
  
# Crop rasters onto bolivia
transition_bolivia = terra::crop(transition, bolivia)
transition_bolivia = terra::mask(transition_bolivia,bolivia)

# Warp rasters to Bolivia's metric CRS (5356)
transition_bolivia_warped = terra::project(transition_bolivia, "EPSG:5356")

# Reclassify rasters

tmf <- classify(transition_bolivia_warped, cbind(10,1), others = NA)
deg <- classify(transition_bolivia_warped, cbind(20,1), others = NA)
reg <- classify(transition_bolivia_warped, cbind(30,1), others = NA)
def <- classify(transition_bolivia_warped, cbind(c(41,42,43,50),1), others = NA)


rm(transition_bolivia_warped)

# Final bit: extract rasters onto shapefiles

system.time({
  bolivia_grid_forest = grid %>%
    mutate(
      tmf = exact_extract(tmf, grid, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      deg = exact_extract(deg, grid, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      reg = exact_extract(reg, grid, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      def = exact_extract(def, grid, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T)))
    )
})

bolivia_grid_forest = bolivia_grid_forest %>% 
  mutate(area = st_area(.)) %>% 
  mutate(tmf = units::drop_units((tmf*900)/area),
         deg = units::drop_units((deg*900)/area),
         reg = units::drop_units((reg*900)/area),
         def = units::drop_units((def*900)/area))

bolivia_grid_forest = bolivia_grid_forest %>% 
  mutate(
    tmf = ifelse(tmf > 1, 1, tmf),
    deg = ifelse(deg > 1, 1, deg),
    reg = ifelse(reg > 1, 1, reg),
    def = ifelse(def > 1, 1, def)) 

bolivia_grid_forest <- read_sf("~/Dropbox/Work/BIOADD/shapefiles/bolivia_grid.shp")

bolivia_grid_forest = bolivia_grid_forest %>% 
  mutate(tmf = round(tmf*100, 1),
         deg = round(deg*100, 1),
         reg = round(reg*100, 1),
         def = round(def*100, 1))

# Plot

bolivia = bolivia %>% 
  st_transform(5356)

plot = tm_shape(bolivia) +
  tm_borders(col = "black") +
tm_shape(bolivia_grid_forest) +
  tm_fill("def", palette = "YlOrRd", title = "Tropical Moist Forest (2021)", style = "fisher", alpha = 0.9, legend.show = T) +
  tm_style("white") +
  tm_layout(legend.outside = T, frame = F)

tmap_save(plot, file.path(output, "forest.pdf"), 
          width = 12, height = 8.445, units = "in", asp = 0)





