


r_s <- rast(paste0(project_path, "/data/constructed/raster/misc/ml-demo/ml_demo_sample_mask.tif"))

r_agg <- aggregate(r_s, 5000, fun = sum, na.rm = TRUE)

v_grid <- as.polygons(r_agg)




rasterToGrid <- function(d_px, r) {

s <- 100 # This is the size of one block to be calculated. 200 seems to be working well
d <- s/2 # This is the effective distance threshold, or the lowest maximum among possible values for all pixels

r <- rast(paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001_agg_1.tif"))
  # Mask pixels outside of Bolivia. Easiest to set to 0 since distances are calculated for NA values
  v <- vect(filenames$vector$gadm, layer = "ADM_ADM_0")
  r_mask <- rasterize(v, r, touches = TRUE)
  r[is.na(r_mask)] <- 0


# get numbers of iterations


r_dims <- dim(r)[1:2]


# Define four rasters that will select blocks

r_crop_list <- list()

for (k in 1:4) {

    offset_r <- d*(as.numeric(k %in% c(2,4)))
    offset_c <- d*(as.numeric(k %in% c(3,4)))

    iters <- ceiling(( r_dims - c( d*(as.numeric(k %in% c(2,4))) , d*(as.numeric(k %in% c(3,4))))) / s)

    r_crop_list[[k]] <- r
    r_crop_list[[k]][] <- 0

    iter <- 0
    for (i in 1:iters[1]) {

        row_start <- s*(i-1) + 1 + offset_r
        row_end   <- min(row_start + s + offset_r, r_dims[1])

        for (j in 1:iters[2]) {

            iter <- iter + 1

            col_start <- s*(j-1) + 1 + offset_c
            col_end   <- min(col_start + s + offset_c, r_dims[2])

            r_crop_list[[k]][row_start:row_end, col_start:col_end] <- iter

        }

    }

}


}


