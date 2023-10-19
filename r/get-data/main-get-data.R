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

# Mapbiomas Bolivia transitions
source(paste0(project_path, "r/get-data/download-mapbiomas-transitions.R"))

# Hansen
source(paste0(project_path, "r/get-data/download-hansen.R"))

# Night lights

# Harmonized night lights
source(paste0(project_path, "r/get-data/download-nightlights-harmonized.R"))

# DMSP-OLS annual composites 1992-2013
# Total download size:  11.7 GB
# Total extracted size: 70.9 GB
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
# There are also some self-intersections in the geometries. These have been fixed with ArcGIS fix geometries
# These issues have been fixed in the following file in Dropbox, copied to project folder

file.copy(from = paste0(dropbox_path, "data/constructed-data/INRA_TITULADOS_resaved_fixed.gpkg"), to = filenames$vector$inra$fixed, overwrite = TRUE)


### Unzip shapefiles

shp_files <- list.files(paste0(project_path, "data/raw/shp/"), full.names = TRUE)
extracted_folders <- gsub(".zip", "/", shp_files)
for (i in 1:length(shp_files)) unzip(zipfile = shp_files[i], exdir = extracted_folders[i])


