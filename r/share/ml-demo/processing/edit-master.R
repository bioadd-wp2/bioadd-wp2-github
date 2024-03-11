
editMaster <- function(in_file, out_file, debug = FALSE){

    t0 <- Sys.time()
    cat(paste0(t0, " | Editing data\n"))

    if (is.null(in_file) | is.null(out_file)) stop("Invalid filenames")

    # Read data

    dt <- fread(in_file, colClasses = c(dist_inra = "numeric"))

    if (debug == TRUE) dt <- copy(dt[cell %in% sample(unique(dt$cell), 10000, replace = FALSE)])

    # Edits

    dt[, n_def := sum(mb_def, na.rm = TRUE), cell]
    dt[, n_ref := sum(mb_ref, na.rm = TRUE), cell]

    dt[, ever_def := as.numeric(n_def > 0), cell]

    dt[, mb_forest := as.numeric(mb %in% c(3, 6))]
    dt[, mb_nonforest := as.numeric(!(mb %in% c(3, 6)))]
    dt[, mb_natural_nonforest := as.numeric(mb %in% c(11,12,13))]
    dt[, mb_nonnatural := as.numeric(mb %in% c(15,18,21,24,25,30))]
    dt[, mb_ag := as.numeric(mb %in% c(15, 18, 21))]

    dt[, mb_change := as.numeric(c(0, diff(mb)) != 0), cell]

    dt[, mb_ref_idx := cumsum(c(0, mb_ref[-1]))*mb_forest, cell] # index of reforestation event
    dt[, mb_def_idx := cumsum(c(0, mb_def[-1]))*mb_nonforest, cell] # index of deforestation event

    dt[, mb_ref_slen := sum(mb_forest) * as.numeric(mb_ref_idx > 0), by = .(cell, mb_ref_idx)]
    dt[, mb_def_slen := sum(mb_nonforest) * as.numeric(mb_def_idx > 0), by = .(cell, mb_def_idx)]

    dt[, mb_char := as.character(mb)] # ranger handles this nicely (creates indicators); will be fed as a baseline variable

    # Mapbiomas transitions variables, including survival lengths

        if (FALSE) {

        dt[, ever_ref_tr := as.numeric(sum(mbtr_ref, na.rm = TRUE) > 0), cell]
        dt[, ever_def_tr := as.numeric(sum(mbtr_def, na.rm = TRUE) > 0), cell]

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

        }

    # Sums over previous 15 years, rolling sum
    
    for (var in c("forest", "nonforest", "nonnatural", "natural_nonforest", "ag", "change")) {

        varname_mb <- paste0("mb_", var)
        varname_15_sum <- paste0("mb_sum15_", var)

        dt[, (varname_15_sum) := frollsum(get(varname_mb), 15, align = "right", fill = NA), cell]

    }


    # Years since forest etc
    # The variable must be binary

    for (var in c("forest", "nonforest", "nonnatural", "natural_nonforest", "ag", "change")) {

        varname_mb <- paste0("mb_", var)
        varname_years_since <- paste0("mb_years_since_", var)

        dt[, mb_temp := get(varname_mb)]
        dt[, rleid_temp := data.table::rleid(mb_temp), cell]

        dt[, (varname_years_since) := pmin(as.numeric(mb_temp == 0)*cumsum(as.numeric(mb_temp == 0)), 15), .(cell, rleid_temp)]

        dt[, mb_temp := NULL]
        dt[, rleid_temp := NULL]

    }

    # Lags
    # Still experimenting with this; full history consumes disk space

    for (var in c("mb", "density_forest", "density_200_forest")) {

        print(var)
        dt[, tempvar := get(var)]

        for (i in 1:15) {

            print(paste0(Sys.time(), "| ", i))
            varname <- paste0(var, "_lag_", i)
            dt[, (varname) := c(rep(NA, i), tempvar[-( (length(tempvar)-i+1):(length(tempvar)) )]), cell]

            #dt[, (varname) := lag(tempvar, n = i), cell]

        }

        dt[, tempvar := NULL]

    }

    for (i in 1:15) {

        varname <- paste0("mb_lag_", i)
        dt[, tempvar := get(varname)]
        dt[, (varname) := as.character(tempvar)]
        dt[, tempvar := NULL]

    }

    # Propagate various time-invariant variables by cell

    vars <- c("pa_national_id", "pa_state_id", "pa_municipal_id", "inra_objectid", "gmted_mean", "gmted_sd", "density_200_road_pri", "density_200_road_sec", "density_200_road_ter", "density_road_pri", "density_road_sec", "density_road_ter", "dist_road_pri", "dist_road_sec", "dist_road_ter")

    for (var in vars) {
        print(var)
        dt[, temp := get(var)]
        if (length(unique(dt[, .(n_unique = length( unique(temp[!is.na(temp)]) )[ !is.na( unique(temp[!is.na(temp)]) ) ]), cell]$n_unique)) > 1) print(paste0("Error in variable ", var, " ; more than one unique value within cell."))
        dt[, (var) := unique(temp[!is.na(temp)]), by = .(cell)]
        dt[, temp := NULL]
    }


    ### INRA property data

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

        dt[, inra_ever := as.numeric(sum(inra_post) > 0), cell]

        table(dt[, .(inra_ever, inra_cohort)])


    # Distance to property

        dt[, dist_inra_cumul := dist_inra]

        dt[inra_ever == 0 & dist_inra_cumul == 0, dist_inra_cumul := 3001]
        dt[inra_ever == 1 & dist_inra_cumul == 0 & year < inra_cohort, dist_inra_cumul := 3001]

        dt[is.na(dist_inra_cumul), dist_inra_cumul := Inf]
        dt[, dist_inra_cumul := cummin(dist_inra_cumul), cell]

        dt[dist_inra_cumul == Inf, dist_inra_cumul := 3001]

        dt[, dist_inra := dist_inra_cumul]
        dt[, dist_inra_cumul := NULL]


        # Check that these make sense:
        dt[inra_ever == 1, .(round(mean(dist_inra))), year]
        dt[inra_ever == 0, .(round(mean(dist_inra))), year]



    # IMPORTANT: Distance variables consistency checks (0 can represent >3000, but this is simple to fix like this)
        # The newer dist variables are unbounded. The bounding was an attempt to save disk space,, now solved; should recalculate these and remove this cde

        colnames(dt)[grepl("dist", colnames(dt))]

        dt[dist_ag == 0 & mb_ag == 0, dist_ag := 3001]
        dt[dist_forest == 0 & mb_forest == 0, dist_forest := 3001]
        dt[dist_urban == 0 & mb != 24, dist_urban := 3001]
        dt[dist_water == 0 & !(mb %in% c(26, 33)), dist_water := 3001]
    


    # Burned area

        dt[is.na(modis_ba), modis_ba := 0]

        dt[, modis_ba_post := as.numeric(cumsum(modis_ba) > 0), cell]
        dt[, modis_ba_ever := as.numeric(sum(modis_ba, na.rm = TRUE) > 0), cell]

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

        dt[, pa_ever := as.numeric(sum(pa_post, na.rm = TRUE) > 0), cell]


    # These will be necessary for subsetting later on. Keep these strictly as last - might edit this procedure

    dt[, rid_nonforest := cumsum(mb_nonforest), cell]
    dt[, rid_nonforest_cumul := cumsum(rid_nonforest), cell]

    dt[, mb_forest_diff := c(0, diff(mb_forest)), cell]

    dt[, mb_ref_obs := as.numeric(mb_forest == 0 | mb_forest_diff ==  1)]
    dt[, mb_def_obs := as.numeric(mb_forest == 1 | mb_forest_diff == -1)]

    dt[mb_ref_obs == 1, ref_cumsum := cumsum(mb_forest), cell] # This catches the reforestation events in the end of each group
    dt[mb_ref_obs == 1, ref_group := ref_cumsum + as.numeric(mb_forest == 0), cell] # This fills out the rest with ones, NA if mb_ref_obs == 0 

    dt[mb_def_obs == 1, def_cumsum := cumsum(mb_nonforest), cell]
    dt[mb_def_obs == 1, def_group := def_cumsum + as.numeric(mb_forest == 1), cell]

    dt[, mb_forest_diff := NULL]
    dt[, mb_ref_obs := NULL]
    dt[, mb_def_obs := NULL]
    dt[, ref_cumsum := NULL]
    dt[, def_cumsum := NULL]

    # Check that this is correct
    # dt[cell == unique(dt[year == 1985 & mb == 3 & ever_ref == TRUE & ever_def == TRUE]$cell)[1], .(mb_forest, mb_ref_obs, ref_cumsum, ref_group, def_group)]

    # Save

    dt |> fwrite(out_file)

    t1 <- Sys.time()
    cat(paste0(Sys.time(), " | edits completed in ", round(t1-t0), " time units\n"))

    return(0)

}