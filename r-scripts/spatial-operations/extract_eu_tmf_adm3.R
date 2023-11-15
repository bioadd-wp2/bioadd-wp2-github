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
tmf = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/raw-data/TMF")



##### Data #####

##### Merge TMF tiles 2000 #####
# Import tiles 
tile_1_2000 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2000_SAM_ID30_N0_W60.tif"))
tile_2_2000 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2000_SAM_ID29_N0_W70.tif"))
tile_3_2000 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2000_SAM_ID13_S10_W60.tif"))
tile_4_2000 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2000_SAM_ID12_S10_W70.tif"))
tile_5_2000 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2000_SAM_ID4_S20_W60.tif"))
tile_6_2000 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2000_SAM_ID3_S20_W70.tif"))

# Merge tiles
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
##### Merge TMF tiles 2001 #####
# Import tiles 
tile_1_2001 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2001_SAM_ID30_N0_W60.tif"))
tile_2_2001 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2001_SAM_ID29_N0_W70.tif"))
tile_3_2001 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2001_SAM_ID13_S10_W60.tif"))
tile_4_2001 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2001_SAM_ID12_S10_W70.tif"))
tile_5_2001 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2001_SAM_ID4_S20_W60.tif"))
tile_6_2001 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2001_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2001 = merge(tile_1_2001,
                 tile_2_2001,
                 tile_3_2001,
                 tile_4_2001,
                 tile_5_2001,
                 tile_6_2001)

# Remove individual tiles
rm(tile_1_2001,
   tile_2_2001,
   tile_3_2001,
   tile_4_2001,
   tile_5_2001,
   tile_6_2001)
##### Merge TMF tiles 2002 #####
# Import tiles 
tile_1_2002 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2002_SAM_ID30_N0_W60.tif"))
tile_2_2002 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2002_SAM_ID29_N0_W70.tif"))
tile_3_2002 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2002_SAM_ID13_S10_W60.tif"))
tile_4_2002 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2002_SAM_ID12_S10_W70.tif"))
tile_5_2002 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2002_SAM_ID4_S20_W60.tif"))
tile_6_2002 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2002_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2002 = merge(tile_1_2002,
                 tile_2_2002,
                 tile_3_2002,
                 tile_4_2002,
                 tile_5_2002,
                 tile_6_2002)

# Remove individual tiles
rm(tile_1_2002,
   tile_2_2002,
   tile_3_2002,
   tile_4_2002,
   tile_5_2002,
   tile_6_2002)
##### Merge TMF tiles 2003 #####
# Import tiles 
tile_1_2003 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2003_SAM_ID30_N0_W60.tif"))
tile_2_2003 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2003_SAM_ID29_N0_W70.tif"))
tile_3_2003 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2003_SAM_ID13_S10_W60.tif"))
tile_4_2003 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2003_SAM_ID12_S10_W70.tif"))
tile_5_2003 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2003_SAM_ID4_S20_W60.tif"))
tile_6_2003 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2003_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2003 = merge(tile_1_2003,
                 tile_2_2003,
                 tile_3_2003,
                 tile_4_2003,
                 tile_5_2003,
                 tile_6_2003)

# Remove individual tiles
rm(tile_1_2003,
   tile_2_2003,
   tile_3_2003,
   tile_4_2003,
   tile_5_2003,
   tile_6_2003)
##### Merge TMF tiles 2004 #####
# Import tiles 
tile_1_2004 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2004_SAM_ID30_N0_W60.tif"))
tile_2_2004 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2004_SAM_ID29_N0_W70.tif"))
tile_3_2004 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2004_SAM_ID13_S10_W60.tif"))
tile_4_2004 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2004_SAM_ID12_S10_W70.tif"))
tile_5_2004 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2004_SAM_ID4_S20_W60.tif"))
tile_6_2004 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2004_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2004 = merge(tile_1_2004,
                 tile_2_2004,
                 tile_3_2004,
                 tile_4_2004,
                 tile_5_2004,
                 tile_6_2004)

# Remove individual tiles
rm(tile_1_2004,
   tile_2_2004,
   tile_3_2004,
   tile_4_2004,
   tile_5_2004,
   tile_6_2004)
##### Merge TMF tiles 2005 #####
# Import tiles 
tile_1_2005 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2005_SAM_ID30_N0_W60.tif"))
tile_2_2005 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2005_SAM_ID29_N0_W70.tif"))
tile_3_2005 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2005_SAM_ID13_S10_W60.tif"))
tile_4_2005 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2005_SAM_ID12_S10_W70.tif"))
tile_5_2005 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2005_SAM_ID4_S20_W60.tif"))
tile_6_2005 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2005_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2005 = merge(tile_1_2005,
                 tile_2_2005,
                 tile_3_2005,
                 tile_4_2005,
                 tile_5_2005,
                 tile_6_2005)

# Remove individual tiles
rm(tile_1_2005,
   tile_2_2005,
   tile_3_2005,
   tile_4_2005,
   tile_5_2005,
   tile_6_2005)
##### Merge TMF tiles 2006 #####
# Import tiles 
tile_1_2006 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2006_SAM_ID30_N0_W60.tif"))
tile_2_2006 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2006_SAM_ID29_N0_W70.tif"))
tile_3_2006 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2006_SAM_ID13_S10_W60.tif"))
tile_4_2006 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2006_SAM_ID12_S10_W70.tif"))
tile_5_2006 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2006_SAM_ID4_S20_W60.tif"))
tile_6_2006 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2006_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2006 = merge(tile_1_2006,
                 tile_2_2006,
                 tile_3_2006,
                 tile_4_2006,
                 tile_5_2006,
                 tile_6_2006)

# Remove individual tiles
rm(tile_1_2006,
   tile_2_2006,
   tile_3_2006,
   tile_4_2006,
   tile_5_2006,
   tile_6_2006)
##### Merge TMF tiles 2007 #####
# Import tiles 
tile_1_2007 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2007_SAM_ID30_N0_W60.tif"))
tile_2_2007 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2007_SAM_ID29_N0_W70.tif"))
tile_3_2007 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2007_SAM_ID13_S10_W60.tif"))
tile_4_2007 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2007_SAM_ID12_S10_W70.tif"))
tile_5_2007 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2007_SAM_ID4_S20_W60.tif"))
tile_6_2007 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2007_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2007 = merge(tile_1_2007,
                 tile_2_2007,
                 tile_3_2007,
                 tile_4_2007,
                 tile_5_2007,
                 tile_6_2007)

# Remove individual tiles
rm(tile_1_2007,
   tile_2_2007,
   tile_3_2007,
   tile_4_2007,
   tile_5_2007,
   tile_6_2007)
##### Merge TMF tiles 2008 #####
# Import tiles 
tile_1_2008 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2008_SAM_ID30_N0_W60.tif"))
tile_2_2008 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2008_SAM_ID29_N0_W70.tif"))
tile_3_2008 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2008_SAM_ID13_S10_W60.tif"))
tile_4_2008 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2008_SAM_ID12_S10_W70.tif"))
tile_5_2008 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2008_SAM_ID4_S20_W60.tif"))
tile_6_2008 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2008_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2008 = merge(tile_1_2008,
                 tile_2_2008,
                 tile_3_2008,
                 tile_4_2008,
                 tile_5_2008,
                 tile_6_2008)

# Remove individual tiles
rm(tile_1_2008,
   tile_2_2008,
   tile_3_2008,
   tile_4_2008,
   tile_5_2008,
   tile_6_2008)
##### Merge TMF tiles 2009 #####
# Import tiles 
tile_1_2009 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2009_SAM_ID30_N0_W60.tif"))
tile_2_2009 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2009_SAM_ID29_N0_W70.tif"))
tile_3_2009 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2009_SAM_ID13_S10_W60.tif"))
tile_4_2009 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2009_SAM_ID12_S10_W70.tif"))
tile_5_2009 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2009_SAM_ID4_S20_W60.tif"))
tile_6_2009 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2009_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2009 = merge(tile_1_2009,
                 tile_2_2009,
                 tile_3_2009,
                 tile_4_2009,
                 tile_5_2009,
                 tile_6_2009)

# Remove individual tiles
rm(tile_1_2009,
   tile_2_2009,
   tile_3_2009,
   tile_4_2009,
   tile_5_2009,
   tile_6_2009)

##### Merge TMF tiles 2010 #####
# Import tiles 
tile_1_2010 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2010_SAM_ID30_N0_W60.tif"))
tile_2_2010 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2010_SAM_ID29_N0_W70.tif"))
tile_3_2010 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2010_SAM_ID13_S10_W60.tif"))
tile_4_2010 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2010_SAM_ID12_S10_W70.tif"))
tile_5_2010 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2010_SAM_ID4_S20_W60.tif"))
tile_6_2010 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2010_SAM_ID3_S20_W70.tif"))

# Merge tiles
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
##### Merge TMF tiles 2011 #####
# Import tiles 
tile_1_2011 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2011_SAM_ID30_N0_W60.tif"))
tile_2_2011 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2011_SAM_ID29_N0_W70.tif"))
tile_3_2011 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2011_SAM_ID13_S10_W60.tif"))
tile_4_2011 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2011_SAM_ID12_S10_W70.tif"))
tile_5_2011 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2011_SAM_ID4_S20_W60.tif"))
tile_6_2011 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2011_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2011 = merge(tile_1_2011,
                 tile_2_2011,
                 tile_3_2011,
                 tile_4_2011,
                 tile_5_2011,
                 tile_6_2011)

# Remove individual tiles
rm(tile_1_2011,
   tile_2_2011,
   tile_3_2011,
   tile_4_2011,
   tile_5_2011,
   tile_6_2011)
##### Merge TMF tiles 2012 #####
# Import tiles 
tile_1_2012 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2012_SAM_ID30_N0_W60.tif"))
tile_2_2012 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2012_SAM_ID29_N0_W70.tif"))
tile_3_2012 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2012_SAM_ID13_S10_W60.tif"))
tile_4_2012 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2012_SAM_ID12_S10_W70.tif"))
tile_5_2012 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2012_SAM_ID4_S20_W60.tif"))
tile_6_2012 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2012_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2012 = merge(tile_1_2012,
                 tile_2_2012,
                 tile_3_2012,
                 tile_4_2012,
                 tile_5_2012,
                 tile_6_2012)

# Remove individual tiles
rm(tile_1_2012,
   tile_2_2012,
   tile_3_2012,
   tile_4_2012,
   tile_5_2012,
   tile_6_2012)
##### Merge TMF tiles 2013 #####
# Import tiles 
tile_1_2013 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2013_SAM_ID30_N0_W60.tif"))
tile_2_2013 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2013_SAM_ID29_N0_W70.tif"))
tile_3_2013 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2013_SAM_ID13_S10_W60.tif"))
tile_4_2013 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2013_SAM_ID12_S10_W70.tif"))
tile_5_2013 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2013_SAM_ID4_S20_W60.tif"))
tile_6_2013 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2013_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2013 = merge(tile_1_2013,
                 tile_2_2013,
                 tile_3_2013,
                 tile_4_2013,
                 tile_5_2013,
                 tile_6_2013)

# Remove individual tiles
rm(tile_1_2013,
   tile_2_2013,
   tile_3_2013,
   tile_4_2013,
   tile_5_2013,
   tile_6_2013)
##### Merge TMF tiles 2014 #####
# Import tiles 
tile_1_2014 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2014_SAM_ID30_N0_W60.tif"))
tile_2_2014 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2014_SAM_ID29_N0_W70.tif"))
tile_3_2014 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2014_SAM_ID13_S10_W60.tif"))
tile_4_2014 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2014_SAM_ID12_S10_W70.tif"))
tile_5_2014 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2014_SAM_ID4_S20_W60.tif"))
tile_6_2014 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2014_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2014 = merge(tile_1_2014,
                 tile_2_2014,
                 tile_3_2014,
                 tile_4_2014,
                 tile_5_2014,
                 tile_6_2014)

# Remove individual tiles
rm(tile_1_2014,
   tile_2_2014,
   tile_3_2014,
   tile_4_2014,
   tile_5_2014,
   tile_6_2014)
##### Merge TMF tiles 2015 #####
# Import tiles 
tile_1_2015 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2015_SAM_ID30_N0_W60.tif"))
tile_2_2015 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2015_SAM_ID29_N0_W70.tif"))
tile_3_2015 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2015_SAM_ID13_S10_W60.tif"))
tile_4_2015 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2015_SAM_ID12_S10_W70.tif"))
tile_5_2015 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2015_SAM_ID4_S20_W60.tif"))
tile_6_2015 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2015_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2015 = merge(tile_1_2015,
                 tile_2_2015,
                 tile_3_2015,
                 tile_4_2015,
                 tile_5_2015,
                 tile_6_2015)

# Remove individual tiles
rm(tile_1_2015,
   tile_2_2015,
   tile_3_2015,
   tile_4_2015,
   tile_5_2015,
   tile_6_2015)
##### Merge TMF tiles 2016 #####
# Import tiles 
tile_1_2016 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2016_SAM_ID30_N0_W60.tif"))
tile_2_2016 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2016_SAM_ID29_N0_W70.tif"))
tile_3_2016 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2016_SAM_ID13_S10_W60.tif"))
tile_4_2016 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2016_SAM_ID12_S10_W70.tif"))
tile_5_2016 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2016_SAM_ID4_S20_W60.tif"))
tile_6_2016 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2016_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2016 = merge(tile_1_2016,
                 tile_2_2016,
                 tile_3_2016,
                 tile_4_2016,
                 tile_5_2016,
                 tile_6_2016)

# Remove individual tiles
rm(tile_1_2016,
   tile_2_2016,
   tile_3_2016,
   tile_4_2016,
   tile_5_2016,
   tile_6_2016)
##### Merge TMF tiles 2017 #####
# Import tiles 
tile_1_2017 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2017_SAM_ID30_N0_W60.tif"))
tile_2_2017 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2017_SAM_ID29_N0_W70.tif"))
tile_3_2017 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2017_SAM_ID13_S10_W60.tif"))
tile_4_2017 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2017_SAM_ID12_S10_W70.tif"))
tile_5_2017 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2017_SAM_ID4_S20_W60.tif"))
tile_6_2017 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2017_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2017 = merge(tile_1_2017,
                 tile_2_2017,
                 tile_3_2017,
                 tile_4_2017,
                 tile_5_2017,
                 tile_6_2017)

# Remove individual tiles
rm(tile_1_2017,
   tile_2_2017,
   tile_3_2017,
   tile_4_2017,
   tile_5_2017,
   tile_6_2017)
##### Merge TMF tiles 2018 #####
# Import tiles 
tile_1_2018 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2018_SAM_ID30_N0_W60.tif"))
tile_2_2018 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2018_SAM_ID29_N0_W70.tif"))
tile_3_2018 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2018_SAM_ID13_S10_W60.tif"))
tile_4_2018 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2018_SAM_ID12_S10_W70.tif"))
tile_5_2018 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2018_SAM_ID4_S20_W60.tif"))
tile_6_2018 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2018_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2018 = merge(tile_1_2018,
                 tile_2_2018,
                 tile_3_2018,
                 tile_4_2018,
                 tile_5_2018,
                 tile_6_2018)

# Remove individual tiles
rm(tile_1_2018,
   tile_2_2018,
   tile_3_2018,
   tile_4_2018,
   tile_5_2018,
   tile_6_2018)
##### Merge TMF tiles 2019 #####
# Import tiles 
tile_1_2019 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2019_SAM_ID30_N0_W60.tif"))
tile_2_2019 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2019_SAM_ID29_N0_W70.tif"))
tile_3_2019 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2019_SAM_ID13_S10_W60.tif"))
tile_4_2019 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2019_SAM_ID12_S10_W70.tif"))
tile_5_2019 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2019_SAM_ID4_S20_W60.tif"))
tile_6_2019 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2019_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2019 = merge(tile_1_2019,
                 tile_2_2019,
                 tile_3_2019,
                 tile_4_2019,
                 tile_5_2019,
                 tile_6_2019)

# Remove individual tiles
rm(tile_1_2019,
   tile_2_2019,
   tile_3_2019,
   tile_4_2019,
   tile_5_2019,
   tile_6_2019)

##### Merge TMF tiles 2020 #####
# Import tiles 
tile_1_2020 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2020_SAM_ID30_N0_W60.tif"))
tile_2_2020 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2020_SAM_ID29_N0_W70.tif"))
tile_3_2020 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2020_SAM_ID13_S10_W60.tif"))
tile_4_2020 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2020_SAM_ID12_S10_W70.tif"))
tile_5_2020 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2020_SAM_ID4_S20_W60.tif"))
tile_6_2020 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2020_SAM_ID3_S20_W70.tif"))

# Merge tiles
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
##### Merge TMF tiles 2021 #####
# Import tiles 
tile_1_2021 = rast(file.path(tmf,  "tmf_N0_W60/JRC_TMF_AnnualChange_v2_2021_SAM_ID30_N0_W60.tif"))
tile_2_2021 = rast(file.path(tmf,  "tmf_N0_W70/JRC_TMF_AnnualChange_v2_2021_SAM_ID29_N0_W70.tif"))
tile_3_2021 = rast(file.path(tmf, "tmf_S10_W60/JRC_TMF_AnnualChange_v2_2021_SAM_ID13_S10_W60.tif"))
tile_4_2021 = rast(file.path(tmf, "tmf_S10_W70/JRC_TMF_AnnualChange_v2_2021_SAM_ID12_S10_W70.tif"))
tile_5_2021 = rast(file.path(tmf, "tmf_S20_W60/JRC_TMF_AnnualChange_v2_2021_SAM_ID4_S20_W60.tif"))
tile_6_2021 = rast(file.path(tmf, "tmf_S20_W70/JRC_TMF_AnnualChange_v2_2021_SAM_ID3_S20_W70.tif"))

# Merge tiles
tmf_2021 = merge(tile_1_2021,
                 tile_2_2021,
                 tile_3_2021,
                 tile_4_2021,
                 tile_5_2021,
                 tile_6_2021)

# Remove individual tiles
rm(tile_1_2021,
   tile_2_2021,
   tile_3_2021,
   tile_4_2021,
   tile_5_2021,
   tile_6_2021)

# Import bolivia grid 
bolivia3 = read_sf(file.path(bolivia_shapefiles, "gadm41_BOL_3.shp"))

##### Extract raster for 2000 #####
system.time({
  tmf_adm3_2000 <- exact_extract(tmf_2000, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2000) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2001 #####
system.time({
  tmf_adm3_2001 <- exact_extract(tmf_2001, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2001) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2002 #####
system.time({
  tmf_adm3_2002 <- exact_extract(tmf_2002, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2002) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2003 #####
system.time({
  tmf_adm3_2003 <- exact_extract(tmf_2003, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2003) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2004 #####
system.time({
  tmf_adm3_2004 <- exact_extract(tmf_2004, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2004) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2005 #####
system.time({
  tmf_adm3_2005 <- exact_extract(tmf_2005, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2005) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2006 #####
system.time({
  tmf_adm3_2006 <- exact_extract(tmf_2006, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2006) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2007 #####
system.time({
  tmf_adm3_2007 <- exact_extract(tmf_2007, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2007) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2008 #####
system.time({
  tmf_adm3_2008 <- exact_extract(tmf_2008, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2008) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2009 #####
system.time({
  tmf_adm3_2009 <- exact_extract(tmf_2009, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2009) %>% 
    relocate(year, .after = GID_3) 
  
})



##### Extract raster for 2010 #####
system.time({
  tmf_adm3_2010 <- exact_extract(tmf_2010, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2010) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2011 #####
system.time({
  tmf_adm3_2011 <- exact_extract(tmf_2011, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2011) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2012 #####
system.time({
  tmf_adm3_2012 <- exact_extract(tmf_2012, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2012) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2013 #####
system.time({
  tmf_adm3_2013 <- exact_extract(tmf_2013, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2013) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2014 #####
system.time({
  tmf_adm3_2014 <- exact_extract(tmf_2014, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2014) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2015 #####
system.time({
  tmf_adm3_2015 <- exact_extract(tmf_2015, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2015) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2016 #####
system.time({
  tmf_adm3_2016 <- exact_extract(tmf_2016, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2016) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2017 #####
system.time({
  tmf_adm3_2017 <- exact_extract(tmf_2017, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2017) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2018 #####
system.time({
  tmf_adm3_2018 <- exact_extract(tmf_2018, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2018) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2019 #####
system.time({
  tmf_adm3_2019 <- exact_extract(tmf_2019, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2019) %>% 
    relocate(year, .after = GID_3) 
  
})









##### Extract raster for 2020 #####
system.time({
  tmf_adm3_2020 <- exact_extract(tmf_2020, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2020) %>% 
    relocate(year, .after = GID_3) 
  
})


##### Extract raster for 2021 #####
system.time({
  tmf_adm3_2021 <- exact_extract(tmf_2021, bolivia3, function(df) {
    df %>%
      mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(GID_3, value) %>%
      summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, include_cols = "GID_3", progress = T) %>% 
    pivot_wider(names_from = value, 
                values_from = freq,
                names_prefix = "tmf_") %>% 
    mutate_at(vars(-GID_3), ~replace_na(., 0)) %>% 
    mutate(year = 2021) %>% 
    relocate(year, .after = GID_3) 
  
})








##### Combine in panel dataset #####
tmf_adm3 <- do.call("rbind", mget(ls(pattern="tmf_adm3_")))

tmf_adm3 = bolivia3 %>% 
  merge(tmf_adm3, by = "GID_3") %>% 
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
write_sf(tmf_adm3, file.path(output, "tmf_adm3.shp"))
save(tmf_adm3, file = file.path(output, "tmf_adm3.RData"))
haven::write_dta(st_drop_geometry(tmf_adm3), file.path(output, "tmf_adm3.dta"))



