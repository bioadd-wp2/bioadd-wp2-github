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

# Ever gain raster and "sampling raster" required for sampling.

source(paste0(ml_demo_path, "processing/process-bolivia-mask.R"), local = new.env())


source(paste0(ml_demo_path, "processing/process-ever-gain.R"), local = new.env())
source(paste0(ml_demo_path, "processing/process-sampling-raster.R"), local = new.env())


# Process data sources

source(paste0(ml_demo_path, "processing/process-bolivia-main.R"), local = new.env())
source(paste0(ml_demo_path, "processing/process-inra.R"), local = new.env())
source(paste0(ml_demo_path, "processing/process-burned-area.R"), local = new.env())

source(paste0(ml_demo_path, "processing/process-protected-areas.R"), local = new.env())



# Distance layers produced in QGIS; relatively fast; see process-distances-xxx.py
# Focal values: Could be produced in QGIS or ArcGIS
# Both of these require considerable disk space; need to invest


# Sample pixels

source(paste0(ml_demo_path, "processing/get-sample.R"), local = new.env())

# Extract variables

# extractRaster() retrieves cell values from a raster using the cell index or by point coordinates
# Retrieving by cell index seems to be faster by about 25%, but maybe does not justify the overhead from resampling to the same dimension.
# Must be careful with years matching the rasters (raster paths). The ith elements must match. The function does not check this!
# The function parallelizes over layers but this may be unnecessary; extracting is very fast

# Extracting from data stored on SSD is quite fast. Extracting from a HDD is slower, but increasing n_threads helps considerably (default is 4)

# Path for external data storage. Use as an alternative project_path, and organize data accordingly
data_path <- "D:/bioadd-wp2/"

extractRaster(r_paths = filenames$raster$mapbiomas, years = 1985:2021, varname = "mb", by_cell_idx = FALSE, n_threads = 4)

extractRaster(r_paths = filenames$ml_demo$inra_rasterized_cohort, years = 1985, varname = "inra_cohort", by_cell_idx = FALSE)
extractRaster(r_paths = filenames$ml_demo$inra_rasterized, years = 1985, varname = "inra_objectid", by_cell_idx = FALSE)

extractRaster(r_paths = paste0(project_path, "data/raw/raster/migration/raster_netMgr_2000_2019_3yrSum.tif"), years = 1985, varname = "migr", by_cell_idx = FALSE)
extractRaster(r_paths = paste0(project_path, "data/raw/raster/migration/raster_netMgr_2000_2019_20yrSum.tif"), years = 1985, varname = "migr_2000_2019", by_cell_idx = FALSE)

extractRaster(r_paths = list.files(paste0(project_path, "data/raw/raster/worldpop/"), full.names = TRUE), years = 2000:2020, varname = "worldpop", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/raw/raster/nightlights/harmonized/"), full.names = TRUE, pattern = "*.tif")[-c(1,2)], years = 1992:2021, varname = "nl", by_cell_idx = FALSE)

extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-gain/"), full.names = TRUE), years = 1986:2021, varname = "mb_ref", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-loss/"), full.names = TRUE), years = 1986:2021, varname = "mb_def", by_cell_idx = FALSE)

extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-gain-transitions/"), full.names = TRUE), years = 1986:2021, varname = "mbtr_ref", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-loss-transitions/"), full.names = TRUE), years = 1986:2021, varname = "mbtr_def", by_cell_idx = FALSE)

extractRaster(r_paths = filenames$vector$protected_areas$polygons$national, years = 1985, varname = "pa_national", by_cell_idx = FALSE)
extractRaster(r_paths = filenames$vector$protected_areas$polygons$state, years = 1985, varname = "pa_state", by_cell_idx = FALSE)
extractRaster(r_paths = filenames$vector$protected_areas$polygons$municipal, years = 1985, varname = "pa_municipal", by_cell_idx = FALSE)

# Densities

extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/forest/"), full.names = TRUE), years = 1985:2021, varname = "density_forest", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/farming/"), full.names = TRUE), years = 1985:2021, varname = "density_ag", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/water/"), full.names = TRUE), years = 1985:2021, varname = "density_water", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/24/"), full.names = TRUE), years = 1985:2021, varname = "density_urban", by_cell_idx = FALSE)

extractRaster(r_paths = paste0(project_path, "data/constructed/raster/misc/ml-demo/road_density/road_density_1.tif"), years = 2001, varname = "density_road_pri", by_cell_idx = FALSE)
extractRaster(r_paths = paste0(project_path, "data/constructed/raster/misc/ml-demo/road_density/road_density_2.tif"), years = 2001, varname = "density_road_sec", by_cell_idx = FALSE)
extractRaster(r_paths = paste0(project_path, "data/constructed/raster/misc/ml-demo/road_density/road_density_3.tif"), years = 2001, varname = "density_road_ter", by_cell_idx = FALSE)

# Densities within 200 pixel grid cell

extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/forest-200/"), full.names = TRUE), years = 1985:2021, varname = "density_200_forest", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/farming-200/"), full.names = TRUE), years = 1985:2021, varname = "density_200_ag", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/water-200/"), full.names = TRUE), years = 1985:2021, varname = "density_200_water", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/urban-200/"), full.names = TRUE), years = 1985:2021, varname = "density_200_urban", by_cell_idx = FALSE)

extractRaster(r_paths = paste0(project_path, "data/constructed/raster/misc/ml-demo/road_density_200/road_density_1.tif"), years = 2001, varname = "density_200_road_pri", by_cell_idx = FALSE)
extractRaster(r_paths = paste0(project_path, "data/constructed/raster/misc/ml-demo/road_density_200/road_density_2.tif"), years = 2001, varname = "density_200_road_sec", by_cell_idx = FALSE)
extractRaster(r_paths = paste0(project_path, "data/constructed/raster/misc/ml-demo/road_density_200/road_density_3.tif"), years = 2001, varname = "density_200_road_ter", by_cell_idx = FALSE)

# Distances

extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/distances/forest/"), full.names = TRUE), years = 1985:2021, varname = "dist_forest", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/distances/water/"), full.names = TRUE), years = 1985:2021, varname = "dist_water", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(data_path, "data/constructed/raster/distances/ag/"), full.names = TRUE), years = 1985:2021, varname = "dist_ag", by_cell_idx = FALSE, n_threads = 12)
extractRaster(r_paths = list.files(paste0(data_path, "data/constructed/raster/distances/urban/"), full.names = TRUE), years = 1985:2021, varname = "dist_urban", by_cell_idx = FALSE, n_threads = 12)

# Important: The following are the distance to the cohort, not the distance to any property in a given year. Must calculate the "running" distance independently from these
extractRaster(r_paths = list.files(paste0(data_path, "data/constructed/raster/distances/inra/"), full.names = TRUE)[-1], years = c(1997:2015), varname = "dist_inra", by_cell_idx = FALSE, n_threads = 12)

extractRaster(r_paths = paste0(project_path, "data/constructed/raster/distances/roads/roads_2001_1.tif"), years = 2001, varname = "dist_road_pri", by_cell_idx = FALSE)
extractRaster(r_paths = paste0(project_path, "data/constructed/raster/distances/roads/roads_2001_2.tif"), years = 2001, varname = "dist_road_sec", by_cell_idx = FALSE)
extractRaster(r_paths = paste0(project_path, "data/constructed/raster/distances/roads/roads_2001_3.tif"), years = 2001, varname = "dist_road_ter", by_cell_idx = FALSE)

# Elevation (GMTED2010)

extractRaster(r_paths = filenames$raster$gmted$mean, years = 2010, varname = "gmted_mean", by_cell_idx = FALSE)
extractRaster(r_paths = filenames$raster$gmted$sd, years = 2010, varname = "gmted_sd", by_cell_idx = FALSE)


# Initialize master data.table and collect extracted

source(paste0(ml_demo_path, "processing/get-master.R"), local = new.env())
source(paste0(ml_demo_path, "processing/process-collect-extracted.R"), local = new.env())


# Edits to master

source(paste0(ml_demo_path, "processing/edit-master.R"), local = new.env())


