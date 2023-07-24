#' Get an exploratory histogram for a given column in a data frame.
#' 
#' This function will take a data frame and an indicated column and will output 
#' an exploratory histogram for the data in that column, splitting by if cells 
#' are "channel positive" or are "normal" cells. The channel must be indicated 
#' as well. 
#' 
#' @param df A "Results" data frame saved from ImageJ.
#' @param channel A current channel of interest that is being examined in the 
#' images.
#' @param column The column in the data frame that is populated with data of a 
#' certain statistic.
#' @export 
stat_hist_explore <- function(df,channel,column) {
  
  im_name <- strsplit(df$Label[1],split = im_ext)[[1]][1]
  im_name <- substr(im_name,4,nchar(im_name))
  im_name <- gsub(paste("_",nuc_channel,"_",cyt_channel,"_",channel,sep = ""),"",im_name)
  
  channel_num <- which(channels_of_interest == channel)
  myCols <- c(names(channels_of_interest)[channel_num],cyt_color)
  
  if (length(unique(df$CellType)) == 1) {
    p <- ggplot(data = df,aes(x=get(column))) + 
      geom_histogram(aes(x=get(column),fill=CellType), 
                     position = "identity",alpha = 0.5) +
      scale_fill_manual(values=c("black")) +
      labs(title = im_name) + xlab(label = column) + 
      theme(title = element_text(size = 10),legend.title = element_text(size = 5), 
            legend.text = element_text(size = 3),
            axis.text.x = element_text(size = 3,angle = 30))
    return(p)
  }  
  if (length(unique(df$CellType)) > 1) {
    p <- ggplot(data = df,aes(x=get(column))) + 
      geom_histogram(aes(x=get(column),fill=CellType), 
                     position = "identity",alpha = 0.5) + 
      scale_fill_manual(values=c(myCols)) +
      labs(title = im_name) + xlab(label = column) + 
      theme(title = element_text(size = 10),legend.title = element_text(size = 5), 
            legend.text = element_text(size = 3),
            axis.text.x = element_text(size = 3,angle = 30))
    return(p)
  }
}