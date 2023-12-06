#
# Survival length of land cover classification after transitioning to it
#
# Inputs:
#     Gain and loss transitions for a land cover class
# Output:
#     One layer per year. Value for year i:
#     > 0 : Transition to class in year i. The value indicates the survival length of that land cover class in years. E.g. for forest, 1 = deforestation in year i+1. 2 = deforestation in year i+2. Max value is always 2022-i.
#       0 : No transition to the land cover class in year i.
#

# This function calculates survival lengths for one gain cohort

getSurvivalLength <- function(year_gain, files_gain, files_loss, out_folder) {

    # Vector of years remaining in data after the gain cohort
    years_loss <- (year_gain + 1):2021
    max_survival_len <- length(years_loss) + 1

    # Load the gain raster and the subsequent loss rasters
    r_gain <- terra::rast(files_gain[[as.character(year_gain)]])
    r_loss <- lapply(files_loss[as.character(years_loss)], terra::rast)

    # loss_idx : indicates the year of loss
    
    # Initialize with the first loss year. The index is already correct for the first year    

    loss_idx <- r_loss[[1]]

    # Loop over any remaining years to determine the year of forest loss
    # Logic:
    # Assign current value as default
    # IF no previous change (loss_idx == 0); 
    # AND change in year j (r_loss[[j]] is binary and indicates these pixels)
    #     assign the index j

    if (length(years_loss) > 1) {
        for (j in 2:length(years_loss)) loss_idx <- loss_idx + as.numeric(loss_idx == 0) * r_loss[[j]] * j
    }

    # Convert the index to survival length
    # Logic:
    # IF recorded gain
    # AND
    #     IF loss was recorded
    #         assign loss_idx which indicates the survival length
    #     ELSE (IF loss was not recorded)
    #         assign maximum survival length value

    survival_len <- r_gain * ( loss_idx + as.numeric(loss_idx == 0)*max_survival_len )

    # Save to disk
    survival_len |> terra::writeRaster(paste0(out_folder, "survival_len_", year_gain, ".tif"), overwrite = TRUE)

    # Explicit exit status
    return(0)

}


### Define file paths

# These must be named lists
forest_gain_files <- as.list(list.files(paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-gain/"), full.names = TRUE))
forest_loss_files <- as.list(list.files(paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-loss/"), full.names = TRUE))

names(forest_gain_files) <- 1986:2021
names(forest_loss_files) <- 1986:2021


### Forest

output_folder <- paste0(project_path, "data/constructed/raster/mapbiomas-transitions/survival-len-forest/")
if (!dir.exists(output_folder)) dir.create(output_folder)

# This took 10 hours on 6 cores on 32GB and 5900X

registerDoParallel(cores = 6)

    foreach(year_gain = 1986:2020, .packages = c("terra")) %dopar% {
        getSurvivalLength(year_gain = year_gain, files_gain = forest_gain_files, files_loss = forest_loss_files, out_folder = output_folder)
    }

stopImplicitCluster()



### Non-forest
# Note: This is simply reversing the gain and loss files

output_folder <- paste0(project_path, "data/constructed/raster/mapbiomas-transitions/survival-len-nonforest/")
if (!dir.exists(output_folder)) dir.create(output_folder)

registerDoParallel(cores = 6)

    foreach(year_gain = 1986:2020, .packages = c("terra")) %dopar% {
        getSurvivalLength(year_gain = year_gain, files_gain = forest_loss_files, files_loss = forest_gain_files, out_folder = output_folder)
    }

stopImplicitCluster()

