

# Read data

dt <- fread(filenames$ml_demo$master_dt, colClasses = c(dist_inra = "numeric"))

classes <- fread(filenames$csv$mapbiomas_colors)


# Edits

dt[, n_def := sum(mb_def, na.rm = TRUE), cell]
dt[, n_ref := sum(mb_ref, na.rm = TRUE), cell]

dt[, ever_def := as.numeric(n_def > 0), cell]
dt[, ever_ref_tr := as.numeric(sum(mbtr_ref, na.rm = TRUE) > 0), cell]
dt[, ever_def_tr := as.numeric(sum(mbtr_def, na.rm = TRUE) > 0), cell]



dt[, mb_forest := as.numeric(mb %in% c(3, 6))]
dt[, mb_nonforest := as.numeric(!(mb %in% c(3, 6)))]
dt[, mb_natural := as.numeric(!(mb %in% c(3:13, 61, 26, 33, 34)))]
dt[, mb_natural_nonforest := mb_natural*mb_nonforest]

dt[, mb_ag := as.numeric(mb %in% c(15, 18, 21))]
dt[, mb_anthro := as.numeric(mb %in% c(15, 18, 21, 22, 24, 30, 25))]

dt[, mb_diff := c(0, diff(mb)), cell]
dt[, mb_change := as.numeric(mb_diff != 0)]
dt[, mb_diff := NULL]

dt[, mb_ref_idx := cumsum(c(0, mb_ref[-1]))*mb_forest, cell] # index of reforestation event
dt[, mb_def_idx := cumsum(c(0, mb_def[-1]))*mb_nonforest, cell] # index of deforestation event

dt[, mb_ref_slen := sum(mb_forest) * as.numeric(mb_ref_idx > 0), by = .(cell, mb_ref_idx)]
dt[, mb_def_slen := sum(mb_nonforest) * as.numeric(mb_def_idx > 0), by = .(cell, mb_def_idx)]



dt[, mbtr_ref_idx := cumsum(c(0, mbtr_ref[-1])) - cumsum(c(0, mbtr_def[-1])), cell]
dt[, mbtr_def_idx := cumsum(c(0, mbtr_def[-1])) * mb_nonforest, cell]

dt[, mbtr_ref_slen := sum(mb_forest) * as.numeric(mbtr_ref_idx > 0), by = .(cell, mbtr_ref_idx)]
dt[, mbtr_def_slen := sum(mb_nonforest) * as.numeric(mbtr_def_idx > 0), by = .(cell, mbtr_def_idx)]


# Examine

dt[cell == "2283472212", .(year, mb, mb_ref, mb_def, mb_ref_idx, mb_def_idx, mb_ref_slen, mb_def_slen)]
dt[cell == "2283472212", .(year, mb, mbtr_ref, mbtr_def, mbtr_ref_idx, mbtr_def_idx, mbtr_ref_slen, mbtr_def_slen)]



# Create predictors based on mapbiomas history

dt[, mb_nchange_sum_15 := frollsum(mb_change, 15, align = "right", fill = NA), cell]
dt[, mb_nref_sum_15 := frollsum(mb_ref, 15, align = "right", fill = NA), cell]
dt[, mb_forest_sum_15 := frollsum(mb_forest, 15, align = "right", fill = NA), cell]
dt[, mb_ag_sum_15 := frollsum(mb_ag, 15, align = "right", fill = NA), cell]
dt[, mb_anthro_sum_15 := frollsum(mb_anthro, 15, align = "right", fill = NA), cell]


# Lags

for (i in 1:15) {

    print(i)

    varname_forest <- paste0("lag_forest_", i)
    dt[, (varname_forest) := c(rep(NA, i), mb_forest[-( (length(mb_forest)-i+1):(length(mb_forest)) )]), cell]

    varname_density_forest <- paste0("lag_density_forest_", i)
    dt[, (varname_density_forest) := c(rep(NA, i), density_forest[-( (length(density_forest)-i+1):(length(density_forest)) )]), cell]

    varname_ag <- paste0("lag_ag_", i)
    dt[, (varname_ag) := c(rep(NA, i), mb_ag[-( (length(mb_ag)-i+1):(length(mb_ag)) )]), cell]

}


### INRA data

# Property variables

dt[, inra_objectid := unique(inra_objectid[!is.na(inra_objectid)]), cell]

dt_inra <- as.data.table(vect(filenames$vector$inra$simplified))

colnames_old <- c("Clasificac", "Modalidad")
colnames_new <- paste0("inra_", tolower(colnames_old))

dt[dt_inra , (colnames_new) := setDT(mget(paste0("i.", colnames_old))) , on = .(inra_objectid = OBJECTID_12)]


table(dt$inra_clasificac)

dt[, inra_clasificac_en := as.character(NA)]
dt[inra_clasificac == "Comunal Forestal", inra_clasificac_en := "communal_forestry"]
dt[inra_clasificac %in% c("Comunaria", "Comunidad", "Comunitaria", "Propiedad Comunaria"), inra_clasificac_en := "communal"]
dt[inra_clasificac %in% c("Empresa", "Empresarial"), inra_clasificac_en := "enterprise"]
dt[inra_clasificac %in% c("Mediana"), inra_clasificac_en := "medium_extension"]
dt[grepl("Peque", inra_clasificac) | inra_clasificac == "Solar Campesino", inra_clasificac_en := "small_extension"]
dt[inra_clasificac %in% c("Sin Calsificacion"), inra_clasificac_en := "not_classified"]
dt[inra_clasificac %in% c("Territorio Indígena Originario Campesino", "Tierra Comunitaria de Origen"), inra_clasificac_en := "indigenous_territories"]

table(dt$inra_modalidad)

dt[, inra_modalidad_en := as.character(NA)]
dt[inra_modalidad == "CAT-SAN", inra_modalidad_en := "prev_national"]
dt[inra_modalidad == "SAN-SIM", inra_modalidad_en := "prev_undefined_contested"]
dt[inra_modalidad == "SAN-TCO", inra_modalidad_en := "indigenous"]


dt[is.na(inra_cohort), inra_cohort := 0, cell]
dt[, inra_cohort := max(inra_cohort, na.rm = TRUE), cell]
dt[, inra_post := as.numeric(inra_cohort > 0 & year >= inra_cohort)]

# Distance to property

    dt[, dist_inra_cumul := dist_inra]
    dt[is.na(dist_inra_cumul), dist_inra_cumul := Inf]

    dt[year < inra_cohort & dist_inra_cumul == 0, dist_inra_cumul := 3001, cell]
    dt[, dist_inra_cumul := cummin(dist_inra_cumul), cell]
    dt[year >= inra_cohort, dist_inra_cumul := 0, cell]
    dt[dist_inra_cumul == Inf, dist_inra_cumul := 3001]

    # Examine to make sure dist_inra_cumul is now correct
    dt[cell == "2283472394", .(year, inra_cohort, dist_inra, dist_inra_cumul)]

    dt[, dist_inra := dist_inra_cumul]
    dt[, dist_inra_cumul := NULL]


# Propagate various variables by cell

    vars <- c("gmted_mean", "gmted_sd", "density_200_road_pri", "density_200_road_sec", "density_200_road_ter", "density_road_pri", "density_road_sec", "density_road_ter", "dist_road_pri", "dist_road_sec", "dist_road_ter")

    for (var in vars) {
        print(var)
        dt[, temp := get(var)]
        if (length(unique(dt[, .(n_unique = length(unique(temp[!is.na(temp)]))), cell]$n_unique)) > 1) print(paste0("Error in variable", var, " ; non-unique values within cell."))
        dt[, (var) := unique(temp[!is.na(temp)]), by = .(cell)]
        dt[, temp := NULL]
    }


# Burned area

dt[, modis_burned := modis_ba]
dt[is.na(modis_ba), modis_burned := 0]

dt[, modis_ever_burned := as.numeric(sum(modis_ba, na.rm = TRUE) > 0), cell]


# Protected areas

dt[is.na(pa_municipal), pa_municipal := 0]
dt[is.na(pa_national),  pa_national := 0]
dt[is.na(pa_state),     pa_state := 0]

dt[, pa_municipal := as.numeric(cumsum(pa_municipal) > 0), cell]
dt[, pa_national  := as.numeric(cumsum(pa_national) > 0), cell]
dt[, pa_state     := as.numeric(cumsum(pa_state) > 0), cell]


# Save

dt |> fwrite(filenames$ml_demo$master_dt)
