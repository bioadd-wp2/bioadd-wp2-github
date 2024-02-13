

for (i in 2000:2020) {

    download.file(
        url = paste0("https://data.worldpop.org/GIS/Population_Density/Global_2000_2020_1km_UNadj/", i, "/BOL/bol_pd_", i, "_1km_UNadj.tif"),
        destfile = paste0(project_path, "data/raw/raster/worldpop/bol_pd_", i, "_1km_UNadj.tif"),
        mode = "wb"
        )

}

