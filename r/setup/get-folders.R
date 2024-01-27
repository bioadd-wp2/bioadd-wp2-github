#######################################################################
### Create folders
#######################################################################

# Folder structure defined below as a nested list. The final level should be an empty list
# Folders may be added later along the project, but do not change any existing folders

folders_list <- list(		
	data = list(

		raw = list(
			raster = list(
				gmted2010 = list(),
				hansen = list(
					gain = list(),
					lossyear = list(),
					treecover = list()
					),
				mapbiomas = list(),
				nightlights = list(
					dmsp = list(
						extracted = list(),
						tar = list()
						),
					viirs = list(
						extracted = list()
						),
					harmonized = list()
					)
				),
			gpkg = list(),
			shp  = list(
				firms = list()
				),
			csv  = list(
				firms = list()
				)
			),

		constructed = list(
			raster = list(
				`mapbiomas-transitions` = list(
					`forest-gain` = list(),
					`forest-loss` = list(),
					`forest-gain-transitions` = list(),
					`forest-loss-transitions` = list()
					)
				),
			gpkg = list(),
			csv = list(),
			shp = list(
				`modis-burned-area` = list()
				)
		)
	),

	output = list(
		figures = list(),
		gif = list(),
		html = list()
		),

	r = list(
		local = list(),
		share = list()
		)
	)


# This function creates the folders in the list recursively

create_folders <- function(folder_list, current_path) {
	for (key in names(folder_list)) {
	new_path <- file.path(current_path, key)
		if (!dir.exists(new_path)) {
			dir.create(new_path)
			cat("Folder created:", new_path, "\n")
		}
		if (length(folder_list[[key]]) > 0) {
			create_folders(folder_list[[key]], new_path)
		}
	}
}

# Create folders

create_folders(folders_list, project_path)

cat("get-folders.R done\n")