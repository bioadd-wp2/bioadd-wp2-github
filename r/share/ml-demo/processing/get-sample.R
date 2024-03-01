
# Read data

r_s <- rast(filenames$ml_demo$sampling_raster)

# Sampling

n <- 2*10^6
set.seed(1000)
s <- data.table(spatSample(x = r_s, size = n, method = "regular", xy = TRUE, cells = TRUE, as.df = TRUE))

value_col <- names(s)[!(names(s) %in% c("cell", "x", "y"))]
setnames(s, value_col, "ever_ref")

# This gives the lateral distance between two sampled points
cat(paste0("Lateral distance between sampled points: ", round(terra::distance(vect(s[1:2], geom=c("x", "y"), crs="+proj=longlat")), 2), " meters\n"))

s <- copy(s[!is.na(ever_ref)])

# This gives the lateral distance between two sampled points
cat(paste0("Sampled pixels: ", nrow(s), "\n"))

# Balance the sample
# NA is outside the area of interest
# 0 and 1 are inside the aoi
# Disabled for now; this is anything but random wrt several treatment variables we have in place
# So we are going brute force

if (FALSE){

	s <- copy(s[!is.na(ever_ref)])
	tab <- s[, .N, by = .(ever_ref)]
	min_n <- min(tab$N)

	set.seed(2000)
	cell_idx <- sample(s[ever_ref == 0]$cell, min_n, replace = FALSE)

	s_balanced <- s[ever_ref == 1 | cell %in% cell_idx]

}

# Save to disk

s |> fwrite(filenames$ml_demo$sample)

