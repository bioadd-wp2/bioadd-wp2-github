# GADM 4.1 administrative boundaries

download.file(
	url = "https://geodata.ucdavis.edu/gadm/gadm4.1/gpkg/gadm41_BOL.gpkg",
	destfile = paste0(project_path, "data/raw/gpkg/"),
	mode = "wb"
	)



# Roads and railways 2016

download.file(
	url = "https://geo.gob.bo/geoserver/igm/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&TYPENAME=igm%3ACAMINOS_Y_VIA_FERREA&OUTPUTFORMAT=SHAPE-ZIP",
	destfile = paste0(project_path, "data/raw/shp/"),
	mode = "wb"
	)



curl_download(url = "https://geo.gob.bo/geoserver/igm/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&TYPENAME=igm%3ACAMINOS_Y_VIA_FERREA&OUTPUTFORMAT=SHAPE-ZIP",
              destfile = paste0(project_path, "data/raw/shp/")
              )


