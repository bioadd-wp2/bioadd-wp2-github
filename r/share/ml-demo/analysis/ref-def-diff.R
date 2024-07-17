
base_folder <- paste0("C:/temp/rf_predictions/")

out_folder <- paste0(base_folder, "diff/diff_raster/")
if (!file.exists(out_folder)) dir.create(out_folder, recursive = TRUE)


# The only parameter is this:
type <- ""

for (i in 2001:2020) {

	r_ref <- rast(paste0(base_folder, "/ref", type, "/processed/pred_", i, ".tif"))
	r_def <- rast(paste0(base_folder, "/def", type, "/processed/pred_", i, ".tif"))

    r_ref <- -r_ref + (1 + minmax(r_ref)["min",])

	#r_ref <- (r_ref - min(as.data.table(r_ref)[[1]], na.rm = TRUE)) 
    #r_ref <- (r_ref) / max(as.data.table(r_ref)[[1]], na.rm = TRUE)

	#r_def <- (r_def - min(as.data.table(r_def)[[1]], na.rm = TRUE))
    #r_def <- (r_def) / max(as.data.table(r_def)[[1]], na.rm = TRUE)
	
    r_diff <- (r_ref - r_def)
    #r_diff <- c(r_ref, r_def)
    #names(r_diff) <- c("ref", "def")

	#r_values <- as.data.table(r_diff)[[1]]
	#r_diff <- r_diff - mean(as.data.table(r_diff)[[1]], na.rm = TRUE) 
	#r_diff <- r_diff / max(abs(as.data.table(r_diff)[[1]]), na.rm = TRUE)

    # Resample the original raster to the new resolution
    #resampled_rast <- terra::disagg(r_diff, 2, method = "bilinear")

	r_diff |> writeRaster(paste0(out_folder, "diff_", i, ".tif"), overwrite = TRUE)

	rm(r_diff)

}



tifToPng <- function(in_folder, out_folder) {

    # To Png

    if (!require("scales", quietly = TRUE)) stop(paste0("Package 'scales' is required but not loaded."))
    
    r_paths <- list.files(in_folder, full.names = TRUE)
    r_list <- lapply(r_paths, rast)

    r_max <- max(unlist(lapply(r_list, function(x) max(as.data.table(x), na.rm = TRUE))), na.rm = TRUE)
    r_min <- min(unlist(lapply(r_list, function(x) min(as.data.table(x), na.rm = TRUE))), na.rm = TRUE)

    for (i in 1:length(r_list)) {
        
        print(i)

        r <- r_list[[i]]
        
        ggplot() +
            geom_spatraster(data = r) +
            theme_map() +
            #scale_fill_gradientn(limits = c(r_min, r_max), colors = c("red", "white", "blue"), values = c(r_min, 0, r_max)) +
            scale_fill_gradientn(limits = c(r_min, r_max), colours = rev(terrain.colors(10)), na.value = "white") +
            #scale_fill_gradient2(limits = c(r_min, r_max), high = "blue", mid = "grey80", low = "red", midpoint = 0, na.value = "white") +
            #scale_fill_gradient2(limits = c(-0.35,0.35)) +  #, high = "red", low = "darkgreen", mid = "grey80") + 
            theme(
                legend.position = "none",
                plot.title = element_text(size = 12)
            ) +
            ggtitle(2000+i) ->
            g
        
        ggsave(plot = g, filename = paste0(out_folder, gsub(".tif", ".png", basename(r_paths[i]))), bg = "white", width = 1000, height = 1000, dpi = 200, units = "px")
        
        rm(r, g)
        gc()
        
    }
}



out_folder_png <- paste0(base_folder, "/diff/png/")
tifToPng(in_folder = out_folder, out_folder = out_folder_png)


out_folder_gif = paste0(project_path, "output/gif/prediction-maps/")
pngToGif(in_folder = out_folder_png, out_folder_gif, paste0("diff", type))



