# Import libraries 
library(terra)
library(sf)
sf_use_s2(FALSE)
library(exactextractr)

# Path to files
mapbiomas = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/raw-data/mapbiomas")
shapefiles = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/raw-data/shapefiles/gadm41_BOL_shp")
burned = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/constructed-data/burned_areas")

##### Minimal Working Example #####

# Import rasters
mapbiomas_2018 = terra::rast(file.path(mapbiomas, "mapbiomas_2018.tif"))
mapbiomas_2019 = terra::rast(file.path(mapbiomas, "mapbiomas_2019.tif"))

# Construct mask
transitions <- (((mapbiomas_2018 == 3) | (mapbiomas_2018 == 6)) & (mapbiomas_2019 == 13))*1

# Visually inspect results vis a vis transitions
forest_2018 <- ((mapbiomas_2018 == 3) | (mapbiomas_2018 == 6))*1
nonforest_2019 <- (mapbiomas_2019 == 13)*1

##### Full extraction #####

# List of years
years <- 2000:2020

# Loop over each year
for (i in 1:length(years)) {
  # Read the raster for the current year
  raster_year <- rast(file.path(mapbiomas, paste0("mapbiomas_", years[i], ".tif")))
  # Read the raster for the following year
  raster_year_next <- rast(file.path(mapbiomas, paste0("mapbiomas_", years[i+1], ".tif")))
  
  # Create the mask for the current year and reclassify the mask to 0 and 1
  transitions <- (((raster_year == 3) | (raster_year == 6)) & (raster_year_next == 13))* 1
  
  # Assign the reclassified mask to the Global Environment
  assign(paste0("transitions_", years[i+1]), transitions, envir = .GlobalEnv)
}

# Import San José de Chiquitos shapefile
sjdc = st_read(file.path(shapefiles, "gadm41_BOL_3.shp")) %>% 
  filter(GID_3 == "BOL.8.3.3_2")

# Loop over each year
rm(years)
years <- 2001:2020

for (year in years) {
  # Get the name of the transitions raster for the current year
  raster_name <- paste0("transitions_", year)
  
  # Read the transitions raster from the Global Environment
  transitions_raster <- get(raster_name)
  
  # Crop the transitions raster to the extent of San Jose de Chiquitos municipality
  transitions_cropped <- crop(transitions_raster, sjdc, mask = TRUE)
  
  # Assign the cropped raster to the Global Environment
  assign(paste0("transitions_cropped_", year), transitions_cropped, envir = .GlobalEnv)
}  


##### Minimal Working Example: burned areas #####

# Import burned areas shapefile
burned_2001 = st_read(file.path(burned, "burned_2001.shp"))  %>% 
  st_union() %>% 
  st_as_sf() %>% 
  rename(geometry = x) %>% 
  mutate(ID = paste0("Burned Area ", year)) %>% 
  relocate(ID)

# Check shape
ggplot() +
  geom_sf(data = burned_2001)

shapefile = st_intersection(burned_2001, sjdc)

# Check shape
ggplot() +
  geom_sf(data = burned_sjdc_2018, colour = "red") +
  geom_sf(data = burned_sjdc_2019, colour = "blue")
  


##### Import burned areas and crop them to San Jose de Chiquitos #####
# Loop over the years from 2001 to 2021
for (year in 2001:2021) {
  # Generate the shapefile name based on the year
  shapefile_name <- paste0("burned_", year)
  
  # Construct the full path to the shapefile
  shapefile_path <- file.path(burned, paste0(shapefile_name, ".shp"))
  
  # Import the shapefile using the sf package
  shapefile <- read_sf(shapefile_path) %>% 
    st_union() %>% 
    st_as_sf() %>% 
    rename(geometry = x) %>% 
    mutate(ID = paste0("Burned Area ", year)) %>% 
    relocate(ID)
  
  shapefile = st_intersection(shapefile, sjdc)
  
  # Assign the cropped shapefile to the Global Environment
  assign(paste0("burned_sjdc_", year), shapefile, envir = .GlobalEnv)

}

##### Crop transition rasters to burned areas in San Jose de Chiquitos in the year prior #####
# Loop over each year
for (year in 2002:2020) {
  # Get the names of the transitions and burned shapefiles for the current year
  transitions_name <- paste0("transitions_", year)
  burned_name <- paste0("burned_sjdc_", year - 1)
  
  # Read the transitions raster and burned area shapefile from the Global Environment
  transitions_raster <- get(transitions_name)
  burned_area <- get(burned_name)
  
  # Crop the transitions raster to the extent of the burned area shapefile
  transitions_cropped <- crop(transitions_raster, burned_area, mask = TRUE)
  
  # Assign the cropped raster to the Global Environment
  cropped_name <- paste0("transitions_burned_", year)
  assign(cropped_name, transitions_cropped, envir = .GlobalEnv)
}



##### Final step: extract raster counts to SJDC #####

sjdc <- sjdc %>% 
    mutate(transitions_2002 = exact_extract(transitions_cropped_2002, sjdc, "sum"),
           transitions_burned_2002 = exact_extract(transitions_burned_2002, sjdc, "sum"),
           transitions_2003 = exact_extract(transitions_cropped_2003, sjdc, "sum"),
           transitions_burned_2003 = exact_extract(transitions_burned_2003, sjdc, "sum"),
           transitions_2004 = exact_extract(transitions_cropped_2004, sjdc, "sum"),
           transitions_burned_2004 = exact_extract(transitions_burned_2004, sjdc, "sum"), 
           transitions_2005 = exact_extract(transitions_cropped_2005, sjdc, "sum"),
           transitions_burned_2005 = exact_extract(transitions_burned_2005, sjdc, "sum"), 
           transitions_2006 = exact_extract(transitions_cropped_2006, sjdc, "sum"),
           transitions_burned_2006 = exact_extract(transitions_burned_2006, sjdc, "sum"), 
           transitions_2007 = exact_extract(transitions_cropped_2007, sjdc, "sum"),
           transitions_burned_2007 = exact_extract(transitions_burned_2007, sjdc, "sum"),
           transitions_2008 = exact_extract(transitions_cropped_2008, sjdc, "sum"),
           transitions_burned_2008 = exact_extract(transitions_burned_2008, sjdc, "sum"),
           transitions_2009 = exact_extract(transitions_cropped_2009, sjdc, "sum"),
           transitions_burned_2009 = exact_extract(transitions_burned_2009, sjdc, "sum"),
           transitions_2010 = exact_extract(transitions_cropped_2010, sjdc, "sum"),
           transitions_burned_2010 = exact_extract(transitions_burned_2010, sjdc, "sum"),
           transitions_2011 = exact_extract(transitions_cropped_2011, sjdc, "sum"),
           transitions_burned_2011 = exact_extract(transitions_burned_2011, sjdc, "sum"),
           transitions_2012 = exact_extract(transitions_cropped_2012, sjdc, "sum"),
           transitions_burned_2012 = exact_extract(transitions_burned_2012, sjdc, "sum"),
           transitions_2013 = exact_extract(transitions_cropped_2013, sjdc, "sum"),
           transitions_burned_2013 = exact_extract(transitions_burned_2013, sjdc, "sum"),
           transitions_2014 = exact_extract(transitions_cropped_2014, sjdc, "sum"),
           transitions_burned_2014 = exact_extract(transitions_burned_2014, sjdc, "sum"), 
           transitions_2015 = exact_extract(transitions_cropped_2015, sjdc, "sum"),
           transitions_burned_2015 = exact_extract(transitions_burned_2015, sjdc, "sum"), 
           transitions_2016 = exact_extract(transitions_cropped_2016, sjdc, "sum"),
           transitions_burned_2016 = exact_extract(transitions_burned_2016, sjdc, "sum"), 
           transitions_2017 = exact_extract(transitions_cropped_2017, sjdc, "sum"),
           transitions_burned_2017 = exact_extract(transitions_burned_2017, sjdc, "sum"),
           transitions_2018 = exact_extract(transitions_cropped_2018, sjdc, "sum"),
           transitions_burned_2018 = exact_extract(transitions_burned_2018, sjdc, "sum"),
           transitions_2019 = exact_extract(transitions_cropped_2019, sjdc, "sum"),
           transitions_burned_2019 = exact_extract(transitions_burned_2019, sjdc, "sum"),
           transitions_2020 = exact_extract(transitions_cropped_2020, sjdc, "sum"),
           transitions_burned_2020 = exact_extract(transitions_burned_2020, sjdc, "sum"))


sjdc_graph = sjdc %>% 
  st_drop_geometry() %>% 
  select(-one_of(c("GID_3","GID_0",             
                   "COUNTRY","GID_1",             
                   "NAME_1","NL_NAME_1",             
                   "GID_2", "NAME_2", "NAME_3",         
                   "NL_NAME_2","VARNAME_3",
                   "NL_NAME_3", "TYPE_3",
                   "ENGTYPE_3", "CC_3", "HASC_3"))) %>% 
  mutate(admin = "San Josè de Chiquitos") %>% 
  rename_at(
    vars(str_subset(names(.), "^transitions_(?!burned)")),
    ~str_replace(., "transitions_", "transitions_all_")) %>% 
  relocate(admin) %>% 
  pivot_longer(
    cols = starts_with("transitions"),
    names_to = c("type", "year"),
    values_to = "value",
    names_prefix = "transitions_",
    names_sep = "_") %>% 
  pivot_wider(names_from = type,
              values_from = value) %>% 
  mutate(unburned = all - burned) %>% 
  pivot_longer(cols = all:unburned,
               values_to = "pixels",
               names_to = "type") %>% 
  filter(!type == "all") %>% 
  mutate(type = case_when(
    type == "burned" ~ "Burned",
    type == "unburned" ~ "Unburned"
  ))


ggplot(sjdc_graph, aes(fill=factor(type), y=pixels, x=year)) + 
  geom_bar(position="stack", stat="identity") +
  theme_minimal() +
  ggtitle("Distribution of 1-4 Transitions in MODIS Burned Areas vs Unburned Land for San Josè de Chiquitos") +
  xlab("Year") + ylab("Pixel count") +
  scale_fill_discrete(name = "Prior Year Burned Status")

ggplot(sjdc_graph, aes(fill=factor(type), y=pixels, x=year)) + 
  geom_bar(position="dodge", stat="identity") +
  theme_minimal() +
  ggtitle("Distribution of 1-4 Transitions in MODIS Burned Areas vs Unburned Land for San Josè de Chiquitos") +
  xlab("Year") + ylab("Pixel count") +
  scale_fill_discrete(name = "Prior Year Burned Status")


##### Crop transition rasters to burned areas in San Jose de Chiquitos in the year prior #####
# Loop over each year
for (year in 2001:2020) {
  # Get the names of the transitions and burned shapefiles for the current year
  transitions_name <- paste0("transitions_", year)
  burned_name <- paste0("burned_sjdc_", year )
  
  # Read the transitions raster and burned area shapefile from the Global Environment
  transitions_raster <- get(transitions_name)
  burned_area <- get(burned_name)
  
  # Crop the transitions raster to the extent of the burned area shapefile
  transitions_cropped <- crop(transitions_raster, burned_area, mask = TRUE)
  
  # Assign the cropped raster to the Global Environment
  cropped_name <- paste0("transitions_contemporaneous_", year)
  assign(cropped_name, transitions_cropped, envir = .GlobalEnv)
}


##### Final step: extract raster counts to SJDC #####

sjdc_cont <- sjdc %>% 
  mutate(transitions_2002 = exact_extract(transitions_cropped_2002, sjdc, "sum"),
         transitions_contemporaneous_2002 = exact_extract(transitions_contemporaneous_2002, sjdc, "sum"),
         transitions_2003 = exact_extract(transitions_cropped_2003, sjdc, "sum"),
         transitions_contemporaneous_2003 = exact_extract(transitions_contemporaneous_2003, sjdc, "sum"),
         transitions_2004 = exact_extract(transitions_cropped_2004, sjdc, "sum"),
         transitions_contemporaneous_2004 = exact_extract(transitions_contemporaneous_2004, sjdc, "sum"), 
         transitions_2005 = exact_extract(transitions_cropped_2005, sjdc, "sum"),
         transitions_contemporaneous_2005 = exact_extract(transitions_contemporaneous_2005, sjdc, "sum"), 
         transitions_2006 = exact_extract(transitions_cropped_2006, sjdc, "sum"),
         transitions_contemporaneous_2006 = exact_extract(transitions_contemporaneous_2006, sjdc, "sum"), 
         transitions_2007 = exact_extract(transitions_cropped_2007, sjdc, "sum"),
         transitions_contemporaneous_2007 = exact_extract(transitions_contemporaneous_2007, sjdc, "sum"),
         transitions_2008 = exact_extract(transitions_cropped_2008, sjdc, "sum"),
         transitions_contemporaneous_2008 = exact_extract(transitions_contemporaneous_2008, sjdc, "sum"),
         transitions_2009 = exact_extract(transitions_cropped_2009, sjdc, "sum"),
         transitions_contemporaneous_2009 = exact_extract(transitions_contemporaneous_2009, sjdc, "sum"),
         transitions_2010 = exact_extract(transitions_cropped_2010, sjdc, "sum"),
         transitions_contemporaneous_2010 = exact_extract(transitions_contemporaneous_2010, sjdc, "sum"),
         transitions_2011 = exact_extract(transitions_cropped_2011, sjdc, "sum"),
         transitions_contemporaneous_2011 = exact_extract(transitions_contemporaneous_2011, sjdc, "sum"),
         transitions_2012 = exact_extract(transitions_cropped_2012, sjdc, "sum"),
         transitions_contemporaneous_2012 = exact_extract(transitions_contemporaneous_2012, sjdc, "sum"),
         transitions_2013 = exact_extract(transitions_cropped_2013, sjdc, "sum"),
         transitions_contemporaneous_2013 = exact_extract(transitions_contemporaneous_2013, sjdc, "sum"),
         transitions_2014 = exact_extract(transitions_cropped_2014, sjdc, "sum"),
         transitions_contemporaneous_2014 = exact_extract(transitions_contemporaneous_2014, sjdc, "sum"), 
         transitions_2015 = exact_extract(transitions_cropped_2015, sjdc, "sum"),
         transitions_contemporaneous_2015 = exact_extract(transitions_contemporaneous_2015, sjdc, "sum"), 
         transitions_2016 = exact_extract(transitions_cropped_2016, sjdc, "sum"),
         transitions_contemporaneous_2016 = exact_extract(transitions_contemporaneous_2016, sjdc, "sum"), 
         transitions_2017 = exact_extract(transitions_cropped_2017, sjdc, "sum"),
         transitions_contemporaneous_2017 = exact_extract(transitions_contemporaneous_2017, sjdc, "sum"),
         transitions_2018 = exact_extract(transitions_cropped_2018, sjdc, "sum"),
         transitions_contemporaneous_2018 = exact_extract(transitions_contemporaneous_2018, sjdc, "sum"),
         transitions_2019 = exact_extract(transitions_cropped_2019, sjdc, "sum"),
         transitions_contemporaneous_2019 = exact_extract(transitions_contemporaneous_2019, sjdc, "sum"),
         transitions_2020 = exact_extract(transitions_cropped_2020, sjdc, "sum"),
         transitions_contemporaneous_2020 = exact_extract(transitions_contemporaneous_2020, sjdc, "sum"))


sjdc_cont_graph = sjdc_cont %>% 
  st_drop_geometry() %>% 
  select(-one_of(c("GID_3","GID_0",             
                   "COUNTRY","GID_1",             
                   "NAME_1","NL_NAME_1",             
                   "GID_2", "NAME_2", "NAME_3",         
                   "NL_NAME_2","VARNAME_3",
                   "NL_NAME_3", "TYPE_3",
                   "ENGTYPE_3", "CC_3", "HASC_3"))) %>% 
  select(-starts_with("transitions_burned")) %>% 
  mutate(admin = "San Josè de Chiquitos") %>% 
  rename_at(
    vars(str_subset(names(.), "^transitions_(?!contemporaneous)")),
    ~str_replace(., "transitions_", "transitions_all_")) %>% 
  relocate(admin) %>% 
  pivot_longer(
    cols = starts_with("transitions"),
    names_to = c("type", "year"),
    values_to = "value",
    names_prefix = "transitions_",
    names_sep = "_") %>% 
  pivot_wider(names_from = type,
              values_from = value) %>% 
  mutate(unburned = all - contemporaneous) %>% 
  pivot_longer(cols = all:unburned,
               values_to = "pixels",
               names_to = "type") %>% 
  filter(!type == "all") %>% 
  mutate(type = case_when(
    type == "contemporaneous" ~ "Burned",
    type == "unburned" ~ "Unburned"
  ))


ggplot(sjdc_cont_graph, aes(fill=factor(type), y=pixels, x=year)) + 
  geom_bar(position="stack", stat="identity") +
  theme_minimal() +
  ggtitle("Distribution of 1-4 Transitions in MODIS Burned Areas vs Unburned Land for San Josè de Chiquitos") +
  xlab("Year") + ylab("Pixel count") +
  scale_fill_discrete(name = "Same Year Burned Status")

ggplot(sjdc_cont_graph, aes(fill=factor(type), y=pixels, x=year)) + 
  geom_bar(position="dodge", stat="identity") +
  theme_minimal() +
  ggtitle("Distribution of 1-4 Transitions in MODIS Burned Areas vs Unburned Land for San Josè de Chiquitos") +
  xlab("Year") + ylab("Pixel count") +
  scale_fill_discrete(name = "Same Year Burned Status")

