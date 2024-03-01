


editMaster <- function(in_file, out_file){

    if (is.null(in_file) | is.null(out_file)) stop("Invalid filenames")

    # Read data

    dt <- fread(in_file, colClasses = c(dist_inra = "numeric"))

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


    # Mapbiomas transitions survival lengths

        dt[, mbtr_ref_temp := as.numeric(cumsum(c(0, mbtr_ref[-1]))) , cell]
        dt[, mbtr_def_temp := as.numeric(cumsum(c(0, mbtr_def[-1]))) , cell]

        dt[ever_ref_tr == 1, mbtr_ref_temp_first := min(year[mbtr_ref_temp > 0], na.rm = TRUE), cell]
        dt[ever_def_tr == 1, mbtr_def_temp_first := min(year[mbtr_def_temp > 0], na.rm = TRUE), cell]

        dt[mbtr_def_temp_first > mbtr_ref_temp_first, mbtr_ref_idx := mbtr_ref_temp*(mbtr_ref_temp - mbtr_def_temp ), cell]
        dt[mbtr_def_temp_first < mbtr_ref_temp_first, mbtr_ref_idx := mbtr_ref_temp*(mbtr_ref_temp - mbtr_def_temp + 1), cell]

        dt[mbtr_ref_temp_first > mbtr_def_temp_first, mbtr_def_idx := mbtr_def_temp*(mbtr_def_temp - mbtr_ref_temp ), cell]
        dt[mbtr_ref_temp_first < mbtr_def_temp_first, mbtr_def_idx := mbtr_def_temp*(mbtr_def_temp - mbtr_ref_temp + 1), cell]

        dt[mbtr_ref_idx > 0, mbtr_ref_slen := .N, by = .(cell, mbtr_ref_idx)]
        dt[mbtr_def_idx > 0, mbtr_def_slen := .N, by = .(cell, mbtr_def_idx)]
        dt[mbtr_ref_idx == 0, mbtr_ref_slen := 0, by = .(cell, mbtr_ref_idx)]
        dt[mbtr_def_idx == 0, mbtr_def_slen := 0, by = .(cell, mbtr_def_idx)]

        dt[, mbtr_ref_temp := NULL]
        dt[, mbtr_def_temp := NULL]
        dt[, mbtr_ref_temp_first := NULL]
        dt[, mbtr_def_temp_first := NULL]


    # Examine

    dt[cell == "2283472212", .(year, mb, mb_ref, mb_def, mb_ref_idx, mb_def_idx, mb_ref_slen, mb_def_slen)]
    dt[cell == "2283472212", .(year, mb, mbtr_ref, mbtr_def, mbtr_ref_idx, mbtr_def_idx, mbtr_ref_slen, mbtr_def_slen)]

    # Sums over previous 15 years, rolling sum

    dt[, mb_nchange_sum_15 := frollsum(mb_change, 15, align = "right", fill = NA), cell]
    dt[, mb_nref_sum_15 := frollsum(mb_ref, 15, align = "right", fill = NA), cell]
    dt[, mb_ndef_sum_15 := frollsum(mb_def, 15, align = "right", fill = NA), cell]
    dt[, mb_forest_sum_15 := frollsum(mb_forest, 15, align = "right", fill = NA), cell]
    dt[, mb_ag_sum_15 := frollsum(mb_ag, 15, align = "right", fill = NA), cell]
    dt[, mb_anthro_sum_15 := frollsum(mb_anthro, 15, align = "right", fill = NA), cell]

    # Years since forest etc

    dt[, mb_years_since_forest := (year - frollapply(mb_forest * year, n = 15, FUN = "max", na.rm = TRUE, align = "right", fill = NA)), cell]
    dt[, mb_years_since_nonforest := year - frollapply(mb_nonforest * year, n = 15, FUN = "max", na.rm = TRUE, align = "right", fill = NA), cell]
    dt[, mb_years_since_ag := year - frollapply(mb_ag * year, n = 15, FUN = "max", na.rm = TRUE, align = "right", fill = NA), cell]
    dt[, mb_years_since_anthro := year - frollapply(mb_anthro * year, n = 15, FUN = "max", na.rm = TRUE, align = "right", fill = NA), cell]
    dt[, mb_years_since_change := year - frollapply(mb_change * year, n = 15, FUN = "max", na.rm = TRUE, align = "right", fill = NA), cell]

    dt[mb_years_since_forest >= 15, mb_years_since_forest := 15]
    dt[mb_years_since_nonforest >= 15, mb_years_since_nonforest := 15]
    dt[mb_years_since_ag >= 15, mb_years_since_ag := 15]
    dt[mb_years_since_anthro >= 15, mb_years_since_anthro := 15]
    dt[mb_years_since_change >= 15, mb_years_since_change := 15]


    # Sums over previous 15 years, unique value per re/deforestation event representing 15 years prior to the event

    types <- c("ref", "def")
    vars <- c(
        "mb_nchange_sum_15", "mb_nref_sum_15", "mb_forest_sum_15", "mb_ag_sum_15", "mb_anthro_sum_15",
        "mb_years_since_forest", "mb_years_since_nonforest", "mb_years_since_ag", "mb_years_since_anthro", "mb_years_since_change"
        )

    for (type in types) {
        print(type)
        if (type == "ref") dt[, typevar :=  mb_ref_idx]
        if (type == "def") dt[, typevar :=  mb_def_idx]
        for (var in vars) {
            print(var)
            dt[, temp_var := get(var)]
            dt[, temp_lag := c(NA, temp_var[-.N]), .(cell)]
            varname <- paste0(var, "_", type)
            dt[, (varname) := temp_lag[year == min(year, na.rm = TRUE)], .(cell, typevar)]
        }
        dt[, typevar := NULL]
    }



    dt[cell == "2283472212", .(year, mb, mb_ref, mb_def, mb_ref_idx, mb_def_idx, mb_ref_slen, mb_def_slen, mb_years_since_forest, mb_years_since_forest_ref, mb_nchange_sum_15, mb_nchange_sum_15_ref, mb_forest_sum_15, mb_forest_sum_15_ref)]


    # Lags

    if (FALSE) {

        for (i in 1:15) {

            print(i)

            varname_forest <- paste0("lag_forest_", i)
            dt[, (varname_forest) := c(rep(NA, i), mb_forest[-( (length(mb_forest)-i+1):(length(mb_forest)) )]), cell]

            varname_density_forest <- paste0("lag_density_forest_", i)
            dt[, (varname_density_forest) := c(rep(NA, i), density_forest[-( (length(density_forest)-i+1):(length(density_forest)) )]), cell]

            varname_ag <- paste0("lag_ag_", i)
            dt[, (varname_ag) := c(rep(NA, i), mb_ag[-( (length(mb_ag)-i+1):(length(mb_ag)) )]), cell]

        }

    }

    # Propagate various variables by cell

        vars <- c("pa_national_id", "pa_state_id", "pa_municipal_id", "inra_objectid", "gmted_mean", "gmted_sd", "density_200_road_pri", "density_200_road_sec", "density_200_road_ter", "density_road_pri", "density_road_sec", "density_road_ter", "dist_road_pri", "dist_road_sec", "dist_road_ter")

        for (var in vars) {
            print(var)
            dt[, temp := get(var)]
            if (length(unique(dt[, .(n_unique = length( unique(temp[!is.na(temp)]) )[ !is.na( unique(temp[!is.na(temp)]) ) ]), cell]$n_unique)) > 1) print(paste0("Error in variable ", var, " ; non-unique values within cell."))
            dt[, (var) := unique(temp[!is.na(temp)]), by = .(cell)]
            dt[, temp := NULL]
        }


    ### INRA data

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
        dt[, inra_post := as.numeric(inra_cohort > 0 & year >= inra_cohort & !is.na(inra_cohort))]
        dt[inra_post != 1 | is.na(inra_post), inra_post := 0]

        dt[, ever_inra := as.numeric(sum(inra_post) > 0), cell]

        table(dt[, .(ever_inra, inra_cohort)])


    # Distance to property

        dt[, dist_inra_cumul := dist_inra]

        dt[ever_inra == 0 & dist_inra_cumul == 0, dist_inra_cumul := 3001]
        dt[ever_inra == 1 & dist_inra_cumul == 0 & year < inra_cohort, dist_inra_cumul := 3001]

        dt[is.na(dist_inra_cumul), dist_inra_cumul := Inf]
        dt[, dist_inra_cumul := cummin(dist_inra_cumul), cell]

        dt[dist_inra_cumul == Inf, dist_inra_cumul := 3001]

        # Examine to make sure dist_inra_cumul is now correct
        dt[cell == "2282529076", .(year, ever_inra, inra_cohort, dist_inra, dist_inra_cumul)]
        dt[cell == "933816075", .(year, ever_inra, inra_cohort, dist_inra, dist_inra_cumul)]


        dt[, dist_inra := dist_inra_cumul]
        dt[, dist_inra_cumul := NULL]


    # IMPORTANT: Distance variables consistency checks (0 can represent >3000, but this is simple to fix like this)

        colnames(dt)[grepl("dist", colnames(dt))]

        dt[dist_ag == 0 & mb_ag == 0, dist_ag := 3001]
        dt[dist_forest == 0 & mb_forest == 0, dist_forest := 3001]
        dt[dist_urban == 0 & mb != 24, dist_urban := 3001]
        dt[dist_water == 0 & !(mb %in% c(26, 33)), dist_water := 3001]
    
        # Check that these make sense:
        dt[ever_inra == 1, .(mean(dist_inra)), year]
        dt[ever_inra == 0, .(mean(dist_inra)), year]




    # Burned area

        dt[, modis_burned := modis_ba]
        dt[is.na(modis_ba), modis_burned := 0]

        dt[, modis_burned_cumul := cumsum(modis_burned), cell]

        dt[, modis_ever_burned := as.numeric(sum(modis_ba, na.rm = TRUE) > 0), cell]


    # Protected areas

        dt_pa <- data.table::rbindlist(lapply(lapply(filenames$vector$protected_areas$polygons, vect), as.data.frame), id = "source")
        dt_exclude <- fread(paste0(project_path, "data/constructed/csv/WDPA_exclusion.csv"))

        # There are overlaps here (overlapping PA polygons). Nationally designated PAs take precedence

        dt[!is.na(pa_municipal_id), pa_id := pa_municipal_id]
        dt[!is.na(pa_state_id), pa_id := pa_state_id]
        dt[!is.na(pa_national_id), pa_id := pa_national_id]

        dt[dt_exclude, pa_keep := i.Polygons_OK, on = .(pa_id = WDPAID)]
        dt[pa_keep == 1 & !is.na(pa_keep), pa_exclude := 0]
        dt[pa_keep == 0 & !is.na(pa_keep), pa_exclude := 1]

        colnames_pa <- c("source", "STATUS", "STATUS_YR")
        colnames_pa_new <- c("pa_source", "pa_status", "pa_cohort" )

        dt[dt_pa , (colnames_pa_new) := setDT(mget(paste0("i.", colnames_pa))) , on = .(pa_id = WDPAID)]

        dt[, pa_post := as.numeric(year >= pa_cohort)]
        dt[is.na(pa_post), pa_post := 0]


    


    # These will be necessary for subsetting later on. Keep these strictly as last - might edit this procedure

    dt[, rid_nonforest := cumsum(mb_nonforest), cell]

    dt[, mb_forest_diff := c(0, diff(mb_forest)), cell]

    dt[, mb_ref_obs := as.numeric(mb_forest == 0 | mb_forest_diff == 1)]
    dt[, mb_def_obs := as.numeric(mb_forest == 1 | mb_forest_diff == -1)]

    dt[mb_ref_obs == 1, ref_cumsum := cumsum(mb_forest), cell]
    dt[mb_ref_obs == 1, ref_group := ref_cumsum + as.numeric(mb_forest == 0), cell]

    dt[mb_def_obs == 1, def_cumsum := cumsum(mb_nonforest), cell]
    dt[mb_def_obs == 1, def_group := def_cumsum + as.numeric(mb_forest == 1), cell]

    # Save

    dt |> fwrite(out_file)


}