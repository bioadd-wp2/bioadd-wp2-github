


### Setup

# Code for the demo located in its own folder
# Constructed data stored in the project folder
ml_demo_path <- paste0(project_path, "r/share/ml-demo/")

source(paste0(ml_demo_path, "filenames.R"))
source(paste0(ml_demo_path, "functions/function-extractRaster.R"))


### Processing

# Process data

source(paste0(ml_demo_path, "processing/process-ever-gain.R"), local = new.env())
source(paste0(ml_demo_path, "processing/process-sampling-raster.R"), local = new.env())
source(paste0(ml_demo_path, "processing/process-inra.R"), local = new.env())

# Sample pixels and initialize a master data.table

source(paste0(ml_demo_path, "processing/get-sample.R"), local = new.env())
source(paste0(ml_demo_path, "processing/get-master.R"), local = new.env())


# Extract variables
# Parallelizations may be unnecessary; extracting by index is very fast
# Must be careful with years matching the rasters. The ith elements must match. The function does not check this.

extractRaster(r_paths = filenames$raster$mapbiomas, years = 1985:2021, varname = "mb")
extractRaster(r_paths = filenames$ml_demo$inra_rasterized_cohort, years = 1985, varname = "inra_cohort")


# Collect extracted to master










# Edits to master

source(paste0(project_path, "r/local/ml-demo/edit-master.R"))


# Any further pre-processing



# Run algorithm



