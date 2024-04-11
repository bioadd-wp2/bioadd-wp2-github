

wrapRanger <- function(dt_path, esample_path, type, min_slen = 1, n_sample = 0, features_list, within_elements = NULL, primary_def = FALSE) {

    # Prepare estimation sample and store to disk 
    prepareDataRanger(dt_path = dt_path, esample_path = esample_path, type = type, min_slen = min_slen, n_sample = n_sample, features_list = features_list, within_elements = within_elements, primary_def = primary_def)

    ### Train the model

    esample_dt <- fread(esample_path)

    # Adjust features list
    if (type == "ref") features_list$def <- NULL
    if (type == "def") features_list$ref <- NULL
    features_list$outcome <- NULL
    
    f_str <- paste0(unique(unlist(features_list)), collapse = " + ")

    cat("Training model ")

    fit <- ranger(
        formula = as.formula(paste0("Surv(year, death)", " ~ ", f_str)),
        data = esample_dt,
        num.trees = 100,
        importance = "impurity",
        num.threads = 20,
        oob.error = TRUE
    )

    cat("done\n")

    ### Parse results

    # Feature importance
    importance <- fit$variable.importance
    importance_sorted <- sort(importance, decreasing = TRUE)
    importance_sorted_scaled <- importance_sorted / sum(importance_sorted)

    # Garbage collection

    rm(esample_dt)
    gc()
    
    # Return

    return(
        list(
            fit = fit,
            importance = data.table(
                var = names(importance_sorted_scaled),
                importance = importance_sorted,
                importance_scaled = importance_sorted_scaled
                )
        )
    )

}
