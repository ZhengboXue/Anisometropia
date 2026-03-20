#!/bin/bash
#SBATCH --job-name=2_2_ibd_pca
#SBATCH --mem-per-cpu=100G
#SBATCH --partition=ojcompute
#SBATCH -t 200:00:00
#SBATCH --output=/public/ojsys/eye/sujianzhong/yyh/1_zhenji/1_Magic_GPB/log/2_2/2_2_ibd_pca.%j.out
#SBATCH --error=/public/ojsys/eye/sujianzhong/yyh/1_zhenji/1_Magic_GPB/log/2_2/2_2_ibd_pca.%j.err

set -euo pipefail

echo "Estimate IBD > 0.2"
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink \
    --bfile maf0005_p1_het_filter \
    --genome \
    --min 0.2 \
    --out maf0005_p1_het_filter_ibd02 > /dev/null
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink \
    --bfile maf0005_p1_het_filter \
    --remove maf0005_p1_ibd02_remove_iid.txt \
    --make-bed \
    --out maf0005_p1_ibd02 > /dev/null

/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink \
    --bfile maf0005_p2_het_filter \
    --genome \
    --min 0.2 \
    --out maf0005_p2_het_filter_ibd02 > /dev/null
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink \
    --bfile maf0005_p2_het_filter \
    --remove maf0005_p2_ibd02_remove_iid.txt \
    --make-bed \
    --out maf0005_p2_ibd02 > /dev/null
echo "Done 1"
echo "Running PCA after pruning(keep top 20 PCs)"

/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink2 \
    --bfile maf0005_p1_ibd02 \
    --freq counts \
    --threads 10 \
    --pca approx 20 allele-wts \
    --out maf0005_p1_pca20 > /dev/null
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink2 \
    --bfile maf0005_p2_ibd02 \
    --freq counts \
    --threads 10 \
    --pca approx 20 allele-wts \
    --out maf0005_p2_pca20 > /dev/null

echo "Done 2"

echo "Final QC"
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink \
        --bfile maf0005_p1_site  \
        --geno 0.02 \
        --mind 0.02 \
        --hwe 1e-6 \
        --remove maf0005_p2_het_remove_3sd.sample \
        --keep-allele-order \
        --make-bed \
        --out maf0005_p1_clean > /dev/null
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink \
        --bfile maf0005_p2_site  \
        --geno 0.02 \
        --mind 0.02 \
        --hwe 1e-6 \
        --remove maf0005_p2_het_remove_3sd.sample \
        --keep-allele-order \
        --make-bed \
        --out maf0005_p2_clean > /dev/null

echo "Done with all QCed data! Congratulations!"
echo "But still 20 PCs"
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink2 \
    --bfile maf0005_p1_clean \
    --threads 10 \
    --read-freq maf0005_p1_pca20.acount \
    --score maf0005_p1_pca20.eigenvec.allele 2 6 header-read no-mean-imputation variance-standardize \
    --score-col-nums 7-26 \
    --out maf0005_p1_20pc > /dev/null
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink2 \
    --bfile maf0005_p2_clean \
    --threads 10 \
    --read-freq maf0005_p2_pca20.acount \
    --score maf0005_p2_pca20.eigenvec.allele 2 6 header-read no-mean-imputation variance-standardize \
    --score-col-nums 7-26 \
    --out maf0005_p2_20pc > /dev/null
echo "All done for 2_2."