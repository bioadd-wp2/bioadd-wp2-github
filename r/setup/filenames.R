#######################################################################
### Set filenames
#######################################################################

# All filenames are collected to a list

filenames <- list()

filenames$raster <- list()
filenames$vector <- list()
filenames$csv <- list()

### Raster layers

filenames$raster$mapbiomas <- lapply(setNames(                                   # Assigns a named list
            as.list(paste0("bolivia_coverage_", 1985:2021, ".tif")),             # Filenames in folder
            paste0("bolivia_", 1985:2021)                                        # Respective names for list elements
        ), function(x) paste0(project_path, "data/raw/raster/mapbiomas/", x))    # Folder path    

filenames$raster$mapbiomas_transitions <- lapply(setNames(                                   
            as.list(paste0("bolivia_transitions_", 1985:2020, "_", 1986:2021, ".tif")),
            paste0("bolivia_transitions_", 1986:2021)                            # Naming by the transition end year
        ), function(x) paste0(project_path, "data/raw/raster/mapbiomas-transitions/", x))

filenames$raster$gmted <- lapply(list(
    mean = "mn75_grd/mn75_grd/w001001.adf",
    median = "md75_grd/md75_grd/w001001.adf",
    sd = "sd75_grd/sd75_grd/w001001.adf"
    ), function(x) paste0(project_path, "data/raw/raster/gmted2010/", x))

filenames$raster$nightlights <- lapply(setNames(                                       # Assigns a named list
        as.list(c(
            paste0("Harmonized_DN_NTL_", 1992:2013, "_calDMSP.tif"),
            paste0("Harmonized_DN_NTL_", 2014:2021, "_simVIIRS.tif")
            )),                                                                        # Filenames in folder
        paste0("nightlights_harmonized_", 1992:2021)                                   # Respective names for list elements
    ), function(x) paste0(project_path, "data/raw/raster/nightlights/harmonized/", x)) # Folder path    


### Vector layers

filenames$vector$gadm <- paste0(project_path, "data/raw/gpkg/gadm41_BOL.gpkg")

filenames$vector$inra <- lapply(list(
    fixed = "INRA_titulados_resaved_fixed",
    simplified = "INRA_titulados_resaved_fixed_simplified"
    ), function(x) paste0(project_path, "data/constructed/gpkg/", x, ".gpkg"))

filenames$vector$protected_areas$points <- lapply(list(
    national = "WDPA_WDOECM_Feb2024_Public_BOL_shp_0",
    state ="WDPA_WDOECM_Feb2024_Public_BOL_shp_1",
    municipal = "WDPA_WDOECM_Feb2024_Public_BOL_shp_2"
    ), function(x) paste0(project_path, "data/raw/shp/WDPA_WDOECM_Feb2024_Public_BOL_shp/", x, "/WDPA_WDOECM_Feb2024_Public_BOL_shp-points.shp"))

filenames$vector$protected_areas$polygons <- lapply(list(
    national = "WDPA_WDOECM_Feb2024_Public_BOL_shp_0",
    state ="WDPA_WDOECM_Feb2024_Public_BOL_shp_1",
    municipal = "WDPA_WDOECM_Feb2024_Public_BOL_shp_2"
    ), function(x) paste0(project_path, "data/raw/shp/WDPA_WDOECM_Feb2024_Public_BOL_shp/", x, "/WDPA_WDOECM_Feb2024_Public_BOL_shp-polygons.shp"))



filenames$vector$firms <- paste0(project_path, "data/constructed/gpkg/firms_bolivia.gpkg")
filenames$vector$firms_polygons <- paste0(project_path, "data/constructed/gpkg/firms_polygons_bolivia.gpkg")

filenames$vector$roads_2001 <- paste0(project_path, "data/raw/shp/Caminos/Caminos.shp")
filenames$vector$roads_2016 <- paste0(project_path, "data/raw/shp/CAMINOS_Y_VIA_FERREA/CAMINOS_Y_VIA_FERREA.shp")


### Csv files

filenames$csv$mapbiomas_colors <- paste0(project_path, "data/constructed/csv/mapbiomas_colors.csv")

filenames$csv$electricity_utilities <- paste0(project_path, "data/raw/csv/bolivia-electricity-utilities/")



################################
### Check that files exist

if (length(lapply(unlist(filenames), file.exists)) > 0) {
    if (sum(lapply(unlist(filenames), file.exists) == FALSE) == 0) {
        cat("All files found\n")
    } else {
        missing_idx <- which(lapply(unlist(filenames), file.exists) == FALSE)
        cat("Missing files:\n")
        for (i in 1:length(missing_idx)) cat(paste0(names(unlist(filenames)[missing_idx[i]]), " | ", unlist(filenames)[missing_idx[i]]), "\n")
    }
} else {
    cat("No filenames defined\n")
}

cat("filenames.R done\n")