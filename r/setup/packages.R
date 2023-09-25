#######################################################################
### Import packages
#######################################################################

# OK to import packages separately in individual scripts. If a package is used repeatedly across scripts, it can be added here.
# Order matters for conflicts. Set conflict preferences below.

### Specify packages

packages_list <- list()

packages_list$general <- c("tidyverse", "foreach", "Rcpp", "data.table")
packages_list$gis <- c("terra", "exactextractr", "sf")
packages_list$graphs <- c("ggplot2", "ggthemes", "viridis", "patchwork", "ggpubr")
packages_list$rmarkdown <- c("rmarkdown", "knitr")
packages_list$estimation <- c("fixest")

packages <- unique(unlist(packages_list))

### Install new packages

new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if (length(new_packages) > 0) install.packages(new_packages, repos="http://cran.rstudio.com/") else cat("All required packages are installed", "\n")

### Import packages to session

invisible(lapply(packages, library, character.only = TRUE))

### Set conflict preferences

extract <- terra::extract

cat("packages.R done\n")