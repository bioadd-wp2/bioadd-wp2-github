library(tidyverse)
library(terra)
library(sf)
library(mapview)

# Set directories
raw_data = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/raw-data/mapbiomas")

# set the download url 
download_url_2000 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2000.tif"
download_url_2001 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2001.tif"
download_url_2002 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2002.tif"
download_url_2003 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2003.tif"
download_url_2004 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2004.tif"
download_url_2005 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2005.tif"
download_url_2006 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2006.tif"
download_url_2007 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2007.tif"
download_url_2008 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2008.tif"
download_url_2009 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2009.tif"
download_url_2010 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2010.tif"
download_url_2011 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2011.tif"
download_url_2012 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2012.tif"
download_url_2013 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2013.tif"
download_url_2014 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2014.tif"
download_url_2015 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2015.tif"
download_url_2016 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2016.tif"
download_url_2017 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2017.tif"
download_url_2018 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2018.tif"
download_url_2019 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2019.tif"
download_url_2020 <- "https://storage.googleapis.com/mapbiomas-public/initiatives/bolivia/collection_1/lclu/coverage/bolivia_coverage_2020.tif"


# Set file name in Dropbox folder
mapbiomas_2000 <- file.path(raw_data, "mapbiomas_2000.tif")
mapbiomas_2001 <- file.path(raw_data, "mapbiomas_2001.tif")
mapbiomas_2002 <- file.path(raw_data, "mapbiomas_2002.tif")
mapbiomas_2003 <- file.path(raw_data, "mapbiomas_2003.tif")
mapbiomas_2004 <- file.path(raw_data, "mapbiomas_2004.tif")
mapbiomas_2005 <- file.path(raw_data, "mapbiomas_2005.tif")
mapbiomas_2006 <- file.path(raw_data, "mapbiomas_2006.tif")
mapbiomas_2007 <- file.path(raw_data, "mapbiomas_2007.tif")
mapbiomas_2008 <- file.path(raw_data, "mapbiomas_2008.tif")
mapbiomas_2009 <- file.path(raw_data, "mapbiomas_2009.tif")
mapbiomas_2010 <- file.path(raw_data, "mapbiomas_2010.tif")
mapbiomas_2011 <- file.path(raw_data, "mapbiomas_2011.tif")
mapbiomas_2012 <- file.path(raw_data, "mapbiomas_2012.tif")
mapbiomas_2013 <- file.path(raw_data, "mapbiomas_2013.tif")
mapbiomas_2014 <- file.path(raw_data, "mapbiomas_2014.tif")
mapbiomas_2015 <- file.path(raw_data, "mapbiomas_2015.tif")
mapbiomas_2016 <- file.path(raw_data, "mapbiomas_2016.tif")
mapbiomas_2017 <- file.path(raw_data, "mapbiomas_2017.tif")
mapbiomas_2018 <- file.path(raw_data, "mapbiomas_2018.tif")
mapbiomas_2019 <- file.path(raw_data, "mapbiomas_2019.tif")
mapbiomas_2020 <- file.path(raw_data, "mapbiomas_2020.tif")

# download the file
download.file(download_url_2000, mapbiomas_2000)
download.file(download_url_2001, mapbiomas_2001)
download.file(download_url_2002, mapbiomas_2002)
download.file(download_url_2003, mapbiomas_2003)
download.file(download_url_2004, mapbiomas_2004)
download.file(download_url_2005, mapbiomas_2005)
download.file(download_url_2006, mapbiomas_2006)
download.file(download_url_2007, mapbiomas_2007)
download.file(download_url_2008, mapbiomas_2008)
download.file(download_url_2009, mapbiomas_2009)
download.file(download_url_2010, mapbiomas_2010)
download.file(download_url_2011, mapbiomas_2011)
download.file(download_url_2012, mapbiomas_2012)
download.file(download_url_2013, mapbiomas_2013)
download.file(download_url_2014, mapbiomas_2014)
download.file(download_url_2015, mapbiomas_2015)
download.file(download_url_2016, mapbiomas_2016)
download.file(download_url_2017, mapbiomas_2017)
download.file(download_url_2018, mapbiomas_2018)
download.file(download_url_2019, mapbiomas_2019)
download.file(download_url_2020, mapbiomas_2020)
