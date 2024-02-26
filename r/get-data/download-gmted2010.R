
for (i in c("mn", "md", "sd")) {

    url <- paste0("https://edcintl.cr.usgs.gov/downloads/sciweb1/shared/topo/downloads/GMTED/Grid_ZipFiles/", i, "75_grd.zip")

    destination_path <- paste0(project_path, "data/raw/raster/gmted2010/", basename(url))

    download.file(
        url = url,
        destfile = destination_path,
        mode = "wb"
        )

    unzip(zipfile = destination_path, exdir = gsub(".zip", "/", destination_path))


}

