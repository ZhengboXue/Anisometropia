#!/bin/bash
#SBATCH --job-name=4_annotation
#SBATCH --mem-per-cpu=100G
#SBATCH --partition=ojcompute
#SBATCH -t 200:00:00
#SBATCH --output=/public/ojsys/eye/sujianzhong/yyh/1_zhenji/1_Magic_GPB/log/4/4_annotation.%j.out
#SBATCH --error=/public/ojsys/eye/sujianzhong/yyh/1_zhenji/1_Magic_GPB/log/4/4_annotation.%j.err

set -euo pipefail

{
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/annovar/table_annovar.pl p1_astig.avinput \
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/annovar/humandb/ -buildver hg19 \
  -out p1_astig -remove \
  -protocol refGene,cytoBand,avsnp150 \
  -operation g,r,f \
  -nastring . -csvout -polish

/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/annovar/table_annovar.pl p1_se.avinput \
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/annovar/humandb/ -buildver hg19 \
  -out p1_se -remove \
  -protocol refGene,cytoBand,avsnp150 \
  -operation g,r,f \
  -nastring . -csvout -polish

/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/annovar/table_annovar.pl p2_astig.avinput \
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/annovar/humandb/ -buildver hg19 \
  -out p2_astig -remove \
  -protocol refGene,cytoBand,avsnp150 \
  -operation g,r,f \
  -nastring . -csvout -polish

/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/annovar/table_annovar.pl p2_se.avinput \
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/annovar/humandb/ -buildver hg19 \
  -out p2_se -remove \
  -protocol refGene,cytoBand,avsnp150 \
  -operation g,r,f \
  -nastring . -csvout -polish
} > /dev/null