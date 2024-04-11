

# This script runs a random forest algorithm and then produces the prediction on a map

# To do:
# distance to PA; distance to burned area; think about these vs post indicators


### Setup
source(paste0(project_path, "r/share/ml-demo/setup.R"))

### Estimation
source(paste0(project_path, "r/share/ml-demo/analysis/survival-forest-estimation.R"))

### Post estimation
load(paste0(project_path, "data/constructed/rdata/ranger_results.RData"))



# Graph importance scores

graphImportance <- function(r_list, n_vars, annotate = TRUE, ad_hoc = FALSE, labels = FALSE) {

    temp_list <- lapply(r_list, function(x) x$importance)

    oob_list <- lapply(r_list, function(x) x$fit$prediction.error)

    oob_string <- ""
    for (i in 1:length(r_list)) oob_string <-  paste(oob_string, names(oob_list)[i], ": ", round(oob_list[[i]], 3), ifelse(i < length(r_list), " | ", ""))
    for (i in 1:length(r_list)) temp_list[[i]][, model := names(temp_list)[[i]]]

    r_dt <- data.table::rbindlist(temp_list)

    # Ad hoc adjustments for Bolivia presentation! Remember to disable
    if (ad_hoc == TRUE) {

        r_dt[var == "dist_nonforest", var := "dist_forest"]

        r_dt <- copy(r_dt[!(var %in% c("dist_road_pri", "dist_road_ter", "density_200_ag", "density_200_forest", "density_forest_lag_1"))])

        r_dt[model == "ref", model := "Regrowth"]
        r_dt[model == "def", model := "Regrowth survival"]
        r_dt[model == "def_primary", model := "Primary forest survival"]

    }


    r_dt <- r_dt[order(-model, -importance_scaled)]

    r_dt$var_f <- factor(r_dt$var, levels = unique(r_dt$var[order(-r_dt[]$importance_scaled)]))

    setorder(r_dt, var_f)

    r_dt[, rid := 1:.N, model]
    n_vars_total <- length(unique(r_dt$var_f))
    r_dt <- copy(r_dt[rid <= n_vars])

    r_dt |>
        ggplot(aes(x = var_f, y = importance_scaled)) +
            geom_point(aes(pch = model, color = model)) +
            theme_bw() + xlab("") + ylab("Importance") +
            labs(color = "Model", pch = "Model") +
            ylim(c(0, max(r_dt$importance_scaled, na.rm = TRUE)*1.1)) +
            scale_color_manual(values = c("blue", "darkorange", "darkred")) +
            theme(axis.text.x = element_text(angle = 45, hjust = 1)) ->
            g

    if (annotate == TRUE) {

        g <- g +
            annotate(
                "label", x = Inf, y = Inf,
                label = paste0(n_vars, " / ", n_vars_total, " model variables plotted", "\nOOB error: ", oob_string),  
                hjust = 1, vjust = 1,
                color = "black", fill = "white"
                )

    }

    if (labels == TRUE) g <- g + scale_x_discrete(labels = x_labels)

    return(g)

}

x_labels <- c("Distance to forest", "Forest density", "Distance to property", "Distance to protected area", "Agriculture density", "Distance to water", "Natural nonforest density", "Distance to road", "Forest density, 1yr lag", "Population density")

x_labels <- c("Distance to forest", "Agriculture density", "Forest density", "Distance to property", "Distance to protected area", "Natural nonforest density", "Distance to water",  "Elevation", "Population density", "Forest density, 1yr lag")


graphImportance(r_list = results_list[c("ref", "ref_min3")], n_vars = 10) -> g1
graphImportance(r_list = results_list[c("def", "def_min3")], n_vars = 10) -> g2
graphImportance(r_list = results_list[c("ref", "ref_within")], n_vars = 10) -> g3
graphImportance(r_list = results_list[c("def", "def_within")], n_vars = 10, annotate = FALSE) -> g4

graphImportance(r_list = results_list[c("def", "ref", "def_primary")], n_vars = 10, ad_hoc = TRUE, annotate = FALSE, labels = FALSE)


(g1 | g2) / (g3 | g4)

g_bolivia <- graphImportance(r_list = results_list[c("def", "ref", "def_primary")], n_vars = 10, ad_hoc = TRUE, annotate = FALSE, labels = TRUE)

ggsave(filename = paste0(project_path, "output/png/Bolivia-presentation/RF_importance.png"), plot = g_bolivia, bg = "white", width = 3000, height = 2000, dpi = 500, units = "px")


### Map of predicted survival

# Determine the folder where the output will be stored

base_folder <- paste0("C:/temp/rf_predictions/")
if (!dir.exists(base_folder)) dir.create(base_folder, recursive = TRUE)

within_elements <- names(f_list)[!(names(f_list) %in% c("time_invariant", "ref", "def", "baseline", "outcome"))]
features_within <- as.vector(unlist(f_list[within_elements]))

wrapPredictionMap(type = "ref", results_list = results_list, base_folder = base_folder, out_folder_gif = paste0(project_path, "output/gif/prediction-maps/"), gif_only = FALSE)
wrapPredictionMap(type = "def", results_list = results_list, base_folder = base_folder, out_folder_gif = paste0(project_path, "output/gif/prediction-maps/"), gif_only = FALSE)
wrapPredictionMap(type = "ref_min3", results_list = results_list, base_folder = base_folder, out_folder_gif = paste0(project_path, "output/gif/prediction-maps/"), gif_only = FALSE)
wrapPredictionMap(type = "def_min3", results_list = results_list, base_folder = base_folder, out_folder_gif = paste0(project_path, "output/gif/prediction-maps/"), gif_only = FALSE)
wrapPredictionMap(type = "ref_within", results_list = results_list, base_folder = base_folder, out_folder_gif = paste0(project_path, "output/gif/prediction-maps/"), features_within = features_within, gif_only = FALSE)
wrapPredictionMap(type = "def_within", results_list = results_list, base_folder = base_folder, out_folder_gif = paste0(project_path, "output/gif/prediction-maps/"), features_within = features_within, gif_only = FALSE)

wrapPredictionMap(type = "def_primary", results_list = results_list, base_folder = base_folder, out_folder_gif = paste0(project_path, "output/gif/prediction-maps/"), gif_only = FALSE)

wrapPredictionMap(type = "def_primary", results_list = results_list, base_folder = base_folder, out_folder_gif = paste0(project_path, "output/gif/prediction-maps/datachanged-"), gif_only = FALSE, change_data = TRUE)

wrapPredictionMap(type = "def", results_list = results_list, base_folder = base_folder, out_folder_gif = paste0(project_path, "output/gif/prediction-maps/datachanged-"), gif_only = FALSE, change_data = TRUE)
wrapPredictionMap(type = "ref", results_list = results_list, base_folder = base_folder, out_folder_gif = paste0(project_path, "output/gif/prediction-maps/datachanged-"), gif_only = FALSE, change_data = TRUE)


### For Bolivia:

tifToPng <- function(in_folder, out_folder, type = "ref") {

    # To Png

    v <- vect(filenames$vector$gadm, layer = "ADM_ADM_1")
    v <- v[v$NAME_1 == "Santa Cruz", ]
    r_temp <- rast(paste0(in_folder, "pred_", 2000 + 1, ".tif"))

    r_v <- rasterize(v, r_temp)


    if (!require("scales", quietly = TRUE)) stop(paste0("Package 'scales' is required but not loaded."))

    for (i in 1:length(list.files(in_folder))) {

        print(i)

        r <- rast(paste0(in_folder, "pred_", 2000 + i, ".tif"))

        if (type == "ref") r <- -r + (1 + minmax(r)["min",])

        r[is.na(r) & r_v == 1] <- minmax(r)["min",]

        ggplot() +
            geom_spatraster(data = r) +
            #scale_fill_gradient(limits = c(0,1)) + 
            #scale_fill_viridis(discrete = TRUE) +
            theme_map() +
            scale_fill_gradient(na.value = "white") +
            theme(
                legend.position = "none",
                plot.title = element_text(size = 12)
            ) +
            ggtitle(2000 + i) ->
            g

        ggsave(plot = g, filename = paste0(out_folder, "pred_", 2000 + i, ".png"), bg = "white", width = 1000, height = 1000, dpi = 200, units = "px")

        rm(r, g)
        gc()

    }

}

tifToPng(in_folder = paste0(base_folder, "/ref/processed/"), out_folder = paste0(base_folder, "/ref/png/"), type = "ref") 
pngToGif(in_folder = paste0(base_folder, "/ref/png/"), out_folder = paste0(project_path, "output/gif/prediction-maps/"), name = paste0("prediction-animation-ref"))

tifToPng(in_folder = paste0(base_folder, "/def/processed/"), out_folder = paste0(base_folder, "/def/png/"), type = "def") 
pngToGif(in_folder = paste0(base_folder, "/def/png/"), out_folder = paste0(project_path, "output/gif/prediction-maps/"), name = paste0("prediction-animation-def"))


tifToPng(in_folder = paste0(base_folder, "/def_primary/processed/"), out_folder = paste0(base_folder, "/def_primary/png/"), type = "def_primary") 
pngToGif(in_folder = paste0(base_folder, "/def_primary/png/"), out_folder = paste0(project_path, "output/gif/prediction-maps/"), name = paste0("prediction-animation-def-primary"))




