

wrapPredictionMap <- function(type, results_list, base_folder, out_folder_gif, features_within = NULL, gif_only = FALSE, change_data = FALSE) {

	### Folders

		if (!dir.exists(base_folder)) stop("Base folder does not exist")
		base_folder <- paste0(base_folder, "/", type, "/")
		
		folders_list <- list()

		folders_list$base <- base_folder
		folders_list$pred <- paste0(folders_list$base, "/prediction/")
		folders_list$processed <- paste0(folders_list$base, "/processed/")
		folders_list$png <- paste0(folders_list$base, "/png/")
		folders_list$gif <- out_folder_gif

		lapply(folders_list, function(x) if (!dir.exists(x)) dir.create(x, recursive = TRUE))
		
	
	if (gif_only == FALSE) {
	### Produce predictions to new data
	# Parallelization within ranger::predict, hence not parallelizing the wrapper.
	# n_threads is passed to ranger::predict

		cat("Preparing data\n")

		vars <- c("cell", "year", names(results_list[[type]]$fit$variable.importance))
		dt_new <- fread(filenames$ml_demo$master_dt_edited)
		dt_new <- copy(dt_new[complete.cases(dt_new[, mget(vars)])])

		# Within transformation if applicable

		if (!is.null(features_within)) {

			cat("- within transformation\n")

            for (var in features_within) {

                dt_new[, tempvar := get(var)]
                dt_new[, (var) := NULL]
                dt_new[, (var) := tempvar - mean(tempvar, na.rm = TRUE), cell]
                dt_new[, tempvar := NULL]

            }

        }


        if (change_data == TRUE) {

			change_vars <- sort(results_list[[type]]$importance$var)
			keep_vars <- c("dist_inra", "density_forest")

			for (var in change_vars) {

				cat(paste0(var))
				if (!(var %in% keep_vars)) {
					cat(" editing")
					dt_new[, tempvar := get(var)]
					dt_new[!is.na(tempvar), obsid := .I]
					dt_new[!is.na(tempvar), (var) := tempvar[obsid == 1]]
					dt_new[, tempvar := NULL]
					dt_new[, obsid := NULL]
				}
				cat("\n")
			}

        }

		cat("Calculating predictions\n")

		for (i in 2001:2020) predictRanger(y = i, fit = results_list[[type]]$fit, newdata = dt_new[year == i, mget(vars)], out_folder = folders_list$pred, n_threads = 6)

		rm(dt_new)
		gc()
	

	### Map the predictions (csv to tif by pixel coordinates)
	# Get a template raster and replace prediction in it
	# Pay attention to the aggregation factor: affects speed

		cat("Mapping\n")

		pred_template_path <- paste0(base_folder, "pred_template.tif")

		r_s <- rast(filenames$ml_demo$sampling_raster)
		r_s_agg <- aggregate(r_s, 100, fun = max, na.rm = TRUE)
		values(r_s_agg) <- as.numeric(NA)
		r_s_agg |> writeRaster(pred_template_path, overwrite = TRUE)

		for (i in 2001:2020) mapPrediction(y = i, in_folder = folders_list$pred, r_path = pred_template_path, pred_t = length(results_list[[type]]$fit$unique.death.times), crop_raster = TRUE, out_folder = folders_list$processed, overlay_forest = TRUE)

	} # gif_only end bracket
	### Collect the prediction to a gif

		cat("Collecting to gif\n")

		# Tif to png
		tifToPng(in_folder = folders_list$processed, out_folder = folders_list$png) 
		tifToPng2(in_folder = folders_list$processed, out_folder = folders_list$png) 
		#tifToPng3(in_folder = folders_list$processed, out_folder = folders_list$png) 
		tifToPng4(in_folder = folders_list$processed, out_folder = folders_list$png) 

		# Collect pngs to a gif animation
		pngToGif(in_folder = folders_list$png, out_folder = folders_list$gif, name = paste0("prediction-animation-", type))

	return(0)

}

