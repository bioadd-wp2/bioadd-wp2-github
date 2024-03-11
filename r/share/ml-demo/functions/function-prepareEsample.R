

prepareEsampleRanger <- function(dt, type) {

    if (type == "ref") features_list$def <- NULL
    if (type == "def") features_list$ref <- NULL

    features <- unique(unlist(features_list))
    if (sum(!(features %in% colnames(dt)) > 0)) stop(paste0("Variables not found: ", features[!(features %in% colnames(dt))]))

    ### Subsetting and sampling

    dt[, groupvar := get(paste0(type, "_group"))]
    dt[, obsid := 1:.N, .(cell)]

    if (type == "def") dt <- copy(dt[ever_ref == 1])

    dt[, min_groupvar := min(groupvar, na.rm = TRUE), cell]

    dt <- copy(dt[groupvar == min_groupvar & obsid > min_slen])

    ids <- unique(dt$cell)
    if (n_sample > 0 & n_sample < length(ids)) dt <- copy(dt[cell %in% ids[sample(1:length(ids), n_sample, replace = FALSE)]])

    ### Edits

    # Baseline variables: Set to baseline value

    for (var in features_list$baseline) {

        dt[, tempvar := get(var)]
        dt[, (var) := tempvar[1], .(cell, groupvar)]
        dt[, tempvar := NULL]

    }

    # Define death variable
    if (type == "ref") dt[, death := as.numeric(mb_forest == 1)]
    if (type == "def") dt[, death := as.numeric(mb_forest == 0)]

    # Adjust the distance predictors where 0 would perfectly predict death

    dt[, death_year := year[death == 1], .(cell, groupvar)]

    dt[death == 1, dist_forest    := dist_forest[year == death_year-1], .(cell, groupvar)]
    dt[death == 1, dist_nonforest := dist_nonforest[year == death_year-1], .(cell, groupvar)]

    dt[death == 1, mb_years_since_forest := mb_years_since_forest[year == death_year-1], .(cell, groupvar)]
    dt[death == 1, mb_years_since_nonforest := mb_years_since_nonforest[year == death_year-1], .(cell, groupvar)]

    return(dt)

}
