
tifToPng <- function(in_folder, out_folder, categorize = FALSE) {

    # To Png

    if (!require("scales", quietly = TRUE)) stop(paste0("Package 'scales' is required but not loaded."))

    for (i in 1:length(list.files(in_folder))) {

        print(i)

        r <- rast(paste0(in_folder, "pred_", 2000 + i, ".tif"))

        if (categorize == TRUE) {

            #r[r > 0 & r < 0.2] <- 0.2
            #r[r > 0.2 & r < 0.4] <- 0.4
            #r[r > 0.4 & r < 0.6] <- 0.6
            #r[r > 0.6 & r < 0.8] <- 0.8
            #r[r > 0.8 & r <= 1] <- 1

            category_breaks <- c(0.1, 0.2, 0.4, 0.6, 0.8, 1)
            r[] <- as.character(cut(values(r), breaks = category_breaks, include.lowest = FALSE, labels = FALSE))

        }

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

