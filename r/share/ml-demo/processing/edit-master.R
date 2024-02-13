
# Read data

dt <- fread(filenames$ml_demo$master_dt)

classes <- fread(filenames$csv$mapbiomas_colors)

# Edits

dt[, ever_def := as.numeric(sum(mb_def, na.rm = TRUE) > 0), by = .(cell)]
dt[, ever_tr_ref := as.numeric(sum(mbtr_ref, na.rm = TRUE) > 0), by = .(cell)]
dt[, ever_tr_def := as.numeric(sum(mbtr_def, na.rm = TRUE) > 0), by = .(cell)]

dt[, mb_forest := as.numeric(mb %in% c(3, 6))]
dt[, mb_nonforest := as.numeric(!(mb %in% c(3, 6)))]
dt[, mb_natural := as.numeric(!(mb %in% c(3:13, 61, 26, 33, 34)))]
dt[, mb_natural_nonforest := mb_natural*mb_nonforest]

dt[, mb_ag := as.numeric(mb %in% c(15, 18, 21))]
dt[, mb_anthro := as.numeric(mb %in% c(15, 18, 21, 22, 24, 30, 25))]

dt[, c_diff := c(0, diff(mb)), by = .(cell)]
dt[, mb_change := as.numeric(c_diff != 0)]
dt[, c_diff := NULL]

dt[, mb_ref_no := cumsum(c(0, mb_ref[-1]))*mb_forest, by = .(cell)]
dt[, mb_def_no := cumsum(c(0, mb_def[-1]))*mb_nonforest, by = .(cell)]

dt[, mb_ref_slen := sum(mb_forest) * as.numeric(mb_ref_no > 0), by = .(cell, mb_ref_no)]
dt[, mb_def_slen := sum(mb_nonforest) * as.numeric(mb_def_no > 0), by = .(cell, mb_def_no)]


dt[, mbtr_ref_no := cumsum(c(0, mbtr_ref[-1])) * mb_forest, by = .(cell)]
dt[, mbtr_def_no := cumsum(c(0, mbtr_def[-1])) * mb_nonforest, by = .(cell)]

dt[, mbtr_ref_slen := sum(mb_forest) * as.numeric(mbtr_ref_no > 0), by = .(cell, mbtr_ref_no)]
dt[, mbtr_def_slen := sum(mb_nonforest) * as.numeric(mbtr_def_no > 0), by = .(cell, mbtr_def_no)]



dt[, inra_cohort := max(inra_cohort, na.rm = TRUE), by = .(cell)]
dt[is.na(inra_cohort), inra_cohort := 0, by = .(cell)]

dt[, inra_post := as.numeric(inra_cohort > 0 & year >= inra_cohort)]


# Create predictors based on mapbiomas history

dt[, v_nchange_sum_15 := frollsum(mb_change, 15, align = "right", fill = NA), by = .(cell)]
dt[, v_nref_sum_15 := frollsum(mb_ref, 15, align = "right", fill = NA), by = .(cell)]
dt[, v_forest_sum_15 := frollsum(mb_forest, 15, align = "right", fill = NA), by = .(cell)]
dt[, v_ag_sum_15 := frollsum(mb_ag, 15, align = "right", fill = NA), by = .(cell)]
dt[, v_anthro_sum_15 := frollsum(mb_anthro, 15, align = "right", fill = NA), by = .(cell)]


# Lags
for (i in 1:15) {

    varname_forest <- paste0("v_forest_lag_", i)
    dt[, (varname_forest) := c(rep(NA, i), mb_forest[-( (length(mb_forest)-i+1):(length(mb_forest)) )]), by = .(cell)]

    varname_ag <- paste0("v_ag_lag_", i)
    dt[, (varname_ag) := c(rep(NA, i), mb_ag[-( (length(mb_ag)-i+1):(length(mb_ag)) )]), by = .(cell)]

}


# Save

dt |> fwrite(filenames$ml_demo$master_dt)
