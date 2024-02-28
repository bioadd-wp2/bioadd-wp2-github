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
source(paste0(project_path, "r/get-data/download-mapbiomas.R"), local = new.env())

# Mapbiomas Bolivia transitions
source(paste0(project_path, "r/get-data/download-mapbiomas-transitions.R"), local = new.env())

# Hansen
source(paste0(project_path, "r/get-data/download-hansen.R"), local = new.env())

# Harmonized night lights
source(paste0(project_path, "r/get-data/download-nightlights-harmonized.R"), local = new.env())

# DMSP-OLS annual composites 1992-2013
# Total download size:  11.7 GB
# Total extracted size: 70.9 GB
# source(paste0(project_path, "r/get-data/download-dmsp-ols.R"))

# VIIRS annual composites 2012-2021
# Total download size:    2.7 GB
# Total extracted size: 108.2 GB
# source(paste0(project_path, "r/get-data/download-viirs.R"))


# FIRMS fires data for Bolivia
source(paste0(project_path, "r/get-data/download-firms.R"), local = new.env())


# MODIS Burned Area from Google Earth Engine
source(paste0(project_path, "r/get-data/get-polygonised-modis-ba.R"), local = new.env())


# Migration data from Niva et al. 2023, https://doi.org/10.5281/zenodo.7997134
source(paste0(project_path, "r/get-data/get-polygonised-modis-ba.R"), local = new.env())

# GMTED2010 elevation data 7.5 arc seconds
source(paste0(project_path, "r/get-data/download-gmted2010.R"), local = new.env())

# Protected areas
source(paste0(project_path, "r/get-data/download-pa.R"), local = new.env())


# Miscellaneous downloads
source(paste0(project_path, "r/get-data/download-misc.R"), local = new.env())


#######################################################################
### Other data sources

### INRA property boundaries
# The original shapefile in Dropbox is corrupted but can be recovered:
# - Open in ArcGIS and export as .gpkg
# - Check that the variables have consistent entries. If anything looks suspicious, the file is still corrupted (e.g. several entries in character columns that are systematically wrong or clearly belong to a different column).
# There are also some self-intersections in the geometries. These have been fixed with ArcGIS fix geometries
# These issues have been fixed in the following file in Dropbox, copied to the project folder:

file.copy(from = paste0(dropbox_path, "data/constructed-data/INRA_TITULADOS_resaved_fixed.gpkg"), to = filenames$vector$inra$fixed, overwrite = TRUE)


### Electricity utilities data

file.copy(from = paste0(dropbox_path, "data/raw-data/bolivia-electricity-utilities/"), to = paste0(project_path, "data/raw/csv/"), overwrite = TRUE, recursive = TRUE)


#######################################################################
### Unzip shapefiles

zip_files <- list.files(paste0(project_path, "data/raw/shp/"), full.names = TRUE)
zip_files <- zip_files[grepl(".zip", zip_files)]
extracted_folders <- gsub(".zip", "/", zip_files)
for (i in 1:length(zip_files)) unzip(zipfile = zip_files[i], exdir = extracted_folders[i])

### Mapbiomas color codes
source(paste0(project_path, "r/get-data/get-mapbiomas-colors.R"), local = new.env())
