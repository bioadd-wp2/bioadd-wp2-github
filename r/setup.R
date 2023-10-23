# 2023/09/22
# Ville Inkinen
# BIOADD Work Package 2
#
# This script initializes the work environment:
#   - defines file paths; creates folders if necessary
#   - imports packages
#   - defines user functions
#
# Start every session by running this script

# Clear environment
rm(list = ls())
gc()

# bioadd-wp2-paths.txt must exist in the R working directory and it must specify the local clone directory of the GitHub repository and the project Dropbox path. See INSTRUCTIONS.txt
project_path <- readLines("bioadd-wp2-paths.txt", warn = FALSE)[1]
dropbox_path <- readLines("bioadd-wp2-paths.txt", warn = FALSE)[2]
cat("project_path set to:", project_path, "\n")
cat("dropbox_path set to:", dropbox_path, "\n")

# Description in each script
source(paste0(project_path, "r/setup/filenames.R"))
source(paste0(project_path, "r/setup/get-folders.R"))
source(paste0(project_path, "r/setup/packages.R"))
source(paste0(project_path, "r/setup/user-functions.R"))

cat("setup.R done\n")


