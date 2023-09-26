#
# 2023/09/25
# Ville Inkinen
#
# This script downloads data and documents the data acquisition when a direct download is not available


#######################################################################
### Downloads

# The download of a single file must finish within the timeout value (seconds). You can increase this value if you get timeout errors.
options(timeout = 6000) 

# Mapbiomas Bolivia
source(paste0(project_path, "r/get-data/download-mapbiomas.R"))

# Hansen
source(paste0(project_path, "r/get-data/download-hansen.R"))

# Night lights

# DMSP-OLS annual composites 1992-2013
# Total download size:  11.7 GB
# Total extracted size: 70.9 GB
# Will explore the possibility to download smaller files from Google Earth Engine using the rgee package (see VIIRS download)
source(paste0(project_path, "r/get-data/download-dmsp-ols.R"))

# VIIRS annual composites available in Google Earth Engine Data Catalog: https://developers.google.com/earth-engine/datasets/catalog/NOAA_VIIRS_DNB_ANNUAL_V21




#######################################################################
### Other data sources

# Currently only copying files from Dropbox

