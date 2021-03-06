#Use cellrangerRkit to plot gene expression. 
#Will re-do using my G-B Matrix and (made 5.24) and my cluster plots (made 5.22)

#load gene-barcode matrix, normalize, log transform, check dimensions
library(cellrangerRkit)
cellranger_pipestance_path <- "/Users/Olga/Downloads/cellranger/count-Neuron"
gbm <- load_cellranger_matrix(cellranger_pipestance_path)
analysis_results <- load_cellranger_analysis_results(cellranger_pipestance_path)
use_genes <- get_nonzero_genes(gbm)
gbm_bcnorm <- normalize_barcode_sums_to_median(gbm[use_genes,])
gbm_log <- log_gene_bc_matrix(gbm_bcnorm,base=10)
print(dim(gbm_log))

#An attempt to understand limits parameter in visualize_gene_markers() function.
m1_log <- exprs(gbm_log)
m1_log <- as.matrix(m1_log)
range(m1_log)
#result: [1] 0.0000000000000000000 3.1912021200731346404
#so the mas value is 3.19. so does limit set to (0, 1.5) not allow this value to be shown as 3.19?
which(m1_log > 3.19, arr.ind = TRUE) 
#result:              row  col
#result               FBgn0023178 9300 6593
#this is Pdf. So now how 
genes <-c("Pdf")
tsne_proj <- analysis_results$tsne
quartz("pdf - c(0, 1.5)", 8,5)
visualize_gene_markers(gbm_log, genes, tsne_proj[c("TSNE.1", "TSNE.2")], limits = c(0,1.5))
quartz("pdf - c(0, 10)", 8,5)
visualize_gene_markers(gbm_log, genes, tsne_proj[c("TSNE.1", "TSNE.2")], limits = c(0,10))

genes <-c("elav", "repo", "Lim1", "eya", "hth", "hbn")
tsne_proj <- analysis_results$tsne
quartz("elav-repo-lim1-eya-hth-hbn", 8,5)
visualize_gene_markers(gbm_log, genes, tsne_proj[c("TSNE.1", "TSNE.2")], limits = c(0, 1.5))
quartz("elav-repo-lim1-eya-hth-hbn - c(0,10)", 8,5)
visualize_gene_markers(gbm_log, genes, tsne_proj[c("TSNE.1", "TSNE.2")], limits = c(0, 10))
#fastest way to get around this is to increase window width. Looked at body(visualize_gene_markers) for more elegant solution, but did not find obvious solution.
quartz("elav-repo-lim1-eya-hth-hbn - c(0,10, quartz 9)", 9,5)
visualize_gene_markers(gbm_log, genes, tsne_proj[c("TSNE.1", "TSNE.2")], limits = c(0, 10))
