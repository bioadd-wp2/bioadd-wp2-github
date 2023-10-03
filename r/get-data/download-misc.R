# GADM 4.1 administrative boundaries

download.file(
	url = "https://geodata.ucdavis.edu/gadm/gadm4.1/gpkg/gadm41_BOL.gpkg",
	destfile = paste0(project_path, "data/raw/gpkg/gadm41_BOL.gpkg"),
	mode = "wb"
	)



### WFS requests from GeoBolivia server
# The WFS request URL is obtained from the GeoBolivia data viewer: Add the layer to the viewer -> Actions -> Download layer -> SHAPE-ZIP

# Roads and railways 2016
download.file(
	url = "https://geo.gob.bo/geoserver/igm/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&TYPENAME=igm%3ACAMINOS_Y_VIA_FERREA&OUTPUTFORMAT=SHAPE-ZIP",
    destfile = paste0(project_path, "data/raw/shp/CAMINOS_Y_VIA_FERREA.zip"),
    mode = "wb"
    )

# Roads 2001
download.file(
	url = "https://geo.gob.bo/geoserver/mddryt/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&TYPENAME=mddryt%3ACaminos&OUTPUTFORMAT=SHAPE-ZIP",
	destfile = paste0(project_path, "data/raw/shp/Caminos.zip"),
	mode = "wb"
	)

# Electric power distribution map
download.file(
	url = "https://geo.gob.bo/geoserver/autoridadelectricidad/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&TYPENAME=autoridadelectricidad%3Aareas_operacion2013&OUTPUTFORMAT=SHAPE-ZIP",
	destfile = paste0(project_path, "data/raw/shp/areas_operacion2013.zip"),
	mode = "wb"
	)

### Protected areas, national
# 2014
download.file(
	url = "https://geo.gob.bo/geoserver/sernap/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&TYPENAME=sernap%3Aap_nacional_wgs84_2014&OUTPUTFORMAT=SHAPE-ZIP",
	destfile = paste0(project_path, "data/raw/shp/ap_nacional_wgs84_2014.zip"),
	mode = "wb"
	)

# 2015
download.file(
	url = "https://geo.gob.bo/geoserver/sernap/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&TYPENAME=sernap%3Aareas_protegidas_nacionales042015&OUTPUTFORMAT=SHAPE-ZIP",
	destfile = paste0(project_path, "data/raw/shp/areas_protegidas_nacionales042015.zip"),
	mode = "wb"
	)

# 2016
download.file(
	url = "https://geo.gob.bo/geoserver/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&TYPENAME=sernap%3Aareasprotegidas_nacionales2016&OUTPUTFORMAT=SHAPE-ZIP",
	destfile = paste0(project_path, "data/raw/shp/areasprotegidas_nacionales2016.zip"),
	mode = "wb"
	)

# 2017
download.file(
	url = "https://geo.gob.bo/geoserver/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&TYPENAME=sernap%3Aareasprotegidas_nacionales2017&OUTPUTFORMAT=SHAPE-ZIP",
	destfile = paste0(project_path, "data/raw/shp/areasprotegidas_nacionales2017.zip"),
	mode = "wb"
	)

# 2018
download.file(
	url = "https://geo.gob.bo/geoserver/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&TYPENAME=sernap%3AAreaProtegida_Nacional_2018&OUTPUTFORMAT=SHAPE-ZIP",
	destfile = paste0(project_path, "data/raw/shp/AreaProtegida_Nacional_2018.zip"),
	mode = "wb"
	)


### Protected areas, state
# 2002
download.file(
	url = "https://geo.gob.bo/geoserver/sernap/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&TYPENAME=sernap%3AAPs_departamentales&OUTPUTFORMAT=SHAPE-ZIP",
	destfile = paste0(project_path, "data/raw/shp/APs_departamentales.zip"),
	mode = "wb"
	)

# 2012
download.file(
	url = "https://geo.gob.bo/geoserver/sernap/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&TYPENAME=sernap%3Aap_departamentales_wgs84_2012&OUTPUTFORMAT=SHAPE-ZIP",
	destfile = paste0(project_path, "data/raw/shp/ap_departamentales_wgs84_2012.zip"),
	mode = "wb"
	)

# 2015
download.file(
	url = "https://geo.gob.bo/geoserver/sernap/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&TYPENAME=sernap%3Aareas_protegidas_departamentales42015&OUTPUTFORMAT=SHAPE-ZIP",
	destfile = paste0(project_path, "data/raw/shp/areas_protegidas_departamentales42015.zip"),
	mode = "wb"
	)


### Protected areas, municipal
# 2002
download.file(
	url = "https://geo.gob.bo/geoserver/sernap/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&TYPENAME=sernap%3AAPs_municipales&OUTPUTFORMAT=SHAPE-ZIP",
	destfile = paste0(project_path, "data/raw/shp/APs_municipales.zip"),
	mode = "wb"
	)

# 2012
download.file(
	url = "https://geo.gob.bo/geoserver/sernap/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&TYPENAME=sernap%3Aap_municipaleswgs84_2012&OUTPUTFORMAT=SHAPE-ZIP",
	destfile = paste0(project_path, "data/raw/shp/ap_municipaleswgs84_2012.zip"),
	mode = "wb"
	)

# 2015
download.file(
	url = "https://geo.gob.bo/geoserver/sernap/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&TYPENAME=sernap%3Aareas_protegidas_municipales042015&OUTPUTFORMAT=SHAPE-ZIP",
	destfile = paste0(project_path, "data/raw/shp/areas_protegidas_municipales042015.zip"),
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


