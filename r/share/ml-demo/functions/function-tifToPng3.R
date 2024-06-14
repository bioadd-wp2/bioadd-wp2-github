
tifToPng3 <- function(in_folder, out_folder) {

    # To Png

    if (!require("scales", quietly = TRUE)) stop(paste0("Package 'scales' is required but not loaded."))

    v <- vect(filenames$vector$gadm, layer = "ADM_ADM_1")
    v <- v[v$NAME_1 == "Santa Cruz",]

    v_pa <- vect(paste0(project_path, "data/constructed/gpkg/pa_temp.gpkg"))
    v_pa <- crop(v_pa, v)

    for (i in 1:length(list.files(in_folder))) {


        print(i)

        v_pa_i <- v_pa[v_pa$STATUS_YR <= 2000 + i,]
        v_pa_i <- aggregate(buffer(v_pa_i, 200))

        r <- rast(paste0(in_folder, "pred_", 2000 + i, ".tif"))

        r_bg <- as.numeric(!is.na(r))

        r_temp <- r
        r_temp[r_temp == 0] <- NA
        r_temp[r_temp < 0.8] <- 0.8


        library(ggnewscale)

        ggplot() +
            geom_spatraster(data = r_bg) +
            scale_fill_gradient(low = "white", high = "black") +
            new_scale_fill() + 
            geom_spatraster(data = -r_temp + 1) +
            geom_spatvector(data = v_pa_i, fill = NA, color = "red", linewidth = 1, alpha = 0.25) +
            #scale_fill_gradient(na.value = NA, high = "yellow", low = "blue") +
            scale_fill_viridis(na.value = NA, discrete = FALSE) +
            #scale_fill_manual(values = c("#003f5c", "#003f5c", "#bc5090", "#ffa600", "#58508d", "#58508d")) +
            #scale_fill_gradient(na.value = NA) +
            theme_minimal() +
            theme(
            legend.title = element_blank(), 
            legend.key = element_rect(color = "black", linewidth = 1),
            legend.position = "none",
                axis.text.x = element_blank(),  # Remove X axis text
                axis.text.y = element_blank(),  # Remove Y axis text
                axis.ticks = element_blank(),   # Remove axis ticks
                axis.title.x = element_blank(), # Remove X axis title
                axis.title.y = element_blank(),  # Remove Y axis title
                panel.grid.major = element_blank(), # Remove major grid lines
                panel.grid.minor = element_blank(), # Remove minor grid lines
                panel.background = element_blank()  # Remove panel background, optional
                ) +
                ggtitle(2000 + i) ->
                g

            g

        ggsave(plot = g, filename = paste0(out_folder, "pred_", 2000 + i, ".png"), bg = "white", width = 2100, height = 2100, units = "px")

        rm(r, g)
        gc()

    }

}

