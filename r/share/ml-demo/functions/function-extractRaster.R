

checkRasters <- function(r_s_path, r_paths) {

	r_list <- lapply(r_paths, rast)
	r_s <- rast(r_s_path)

	matches <- rep(as.numeric(NA), length(r_list))
	
	for (i in 1:length(r_list)) {

		extents_match <- as.numeric(ext(r_s) == ext(r_list[[i]]))
		dims_match <- as.numeric(sum(as.numeric(dim(r_s) == dim(r_list[[i]]))) == length(dim(r_s)))

		matches[i] <- extents_match * dims_match

	}

	if (sum(matches, na.rm = TRUE)  < length(matches)) return(1)
	if (sum(matches, na.rm = TRUE) == length(matches)) return(0)

}


parExtract <- function(i, s_path, r_paths, years, varname, out_folder, by_cell_idx) {

	s <- fread(s_path, colClasses = c(cell = "numeric"))
	r <- rast(r_paths[[i]])
	year_i <- years[i]

	if (by_cell_idx == TRUE)  dt <- data.table(r[s$cell])
	if (by_cell_idx == FALSE) dt <- data.table(terra::extract(r, vect(s, geom = c("x", "y"), crs = "epsg:4326")))[, ID := NULL]

	if (ncol(dt) == 1) data.table::setnames(dt, varname)
	if (ncol(dt) > 1)  data.table::setnames(dt, colnames(dt), paste0(varname, "_", colnames(dt)))

	dt[, cell := s$cell]
	dt[, year := ..year_i]

	data.table::setcolorder(dt, c("cell", "year"))
	data.table::setorder(dt, "cell", "year")

	dt |> fwrite(paste0(out_folder, "/", varname, "/", varname, "_", year_i, ".csv"))

	return(0)

}



extractRaster <- function(s_path = filenames$ml_demo$sample, r_s_path = filenames$ml_demo$sampling_raster, r_paths, by_cell_idx = FALSE, years, varname, out_folder = paste0(project_path, "data/constructed/csv/ml-demo-extracted/"), n_threads = 4){

	# Input checks

    if (by_cell_idx == TRUE & checkRasters(r_s_path = r_s_path, r_paths = r_paths) == 1) stop("Input raster dimensions or extents do not match with sampling raster.")
	if (length(years) != length(r_paths)) stop("Length of years does not match input rasters.")

	if (!dir.exists(paste0(out_folder, "/", varname, "/"))) dir.create(paste0(out_folder, "/", varname, "/"))

	# Set up parallelization over layers
 
	registerDoParallel(cores = n_threads)

    foreach(ii = 1:length(r_paths), .packages = c("terra", "data.table"), .export = c("parExtract")) %dopar% {

        parExtract(
        	i = ii, 
        	s_path = s_path, 
        	r_paths = r_paths, 
        	years = years, 
        	varname = varname, 
        	out_folder = out_folder,
        	by_cell_idx = by_cell_idx
        	)

    }

	stopImplicitCluster()

	print(paste0("Output saved to: ", out_folder))

	return(0)

}





