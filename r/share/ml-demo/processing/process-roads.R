

# Rasterize roads data

# Read data

roads <- vect("C:/Users/localadmin/Dropbox/NERC BIG BOI/Work Packages/WP2/data/Caminos/Caminos.shp")
r_s <- rast(filenames$ml_demo$sampling_raster)

