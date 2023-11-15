#######################################################################
### User functions
#######################################################################

functions_folder <- paste0(project_path, "r/functions/")

functions_names <- list.files(functions_folder, pattern = "*.R", recursive = TRUE)
functions_paths <- list.files(functions_folder, pattern = "*.R", recursive = TRUE, full.names = TRUE)

cat("Defining functions:", "\n")
for (i in 1:length(functions_names)) {
    cat("    ", functions_names[i],"\n")
    source(functions_paths[i], local = FALSE, echo = FALSE)
}

cat("user-functions.R done\n")