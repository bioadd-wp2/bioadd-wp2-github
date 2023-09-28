#
# 2023/09/25
# Ville Inkinen
#
# This script downloads data and documents the data acquisition when a direct download is not available

#######################################################################
### Downloads

# The download of a single file must finish within the timeout value (seconds). You can increase this value if you get timeout errors.
options(timeout = 60000) 

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

# VIIRS annual composites 2012-2021
# Total download size:    2.7 GB
# Total extracted size: 108.2 GB
source(paste0(project_path, "r/get-data/download-viirs.R"))

# Miscellaneous downloads
source(paste0(project_path, "r/get-data/download-misc.R"))



#######################################################################
### Other data sources

# INRA property boundaries
# The original shapefile in Dropbox is corrupted but can be recovered:
# - Open in ArcGIS and export as .gpkg
# - Check that the variables have consistent entries. If anything looks suspicious, the file is still corrupted (e.g. several entries in character columns that are systematically wrong or clearly belong to a different column).
# There are also some self-intersections in the geometries
# These issues have been fixed in the following file in Dropbox, copied to project folder

file.copy(from = paste0(dropbox_path, "data/constructed-data/INRA_TITULADOS_resaved_fixed.gpkg"), to = filenames$vector$inra_titulados, overwrite = TRUE)






