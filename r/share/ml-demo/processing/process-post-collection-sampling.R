

dt <- fread(filenames$ml_demo$master_dt_collected, colClasses = c(dist_inra = "numeric"))



# Ref only

dt[ever_ref == 1] |> fwrite(filenames$ml_demo$master_dt_collected_everref)


# Sample from all observations to cut down file size and processing time

if (FALSE){
    set.seed(1000)
    sampled_cells <- sample(dt[year == 1985]$cell, size = 200000, replace = FALSE)

    dt <- copy(dt[cell %in% sampled_cells])
    gc()
}

dt |> fwrite(filenames$ml_demo$master_dt_collected_sampled)

rm(dt)
gc()
