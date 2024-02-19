feedback = QgsProcessingFeedback()
project_path = 'E:/Dropbox/Dropbox/GitHub/bioadd-wp2-github/'

r_path = project_path + 'data/constructed/raster/misc/ml-demo/roads_2001.tif'

for i in range(1, 4):
    
    print(i)

    out_path = project_path + 'data/constructed/raster/distances/roads/' + 'roads_2001_' + str(i) + '.tif'

    params = {
            'INPUT': r_path,
            'BAND': 1,
            'DISTUNITS': 0, # 0 for Georeferenced units, 1 for Pixels
            'VALUES': i, # Compute distance for raster pixel values of 1
            'MAX_DISTANCE': 0, # No max distance
            'REPLACE': 0, # Output value for no_data cells
            'NODATA': 0, # No_data value in output raster
            'OPTIONS': '',
            'DATA_TYPE': 5, # Float32
            'OUTPUT': out_path
        }
        
    result = processing.run("gdal:proximity", params, feedback=feedback)

