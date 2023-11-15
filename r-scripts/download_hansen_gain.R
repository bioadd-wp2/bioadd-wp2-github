library(tidyverse)
library(terra)
library(sf)
library(mapview)

# Set directories
raw_data = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/raw-data/hansen")

# set the download url 
download_url_gain_tile1 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_gain_00N_070W.tif"
download_url_gain_tile2 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_gain_00N_060W.tif"
download_url_gain_tile3 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_gain_10S_070W.tif"
download_url_gain_tile4 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_gain_10S_060W.tif"
download_url_gain_tile5 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_gain_20S_070W.tif"
download_url_gain_tile6 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_gain_20S_060W.tif"

# Set file name in Dropbox folder
gain_tile1 <- file.path(raw_data, "hansen_gain_tile1.tif")
gain_tile2 <- file.path(raw_data, "hansen_gain_tile2.tif")
gain_tile3 <- file.path(raw_data, "hansen_gain_tile3.tif")
gain_tile4 <- file.path(raw_data, "hansen_gain_tile4.tif")
gain_tile5 <- file.path(raw_data, "hansen_gain_tile5.tif")
gain_tile6 <- file.path(raw_data, "hansen_gain_tile6.tif")


# download the file
download.file(download_url_gain_tile1, gain_tile1)
download.file(download_url_gain_tile2, gain_tile2)
download.file(download_url_gain_tile3, gain_tile3)
download.file(download_url_gain_tile4, gain_tile4)
download.file(download_url_gain_tile5, gain_tile5)
download.file(download_url_gain_tile6, gain_tile6)





