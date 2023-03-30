library(terra)
library(tidyverse)
library(sf)
library(exactextractr)

# Define Paths
datafolder_1 = file.path("~/Dropbox/Work/BIOADD/TMF/tmf_N0_W60")
datafolder_2 = file.path("~/Dropbox/Work/BIOADD/TMF/tmf_N0_W70")
datafolder_3 = file.path("~/Dropbox/Work/BIOADD/TMF/tmf_S10_W60")
datafolder_4 = file.path("~/Dropbox/Work/BIOADD/TMF/tmf_S10_W70")
datafolder_5 = file.path("~/Dropbox/Work/BIOADD/TMF/tmf_S20_W60")
datafolder_6 = file.path("~/Dropbox/Work/BIOADD/TMF/tmf_S20_W70")

shapefiles = file.path("~/Dropbox/Work/BIOADD/shapefiles/gadm41_BOL_shp")


##### Data 1990 #####

# Import 1990
tile_1_1990 = rast(file.path(datafolder_1, "JRC_TMF_AnnualChange_v2_1990_SAM_ID30_N0_W60.tif"))
tile_2_1990 = rast(file.path(datafolder_2, "JRC_TMF_AnnualChange_v2_1990_SAM_ID29_N0_W70.tif"))
tile_3_1990 = rast(file.path(datafolder_3, "JRC_TMF_AnnualChange_v2_1990_SAM_ID13_S10_W60.tif"))
tile_4_1990 = rast(file.path(datafolder_4, "JRC_TMF_AnnualChange_v2_1990_SAM_ID12_S10_W70.tif"))
tile_5_1990 = rast(file.path(datafolder_5, "JRC_TMF_AnnualChange_v2_1990_SAM_ID4_S20_W60.tif"))
tile_6_1990 = rast(file.path(datafolder_6, "JRC_TMF_AnnualChange_v2_1990_SAM_ID3_S20_W70.tif"))

# Merge 1990 tiles
tmf_1990 = merge(tile_1_1990,
                 tile_2_1990,
                 tile_3_1990,
                 tile_4_1990,
                 tile_5_1990,
                 tile_6_1990)

# Remove individual tiles
rm(tile_1_1990,
   tile_2_1990,
   tile_3_1990,
   tile_4_1990,
   tile_5_1990,
   tile_6_1990)



##### Data 2000 #####

# Import 2000
tile_1_2000 = rast(file.path(datafolder_1, "JRC_TMF_AnnualChange_v2_2000_SAM_ID30_N0_W60.tif"))
tile_2_2000 = rast(file.path(datafolder_2, "JRC_TMF_AnnualChange_v2_2000_SAM_ID29_N0_W70.tif"))
tile_3_2000 = rast(file.path(datafolder_3, "JRC_TMF_AnnualChange_v2_2000_SAM_ID13_S10_W60.tif"))
tile_4_2000 = rast(file.path(datafolder_4, "JRC_TMF_AnnualChange_v2_2000_SAM_ID12_S10_W70.tif"))
tile_5_2000 = rast(file.path(datafolder_5, "JRC_TMF_AnnualChange_v2_2000_SAM_ID4_S20_W60.tif"))
tile_6_2000 = rast(file.path(datafolder_6, "JRC_TMF_AnnualChange_v2_2000_SAM_ID3_S20_W70.tif"))

# Merge 2000 tiles
tmf_2000 = merge(tile_1_2000,
                 tile_2_2000,
                 tile_3_2000,
                 tile_4_2000,
                 tile_5_2000,
                 tile_6_2000)

# Remove individual tiles
rm(tile_1_2000,
   tile_2_2000,
   tile_3_2000,
   tile_4_2000,
   tile_5_2000,
   tile_6_2000)



##### Data 2010 #####

# Import 2010
tile_1_2010 = rast(file.path(datafolder_1, "JRC_TMF_AnnualChange_v2_2010_SAM_ID30_N0_W60.tif"))
tile_2_2010 = rast(file.path(datafolder_2, "JRC_TMF_AnnualChange_v2_2010_SAM_ID29_N0_W70.tif"))
tile_3_2010 = rast(file.path(datafolder_3, "JRC_TMF_AnnualChange_v2_2010_SAM_ID13_S10_W60.tif"))
tile_4_2010 = rast(file.path(datafolder_4, "JRC_TMF_AnnualChange_v2_2010_SAM_ID12_S10_W70.tif"))
tile_5_2010 = rast(file.path(datafolder_5, "JRC_TMF_AnnualChange_v2_2010_SAM_ID4_S20_W60.tif"))
tile_6_2010 = rast(file.path(datafolder_6, "JRC_TMF_AnnualChange_v2_2010_SAM_ID3_S20_W70.tif"))

# Merge 2010 tiles
tmf_2010 = merge(tile_1_2010,
                 tile_2_2010,
                 tile_3_2010,
                 tile_4_2010,
                 tile_5_2010,
                 tile_6_2010)

# Remove individual tiles
rm(tile_1_2010,
   tile_2_2010,
   tile_3_2010,
   tile_4_2010,
   tile_5_2010,
   tile_6_2010)



##### Data 2020 #####

# Import 2020
tile_1_2020 = rast(file.path(datafolder_1, "JRC_TMF_AnnualChange_v2_2020_SAM_ID30_N0_W60.tif"))
tile_2_2020 = rast(file.path(datafolder_2, "JRC_TMF_AnnualChange_v2_2020_SAM_ID29_N0_W70.tif"))
tile_3_2020 = rast(file.path(datafolder_3, "JRC_TMF_AnnualChange_v2_2020_SAM_ID13_S10_W60.tif"))
tile_4_2020 = rast(file.path(datafolder_4, "JRC_TMF_AnnualChange_v2_2020_SAM_ID12_S10_W70.tif"))
tile_5_2020 = rast(file.path(datafolder_5, "JRC_TMF_AnnualChange_v2_2020_SAM_ID4_S20_W60.tif"))
tile_6_2020 = rast(file.path(datafolder_6, "JRC_TMF_AnnualChange_v2_2020_SAM_ID3_S20_W70.tif"))

# Merge 2020 tiles
tmf_2020 = merge(tile_1_2020,
                 tile_2_2020,
                 tile_3_2020,
                 tile_4_2020,
                 tile_5_2020,
                 tile_6_2020)

# Remove individual tiles
rm(tile_1_2020,
   tile_2_2020,
   tile_3_2020,
   tile_4_2020,
   tile_5_2020,
   tile_6_2020)




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
  st_transform(5356) %>% # for a metric grid
  
# Crop rasters onto bolivia
tmf_1990_bolivia = terra::crop(tmf_1990, bolivia)
tmf_1990_bolivia = terra::mask(tmf_1990_bolivia,bolivia)

tmf_2000_bolivia = terra::crop(tmf_2000, bolivia)
tmf_2000_bolivia = terra::mask(tmf_2000_bolivia,bolivia)

tmf_2010_bolivia = terra::crop(tmf_2010, bolivia)
tmf_2010_bolivia = terra::mask(tmf_2010_bolivia,bolivia)

tmf_2020_bolivia = terra::crop(tmf_2020, bolivia)
tmf_2020_bolivia = terra::mask(tmf_2020_bolivia,bolivia)

# Warp rasters to Bolivia's metric CRS (5356)
tmf_1990_bolivia_warped = terra::project(tmf_1990_bolivia, "EPSG:5356")
tmf_2000_bolivia_warped = terra::project(tmf_2000_bolivia, "EPSG:5356")
tmf_2010_bolivia_warped = terra::project(tmf_2010_bolivia, "EPSG:5356")
tmf_2020_bolivia_warped = terra::project(tmf_2020_bolivia, "EPSG:5356")

rm(tmf_1990, tmf_2000, tmf_2010, tmf_2020,
   tmf_1990_bolivia, tmf_2000_bolivia, tmf_2010_bolivia, tmf_2020_bolivia)

# Reclassify rasters

tmf_1990 <- classify(tmf_1990_bolivia_warped, cbind(1,1), others = NA)
tmf_2000 <- classify(tmf_2000_bolivia_warped, cbind(1,1), others = NA)
tmf_2010 <- classify(tmf_2010_bolivia_warped, cbind(1,1), others = NA)
tmf_2020 <- classify(tmf_2020_bolivia_warped, cbind(1,1), others = NA)

deg_1990 <- classify(tmf_1990_bolivia_warped, cbind(2,1), others = NA)
deg_2000 <- classify(tmf_2000_bolivia_warped, cbind(2,1), others = NA)
deg_2010 <- classify(tmf_2010_bolivia_warped, cbind(2,1), others = NA)
deg_2020 <- classify(tmf_2020_bolivia_warped, cbind(2,1), others = NA)

def_1990 <- classify(tmf_1990_bolivia_warped, cbind(3,1), others = NA)
def_2000 <- classify(tmf_2000_bolivia_warped, cbind(3,1), others = NA)
def_2010 <- classify(tmf_2010_bolivia_warped, cbind(3,1), others = NA)
def_2020 <- classify(tmf_2020_bolivia_warped, cbind(3,1), others = NA)

reg_1990 <- classify(tmf_1990_bolivia_warped, cbind(4,1), others = NA)
reg_2000 <- classify(tmf_2000_bolivia_warped, cbind(4,1), others = NA)
reg_2010 <- classify(tmf_2010_bolivia_warped, cbind(4,1), others = NA)
reg_2020 <- classify(tmf_2020_bolivia_warped, cbind(4,1), others = NA)

rm(tmf_1990_bolivia_warped,
   tmf_2000_bolivia_warped,
   tmf_2010_bolivia_warped,
   tmf_2020_bolivia_warped)

# Final bit: extract rasters onto shapefiles

system.time({
  bolivia_municipios_forest = bolivia_municipios %>%
    mutate(
      tmf_1990 = exact_extract(tmf_1990, bolivia_municipios, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      tmf_2000 = exact_extract(tmf_2000, bolivia_municipios, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      tmf_2010 = exact_extract(tmf_2010, bolivia_municipios, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      tmf_2020 = exact_extract(tmf_2020, bolivia_municipios, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      deg_1990 = exact_extract(deg_1990, bolivia_municipios, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      deg_2000 = exact_extract(deg_2000, bolivia_municipios, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      deg_2010 = exact_extract(deg_2010, bolivia_municipios, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      deg_2020 = exact_extract(deg_2020, bolivia_municipios, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      def_1990 = exact_extract(def_1990, bolivia_municipios, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      def_2000 = exact_extract(def_2000, bolivia_municipios, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      def_2010 = exact_extract(def_2010, bolivia_municipios, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      def_2020 = exact_extract(def_2020, bolivia_municipios, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      reg_1990 = exact_extract(reg_1990, bolivia_municipios, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      reg_2000 = exact_extract(reg_2000, bolivia_municipios, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      reg_2010 = exact_extract(reg_2010, bolivia_municipios, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T))),
      reg_2020 = exact_extract(reg_2020, bolivia_municipios, 
                               function(values, coverage_fraction)
                                 (sum(values*coverage_fraction, na.rm = T)))
)
})

bolivia_municipios_forest = bolivia_municipios_forest %>% 
  mutate(area = st_area(.)) %>% 
  mutate(tmf_1990 = units::drop_units((tmf_1990*900)/area)) 

write_sf(bolivia_municipios_forest, "~/Dropbox/Work/BIOADD/shapefiles/bolivia_TMF.shp")

# plot to check it has worked
ggplot() +
  geom_sf(data = bolivia_municipios_forest, aes(fill = tmf_1990)) +
  scale_fill_viridis_c()

