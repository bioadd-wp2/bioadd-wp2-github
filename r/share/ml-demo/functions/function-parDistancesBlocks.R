
plot(rast(paste0(project_path, "data/constructed/raster/misc/ml-demo/distances/roads_2001_dist_3.tif")))

plot(rast(paste0(project_path, "data/constructed/raster/misc/ml-demo/distances/roads_2001_dist_1.tif")))


# Try a creative approach of batching to smaller chunks to enforce a threshold

# There might be a further optimization to this... not sure if d/2 is the optimal value


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

#plot(r_crop_list[[1]])
#plot(r_crop_list[[2]])
#plot(r_crop_list[[3]])
#plot(r_crop_list[[4]])

for (k in 1:length(r_crop_list)) {

    print(paste0(Sys.time(), " | k : ", k))

    r_collect_list[[k]] <- r
    r_collect_list[[k]][] <- Inf # Placeholder value to distinguish NAs (for some reason NAs are lost here: r_collect_list[[k]][r_crop == i] <- r_dist)

    r_crop <- r_crop_list[[k]]

    for (i in minmax(r_crop)["min",]:minmax(r_crop)["max",]) {
    #for (i in 23:24) {

        print(paste0(Sys.time(), " | i : ", i))

        r_temp <- rast(paste0(project_path, "data/constructed/raster/misc/ml-demo/roads_2001_agg_1.tif"))
        r_temp[r_crop != i] <- 0

        if (minmax(r_temp)["max",] > 0){
            r_dist <- terra::distance(r_temp, exclude = 0)
            r_collect_list[[k]][r_crop == i] <- r_dist
        }

        rm(r_temp)
        gc()

    }

    rm(r_crop)
    gc()

}


r_collected_merged <- lapp(do.call(c, r_collect_list), pmin)

