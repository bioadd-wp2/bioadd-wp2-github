
library(tidyterra)

### Read rasters

r_mb <- lapply(filenames$raster$mapbiomas, rast)
r_nl <- lapply(filenames$raster$nightlights, rast)

### Crop a municipality

gadm <- list()
gadm$district <- vect(filenames$vector$gadm, layer = "ADM_ADM_3")

crop_polygon <- gadm$district[gadm$district$NAME_3 == "El Torno",]

r_mb_cropped <- lapply(r_mb, function(x) terra::crop(x, crop_polygon))
r_nl_cropped <- lapply(r_nl, function(x) terra::crop(x, crop_polygon))


### Graphs

mapbiomas_colors <- fread(filenames$csv$mapbiomas_colors)

# Resampling resolution
max_cell <- 5E5


# Create graphs

g_mb_list <- list()
for (i in 1:length(r_mb_cropped)){
	ggplot() +
		geom_spatraster(data = as.factor(r_mb_cropped[[i]]), maxcell = max_cell) +
		geom_spatvector(data = crop_polygon, alpha = 0, color = "white") +
		theme_void() + 
		scale_fill_manual(
			values = setNames(mapbiomas_colors$color, mapbiomas_colors$value),
			labels = setNames(mapbiomas_colors$category_en, mapbiomas_colors$value), 
	        na.value = "transparent",
	        name = "Land cover") +
		theme(legend.position = "none") ->
		g_mb_list[[i]]
}


g_nl_list <- list()
for (i in 1:length(r_nl_cropped)){
	ggplot() +
		geom_spatraster(data = as.numeric(r_nl_cropped[[i]]), maxcell = max_cell) +
		geom_spatvector(data = crop_polygon, alpha = 0, color = "white") +
		theme_void() + 
		theme(legend.position = "none") ->
		g_nl_list[[i]]
}



### Combine to one graph
# (Mind that the years match)

names(r_mb_cropped)
names(r_nl_cropped)

g_mb_list_matching <- g_mb_list[8:length(g_mb_list)]

g_combined <- lapply(1:length(g_mb_list_matching), function(x) (g_mb_list_matching[[x]] | g_nl_list[[x]] ) )


### Save

rmarkdown_folder <- paste0(project_path, "output/html/notes-example/")
figures_folder <- paste0(rmarkdown_folder, "images/el-torno/")
dir.create(rmarkdown_folder, recursive = TRUE)
dir.create(figures_folder, recursive = TRUE)

for (i in seq_along(g_combined)) {

	ggsave(filename = paste0(figures_folder, "plot_el_torno_", i, ".png"), plot = g_combined[[i]], width = 18, units = "cm")
	print(i)

}


### Render RMarkdown file

# The .Rmd file must exist in the output folder (should fix this)

file.copy(
	from = paste0(project_path, "r/share/notes_example.Rmd"),
	to = paste0(project_path, "output/html/notes-example/notes_example.Rmd"),
	overwrite = TRUE
	)


# Render

rmarkdown::render(
	paste0(project_path, "output/html/notes-example/notes_example.Rmd"),
	output_dir = rmarkdown_folder
	)

