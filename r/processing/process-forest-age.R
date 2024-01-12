#
# Age of standing forest
#
# Inputs:
#     Mapbiomas land cover
# Output:
#     One layer per year. Value for year i:
#     > 0 : Is forest in year i. Value indicates the age of the forest. E.g. for forest, 1 = deforestation in year i+1. 2 = deforestation in year i+2. Max value is always 2022-i.
#       0 : Not forest in year i.
#


# This function calculates forest age for one cohort

getAge <- function(year, files_mapbiomas, out_folder) {

    # Vector of years in data before year i
    years <- 1985:(year)
    max_age <- length(years)

    # Load mapbiomas

    r_list <- lapply(files_mapbiomas, rast)

    # Initialize age

    r_age <- as.numeric(r_list[[paste0("bolivia_", year)]] %in% c(3,6)) * max_age

    # Iteratively determine age

    if (length(years) > 1) {

        for (i in 1:(length(years)-1)) {

            year_i <- years[length(years)-i]
            r_age[r_age == max_age & !(r_list[[paste0("bolivia_", year_i)]] %in% c(3,6))] <- i

        }

    }

    # Save to disk
    r_age |> terra::writeRaster(paste0(out_folder, "forest_age_", year, ".tif"), overwrite = TRUE)

    # Exit status
    return(0)

}


# Define file paths

output_folder <- paste0(project_path, "data/constructed/raster/mapbiomas-forest-age/")
if (!dir.exists(output_folder)) dir.create(output_folder)

# Parallelize
# This took X hours on 6 cores on 32GB and 5900X

t0 <- Sys.time()

registerDoParallel(cores = 6)

    foreach(years = 1985:2021, .packages = c("terra")) %dopar% {
        getAge(year = years, files_mapbiomas = filenames$raster$mapbiomas, out_folder = output_folder)
    }

stopImplicitCluster()

t1 <- Sys.time()

t1-t0
