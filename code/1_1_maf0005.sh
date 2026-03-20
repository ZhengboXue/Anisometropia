#!/bin/bash
#SBATCH --job-name=1_1_maf0005
#SBATCH --mem-per-cpu=100G
#SBATCH --partition=ojcompute
#SBATCH -t 200:00:00
#SBATCH --output=/public/ojsys/eye/sujianzhong/yyh/1_zhenji/1_Magic_GPB/log/1_1_maf0005.%j.out
#SBATCH --error=/public/ojsys/eye/sujianzhong/yyh/1_zhenji/1_Magic_GPB/log/1_1_maf0005.%j.err

set -euo pipefail

# Step01 Get VCF files which obtain SNPs of MAF>=0.005
echo "Getting VCF files which obtain SNPs of MAF>=0.005"
echo "..."
{
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/bcftools-1.21/bcftools view -i 'INFO/MAF >= 0.005' /public/ojsys/eye/sujianzhong/dw_sulab/zhenji/Gene/cohort_S9730_S11225_clean_unrelated_pick_fix.vcf -Ov -o maf0005_p1.vcf
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/bcftools-1.21/bcftools view -i 'INFO/MAF >= 0.005' /public/ojsys/eye/sujianzhong/dw_sulab/zhenji/Gene/S8114/S8114_combine_snpQC_sampleQC_fix.recode.vcf -Ov -o maf0005_p2.vcf
} > /dev/null
echo "All done for 1_1."