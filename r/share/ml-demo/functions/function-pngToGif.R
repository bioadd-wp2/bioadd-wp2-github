

pngToGif <- function(in_folder, out_folder, name) {

    out_file <- paste0(out_folder, name, ".gif")
    png_files <- list.files(in_folder, full.names = TRUE)

    image_list <- lapply(png_files, image_read)
    image_anim <- image_join(image_list)
    image_anim <- image_animate(image_anim, fps = 2)

    # Write
    image_write(image_anim, out_file, depth = 16, quality = 100)

    return(0)

}
