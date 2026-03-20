library(data.table)
library(pheatmap)
library(dplyr)
library(tibble)

# 1. Load Data
gene <- fread("/share/pub/xuezb/expression/gene.txt", header = F)
names(gene) <- "Symbol"
gtex <- fread("/share/pub/xuezb/expression/gtex_55tissue_Log2Median.txt")

# 2. Merge and Handle Duplicate Symbols
gtex_gene <- merge(gene, gtex, by = "Symbol")
# Ensure unique gene names to prevent errors when setting row names
gtex_gene[, Symbol := make.unique(Symbol)] 

# 3. Data Cleaning and Format Conversion
data_clean <- gtex_gene %>%
  # Remove unnecessary columns (assuming Ensembl_ID is the 2nd column, or remove by name)
  select(-any_of(c("Ensembl_ID", "Name", "V1"))) %>% 
  column_to_rownames("Symbol") %>%
  # Correction: Use mutate + across for numeric conversion
  mutate(across(everything(), as.numeric)) %>%
  as.matrix()

# --- CRITICAL: Preprocessing to resolve NA/NaN/Inf errors ---

# A. Remove rows containing NA values (if any)
data_clean <- data_clean[complete.cases(data_clean), ]

# B. Remove rows with zero variance (scale="row" causes errors due to division by zero)
# We only keep genes that show expression variation across different tissues
data_variance <- apply(data_clean, 1, var)
data_clean <- data_clean[data_variance > 0 & !is.na(data_variance), ]

# 4. Generate and Save Heatmap as PDF
pdf("Gene_Expression_Heatmap.pdf", width = 10, height = 5)

pheatmap(data_clean, 
         cluster_rows = TRUE, 
         cluster_cols = TRUE, 
         show_colnames = TRUE, 
         main = "Gene Expression Across Tissues",
         color = colorRampPalette(c("navy", "white", "firebrick3"))(100),
         scale = "row",               # Automatically calculates Z-score
         fontsize_col = 7, 
         fontsize_row = 8,
         angle_col = 90)              # Vertical alignment for better readability of tissue names

dev.off()