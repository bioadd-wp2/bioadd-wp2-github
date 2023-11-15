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
tile_1 = rast(file.path(hansen, "hansen_treecover_tile1.tif"))
tile_2 = rast(file.path(hansen, "hansen_treecover_tile2.tif"))
tile_3 = rast(file.path(hansen, "hansen_treecover_tile3.tif"))
tile_4 = rast(file.path(hansen, "hansen_treecover_tile4.tif"))
tile_5 = rast(file.path(hansen, "hansen_treecover_tile5.tif"))
tile_6 = rast(file.path(hansen, "hansen_treecover_tile6.tif"))

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

#Rescale for aggregation
hansen_treecover = hansen_treecover*0.01

##### Merge Hansen lossyear #####

# Import tiles 
tile_1 = rast(file.path(hansen,  "hansen_lossyear_tile1.tif"))
tile_2 = rast(file.path(hansen,  "hansen_lossyear_tile2.tif"))
tile_3 = rast(file.path(hansen,  "hansen_lossyear_tile3.tif"))
tile_4 = rast(file.path(hansen,  "hansen_lossyear_tile4.tif"))
tile_5 = rast(file.path(hansen,  "hansen_lossyear_tile5.tif"))
tile_6 = rast(file.path(hansen,  "hansen_lossyear_tile6.tif"))

# Merge tiles
hansen_lossyear = merge(tile_1,
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

##### Extract Hansen treecover_2000 #####

system.time({
  
  hansen_adm3_2000 <- bolivia3 %>% 
    mutate(hansen_treecover = exact_extract(hansen_treecover, bolivia3, 
                                    function(values, coverage_fraction) {
   sum(values*coverage_fraction, na.rm = T)
                                    })
    )
  
})


##### Extract raster for Deforestation #####
system.time({
  hansen_lossyear <- exact_extract(hansen_lossyear, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T)  %>% 
    mutate(year = case_when(
      value == 0 ~ NA, 
      value == 1 ~ 2001, 
      value == 2 ~ 2002, 
      value == 3 ~ 2003, 
      value == 4 ~ 2004, 
      value == 5 ~ 2005, 
      value == 6 ~ 2006, 
      value == 7 ~ 2007, 
      value == 8 ~ 2008, 
      value == 9 ~ 2009, 
      value == 10 ~ 2010, 
      value == 11 ~ 2011,
      value == 12 ~ 2012,
      value == 13 ~ 2013,
      value == 14 ~ 2014,
      value == 15 ~ 2015,
      value == 16 ~ 2016,
      value == 17 ~ 2017,
      value == 18 ~ 2018,
      value == 19 ~ 2019
    )) %>% 
    select(-value) %>% 
    pivot_wider(names_from = year, 
                values_from = freq,
                names_prefix = "hansen_deforestation_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0))
    relocate(year, .after = GID_3) 
  
})



##### Combine in panel dataset #####

hansen_adm3 = bolivia3 %>% 
  merge(hansen_lossyear, by = "GID_3") %>% 
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
write_sf(hansen_adm3, file.path(output, "hansen_adm3.shp"))
save(hansen_adm3, file = file.path(output, "hansen_adm3.RData"))
haven::write_dta(st_drop_geometry(hansen_adm3), file.path(output, "hansen_adm3.dta"))



