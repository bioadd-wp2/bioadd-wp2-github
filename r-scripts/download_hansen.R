library(tidyverse)
library(terra)
library(sf)
library(mapview)

# Set directories
raw_data = file.path("~/Dropbox/BIOADD/Work_Packages/WP2/data/raw-data/hansen")

# set the download url 
download_url_treecover_tile1 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_treecover2000_00N_070W.tif"
download_url_treecover_tile2 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_treecover2000_00N_060W.tif"
download_url_treecover_tile3 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_treecover2000_10S_070W.tif"
download_url_treecover_tile4 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_treecover2000_10S_060W.tif"
download_url_treecover_tile5 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_treecover2000_20S_070W.tif"
download_url_treecover_tile6 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_treecover2000_20S_060W.tif"

download_url_lossyear_tile1 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_lossyear_00N_070W.tif"
download_url_lossyear_tile2 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_lossyear_00N_060W.tif"
download_url_lossyear_tile3 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_lossyear_10S_070W.tif"
download_url_lossyear_tile4 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_lossyear_10S_060W.tif"
download_url_lossyear_tile5 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_lossyear_20S_070W.tif"
download_url_lossyear_tile6 <- "https://storage.googleapis.com/earthenginepartners-hansen/GFC-2019-v1.7/Hansen_GFC-2019-v1.7_lossyear_20S_060W.tif"

download_url_lossyear_fire <- "https://glad.umd.edu/users/Alexandra/Fire_GFL_data/2001-22/LAM_fire_forest_loss_2001-22_annual.tif"

# Set file name in Dropbox folder
treecover_tile1 <- file.path(raw_data, "hansen_treecover_tile1.tif")
treecover_tile2 <- file.path(raw_data, "hansen_treecover_tile2.tif")
treecover_tile3 <- file.path(raw_data, "hansen_treecover_tile3.tif")
treecover_tile4 <- file.path(raw_data, "hansen_treecover_tile4.tif")
treecover_tile5 <- file.path(raw_data, "hansen_treecover_tile5.tif")
treecover_tile6 <- file.path(raw_data, "hansen_treecover_tile6.tif")
lossyear_tile1 <- file.path(raw_data, "hansen_lossyear_tile1.tif")
lossyear_tile2 <- file.path(raw_data, "hansen_lossyear_tile2.tif")
lossyear_tile3 <- file.path(raw_data, "hansen_lossyear_tile3.tif")
lossyear_tile4 <- file.path(raw_data, "hansen_lossyear_tile4.tif")
lossyear_tile5 <- file.path(raw_data, "hansen_lossyear_tile5.tif")
lossyear_tile6 <- file.path(raw_data, "hansen_lossyear_tile6.tif")

# download the file
download.file(download_url_treecover_tile1, treecover_tile1)
download.file(download_url_treecover_tile2, treecover_tile2)
download.file(download_url_treecover_tile3, treecover_tile3)
download.file(download_url_treecover_tile4, treecover_tile4)
download.file(download_url_treecover_tile5, treecover_tile5)
download.file(download_url_treecover_tile6, treecover_tile6)
download.file(download_url_lossyear_tile1 , lossyear_tile1 )
download.file(download_url_lossyear_tile2 , lossyear_tile2 )
download.file(download_url_lossyear_tile3 , lossyear_tile3 )
download.file(download_url_lossyear_tile4 , lossyear_tile4 )
download.file(download_url_lossyear_tile5 , lossyear_tile5 )
download.file(download_url_lossyear_tile6 , lossyear_tile6 )




