#!/bin/bash
#SBATCH --job-name=2_3_GRM.sh
#SBATCH --mem-per-cpu=100G
#SBATCH --partition=ojcompute
#SBATCH -t 200:00:00
#SBATCH --output=/public/ojsys/eye/sujianzhong/yyh/1_zhenji/1_Magic_GPB/log/2_3/2_3_GRM.sh.%j.out
#SBATCH --error=/public/ojsys/eye/sujianzhong/yyh/1_zhenji/1_Magic_GPB/log/2_3/2_3_GRM.sh.%j.err

set -euo pipefail

echo "Use GCTA to calculate GRM"
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/gcta/gcta64 \
     --bfile maf0005_p1_clean \
     --make-grm \
     --autosome \
     --out ./GRM/maf0005_p1_clean_grm > /dev/null
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/gcta/gcta64 \
     --bfile maf0005_p2_clean \
     --make-grm \
     --autosome \
     --out ./GRM/maf0005_p2_clean_grm > /dev/null
echo "Done !"