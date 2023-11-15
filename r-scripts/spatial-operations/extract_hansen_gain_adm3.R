library(terra)
library(tidyverse)
library(sf)
library(exactextractr)
library(tmap)

# Disable dplyr summarise warnings
options(dplyr.summarise.inform = FALSE)

# Define Paths
bolivia_shapefiles = file.path("~/Dropbox/BIOADD/shapefiles/gadm41_BOL_shp")
output = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/constructed-data")
hansen = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/raw-data/hansen")



##### Data #####

##### Merge Hansen tiles 2000 #####

# Import tiles 
tile_1 = rast(file.path(hansen, "hansen_gain_tile1.tif"))
tile_2 = rast(file.path(hansen, "hansen_gain_tile2.tif"))
tile_3 = rast(file.path(hansen, "hansen_gain_tile3.tif"))
tile_4 = rast(file.path(hansen, "hansen_gain_tile4.tif"))
tile_5 = rast(file.path(hansen, "hansen_gain_tile5.tif"))
tile_6 = rast(file.path(hansen, "hansen_gain_tile6.tif"))

# Merge tiles
hansen_treecover = merge(tile_1,
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

# Import bolivia grid 
bolivia3 = read_sf(file.path(bolivia_shapefiles, "gadm41_BOL_3.shp"))

##### Extract Hansen Gain #####

system.time({
  
  hansen_gain <- bolivia3 %>% 
    mutate(hansen_gain = exact_extract(hansen_treecover, bolivia3, 
                                    function(values, coverage_fraction) {
   sum(values*coverage_fraction, na.rm = T)
                                    })
   )
  
})



##### Combine in panel dataset #####

hansen_adm3 = hansen_gain %>% 
  select(-one_of(c("GID_3","GID_0","GID_1",    
                   "NL_NAME_1", "GID_2", "NL_NAME_2",      
                   "VARNAME_3", "NL_NAME_3", "TYPE_3", "ENGTYPE_3", "CC_3",      
                   "HASC_3"))) %>% 
  rename(country = COUNTRY, 
         admin_1 = NAME_1,
         admin_2 = NAME_2,
         admin_3 = NAME_3) %>% 
  arrange(admin_1, admin_2, admin_3)

# Write to disk
write_sf(hansen_adm3, file.path(output, "hansen_gain_adm3.shp"))
save(hansen_adm3, file = file.path(output, "hansen_gain_adm3.RData"))
haven::write_dta(st_drop_geometry(hansen_adm3), file.path(output, "hansen_gain_adm3.dta"))

library(mapview)
removeMapJunk(mapview(hansen_adm3, zcol = "hansen_gain",
                      stroke = FALSE,
                      # cex = "n",
                      alpha.regions = 0.35,
                      legend = T,
                      layer.name = "2000-2012 Forest Gain"), junk = c("zoomControl",
                                                                   "layersControl",
                                                                   "homeButton",
                                                                   "drawToolbar",
                                                                   "easyButton"))



