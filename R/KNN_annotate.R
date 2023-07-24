#' Use binary k-nearest-neighbors classification to annotate cells
#' 
#' This function will use a training set in the current directory that 
#' corresponds to a given data frame and use it to annotate all of the cells in
#' that data frame. This function is tailored for use with this package's
#' workflow. It is not recommended for use with other types of data.
#' 
#' @param df A "Results" data frame saved from ImageJ.
#' @param chan_oi The name of the channel of interest.
#' @param k The number of neighbors used for classification.
#' @param features A vector of features from the data frame to use for 
#' classification. These will be column names.
#' @export
KNN_annotate <- function(df,chan_oi,k,features) {
  
  im_name <- strsplit(df$Label[1],split = im_ext)[[1]][1]
  im_name <- substr(im_name,4,nchar(im_name))
  
  t_set <- read_csv(paste(analysis_dir,"/",im_name,"_training_set.csv",sep = ""),
                    show_col_types = F)
  training.indices <- t_set$ROI.indices
  
  if (training.indices[1] == paste("All cells are ",chan_oi,"+",sep = "")) {
    df$CellType <- paste(chan_oi,"+",sep = "")
  }
  if (training.indices[1] == paste("All cells are ",chan_oi,"-",sep = "")) {
    df$CellType <- "normal"
  }
  if (length(training.indices) > 1) {
    training_data <- df[training.indices,]
    
    find_distance <- function(v1,v2) {
      return((sum((v1-v2)**2))**0.5)
    }
    
    get_distances <- function(df_row,feats,train.data) {
      return(apply(train.data[,feats],1,find_distance,
                   as.numeric(df_row[feats])))
    }
    all_neighbors <- apply(df,1,get_distances,features,training_data)
    get_annotation <- function(mat_col,train.inds,t.set,k,chan) {
      names(mat_col) <- train.inds
      in_order <- sort(mat_col,decreasing = F)
      top_k <- in_order[1:k]
      top_k_annotations <- t.set[t.set$ROI.indices %in% names(top_k),]$cell.type
      if (length(grep(chan,top_k_annotations)) >
          length(grep("normal",top_k_annotations))) {
        anno <- paste(chan,"+",sep = "")
        return(anno)
      }
      if (length(grep(chan,top_k_annotations)) <
          length(grep("normal",top_k_annotations))) {
        anno <- "normal"
        return(anno)
      }
    }
    
    annotations <- apply(all_neighbors,2,get_annotation,training.indices,t_set,k,chan_oi)
    df$CellType <- annotations
    df$CellType[training.indices] <- t_set$cell.type
  }
  idx <- which(df$CellType != "normal")
  df$index <- df$...1-1
  write.table(df[idx,"index"],
              file = paste(analysis_dir,"/",im_name,"_positive_indices.txt",
                           sep = ""),
              sep = ',',row.names = F,quote = F)
  return(df)
}