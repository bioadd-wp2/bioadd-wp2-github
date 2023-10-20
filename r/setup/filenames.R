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
            paste0("bolivia_transitions_", 1986:2021)                            # Naming by end year
        ), function(x) paste0(project_path, "data/raw/raster/mapbiomas-transitions/", x))

filenames$raster$gmted <- lapply(list(
    mean = "mn75_grd/mn75_grd/w001001.adf",
    sd = "ds75_grd/ds75_grd/w001001.adf"
    ), function(x) paste0(project_path, "data/raw/raster/gmted2010/", x))


### Vector layers

filenames$vector$gadm <- paste0(project_path, "data/raw/gpkg/gadm41_BOL.gpkg")

filenames$vector$inra <- lapply(list(
    fixed = "INRA_titulados_resaved_fixed",
    simplified = "INRA_titulados_resaved_fixed_simplified"
    ), function(x) paste0(project_path, "data/constructed/gpkg/", x, ".gpkg"))


filenames$vector$protected_areas <- lapply(list(
    national_2014 = "ap_nacional_wgs84_2014",
    national_2015 = "areas_protegidas_nacionales042015",
    national_2016 = "areasprotegidas_nacionales2016",
    national_2017 = "areasprotegidas_nacionales2017",
    national_2018 = "AreaProtegida_Nacional_2018",
    state_2002 = "APs_departamentales",
    state_2012 = "ap_departamentales_wgs84_2012",
    state_2015 = "areas_protegidas_departamentales42015",
    municipal_2002 = "APs_municipales",
    municipal_2012 = "ap_municipaleswgs84_2012",
    municipal_2015 = "areas_protegidas_municipales042015"
    ), function(x) paste0(project_path, "data/raw/shp/", x, "/", x, ".shp"))


### Csv files

filenames$csv$mapbiomas_colors <- paste0(project_path, "data/constructed/csv/mapbiomas_color_codes.csv")

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