#!/bin/bash
#SBATCH --job-name=2_1_basic_qc
#SBATCH --mem-per-cpu=100G
#SBATCH --partition=ojcompute
#SBATCH -t 200:00:00
#SBATCH --output=/public/ojsys/eye/sujianzhong/yyh/1_zhenji/1_Magic_GPB/log/2_1/2_1_basic_qc.%j.out
#SBATCH --error=/public/ojsys/eye/sujianzhong/yyh/1_zhenji/1_Magic_GPB/log/2_1/2_1_basic_qc.%j.err

set -euo pipefail

echo "Dealing VCF2PLINK"
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink --vcf maf0005_p1.vcf --make-bed --out maf0005_p1 > /dev/null
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink --vcf maf0005_p2.vcf --make-bed --out maf0005_p2 > /dev/null
echo "Done 1!"

echo "Add site information"
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink \
      --bfile maf0005_p1 \
      --set-missing-var-ids @:# \
      --make-bed \
      --out maf0005_p1_site > /dev/null

/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink \
      --bfile maf0005_p2 \
      --set-missing-var-ids @:# \
      --make-bed \
      --out maf0005_p2_site > /dev/null
echo "Done 2!"

echo "Data Basic QC"
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink \
    --bfile maf0005_p1_site \
    --geno 0.02 \
    --mind 0.02 \
    --indep-pairwise 50 5 0.2 \
    --out maf0005_p1_geno_mind_ld > /dev/null

/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink \
    --bfile maf0005_p2_site \
    --geno 0.02 \
    --mind 0.02 \
    --indep-pairwise 50 5 0.2 \
    --out maf0005_p2_geno_mind_ld > /dev/null
echo "Done 3"

echo "HWE and het"
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink \
    --bfile maf0005_p1_geno_mind_ld \
    --hwe 1e-6 \
    --make-bed \
    --out maf0005_p1_hwe > /dev/null

/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink \
    --bfile maf0005_p2_geno_mind_ld \
    --hwe 1e-6 \
    --make-bed \
    --out maf0005_p2_hwe > /dev/null

/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink \
    --bfile maf0005_p1_hwe \
    --het \
    --out maf0005_p1_het > /dev/null

/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink \
    --bfile maf0005_p2_hwe \
    --het \
    --out maf0005_p2_het > /dev/null
echo "Done 4"
echo "Exclude heterozygosity"
awk '
NR==1 {next} # 跳过表头
{
    sum += $6;
    sumsq += $6 * $6;
    data[NR] = $0; # 保存整行数据
    f_values[NR] = $6; # 保存F值
}
END {
    n = NR - 1; # 数据行数
    mean = sum / n;
    stdev = sqrt(sumsq / n - mean * mean);

    print "异质性统计结果:";
    print "样本数量: " n;
    print "F值均值: " mean;
    print "F值标准差: " stdev;
    print "均值 ± 3SD: " (mean - 3 * stdev) " 到 " (mean + 3 * stdev);
    print "";
    print "异常样本 (F值超出均值±3SD):";

    lower = mean - 3 * stdev;
    upper = mean + 3 * stdev;

    for(i = 2; i <= NR; i++) {
        if(f_values[i] < lower || f_values[i] > upper) {
            split(data[i], fields, /[[:space:]]+/);
            print fields[1], fields[2], f_values[i];
        }
    }
}' maf0005_p1_het.het

awk '
NR==1 {next} # 跳过表头
{
    sum += $6;
    sumsq += $6 * $6;
    data[NR] = $0; # 保存整行数据
    f_values[NR] = $6; # 保存F值
}
END {
    n = NR - 1; # 数据行数
    mean = sum / n;
    stdev = sqrt(sumsq / n - mean * mean);

    print "异质性统计结果:";
    print "样本数量: " n;
    print "F值均值: " mean;
    print "F值标准差: " stdev;
    print "均值 ± 3SD: " (mean - 3 * stdev) " 到 " (mean + 3 * stdev);
    print "";
    print "异常样本 (F值超出均值±3SD):";

    lower = mean - 3 * stdev;
    upper = mean + 3 * stdev;

    for(i = 2; i <= NR; i++) {
        if(f_values[i] < lower || f_values[i] > upper) {
            split(data[i], fields, /[[:space:]]+/);
            print fields[1], fields[2], f_values[i];
        }
    }
}' maf0005_p2_het.het
/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink \
      --bfile maf0005_p1_geno_mind_ld\
      --remove maf0005_p1_het_remove_3sd.sample \
      --make-bed \
      --out maf0005_p1_het_filter > /dev/null

/public/ojsys/eye/sujianzhong/dw_sulab/zhenji/software/plink \
      --bfile maf0005_p2_geno_mind_ld\
      --remove maf0005_p2_het_remove_3sd.sample \
      --make-bed \
      --out maf0005_p2_het_filter > /dev/null

echo "All done for 2_1."