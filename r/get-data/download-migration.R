
# Migration data from Niva et al. 2023, https://doi.org/10.5281/zenodo.7997134

download.file(
    url = "https://zenodo.org/records/7997134/files/raster_netMgr_2000_2019_20yrSum.tif",
    destfile = paste0(project_path, "data/raw/raster/migration/raster_netMgr_2000_2019_20yrSum.tif"),
    mode = "wb"
    )

download.file(
    url = "https://zenodo.org/records/7997134/files/raster_netMgr_2000_2019_3yrSum.tif",
    destfile = paste0(project_path, "data/raw/raster/migration/raster_netMgr_2000_2019_3yrSum.tif"),
    mode = "wb"
    )

download.file(
    url = "https://zenodo.org/records/7997134/files/raster_netMgr_2000_2019_5yrSum.tif",
    destfile = paste0(project_path, "data/raw/raster/migration/raster_netMgr_2000_2019_5yrSum.tif"),
    mode = "wb"
    )

download.file(
    url = "https://zenodo.org/records/7997134/files/raster_netMgr_2000_2019_annual.tif",
    destfile = paste0(project_path, "data/raw/raster/migration/raster_netMgr_2000_2019_annual.tif"),
    mode = "wb"
    )
