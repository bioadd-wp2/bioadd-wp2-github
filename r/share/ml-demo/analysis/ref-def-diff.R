
base_folder <- paste0("C:/temp/rf_predictions/")

out_folder <- paste0(base_folder, "diff/diff_raster/")
if (!file.exists(out_folder)) dir.create(out_folder, recursive = TRUE)

for (i in 2001:2020) {

	r_ref <- rast(paste0(base_folder, "/ref/processed/pred_", i, ".tif"))
	r_def <- rast(paste0(base_folder, "/def/processed/pred_", i, ".tif"))

	r_ref <- 1 - r_ref

	r_ref <- (r_ref - min(as.data.table(r_ref)[[1]], na.rm = TRUE)) / max(as.data.table(r_ref)[[1]], na.rm = TRUE)
    r_ref <- (r_ref) / max(as.data.table(r_ref)[[1]], na.rm = TRUE)

	r_def <- (r_def - min(as.data.table(r_def)[[1]], na.rm = TRUE)) / max(as.data.table(r_def)[[1]], na.rm = TRUE)
    r_def <- (r_def) / max(as.data.table(r_def)[[1]], na.rm = TRUE)

	
    r_diff <- r_ref - r_def
    #r_diff <- c(r_ref, r_def)
    #names(r_diff) <- c("ref", "def")

	#r_values <- as.data.table(r_diff)[[1]]
	#r_diff <- r_diff - mean(as.data.table(r_diff)[[1]], na.rm = TRUE) 
	#r_diff <- r_diff / max(abs(as.data.table(r_diff)[[1]]), na.rm = TRUE)


	r_diff |> writeRaster(paste0(out_folder, "diff_", i, ".tif"), overwrite = TRUE)

	rm(r_diff)

}


col_func <- function(x, y){

  x[x == 0] <- 0.000001
  y[y == 0] <- 0.000001
  x[x == 1] <- 0.999999
  y[y == 1] <- 0.999999

  # upper or lower triangle?
  u <- y > x

  # Change me for different hues.
  hue <- ifelse(u, 0.3, 0.8)


  # distace from (0,0) to (x,y)
  hyp <- sqrt(x^2 + y^2) 

  # Angle between x axis and line to our point
  theta <- asin(y / hyp)

  # Angle between 45 degree line and (x,y)
  phi <- ifelse(u, theta - pi/4, pi/4 - theta)
  phi <- ifelse(phi < 0, 0, phi)

  # Distance from 45 degree line and (x,y)
  s <- hyp * sin(phi) / sqrt(2)

  # Draw line from (x, y) to 45 degree line that is at right angles.
  # How far along 45 degree line, does that line join.
  v <- 1 - hyp * cos(phi) / sqrt(2)

  # Get hsv values.
  sapply(seq_along(x), function(i) hsv(hue[i], s[i], v[i]))

}


tifToPng <- function(in_folder, out_folder) {

    # To Png

    if (!require("scales", quietly = TRUE)) stop(paste0("Package 'scales' is required but not loaded."))
    
    r_paths <- list.files(in_folder, full.names = TRUE)
    r_list <- lapply(r_paths, rast)

    r_max <- max(unlist(lapply(r_list, function(x) max(as.data.table(x), na.rm = TRUE))), na.rm = TRUE)
    r_min <- min(unlist(lapply(r_list, function(x) min(as.data.table(x), na.rm = TRUE))), na.rm = TRUE)

    #r_max_def <- max(unlist(lapply(r_list, function(x) max(as.data.table(x)$def, na.rm = TRUE))), na.rm = TRUE)
    #r_min_def <- min(unlist(lapply(r_list, function(x) min(as.data.table(x)$def, na.rm = TRUE))), na.rm = TRUE)

    #r_max_ref <- max(unlist(lapply(r_list, function(x) max(as.data.table(x)$ref, na.rm = TRUE))), na.rm = TRUE)
    #r_min_ref <- min(unlist(lapply(r_list, function(x) min(as.data.table(x)$ref, na.rm = TRUE))), na.rm = TRUE)

    for (i in 1:length(r_list)) {
        
        print(i)

        r <- r_list[[i]]
        
        if (TRUE) {
        ggplot() +
            geom_spatraster(data = r) +
            theme_bw() +
            #scale_fill_gradientn(limits = c(r_min, r_max), colors = c("red", "white", "blue"), values = c(r_min, 0, r_max)) +
            scale_fill_gradientn(limits = c(r_min, r_max), colours = terrain.colors(10), na.value = "grey90") +
            #scale_fill_gradient2(limits = c(r_min, r_max), low = "red", high = "blue", na.value = "grey80") +
            #scale_fill_gradient2(limits = c(-0.35,0.35)) +  #, high = "red", low = "darkgreen", mid = "grey80") + 
            ggtitle(2000+i) ->
            g
        }
        
        if (FALSE) {
        
        ggplot(data=r, aes(x, y, fill=ref, fill2=def)) +
            geom_raster() +
            theme_minimal() +
            scale_fill_colourplane(
                name = "", na.color = "white",
                color_projection = col_func, 
                limits_y = c(0,1), limits = c(0,1)
                ) -> 
                g
        }
        
        ggsave(plot = g, filename = paste0(out_folder, gsub(".tif", ".png", basename(r_paths[i]))), bg = "white", width = 2700, height = 2000, units = "px")
        
        rm(r, g)
        gc()
        
    }
}




out_folder_png <- paste0(base_folder, "diff/png/")

tifToPng(in_folder = out_folder, out_folder = out_folder_png)

out_folder_gif = paste0(project_path, "output/gif/prediction-maps/")

pngToGif(in_folder = out_folder_png, out_folder_gif, "diff")



