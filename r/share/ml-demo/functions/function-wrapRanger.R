
wrapRanger <- function(dt_path, esample_path, type, min_slen = 1, n_sample = 0, features_list, within_elements = NULL) {

    # Prepare estimation sample and store to disk 
    prepareDataRanger(dt_path = dt_path, esample_path = esample_path, type = type, min_slen = min_slen, n_sample = n_sample, features_list = features_list, within_elements = within_elements)

    ### Train the model

    esample_dt <- fread(esample_path)

    # Adjust features list
    if (type == "ref") features_list$def <- NULL
    if (type == "def") features_list$ref <- NULL
    features_list$outcome <- NULL

    fit <- ranger(
        formula = as.formula(paste0("Surv(year, death)", " ~ ", paste0(unique(unlist(features_list)), collapse = " + "))),
        data = esample_dt,
        num.trees = 100,
        importance = "impurity",
        num.threads = 20,
        oob.error = TRUE
    )

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
