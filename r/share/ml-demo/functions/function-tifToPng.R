
tifToPng <- function(in_folder, out_folder) {

    # To Png

    if (!require("scales", quietly = TRUE)) stop(paste0("Package 'scales' is required but not loaded."))

    for (i in 1:length(list.files(in_folder))) {

        print(i)

        r <- rast(paste0(in_folder, "pred_", 2000 + i, ".tif"))

        ggplot() +
            geom_spatraster(data = r) +
            #scale_fill_gradient(limits = c(0,1)) + 
            #scale_fill_viridis(discrete = TRUE) +
            #scale_fill_manual(values = c("#003f5c", "#003f5c", "#bc5090", "#ffa600", "#58508d", "#58508d")) +
            ggtitle(2000 + i) ->
            g

        ggsave(plot = g, filename = paste0(out_folder, "pred_", 2000 + i, ".png"), bg = "white", width = 2100, height = 2100, units = "px")

        rm(r, g)
        gc()

    }

}

