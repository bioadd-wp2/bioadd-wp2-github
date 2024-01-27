
# Rasterize INRA property boundary data

# Read data

inra <- vect(filenames$vector$inra$simplified)
r_s <- rast(filenames$ml_demo$sampling_raster)

# Edits

inra$cohort <- as.numeric(substr(inra$FechaResol, 7,10 ))
inra[!is.na(inra$cohort) & inra$cohort == 5,]$cohort <- 2005

inra_reproj <- project(inra, r_s)

# Rasterize and save to disk

r_inra <- terra::rasterize(inra_reproj, r_s, field = "OBJECTID_12", touches = TRUE)
r_inra |> writeRaster(filenames$ml_demo$inra_rasterized, overwrite = TRUE)

r_inra_cohort <- terra::rasterize(inra_reproj, r_s, field = "cohort", touches = TRUE)
r_inra_cohort |> writeRaster(filenames$ml_demo$inra_rasterized_cohort, overwrite = TRUE)
