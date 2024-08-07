#
# 30/01/2024
# Ville Inkinen
#
# BIOADD WP2 - Machine learning demonstration
#

### Setup

source(paste0(project_path, "r/share/ml-demo/setup.R"))


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
# Focal values: Could be produced in QGIS or ArcGIS; for now densities are on a fixed 40px and 200px grid
# Both of these require considerable disk space; investment


# Sample pixels

source(paste0(ml_demo_path, "processing/get-sample.R"), local = new.env())

# Extract variables

# extractRaster() retrieves cell values from a raster using the cell index or by point coordinates
# Extracting by cell index can be considerably faster with a large number of sampled points. Do not to use it if the raster is not in the same resolution as the sampling raster. The function also checks for this
# Must be careful with years matching the rasters (raster paths). The ith elements must match. The function does not check this!
# The function parallelizes over layers but this may be unnecessary; extracting is very fast

# Memory requirement depends heavily on sample size

# Extracting from data stored on SSD is quite fast. Extracting from a HDD is slower, but increasing n_threads helps considerably (default is 4)

t0 <- Sys.time()
extractRaster(r_paths = filenames$raster$mapbiomas, years = 1985:2021, varname = "mb", by_cell_idx = TRUE)

extractRaster(r_paths = filenames$ml_demo$inra_rasterized_cohort, years = 1985, varname = "inra_cohort", by_cell_idx = TRUE)
extractRaster(r_paths = filenames$ml_demo$inra_rasterized, years = 1985, varname = "inra_objectid", by_cell_idx = TRUE)

extractRaster(r_paths = paste0(project_path, "data/raw/raster/migration/raster_netMgr_2000_2019_3yrSum.tif"), years = 1985, varname = "migr", by_cell_idx = FALSE)
extractRaster(r_paths = paste0(project_path, "data/raw/raster/migration/raster_netMgr_2000_2019_20yrSum.tif"), years = 1985, varname = "migr_2000_2019", by_cell_idx = FALSE)

extractRaster(r_paths = list.files(paste0(project_path, "data/raw/raster/worldpop/"), full.names = TRUE, pattern = "*.tif"), years = 2000:2020, varname = "worldpop", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/raw/raster/nightlights/harmonized/"), full.names = TRUE, pattern = "*.tif")[-c(1,2)], years = 1992:2021, varname = "nl", by_cell_idx = FALSE)

extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-gain/"), full.names = TRUE, pattern = "*.tif"), years = 1986:2021, varname = "mb_ref", by_cell_idx = TRUE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-loss/"), full.names = TRUE, pattern = "*.tif"), years = 1986:2021, varname = "mb_def", by_cell_idx = TRUE)

extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-gain-transitions/"), full.names = TRUE, pattern = "*.tif"), years = 1986:2021, varname = "mbtr_ref", by_cell_idx = TRUE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-loss-transitions/"), full.names = TRUE, pattern = "*.tif"), years = 1986:2021, varname = "mbtr_def", by_cell_idx = TRUE)

extractRaster(r_paths = paste0(project_path, "data/constructed/raster/protected-areas/national.tif"), years = 1985, varname = "pa_national_id", by_cell_idx = TRUE)
extractRaster(r_paths = paste0(project_path, "data/constructed/raster/protected-areas/state.tif"), years = 1985, varname = "pa_state_id", by_cell_idx = TRUE)
extractRaster(r_paths = paste0(project_path, "data/constructed/raster/protected-areas/municipal.tif"), years = 1985, varname = "pa_municipal_id", by_cell_idx = TRUE)

# Densities

extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/forest/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "density_forest", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/nonforest/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "density_nonforest", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/natural-nonforest/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "density_natural_nonforest", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/nonnatural/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "density_nonnatural", by_cell_idx = FALSE)

extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/farming/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "density_ag", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/water/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "density_water", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/24/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "density_urban", by_cell_idx = FALSE)

extractRaster(r_paths = paste0(project_path, "data/constructed/raster/misc/ml-demo/road_density/road_density_1.tif"), years = 2001, varname = "density_road_pri", by_cell_idx = FALSE)
extractRaster(r_paths = paste0(project_path, "data/constructed/raster/misc/ml-demo/road_density/road_density_2.tif"), years = 2001, varname = "density_road_sec", by_cell_idx = FALSE)
extractRaster(r_paths = paste0(project_path, "data/constructed/raster/misc/ml-demo/road_density/road_density_3.tif"), years = 2001, varname = "density_road_ter", by_cell_idx = FALSE)

# Densities within 200 pixel grid cell

extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/forest-200/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "density_200_forest", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/nonforest-200/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "density_200_nonforest", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/natural-nonforest-200/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "density_200_natural_nonforest", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/nonnatural-200/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "density_200_nonnatural", by_cell_idx = FALSE)

extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/farming-200/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "density_200_ag", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/water-200/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "density_200_water", by_cell_idx = FALSE)
extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/mapbiomas-aggregated/urban-200/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "density_200_urban", by_cell_idx = FALSE)

extractRaster(r_paths = paste0(project_path, "data/constructed/raster/misc/ml-demo/road_density_200/road_density_1.tif"), years = 2001, varname = "density_200_road_pri", by_cell_idx = FALSE)
extractRaster(r_paths = paste0(project_path, "data/constructed/raster/misc/ml-demo/road_density_200/road_density_2.tif"), years = 2001, varname = "density_200_road_sec", by_cell_idx = FALSE)
extractRaster(r_paths = paste0(project_path, "data/constructed/raster/misc/ml-demo/road_density_200/road_density_3.tif"), years = 2001, varname = "density_200_road_ter", by_cell_idx = FALSE)

# Distances

extractRaster(r_paths = list.files(paste0(data_path, "data/constructed/raster/distances/forest/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "dist_forest", by_cell_idx = FALSE, n_threads = 12)
extractRaster(r_paths = list.files(paste0(data_path, "data/constructed/raster/distances/nonforest/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "dist_nonforest", by_cell_idx = FALSE, n_threads = 12)
extractRaster(r_paths = list.files(paste0(data_path, "data/constructed/raster/distances/natural-nonforest/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "dist_natural_nonforest", by_cell_idx = FALSE, n_threads = 12)
extractRaster(r_paths = list.files(paste0(data_path, "data/constructed/raster/distances/nonnatural/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "dist_nonnatural", by_cell_idx = FALSE, n_threads = 12)

extractRaster(r_paths = list.files(paste0(data_path, "data/constructed/raster/distances/water/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "dist_water", by_cell_idx = FALSE, n_threads = 12)
extractRaster(r_paths = list.files(paste0(data_path, "data/constructed/raster/distances/ag/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "dist_ag", by_cell_idx = FALSE, n_threads = 12)
extractRaster(r_paths = list.files(paste0(data_path, "data/constructed/raster/distances/urban/"), full.names = TRUE, pattern = "*.tif"), years = 1985:2021, varname = "dist_urban", by_cell_idx = FALSE, n_threads = 12)

# Important: The following are the distance to the cohort, not the distance to any property in a given year. Must calculate the "running" distance further down the line
extractRaster(r_paths = list.files(paste0(data_path, "data/constructed/raster/distances/inra/"), full.names = TRUE, pattern = "*.tif")[-1], years = c(1997:2015), varname = "dist_inra", by_cell_idx = FALSE, n_threads = 12)

# Same for these distances; distance to cohort, calculate running distance later in the code
# For always treated, must create separate variables, done below

pa_cohort_list_all <- list(
    municipal = list.files(paste0(data_path, "data/constructed/raster/distances/protected-area-cohort/municipal/"), full.names = TRUE, pattern = "*.tif"),
    state = list.files(paste0(data_path, "data/constructed/raster/distances/protected-area-cohort/state/"), full.names = TRUE, pattern = "*.tif"),
    national = list.files(paste0(data_path, "data/constructed/raster/distances/protected-area-cohort/national/"), full.names = TRUE, pattern = "*.tif")
    )

years_list <- lapply(pa_cohort_list_all, function(x) as.numeric(gsub(".tif", "", gsub("pa_dist_", "", basename(x)))))
idx_list_treated <- lapply(years_list, function(x) x > 1985)
idx_list_always <- lapply(years_list, function(x) x <= 1985)

pa_cohort_list_treated <- base::Map(`[`, pa_cohort_list_all, idx_list_treated)
pa_cohort_list_always <- base::Map(`[`, pa_cohort_list_all, idx_list_always)

# PAs treated during 1986:2021

for (i in 1:length(pa_cohort_list_treated)) extractRaster(r_paths = pa_cohort_list_treated[[i]], years = as.numeric(substr(pa_cohort_list_treated[[i]], nchar(pa_cohort_list_treated[[i]])-7, nchar(pa_cohort_list_treated[[i]])-4)), varname = paste0("dist_pa_", names(pa_cohort_list_treated)[i], "_cohort"), by_cell_idx = FALSE, n_threads = 12)

# Always treated PAs
# This is a total hack and must be careful not to make a mistake in the editing phase
# Note that the indices should be the complement of the indices above

for (i in 1:length(pa_cohort_list_always)) extractRaster(r_paths = pa_cohort_list_always[[i]], years = (1:length(pa_cohort_list_always[[i]]) + 1984), varname = paste0("dist_pa_", names(pa_cohort_list_always)[i], "_cohort_always"), by_cell_idx = FALSE, n_threads = 12)



# Distance to road
extractRaster(r_paths = paste0(data_path, "data/constructed/raster/distances/roads/roads_2001_1.tif"), years = 2001, varname = "dist_road_pri", by_cell_idx = FALSE)
extractRaster(r_paths = paste0(data_path, "data/constructed/raster/distances/roads/roads_2001_2.tif"), years = 2001, varname = "dist_road_sec", by_cell_idx = FALSE)
extractRaster(r_paths = paste0(data_path, "data/constructed/raster/distances/roads/roads_2001_3.tif"), years = 2001, varname = "dist_road_ter", by_cell_idx = FALSE)

# Elevation (GMTED2010)

extractRaster(r_paths = filenames$raster$gmted$mean, years = 2010, varname = "gmted_mean", by_cell_idx = FALSE)
extractRaster(r_paths = filenames$raster$gmted$sd, years = 2010, varname = "gmted_sd", by_cell_idx = FALSE)


# Modis burned area

extractRaster(r_paths = list.files(paste0(project_path, "data/constructed/raster/modis-burned-area/"), full.names = TRUE, pattern = "*.tif"), years = 2001:2021, varname = "modis_ba", by_cell_idx = FALSE)

t1 <- Sys.time()
t1-t0
# Last run was 33min


# Initialize master data.table and collect extracted

source(paste0(ml_demo_path, "processing/get-master.R"), local = new.env())
source(paste0(ml_demo_path, "processing/process-collect-extracted.R"), local = new.env())


# Edits to master

editMaster(in_file = filenames$ml_demo$master_dt_collected, out_file = filenames$ml_demo$master_dt_edited, debug = FALSE)


# REMINDER: water bodies not included in "natural", but are exluded form "non-natural". Natural non-forest = c(10,11,12,13), Nonnatural = c(15,18,21,24,25,30). In other words, they should be inlcuded as separate categories. Same for salt flat, glacier.
# Nonforest = c(11,12,13,15,18,21,24,25,30,33,34,61), or !(3,6)
# Natural non-forest = c(10,11,12,13)
# Nonnatural = c(15,18,21,24,25,30)