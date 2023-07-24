#' Display tif, segmentation, and overlay images in a row
#' 
#' This function takes in a list of three file names: the name of a tif file, 
#' a segmentation png file, and an overlay png file. It will output a visual 
#' of the three files side-by-side.
#' 
#' @param ls A list of three file names.
#' @param directory A directory in which the files with the names listed in the 
#' ls paramter exist.
#' @export
display_TSO <- function(ls,directory) {

  tif <- image_read(paste(directory,ls[[1]],sep = '/'))
  seg <- image_read(paste(directory,ls[[2]],sep = '/'))
  over <- image_read(paste(directory,ls[[3]],sep = '/'))
  
  tif_plot <- image_ggplot(tif) +
    labs(title = gsub(im_ext,"",ls[[1]])) +
    theme(plot.title = element_text(size=10))
  seg_plot <- image_ggplot(seg) +
    labs(title = "+ Segmentation") +
    theme(plot.title = element_text(size=10))
  over_plot <- image_ggplot(over) +
    labs(title = "+ Cell Type Overlay") +
    theme(plot.title = element_text(size=10))
  
  grid.arrange(tif_plot,seg_plot,over_plot,ncol=3)
}