#!/bin/bash
#SBATCH --job-name=3_1_Meta
#SBATCH --mem-per-cpu=100G
#SBATCH --partition=ojcompute
#SBATCH -t 200:00:00
#SBATCH --output=/public/ojsys/eye/sujianzhong/yyh/1_zhenji/1_Magic_GPB/log/3_1/3_1_Meta.%j.out
#SBATCH --error=/public/ojsys/eye/sujianzhong/yyh/1_zhenji/1_Magic_GPB/log/3_1/3_1_Meta.%j.err

set -euo pipefail

/public/ojsys/eye/sujianzhong/yyh/software/generic-metal/metal Metal_se.txt

/public/ojsys/eye/sujianzhong/yyh/software/generic-metal/metal Metal_astig.txt