

# Read data

dt <- fread(filenames$ml_demo$master_dt, colClasses = c(cell = "numeric"))

in_folder <- paste0(project_path, "data/constructed/csv/ml-demo-extracted/")

e_list <- lapply(list.files(in_folder, recursive = TRUE, full.names = TRUE), fread, colClasses = c(cell = "numeric"))


for (i in 1:length(e_list)) {

    names_i <- names(e_list[[i]])

    if (!("cell" %in% names_i) | !("year" %in% names_i)) {

        print("Error: Input column names not as expected. Data not joined to master.")

    } else {

        varnames <- names_i[!(names_i %in% c("cell", "year"))]

        dt[e_list[[i]], (varnames) := setDT(mget(paste0("i.", varnames))), on = .(cell, year)]

    }

}


dt |> fwrite(filenames$ml_demo$master_dt)

