setwd("/share/pub/xuezb/expression")
library(data.table)

###########################################################
# 1. Process GTEx Official Median Expression Data
###########################################################

# Load GTEx median TPM data (skipping the first two header rows)
gtex_median <- fread("GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_median_tpm.gct")

# Identify numeric columns (starting from the 3rd column)
tissue_cols <- colnames(gtex_median)[3:ncol(gtex_median)]

# Apply Log2(TPM + 1) transformation for data normalization
gtex_median[, (tissue_cols) := lapply(.SD, function(x) log2(x + 1)), .SDcols = tissue_cols]

# Standardize IDs: Remove version suffix (e.g., ".5") from Ensembl_ID to improve matching
gtex_median[, Name_Clean := gsub("\\..*", "", Ensembl_ID)]


###########################################################
# 2. Process Retina Data (Calculate Median and Align)
###########################################################

# Load the retina expression matrix
eye <- fread("retina_normal.tpm.matrix.gct")

# Identify sample columns (from column 3 to the end)
eye_sample_cols <- colnames(eye)[3:ncol(eye)]

# Calculate row-wise median across samples and apply log2(median + 1)
eye_median_val <- apply(eye[, ..eye_sample_cols], 1, median)
eye[, Retina_Log2Median := log2(eye_median_val + 1)]

# Standardize IDs: Remove version suffix from the 'NAME' column to match GTEx format
eye[, Name_Clean := gsub("\\..*", "", NAME)]

# Extract cleaned IDs and the calculated retina expression values
retina_exp <- eye[, .(Name_Clean, Retina = Retina_Log2Median)]


###########################################################
# 3. Merge 55 Tissues (54 GTEx + 1 Retina)
###########################################################

# Merge datasets using the standardized 'Name_Clean' as the primary key
gtex_55tissue <- merge(gtex_median, retina_exp, by = "Name_Clean")

# Reorganize column order: Symbol, Ensembl_ID, Retina, followed by other tissues
setcolorder(gtex_55tissue, c("Symbol", "Ensembl_ID", "Retina"))

# Remove the auxiliary column 'Name_Clean'
gtex_55tissue[, Name_Clean := NULL]

# Export the final processed dataset
fwrite(gtex_55tissue, "gtex_55tissue_Log2Median.txt", sep = "\t")





