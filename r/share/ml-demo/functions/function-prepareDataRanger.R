

prepareDataRanger <- function(dt_path, esample_path, type, min_slen = 1, n_sample = 0, features_list, within_elements) {

    cat("Preparing data ")

    dt <- fread(dt_path)

    ### Check that features exist; get complete cases

        features <- unique(unlist(features_list))
        if (sum(!(features %in% colnames(dt)) > 0)) stop(paste0("Variables not found: ", features[!(features %in% colnames(dt))]))

        features_keep <- c(features, "cell", "year", paste0(type, "_group"))

        complete_cases_idx <- complete.cases(dt[, mget(features_keep)])

    ### Subsetting and sampling

        # rid_nonforest is the row index of nonforest observations; ensures that we are looking at secondary forest

        dt <- copy(dt[year >= 2000 & rid_nonforest > 0 & complete_cases_idx == TRUE, mget(features_keep)])

        # Ensure correct ordering of rows

        setorder(dt, cell, year)

        dt[, groupvar := get(paste0(type, "_group"))]
        dt[, obsid := 1:.N, .(cell)]
        dt[, min_groupvar := min(groupvar, na.rm = TRUE), cell]

        dt <- copy(dt[groupvar == min_groupvar & obsid > min_slen]) # note the strict inequality; the +1 is for the first observation

        dt[, min_groupvar := NULL]

        ids <- unique(dt$cell)
        if (n_sample > 0 & n_sample < length(ids)) dt <- copy(dt[cell %in% ids[sample(1:length(ids), n_sample, replace = FALSE)]])

    ### Edits

        # Baseline variables: Set to baseline value

        for (var in features_list$baseline) {

            dt[, tempvar := get(var)]
            dt[, (var) := tempvar[1], .(cell, groupvar)]
            dt[, tempvar := NULL]

        }

        # Within variables:

        if (!is.null(within_elements)) {

            features_within <- unique(unlist(features_list[within_elements]))

            for (var in features_within) {

                dt[, tempvar := get(var)]
                dt[, (var) := tempvar - mean(tempvar, na.rm = TRUE), cell]
                dt[, tempvar := NULL]

            }

        }

        # Define death variable
        if (type == "ref") dt[, death := as.numeric(mb_forest == 1)]
        if (type == "def") dt[, death := as.numeric(mb_forest == 0)]

        # Adjust the distance predictors where 0 would perfectly predict death

        dt[, death_year := year[death == 1], .(cell, groupvar)]

        dt[death == 1, dist_forest    := dist_forest[year == death_year-1], .(cell, groupvar)]
        dt[death == 1, dist_nonforest := dist_nonforest[year == death_year-1], .(cell, groupvar)]

        dt[death == 1, mb_years_since_forest    := (mb_years_since_forest[year == death_year-1] + 1), .(cell, groupvar)]
        dt[death == 1, mb_years_since_nonforest := (mb_years_since_nonforest[year == death_year-1] + 1), .(cell, groupvar)]

        dt[, death_year := NULL]



    ### Save to disk

    dt |> fwrite(esample_path)

    ### Garbage collection

    rm(dt)
    gc()

    cat(" | Done\n")

    return(0)

}
