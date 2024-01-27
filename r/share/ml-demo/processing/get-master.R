
s <- fread(filenames$ml_demo$sample, colClasses = c(cell = "numeric"))

s |> fwrite(filenames$ml_demo$master_dt)
