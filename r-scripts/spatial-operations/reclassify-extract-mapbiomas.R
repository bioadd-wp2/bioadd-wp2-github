library(terra)
library(tidyverse)
library(sf)
library(exactextractr)
library(tmap)

# Disable dplyr summarise warnings
options(dplyr.summarise.inform = FALSE)

# Define Paths
forest_rasters = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/raw-data/mapbiomas")
bolivia_shapefiles = file.path("~/Dropbox/BIOADD/shapefiles/gadm41_BOL_shp")
output = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/constructed-data")
property_shapefiles = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/raw-data/INRA_property_boundaries")


##### Data #####

# Import rasters
mapbiomas_2000 <- rast(file.path(forest_rasters, "mapbiomas_2000.tif"))
mapbiomas_2001 <- rast(file.path(forest_rasters, "mapbiomas_2001.tif"))
mapbiomas_2002 <- rast(file.path(forest_rasters, "mapbiomas_2002.tif"))
mapbiomas_2003 <- rast(file.path(forest_rasters, "mapbiomas_2003.tif"))
mapbiomas_2004 <- rast(file.path(forest_rasters, "mapbiomas_2004.tif"))
mapbiomas_2005 <- rast(file.path(forest_rasters, "mapbiomas_2005.tif"))
mapbiomas_2006 <- rast(file.path(forest_rasters, "mapbiomas_2006.tif"))
mapbiomas_2007 <- rast(file.path(forest_rasters, "mapbiomas_2007.tif"))
mapbiomas_2008 <- rast(file.path(forest_rasters, "mapbiomas_2008.tif"))
mapbiomas_2009 <- rast(file.path(forest_rasters, "mapbiomas_2009.tif"))
mapbiomas_2010 <- rast(file.path(forest_rasters, "mapbiomas_2010.tif"))
mapbiomas_2011 <- rast(file.path(forest_rasters, "mapbiomas_2011.tif"))
mapbiomas_2012 <- rast(file.path(forest_rasters, "mapbiomas_2012.tif"))
mapbiomas_2013 <- rast(file.path(forest_rasters, "mapbiomas_2013.tif"))
mapbiomas_2014 <- rast(file.path(forest_rasters, "mapbiomas_2014.tif"))
mapbiomas_2015 <- rast(file.path(forest_rasters, "mapbiomas_2015.tif"))
mapbiomas_2016 <- rast(file.path(forest_rasters, "mapbiomas_2016.tif"))
mapbiomas_2017 <- rast(file.path(forest_rasters, "mapbiomas_2017.tif"))
mapbiomas_2018 <- rast(file.path(forest_rasters, "mapbiomas_2018.tif"))
mapbiomas_2019 <- rast(file.path(forest_rasters, "mapbiomas_2019.tif"))
mapbiomas_2020 <- rast(file.path(forest_rasters, "mapbiomas_2020.tif"))
mapbiomas_2021 <- rast(file.path(forest_rasters, "mapbiomas_2021.tif"))

# Import bolivia grid 
grid = read_sf(file.path(bolivia_shapefiles, "bolivia_grid.shp"))

# Reclassify rasters

##### Reclassify 2000 #####
system.time({
  
ffo_2000 <- classify(mapbiomas_2000, cbind(1,1), others = NA) #forest formation
for_2000 <- classify(mapbiomas_2000, cbind(3,1), others = NA) #forest
flf_2000 <- classify(mapbiomas_2000, cbind(6,1), others = NA) #flooded forest

nfo_2000 <- classify(mapbiomas_2000, cbind(10,1), others = NA) #non-forest formation
wet_2000 <- classify(mapbiomas_2000, cbind(11,1), others = NA) #wetland
gra_2000 <- classify(mapbiomas_2000, cbind(12,1), others = NA) #grassland
onf_2000 <- classify(mapbiomas_2000, cbind(13,1), others = NA) #other non-forest

far_2000 <- classify(mapbiomas_2000, cbind(14,1), others = NA) #farming 
pas_2000 <- classify(mapbiomas_2000, cbind(15,1), others = NA) #pasture
agr_2000 <- classify(mapbiomas_2000, cbind(18,1), others = NA) #agriculture
mos_2000 <- classify(mapbiomas_2000, cbind(21,1), others = NA) #mosaic of uses

nva_2000 <- classify(mapbiomas_2000, cbind(22,1), others = NA) #non-vegetated area
urb_2000 <- classify(mapbiomas_2000, cbind(24,1), others = NA) #urban
min_2000 <- classify(mapbiomas_2000, cbind(30,1), others = NA) #mining
onv_2000 <- classify(mapbiomas_2000, cbind(25,1), others = NA) #other non-vegetated
sal_2000 <- classify(mapbiomas_2000, cbind(61,1), others = NA) #salar

wat_2000 <- classify(mapbiomas_2000, cbind(26,1), others = NA) #water
riv_2000 <- classify(mapbiomas_2000, cbind(33,1), others = NA) #river/lake
gla_2000 <- classify(mapbiomas_2000, cbind(34,1), others = NA) #glacier

not_2000 <- classify(mapbiomas_2000, cbind(27,1), others = NA) #not observed


# Extract onto grid individually

  mapbiomas_2000_bolivia_ind = grid %>%
    mutate(
      year = 2000,
      mapbiomas_1 = exact_extract(ffo_2000, grid,
                                function(values, coverage_fraction)
                                  (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_3 = exact_extract(for_2000, grid,
                                  function(values, coverage_fraction)
                                    (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_6 = exact_extract(flf_2000, grid,
                                  function(values, coverage_fraction)
                                    (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_10 = exact_extract(nfo_2000, grid,
                                  function(values, coverage_fraction)
                                    (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_11 = exact_extract(wet_2000, grid,
                                  function(values, coverage_fraction)
                                    (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_12 = exact_extract(gra_2000, grid,
                                  function(values, coverage_fraction)
                                    (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_13 = exact_extract(onf_2000, grid,
                                  function(values, coverage_fraction)
                                    (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_14 = exact_extract(far_2000, grid,
                                   function(values, coverage_fraction)
                                     (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_15 = exact_extract(pas_2000, grid,
                                   function(values, coverage_fraction)
                                     (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_18 = exact_extract(agr_2000, grid,
                                   function(values, coverage_fraction)
                                     (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_21 = exact_extract(mos_2000, grid,
                                   function(values, coverage_fraction)
                                     (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_22 = exact_extract(nva_2000, grid,
                                   function(values, coverage_fraction)
                                     (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_24 = exact_extract(urb_2000, grid,
                                   function(values, coverage_fraction)
                                     (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_30 = exact_extract(min_2000, grid,
                                   function(values, coverage_fraction)
                                     (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_25 = exact_extract(onv_2000, grid,
                                   function(values, coverage_fraction)
                                     (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_61 = exact_extract(sal_2000, grid,
                                   function(values, coverage_fraction)
                                     (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_26 = exact_extract(wat_2000, grid,
                                   function(values, coverage_fraction)
                                     (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_33 = exact_extract(riv_2000, grid,
                                   function(values, coverage_fraction)
                                     (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_34 = exact_extract(gla_2000, grid,
                                   function(values, coverage_fraction)
                                     (sum(values*coverage_fraction, na.rm = T))),
      mapbiomas_27 = exact_extract(not_2000, grid,
                                   function(values, coverage_fraction)
                                     (sum(values*coverage_fraction, na.rm = T)))
      
      
    )
})

save(mapbiomas_2000_bolivia_ind, file = file.path(output, "mapbiomas_reclassified_grid.RData"))