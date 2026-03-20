#!/bin/bash
#SBATCH --job-name=5_PRS
#SBATCH --mem-per-cpu=100G
#SBATCH --partition=ojcompute
#SBATCH -t 200:00:00
#SBATCH --output=/public/ojsys/eye/sujianzhong/yyh/1_zhenji/1_Magic_GPB/log/5/5_PRS.%j.out
#SBATCH --error=/public/ojsys/eye/sujianzhong/yyh/1_zhenji/1_Magic_GPB/log/5/5_PRS.%j.err

set -euo pipefail

Rscript /public/ojsys/eye/sujianzhong/yyh/software/PRSice/PRSice.R --dir . \
    --prsice /public/ojsys/eye/sujianzhong/yyh/software/PRSice/bin/PRSice --base "input" \
    --target "plink_format_Gene" --snp SNP --A1 A1 --A2 A2 --stat Beta --pvalue p --pheno-file "phenotype" \
    --bar-levels 5e-8,5e-7,5e-6,5e-5,5e-4,5e-3,5e-2,5e-1 \
    --fastscore --binary-target F \
    --clump-kb 250 \
    --clump-r2 0.1 \
    --clump-p 1.0 \
    --out "output"