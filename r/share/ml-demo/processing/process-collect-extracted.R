

# Read data

dt <- fread(filenames$ml_demo$master_dt, colClasses = c(cell = "numeric"))

in_folder <- paste0(project_path, "data/constructed/csv/ml-demo-extracted/")

e_list <- lapply(list.files(in_folder, recursive = TRUE, full.names = TRUE), fread, colClasses = c(cell = "numeric"))


for (i in 1:length(e_list)) {

    names_i <- names(e_list[[i]])

    if (length(names_i) != 3 | !("cell" %in% names_i) | !("year" %in% names_i)) {

        print("Error: input column names not as expected")

    } else {

        varname <- names_i[!(names_i %in% c("cell", "year"))]

        dt[e_list[[i]], (varname) := setDT(mget(paste0("i.", varname))), on = .(cell, year)]

    }

}


dt |> fwrite(filenames$ml_demo$master_dt)

