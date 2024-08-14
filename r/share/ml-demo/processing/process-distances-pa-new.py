
from datetime import datetime
import pandas as pd
import csv
import numpy as np
import os

processing.algorithmHelp("gdal:proximity")
feedback = QgsProcessingFeedback()

project_path = 'E:/Dropbox/Dropbox/GitHub/bioadd-wp2-github/'

r_path = project_path + 'data/constructed/raster/protected-areas-cohort/pa-bolivia-truncated.tif'

df = pd.read_csv(project_path + 'data/constructed/csv/pa-cohort-freq.csv')
years = df['value'].tolist()

for year in years:
    
    print(str(datetime.now()) + ' | ' + str(year))
    
    out_folder = 'D:/bioadd-wp2/data/constructed/raster/distances/protected-area-cohort-new/'

    if not os.path.exists(out_folder):
        os.makedirs(out_folder, exist_ok=True)
            
    out_path = out_folder + 'pa_dist_' + str(year) + '.tif'

    params = {
            'INPUT': r_path,
            'BAND': 1,
            'VALUES': year, # Compute distance for raster pixel values of 0
            'MAX_DISTANCE': 5000, # Max distance
            'REPLACE': 0, # Output value for no_data cells
            'NODATA': 0, # No_data value in output raster
            'OPTIONS': 'COMPRESS=LZW', # Enable LZW compression
            'DATA_TYPE': 2, # UInt16
            'OUTPUT': out_path
        }
        
    result = processing.run("gdal:proximity", params, feedback=feedback)


