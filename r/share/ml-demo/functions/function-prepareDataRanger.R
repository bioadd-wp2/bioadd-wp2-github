

prepareDataRanger <- function(dt_path, esample_path, type, min_slen = 1, n_sample = 0, features_list, within_elements, primary_def = FALSE) {

    dt <- fread(dt_path)

    cat("Preparing data ")

    ### Check that features exist; get complete cases

        features <- unique(unlist(features_list))
        if (sum(!(features %in% colnames(dt)) > 0)) stop(paste0("Variables not found: ", features[!(features %in% colnames(dt))]))

        features_keep <- c(features, "cell", "year", paste0(type, "_group"))


    ### Subsetting and sampling

        # rid_nonforest is the row index of nonforest observations; ensures that we are looking at secondary forest
        # Note: this works in conjunction with choosing the minimum of groupvar

        if (type == "def" & primary_def == TRUE) {
            cat(paste0("\n Note: primary deforestation "))
            dt[, tempvar := mb_sum15_forest[year == 2000], cell]
            dt <- copy(dt[tempvar == 15])
            dt[, tempvar := NULL]
        } else {
            dt <- copy(dt[rid_nonforest > 0])
        }

        complete_cases_idx <- complete.cases(dt[, mget(features_keep)])
        dt <- copy(dt[year >= 2000 & complete_cases_idx == TRUE, mget(features_keep)])

        # Ensure correct ordering of rows
        setorder(dt, cell, year)

        # Here, order of subsetting is very important

        dt[, groupvar := get(paste0(type, "_group"))]
        dt[, min_groupvar := min(groupvar, na.rm = TRUE), cell]

        dt <- copy(dt[groupvar == min_groupvar])
        dt[, min_groupvar := NULL]


        # Sampling
        ids <- unique(dt$cell)
        if (n_sample > 0 & n_sample < length(ids)) dt <- copy(dt[cell %in% ids[sample(1:length(ids), n_sample, replace = FALSE)]])

    ### Edits

        # Baseline variables: Set to baseline value
        
        if (!is.null(features_list$baseline)) {
            for (var in features_list$baseline) {

                dt[, tempvar := get(var)]
                dt[, (var) := tempvar[1], .(cell, groupvar)]
                dt[, tempvar := NULL]

            }
        }

        # Within variables:

        if (!is.null(within_elements)) {

            features_within <- unique(unlist(features_list[within_elements]))

            for (var in features_within) {

                dt[, tempvar := get(var)]
                dt[, (var) := NULL]
                dt[, (var) := tempvar - mean(tempvar, na.rm = TRUE), cell]
                dt[, tempvar := NULL]

            }

        }

        # Define death variable
        if (type == "ref") dt[, death := as.numeric(mb_forest == 1)]
        if (type == "def") dt[, death := as.numeric(mb_forest == 0)]

        # Adjust the temporal or spatial distance predictors where 0 would perfectly predict death
        # Current adjustment: for death year, carry over the previous observation

        dt[, death_year := year[death == 1], .(cell, groupvar)]

        vars <- c("dist_forest", "dist_nonforest", "mb_years_since_forest", "mb_years_since_nonforest", "dist_natural_nonforest", "dist_ag", "dist_urban", "dist_water")

        for (var in vars) {

            if (var %in% colnames(dt)) {

                dt[, tempvar := get(var)]

                dt[death == 1, tempvar := tempvar[year == death_year-1], .(cell, groupvar)]
                dt[death == 1, (var) := tempvar, .(cell, groupvar)]

                dt[, tempvar := NULL]

            }

        }

        dt[, death_year := NULL]

        #if ("dist_forest" %in% colnames(dt)) dt[death == 1, dist_forest    := dist_forest[year == death_year-1], .(cell, groupvar)]
        #if ("dist_nonforest" %in% colnames(dt)) dt[death == 1, dist_nonforest := dist_nonforest[year == death_year-1], .(cell, groupvar)]
        #if ("mb_years_since_forest" %in% colnames(dt)) dt[death == 1, mb_years_since_forest    := (mb_years_since_forest[year == death_year-1] + 1), .(cell, groupvar)]
        #if ("mb_years_since_nonforest" %in% colnames(dt)) dt[death == 1, mb_years_since_nonforest := (mb_years_since_nonforest[year == death_year-1] + 1), .(cell, groupvar)]

        
        # Finally subsetting by min_slen. Note the strict inequality. First observation is taken out.
        # This subsetting is done only last since the baseline values need to be calculated from the very first observation
        dt[, obsid := 1:.N, .(cell, groupvar)]
        dt <- copy(dt[obsid > min_slen])


    ### Save to disk

    dt |> fwrite(esample_path)

    ### Garbage collection

    rm(dt)
    gc()

    cat("done\n")

    return(0)

}
