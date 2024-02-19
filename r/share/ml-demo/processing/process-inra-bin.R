
# Rasterize INRA property boundary data

# Read data

inra <- vect(filenames$vector$inra$simplified)
r_s <- rast(filenames$ml_demo$sampling_raster)
