#######################################################################
### Set filenames
#######################################################################

# All filenames are collected to a list

filenames <- list()

filenames$raster <- list()
filenames$vector <- list()
filenames$csv <- list()


################################
### Raw data

### Raster layers

filenames$raster$mapbiomas <- lapply(setNames(                                   # Assigns a named list that refers to filenames
            as.list(paste0("bolivia_coverage_", 1985:2021, ".tif")),             # Filenames in folder
            paste0("bolivia_", 1985:2021)                                        # Respective names for list elements
        ), function(x) paste0(project_path, "data/raw/raster/mapbiomas/", x))    # Folder path    


### Vector layers

### Csv files

################################
### Constructed data

### Raster layers

### Vector layers

### Csv files

################################
### Check that files exist

if (length(lapply(unlist(filenames), file.exists)) > 0) {
    if (sum(lapply(unlist(filenames), file.exists) == FALSE) == 0) {
        cat("All files found\n")
    } else {
        missing_idx <- which(lapply(unlist(filenames), file.exists) == FALSE)
        cat("Missing files:\n")
        for (i in 1:length(missing_idx)) cat(paste0(unlist(filenames)[1]), "\n")
    }
} else {
    cat("No filenames defined\n")
}

cat("filenames.R done\n")