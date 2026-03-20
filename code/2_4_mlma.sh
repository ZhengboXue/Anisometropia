#!/bin/bash
#SBATCH --job-name=2_4_mlma.sh
#SBATCH --mem-per-cpu=100G
#SBATCH --partition=ojcompute
#SBATCH -t 200:00:00
#SBATCH --output=/public/ojsys/eye/sujianzhong/yyh/1_zhenji/1_Magic_GPB/log/2_4/2_4_mlma.sh.%j.out
#SBATCH --error=/public/ojsys/eye/sujianzhong/yyh/1_zhenji/1_Magic_GPB/log/2_4/2_4_mlma.sh.%j.err

set -euo pipefail

## Before this step, u need to confirm the input file prepared.
{
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/gcta/gcta64 \
    --mlma \
    --bfile maf0005_p1_clean \
    --grm maf0005_p1_clean_grm \
    --thread-num 10 \
    --pheno p1_pheno_se.txt \
    --qcovar maf0005_p1_covar_pc3.txt \
    --out maf0005_p1_covar_pc3_se_mlma

/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/gcta/gcta64 \
    --mlma \
    --bfile maf0005_p2_clean \
    --grm maf0005_p2_clean_grm \
    --thread-num 10 \
    --pheno p2_pheno_se.txt \
    --qcovar maf0005_p2_covar_pc3.txt \
    --out maf0005_p2_covar_pc3_se_mlma

/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/gcta/gcta64 \
    --mlma \
    --bfile maf0005_p1_clean \
    --grm maf0005_p1_clean_grm \
    --thread-num 10 \
    --pheno p1_pheno_astig.txt \
    --qcovar maf0005_p1_covar_pc3.txt \
    --out maf0005_p1_covar_pc3_astig_mlma

/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/gcta/gcta64 \
    --mlma \
    --bfile maf0005_p2_clean \
    --grm maf0005_p2_clean_grm \
    --thread-num 10 \
    --pheno p2_pheno_astig.txt \
    --qcovar maf0005_p2_covar_pc3.txt \
    --out maf0005_p2_covar_pc3_astig_mlma
} > /dev/null

echo "MLMA finished!"