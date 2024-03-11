

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

graphImportance <- function(r_list, n_vars) {

    temp_list <- lapply(r_list, function(x) x$importance)

    oob_list <- lapply(r_list, function(x) x$fit$prediction.error)

    oob_string <- ""
    for (i in 1:length(r_list)) oob_string <-  paste(oob_string, names(oob_list)[i], ": ", round(oob_list[[i]], 3), ifelse(i < length(r_list), " | ", ""))

    for (i in 1:length(r_list)) temp_list[[i]][, model := names(temp_list)[[i]]]

    r_dt <- data.table::rbindlist(temp_list)
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
            annotate(
                "label", x = Inf, y = Inf,
                label = paste0(n_vars, " / ", n_vars_total, " model variables plotted", "\nOOB error: ", oob_string),  
                hjust = 1, vjust = 1,
                color = "black", fill = "white"
                ) +
            ylim(c(0, max(r_dt$importance_scaled, na.rm = TRUE)*1.1)) +
            theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) ->
            g

    return(g)

}


graphImportance(r_list = results_list[c("ref", "ref_min2")], n_vars = 30) -> g1
graphImportance(r_list = results_list[c("def", "def_min2")], n_vars = 30) -> g2


g1 | g2



### Map of predicted survival

# Determine the folder where the output will be stored

base_folder <- paste0("C:/temp/rf_predictions/")
if (!dir.exists(base_folder)) dir.create(base_folder, recursive = TRUE)

wrapPredictionMap(type = "ref", results_list = results_list, base_folder = base_folder)
wrapPredictionMap(type = "def", results_list = results_list, base_folder = base_folder)
wrapPredictionMap(type = "ref_min2", results_list = results_list, base_folder = base_folder)
wrapPredictionMap(type = "def_min2", results_list = results_list, base_folder = base_folder)


