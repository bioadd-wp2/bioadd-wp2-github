
### Setup


### File Paths

# Code for the demo located in its own folder
ml_demo_path <- paste0(project_path, "r/share/ml-demo/")

# Path for external data storage. Use as an alternative project_path, and organize data accordingly
data_path <- "D:/bioadd-wp2/"

cat(paste0("ML code parent folder: ", ml_demo_path, " | ml_demo_path\n"))
cat(paste0("External data storage in: ", data_path, " | data_path\n"))

# Constructed data stored in the project folder
# Refer to files using filenames$ml_demo$--- ; defined in this script:
source(paste0(ml_demo_path, "filenames.R"))

cat(paste0("Refer to files using filenames$ml_demo$---\n"))

### Functions

functions_folder <- paste0(ml_demo_path, "functions/")

functions_names <- list.files(functions_folder, pattern = "*.R", recursive = TRUE)
functions_paths <- list.files(functions_folder, pattern = "*.R", recursive = TRUE, full.names = TRUE)

cat("Defining functions:", "\n")
for (i in 1:length(functions_names)) {
    cat("    ", functions_names[i],"\n")
    source(functions_paths[i], local = FALSE, echo = FALSE)
}


### Packages

library(ranger)
library(survival)
library(magick)
library(scales)
