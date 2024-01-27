
# Read data

r_s <- rast(filenames$ml_demo$sampling_raster)

# Sampling

n <- 10^6
set.seed(1000)
s <- data.table(spatSample(x = r_s, size = n, method = "regular", xy = TRUE, cells = TRUE, as.df = TRUE))

value_col <- names(s)[!(names(s) %in% c("cell", "x", "y"))]
setnames(s, value_col, "ever_ref")

# Balance the sample
# NA is outside the area of interest
# 0 and 1 are inside the aoi

s <- copy(s[!is.na(ever_ref)])
tab <- s[, .N, by = .(ever_ref)]
min_n <- min(tab$N)

set.seed(2000)
cell_idx <- sample(s[ever_ref == 0]$cell, min_n, replace = FALSE)

s_balanced <- s[ever_ref == 1 | cell %in% cell_idx]

# Save to disk

s_balanced |> fwrite(filenames$ml_demo$sample)

