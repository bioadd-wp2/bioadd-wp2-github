library(tidyverse)
library(sf)

# Define Paths
shapefiles = file.path("~/Dropbox/BIOADD/shapefiles/gadm41_BOL_shp")

# Import Bolivia shapefile & make grid
bolivia <- read_sf(file.path(shapefiles, "gadm41_BOL_0.shp")) 

mapview::mapview(bolivia)
