
s <- fread(filenames$ml_demo$sample, colClasses = c(cell = "numeric"))

dt <- CJ(cell = s$cell, year = 1985:2021)

update_cols <- c("ever_ref")
dt[s, (update_cols) := setDT(mget(paste0("i.", update_cols))), on = .(cell)]


dt |> fwrite(filenames$ml_demo$master_dt)
