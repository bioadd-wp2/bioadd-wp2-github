#
# 2023/09/25
# Ville Inkinen
#
# This script downloads data and documents the data acquisition when a direct download is not available


#######################################################################
### Downloads

# The download of a single file must finish within the timeout value (seconds). You can indrease this value if you get timeout errors. 
options(timeout = 600) 

# Download Mapbiomas Bolivia
source(paste0(project_path, "r/get-data/download-mapbiomas.R"))

# Download Hansen
source(paste0(project_path, "r/get-data/download-hansen.R"))




#######################################################################
### Other data sources