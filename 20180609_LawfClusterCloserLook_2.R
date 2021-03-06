#20180609_LawfClusterCloserLook_2.R
#Continuation of 20180604_LawfClusterExpdGenes.R
#Plots genes relative to Lim1, in single plot.

#Load GBM file created 20180531 (see 20180531_GBMpulled.R)
setwd("/Users/Olga/Google Drive/Desplan Lab/Notebooks/Notebook 5/10X processing/20180531_GBMpulled/")
k20_Lawf_cluster_GBM_wGeneNames<-read.table("k20_Lawf_cluster_GBM_wGeneNames.txt")

###Delete genes that are not expressed in any of the 852 cells
#sum across rows
sum<-c()
for (i in 1:dim(k20_Lawf_cluster_GBM_wGeneNames)[1])
  sum[i] <- sum(k20_Lawf_cluster_GBM_wGeneNames[i, 4:855])
#add sums in column to dataframe
k20_Lawf_cluster_GBM_wGeneNames$RowSum <- sum
length(which(k20_Lawf_cluster_GBM_wGeneNames$RowSum == 0)) #3019 genes eliminated (not expressed in any cells in this cluster)
#delete all rows for which RowSum == 0. I did some manual check to make sure this worked properly.
zerorows<-which(k20_Lawf_cluster_GBM_wGeneNames$RowSum == 0)
k20_Lawf_cluster_GBM_wGeneNames_ExpdGenesOnly <- k20_Lawf_cluster_GBM_wGeneNames[-zerorows,]
dim(k20_Lawf_cluster_GBM_wGeneNames_ExpdGenesOnly)
#Save file
#Note again that .txt files appear to load OK in excel, but some rows are missing (see 20180531_GBMpulled.R for details)
#SO, I should only load these in R, not in excel!
setwd("/Users/Olga/Google Drive/Desplan Lab/Notebooks/Notebook 5/10X processing/20180609_LawfClusterCloserLook_2/")
write.table(k20_Lawf_cluster_GBM_wGeneNames_ExpdGenesOnly, "k20_repo_cluster_GBM_wGeneNames_ExpdGenesOnly.txt", sep = "\t")
#Sort by expression (RowSums), in descending order
k20_Lawf_cluster_GBM_wGeneNames_ExpdGenesOnly_sorted <-
  k20_Lawf_cluster_GBM_wGeneNames_ExpdGenesOnly[order(-k20_Lawf_cluster_GBM_wGeneNames_ExpdGenesOnly$RowSum),]
write.table(k20_Lawf_cluster_GBM_wGeneNames_ExpdGenesOnly_sorted, "k20_repo_cluster_GBM_wGeneNames_ExpdGenesOnly_sorted.txt", sep = "\t")

#plot 1_enriched genes
#note: made enriched_1 and enriched_2 tables from text files (code not included). 
#These two text files are saved to local folder at end of file to be able to re-run code
Lim1_row <- which(k20_Lawf_cluster_GBM_wGeneNames_ExpdGenesOnly$GeneSymbol_Flybase == "Lim1")

ylimit<-range(k20_Lawf_cluster_GBM_wGeneNames_ExpdGenesOnly[, 4:855])[2]

gene2 <- c()
for (i in 1:dim(enriched_1)[1])
{
gene2[i] <- which(k20_Lawf_cluster_GBM_wGeneNames_ExpdGenesOnly$FBN_Flybase == paste(enriched_1[i, 1]))
}

png("enriched_1.png", width = 1200, height = 600)
layout(matrix(c(1:66), nrow = 6, byrow = TRUE))

for (i in 1:length(gene2)) 
{
  twogenes_df <- data.frame(as.numeric(k20_Lawf_cluster_GBM_wGeneNames_ExpdGenesOnly[Lim1_row, 4:855]), 
                  as.numeric(k20_Lawf_cluster_GBM_wGeneNames_ExpdGenesOnly[gene2[i], 4:855]))
  colnames(twogenes_df) <- c("Lim1", "gene2")
  #reorder based on Lim1 expression 
  twogenes_df_ordered<-twogenes_df[order(twogenes_df$Lim1),]
  par(mar = c (0, 0, 0, 0))
  plot(twogenes_df_ordered$gene2, ylab = "", xlab = "", pch=16, cex = 0.5, axes = FALSE, ylim = c(0, ylimit))
  points(twogenes_df_Lim1$Lim1, col = "red", cex = 0.1, ylim = ylimit)
}
dev.off()

#plot 2_enriched genes
Lim1_row <- which(k20_Lawf_cluster_GBM_wGeneNames_ExpdGenesOnly$GeneSymbol_Flybase == "Lim1")

gene2 <- c()
for (i in 1:dim(enriched_1)[1])
{
  gene2[i] <- which(k20_Lawf_cluster_GBM_wGeneNames_ExpdGenesOnly$FBN_Flybase == paste(enriched_2[i, 1]))
}

png("enriched_2.png", width = 1200, height = 600)
layout(matrix(c(1:66), nrow = 6, byrow = TRUE))

for (i in 1:length(gene2)) 
{
  twogenes_df <- data.frame(as.numeric(k20_Lawf_cluster_GBM_wGeneNames_ExpdGenesOnly[Lim1_row, 4:855]), 
                            as.numeric(k20_Lawf_cluster_GBM_wGeneNames_ExpdGenesOnly[gene2[i], 4:855]))
  colnames(twogenes_df) <- c("Lim1", "gene2")
  #reorder based on Lim1 expression 
  twogenes_df_ordered<-twogenes_df[order(twogenes_df$Lim1),]
  par(mar = c (0, 0, 0, 0))
  plot(twogenes_df_ordered$gene2, ylab = "", xlab = "", pch=16, cex = 0.5, axes = FALSE, ylim = c(0, ylimit))
  points(twogenes_df_Lim1$Lim1, col = "red", cex = 0.1, ylim = ylimit)
}
dev.off()

#save enriched_1, enriched_2
setwd("/Users/Olga/Google Drive/Desplan Lab/Notebooks/Notebook 5/10X processing/20180609_LawfClusterCloserLook_2")
write.table(enriched_1, "enriched_1.txt")
write.table(enriched_2, "enriched_2.txt")

