
from datetime import datetime

processing.algorithmHelp("gdal:proximity")

feedback = QgsProcessingFeedback()

project_path = 'E:/Dropbox/Dropbox/GitHub/bioadd-wp2-github/'

r_dir = project_path + 'data/constructed/raster/mapbiomas-forest-bin/'
r_files = os.listdir(r_dir)

for r in r_files:
    
    print(str(datetime.now()) + ' | ' + r)
    
    r_path = r_dir + r
    
    out_path = 'D:/bioadd-wp2/data/constructed/raster/distances/nonforest/' + r

    params = {
            'INPUT': r_path,
            'BAND': 1,
            'VALUES': 0, # Compute distance for raster pixel values of 0
            'MAX_DISTANCE': 3000, # Max distance
            'REPLACE': 0, # Output value for no_data cells
            'NODATA': 0, # No_data value in output raster
            'OPTIONS': 'COMPRESS=LZW', # Enable LZW compression
            'DATA_TYPE': 2, # UInt16
            'OUTPUT': out_path
        }
        
    result = processing.run("gdal:proximity", params, feedback=feedback)

