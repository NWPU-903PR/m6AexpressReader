.peak_methy_level <- function(IP_Input_read,size_factor){

  IP_site_read <- IP_Input_read[,grep("IP",colnames(IP_Input_read))]
  Input_site_read <- IP_Input_read[,(grep("Input",colnames(IP_Input_read)))]
  IP_Input <- cbind(IP_site_read, Input_site_read)
  IP_Input_norm <- as.data.frame(t(t(IP_Input)/size_factor)) 
  IP_norm_site <- IP_Input_norm[,1:(ncol(IP_Input_norm)/2)]
  Input_norm_site <- IP_Input_norm[,((ncol(IP_Input_norm)/2)+1):(ncol(IP_Input_norm))]
  methy_level <- log((IP_norm_site+0.01)/(Input_norm_site+0.01)) 
  methy_level_infor <- data.frame(IP_Input_read[,-c(grep("IP",colnames(IP_Input_read)),
                                                    (grep("Input",colnames(IP_Input_read))))], methy_level)
  for (i in 1:nrow(methy_level_infor)) {
    for(j in grep("IP",colnames(methy_level_infor))[1]:ncol(methy_level_infor)){
      if(methy_level_infor[i,j]<=0){
        methy_level_infor[i,j] <- NA
      }
    }
  }
  return(methy_level_infor)
}

nobindgene_methylevel <- function(methy_site_infor,library_size,peak_dist_stopcodon){
  size_factor <- as.numeric(library_size/exp(mean(log(library_size))))
  nonbindgene_peak_GR <- GRanges(seqnames = as.character(methy_site_infor$seqnames),
                                          IRanges(start = as.numeric(as.character(methy_site_infor$start)),
                                                  end = as.numeric(as.character(methy_site_infor$end))),
                                          strand = as.character(methy_site_infor$strand))
  
  peak_dist_stopcodon_GR <- GRanges(seqnames = as.character(peak_dist_stopcodon$seqnames),
                                    IRanges(start = as.numeric(as.character(peak_dist_stopcodon$start)),
                                            width = 1 ),
                                    strand = as.character(peak_dist_stopcodon$strand))
  select_peaksites <- data.frame()
  for (i in 1:nrow(peak_dist_stopcodon)) {
    one_overlap <- findOverlaps(peak_dist_stopcodon_GR[i],nonbindgene_peak_GR,type = "within")
    one_selectpeak <- cbind(methy_site_infor[unique(one_overlap@to),],
                            peak_dist_stopcodon[i,ncol(peak_dist_stopcodon)])
    
    select_peaksites <- rbind(select_peaksites,one_selectpeak)                       
    
  }
  colnames(select_peaksites)[ncol(select_peaksites)] <- "dist_stopcodon"

  norm_methy_level <- .peak_methy_level(methy_site_infor,size_factor)
  norm_methy_level <- na.omit(norm_methy_level)
  dist <- as.numeric(as.character(norm_methy_level$dist_stopcodon))
  distdecay <- exp(-dist/round(quantile(dist,0.75)))
  dist_decay <- data.frame(as.character(norm_methy_level$gene_name),distdecay)
  colnames(dist_decay)[1] <- "gene_name"
  table_genename <- as.data.frame(table(as.character(norm_methy_level$gene_name)))
  colnames(table_genename) <- c("gene_name","freq")
  select_gene_name <- unique(as.character(norm_methy_level$gene_name))
  genelevel_decay <- data.frame()
  for (i in 1:length(select_gene_name)) {
    one_gene <- table_genename[table_genename$gene_name==select_gene_name[i],]
    add_decay_methy <- norm_methy_level[which(!is.na(match(norm_methy_level$gene_name, select_gene_name[i]))),grep("IP",colnames(norm_methy_level))[1]:ncol(norm_methy_level)]*
      dist_decay[dist_decay$gene_name==select_gene_name[i],-1]
    mean_site_methydecay <- round(colMeans(add_decay_methy),2)
    genelevel_decay <- rbind(genelevel_decay, mean_site_methydecay)
  }
  new_decaylevel <- cbind(select_gene_name, genelevel_decay)
  colnames(new_decaylevel) <- c("gene_name", colnames(norm_methy_level)[grep("IP",colnames(norm_methy_level))[1]:ncol(norm_methy_level)])
  ##select methy-level
  select_decaylevel <- new_decaylevel[rowSums(new_decaylevel[,-1])>0,]
  last_select_decaylevel <- select_decaylevel[rowSums(round(select_decaylevel[,-1],2))>0,]
  last_select_gene <- na.omit(last_select_decaylevel)
  last_gene_name <- as.character(last_select_gene$gene_name) 
  last_selectdecaylevel <- cbind(last_gene_name,round(last_select_gene[,-1],2))
  colnames(last_selectdecaylevel)[1] <- "gene_name"
  rownames(last_selectdecaylevel) <- NULL
  genedecaylevel <- last_selectdecaylevel[,-1]
  meanmethy <- rowMeans(genedecaylevel)
  select_label <- which(meanmethy>0.1)
  last_genedecaylevel <- last_selectdecaylevel[select_label, ]
  return(last_genedecaylevel)
}
