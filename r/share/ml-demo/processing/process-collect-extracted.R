
# Read data

dt <- fread(filenames$ml_demo$master_dt, colClasses = c(cell = "numeric"))

e_list <- list.files(paste0(project_path, "data/constructed/csv/ml-demo-extracted/"), recursive = TRUE, full.names = TRUE)

# Possible to sample here if the size grows too large

# Join extracted data to master

for (i in 1:length(e_list)) {

    e_list_i <- fread(e_list[i], colClasses = c(cell = "numeric"))
    names_i <- names(e_list_i)

    if (!("cell" %in% names_i) | !("year" %in% names_i)) {

        print("Error: Input column names not as expected. Data not joined to master.")

    } else {

        varnames <- names_i[!(names_i %in% c("cell", "year"))]

        cat(paste0(Sys.time(), " | ", varnames, " | ", i, " / ", length(e_list), "\n"))

        dt[e_list_i, (varnames) := setDT(mget(paste0("i.", varnames))), on = .(cell, year)]

    }

    rm(e_list_i)
    gc()

}

rm(e_list)
gc()

# Save

dt |> fwrite(filenames$ml_demo$master_dt_collected)
