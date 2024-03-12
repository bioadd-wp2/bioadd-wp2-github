

# Define features. Where indicated below, specific list elements handled inside the wrapper function

f_list <- list()

f_list$mb_density     <- c("density_forest", "density_natural_nonforest", "density_water",  "density_ag", "density_urban")
f_list$mb_density_200 <- c("density_200_forest", "density_200_natural_nonforest", "density_200_water", "density_200_ag", "density_200_urban")
f_list$inra           <- c("dist_inra")
f_list$pa             <- c("pa_post")
f_list$burned_area    <- c("modis_ba_post")
f_list$worldpop       <- c("worldpop")
f_list$nl             <- c("nl")
f_list$mb_dist        <- c("dist_natural_nonforest", "dist_ag", "dist_water")
f_list$forest_lags    <- c(paste0("density_forest_lag_", 1:15), paste0("density_200_forest_lag_", 1:15))

f_list$time_invariant <- c("gmted_mean", "gmted_sd", "inra_clasificac_en", "inra_modalidad_en", "pa_source", "modis_ba_ever", "density_road_pri", "density_road_sec", "density_road_ter", "dist_road_pri", "dist_road_sec", "dist_road_ter")

# Variables specific to estimation type (ref or def). Only one or the other will be included. These should be only spatial or temporal distances
# These are handled inside the wrapper function.
f_list$ref            <- c("dist_forest") #, "mb_years_since_forest")
f_list$def            <- c("dist_nonforest") #, "mb_years_since_nonforest")

# All variables intended to only have one time-invariant value measured at the first observed year of the ref or def sequence
# These are handled inside the wrapper function.
f_list$baseline       <- c(paste0("mb_lag_", 1:15)) #"mb_sum15_forest", "mb_sum15_nonforest",

# The outcome variable will be based on this variable
# Handled inside the wrapper function.
f_list$outcome        <- c("mb_forest")


within_elements <- names(f_list)[!(names(f_list) %in% c("time_invariant", "ref", "def", "baseline", "outcome"))]

n_sample <- 1000


results_list <- list()

results_list$ref <- wrapRanger(dt_path = filenames$ml_demo$master_dt_edited, esample_path = filenames$ml_demo$esample_ranger_prepared, type = "ref", min_slen = 1, n_sample = n_sample, features_list = f_list, within_elements = NULL)
results_list$def <- wrapRanger(dt_path = filenames$ml_demo$master_dt_edited, esample_path = filenames$ml_demo$esample_ranger_prepared, type = "def", min_slen = 1, n_sample = n_sample, features_list = f_list, within_elements = NULL)

results_list$ref_min3 <- wrapRanger(dt_path = filenames$ml_demo$master_dt_edited, esample_path = filenames$ml_demo$esample_ranger_prepared, type = "ref", min_slen = 3, n_sample = n_sample, features_list = f_list, within_elements = NULL)
results_list$def_min3 <- wrapRanger(dt_path = filenames$ml_demo$master_dt_edited, esample_path = filenames$ml_demo$esample_ranger_prepared, type = "def", min_slen = 3, n_sample = n_sample, features_list = f_list, within_elements = NULL)

results_list$ref_within <- wrapRanger(dt_path = filenames$ml_demo$master_dt_edited, esample_path = filenames$ml_demo$esample_ranger_prepared, type = "ref", min_slen = 1, n_sample = n_sample, features_list = f_list, within_elements = within_elements)
results_list$def_within <- wrapRanger(dt_path = filenames$ml_demo$master_dt_edited, esample_path = filenames$ml_demo$esample_ranger_prepared, type = "def", min_slen = 1, n_sample = n_sample, features_list = f_list, within_elements = within_elements)


# Save estimation results in RData format
# (Need to preserve the format for prediction with ranger)

out_path <- paste0(project_path, "data/constructed/rdata/ranger_results.RData")
save(results_list, file = out_path)

cat("Estimation results in results_list\n")
cat("Estimation results saved to ", out_path, "\n")
