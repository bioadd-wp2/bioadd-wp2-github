#
# 30/01/2024
# Ville Inkinen
#
# BIOADD WP2 - Machine learning demonstration
#

### Setup


# Code for the demo located in its own folder
ml_demo_path <- paste0(project_path, "r/share/ml-demo/")

# Constructed data stored in the project folder
# Refer to files using filenames$ml_demo$--- ; defined in this script:
source(paste0(ml_demo_path, "filenames.R"))

source(paste0(ml_demo_path, "functions/function-extractRaster.R"))


### Processing

# Ever gain raster and "sampling raster" required for sampling further down. 

source(paste0(ml_demo_path, "processing/process-ever-gain.R"), local = new.env())
source(paste0(ml_demo_path, "processing/process-sampling-raster.R"), local = new.env())


# Process data sources

source(paste0(ml_demo_path, "processing/process-inra.R"), local = new.env())


# Sample pixels

source(paste0(ml_demo_path, "processing/get-sample.R"), local = new.env())


# Extract variables

# extractRaster() retrieves cell values from a raster using the cell index
# The raster extent and dimension must exactly match Mapbiomas Bolivia rasters
# Must be careful with years matching the rasters (raster paths). The ith elements must match. The function does not check this!
# The function parallelizes over layers but this may be unnecessary; extracting by index is very fast


extractRaster(r_paths = filenames$raster$mapbiomas, years = 1985:2021, varname = "mb")
extractRaster(r_paths = filenames$ml_demo$inra_rasterized_cohort, years = 1985, varname = "inra_cohort")

extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-gain/"), full.names = TRUE), years = 1986:2021, varname = "mb_ref")
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-loss/"), full.names = TRUE), years = 1986:2021, varname = "mb_def")

extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-gain-transitions/"), full.names = TRUE), years = 1986:2021, varname = "mbtr_ref")
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-loss-transitions/"), full.names = TRUE), years = 1986:2021, varname = "mbtr_def")



# Initialize master data.table and collect extracted

source(paste0(ml_demo_path, "processing/get-master.R"), local = new.env())

source(paste0(ml_demo_path, "processing/process-collect-extracted.R"), local = new.env())



# Edits to master

source(paste0(ml_demo_path, "processing/edit-master.R"), local = new.env())


# Any further pre-processing





# Run algorithm





