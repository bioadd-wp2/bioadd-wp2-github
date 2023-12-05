#
# Survival length of forest after gain event
#
# Inputs:
#     Forest gain and loss annual transitions, produced in get-transitions.R
# Output:
#     One layer per year. Value for year i:
#     > 0 : Transition to forest in year i. The value indicates the survival length of that forest in years. E.g. 1 = deforestation in year i+1. 2 = deforestation in year i+2. Max value is always 2022-i.
#       0 : No transition to forest in year i.
#

forest_gain_folder <- paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-gain/")
forest_loss_folder <- paste0(project_path, "data/constructed/raster/mapbiomas-transitions/forest-loss/")


# This function calculates survival lengths for one forest gain cohort.

getSurvivalLength <- function(year_gain, out_folder) {

    # Dependencies: terra

    # Vector of years remaining in data after the gain cohort
    years_loss <- (year_gain + 1):2021
    max_survival_len <- length(years_loss) + 1

    # Load the gain raster and the subsequent loss rasters
    r_gain <- terra::rast(paste0(forest_gain_folder,  "forest_gain_", year_gain, ".tif"))
    r_loss <- lapply(paste0(forest_loss_folder, "forest_loss_", years_loss, ".tif"), terra::rast)

    # loss_idx : The index or first year of forest loss.
    
    # Initialize with the first loss year. The index is already correct for the first year    

    loss_idx <- r_loss[[1]]

    # Loop over any remaining years to determine the year of forest loss
    # Logic:
    # Assign current value as default
    # IF forest was not previously lost (loss_idx == 0); 
    # AND IF forest loss in year j (r_loss[[j]] is binary and indicates these pixels)
    #     assign the index j

    t0 <- Sys.time()

    if (length(years_loss) > 1) {
        for (j in 2:length(years_loss)) loss_idx <- loss_idx + as.numeric(loss_idx == 0) * r_loss[[j]] * j
    }

    t1 <- Sys.time()


    loss_idx <- r_loss[[1]]

    t00 <- Sys.time()

    if (length(years_loss) > 1) {
        for (j in 2:length(years_loss)) loss_idx[loss_idx == 0 & r_loss[[j]] == 1] <- j
    }

    t11 <- Sys.time()

    t1 - t0
    t11 - t00

    # Convert the index to survival length.
    # Logic:
    # IF recorded gain
    # AND
    #     IF loss was recorded
    #         assign loss_idx which indicates the survival length
    #     ELSE (IF loss was not recorded)
    #         assign maximum survival length value

    t0 <- Sys.time()
    survival_len <- r_gain * ( loss_idx + as.numeric(loss_idx == 0)*max_survival_len )
    t1 <- Sys.time()

    t00 <- Sys.time()
    survival_len <- r_gain
    survival_len[survival_len == 1 & loss_idx != 0] <- loss_idx
    survival_len[survival_len == 1 & loss_idx == 0] <- max_survival_len
    t11 <- Sys.time()


    # Save to disk
    survival_len |> terra::writeRaster(paste0(out_folder, "survival_len_", year_gain, ".tif"), overwrite = TRUE)

    # Explicit exit status
    return(0)

}



output_folder <- paste0(project_path, "data/constructed/raster/mapbiomas-transitions/survival-len/")

# This took 11.7 hours on 4 cores on 32GB and 5900X

# Around 10 hours with 6 cores

t0 <- Sys.time()
registerDoParallel(cores = 6)

    foreach(year_gain = 1986:2020, .packages = c("terra")) %dopar% {
        getSurvivalLength(year_gain = year_gain, out_folder = output_folder)
    }

stopImplicitCluster()
t1 <- Sys.time()
t1-t0

