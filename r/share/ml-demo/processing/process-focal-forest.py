from datetime import datetime
import os
from qgis.core import QgsProcessingFeedback, QgsApplication
import processing

processing.algorithmHelp("grass7:r.neighbors")

# Initialize QGIS Application if not already done (outside of QGIS Desktop)
# QgsApplication.setPrefixPath("/path/to/qgis", True)
# qgs = QgsApplication([], False)
# qgs.initQgis()

# Your project path and directories
project_path = 'E:/Dropbox/Dropbox/GitHub/bioadd-wp2-github/'
r_dir = project_path + 'data/constructed/raster/mapbiomas-forest-bin/'
r_files = os.listdir(r_dir)

feedback = QgsProcessingFeedback()

for r in r_files:
    print(str(datetime.now()) + ' | ' + r)
    r_path = os.path.join(r_dir, r)
    out_path = os.path.join(project_path, 'data/constructed/raster/focal/forest/', r)

    # Parameters for r.neighbors to calculate mean within a 67-pixel window
    # Adjust 'size' parameter as needed to approximate a 67-pixel window
    params = {
        'input': r_path,
        'output': out_path,
        'method': 0,  # Method to calculate the mean
        'size': 67  # This should be adjusted based on the resolution to approximate a 67-pixel window
    }

    result = processing.run("grass7:r.neighbors", params, feedback=feedback)

# If running outside QGIS Desktop, finalize the QGIS application
# qgs.exitQgis()




