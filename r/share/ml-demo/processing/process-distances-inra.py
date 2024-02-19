
from datetime import datetime
import pandas as pd
import csv
import numpy as np

processing.algorithmHelp("gdal:proximity")
feedback = QgsProcessingFeedback()

project_path = 'E:/Dropbox/Dropbox/GitHub/bioadd-wp2-github/'

r_path = project_path + 'data/constructed/raster/misc/ml-demo/inra_rasterized_cohort.tif'

# Here is a very awkward way of finding the unique values of the cohort raster

v_mask_path = project_path + 'data/constructed/raster/misc/ml-demo/bolivia_mask_polygon.gpkg'
temp_out_path = 'E:/temp/temp.csv'

params = {
    'INPUT_RASTER':r_path,
    'RASTER_BAND':1,
    'INPUT_VECTOR':v_mask_path,
    'COLUMN_PREFIX':
    'HISTO_',
    'OUTPUT':temp_out_path}

processing.run("native:zonalhistogram", params)

df = pd.read_csv(temp_out_path)
histo_columns = [col for col in df.columns if col.startswith('HISTO_')]
years = [int(col.replace('HISTO_', '')) for col in histo_columns]

for year in years:
    
    print(str(datetime.now()) + ' | ' + str(year))
    
    out_path = 'D:/bioadd-wp2/data/constructed/raster/distances/inra/inra_distance_' + str(year) + '.tif'

    params = {
            'INPUT': r_path,
            'BAND': 1,
            'VALUES': year, # Compute distance for raster pixel values of 0
            'MAX_DISTANCE': 3000, # Max distance
            'REPLACE': 0, # Output value for no_data cells
            'NODATA': 0, # No_data value in output raster
            'OPTIONS': 'COMPRESS=LZW', # Enable LZW compression
            'DATA_TYPE': 2, # UInt16
            'OUTPUT': out_path
        }
        
    result = processing.run("gdal:proximity", params, feedback=feedback)


  