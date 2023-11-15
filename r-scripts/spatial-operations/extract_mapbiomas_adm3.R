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
bolivia3 = read_sf(file.path(bolivia_shapefiles, "gadm41_BOL_3.shp"))

##### Extract raster for 2000 #####
system.time({
  mapbiomas_adm3_2000 <- exact_extract(mapbiomas_2000, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
   pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2000) %>% 
    relocate(year, .after = GID_3) 
    
})


##### Extract raster for 2001 #####
system.time({
  mapbiomas_adm3_2001 <- exact_extract(mapbiomas_2001, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2001) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2002 #####
system.time({
  mapbiomas_adm3_2002 <- exact_extract(mapbiomas_2002, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2002) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2003 #####
system.time({
  mapbiomas_adm3_2003 <- exact_extract(mapbiomas_2003, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2003) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2004 #####
system.time({
  mapbiomas_adm3_2004 <- exact_extract(mapbiomas_2004, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2004) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2005 #####
system.time({
  mapbiomas_adm3_2005 <- exact_extract(mapbiomas_2005, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2005) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2006 #####
system.time({
  mapbiomas_adm3_2006 <- exact_extract(mapbiomas_2006, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2006) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2007 #####
system.time({
  mapbiomas_adm3_2007 <- exact_extract(mapbiomas_2007, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2007) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2008 #####
system.time({
  mapbiomas_adm3_2008 <- exact_extract(mapbiomas_2008, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2008) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2009 #####
system.time({
  mapbiomas_adm3_2009 <- exact_extract(mapbiomas_2009, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2009) %>% 
    relocate(year, .after = GID_3) 
  
})



##### Extract raster for 2010 #####
system.time({
  mapbiomas_adm3_2010 <- exact_extract(mapbiomas_2010, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2010) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2011 #####
system.time({
  mapbiomas_adm3_2011 <- exact_extract(mapbiomas_2011, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2011) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2012 #####
system.time({
  mapbiomas_adm3_2012 <- exact_extract(mapbiomas_2012, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2012) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2013 #####
system.time({
  mapbiomas_adm3_2013 <- exact_extract(mapbiomas_2013, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2013) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2014 #####
system.time({
  mapbiomas_adm3_2014 <- exact_extract(mapbiomas_2014, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2014) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2015 #####
system.time({
  mapbiomas_adm3_2015 <- exact_extract(mapbiomas_2015, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2015) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2016 #####
system.time({
  mapbiomas_adm3_2016 <- exact_extract(mapbiomas_2016, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2016) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2017 #####
system.time({
  mapbiomas_adm3_2017 <- exact_extract(mapbiomas_2017, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2017) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2018 #####
system.time({
  mapbiomas_adm3_2018 <- exact_extract(mapbiomas_2018, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2018) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2019 #####
system.time({
  mapbiomas_adm3_2019 <- exact_extract(mapbiomas_2019, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2019) %>% 
    relocate(year, .after = GID_3) 
  
})









##### Extract raster for 2020 #####
system.time({
  mapbiomas_adm3_2020 <- exact_extract(mapbiomas_2020, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2020) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2021 #####
system.time({
  mapbiomas_adm3_2021 <- exact_extract(mapbiomas_2021, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "mapbiomas_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2021) %>% 
    relocate(year, .after = GID_3) 
  
})







# Combine in panel dataset
mapbiomas_adm3 <- do.call("rbind", mget(ls(pattern="mapbiomas_adm3_")))

mapbiomas_adm3 = bolivia3 %>% 
  merge(mapbiomas_adm3, by = "GID_3") %>% 
  select(-one_of(c("GID_3","GID_0","GID_1",    
                   "NL_NAME_1", "GID_2", "NL_NAME_2",      
                   "VARNAME_3", "NL_NAME_3", "TYPE_3", "ENGTYPE_3", "CC_3",      
                   "HASC_3"))) %>% 
  rename(country = COUNTRY, 
         admin_1 = NAME_1,
         admin_2 = NAME_2,
         admin_3 = NAME_3) %>% 
  arrange(admin_1, admin_2, admin_3, year)

# Write to disk
write_sf(mapbiomas_adm3, file.path(output, "mapbiomas_adm3.shp"))
save(mapbiomas_adm3, file = file.path(output, "mapbiomas_adm3.RData"))
haven::write_dta(st_drop_geometry(mapbiomas_adm3), file.path(output, "mapbiomas_adm3.dta"))

  