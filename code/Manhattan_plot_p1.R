# =====================================
# 批量绘制 MLMA 文件的 Manhattan + QQ 图
# 同时计算 Genomic Inflation Factor (λGC)
# =====================================

library(data.table)
library(qqman)

# ---------------------------
# 路径设置
# ---------------------------
input_dir <- "/public/ojsys/eye/sujianzhong/yyh/Jiyuan/1_child_maf0005/"  # ← 修改为你的MLMA目录
output_dir <- "/public/ojsys/eye/sujianzhong/yyh/Jiyuan/GPB_plots/p1/" # ← 输出图片目录
dir.create(output_dir, showWarnings = FALSE)

# ---------------------------
# 获取所有 .mlma 文件
# ---------------------------
files <- list.files(input_dir, pattern = "\\.mlma$", full.names = TRUE)

# ---------------------------
# 定义计算 lambda 的函数
# ---------------------------
calc_lambda <- function(pvals) {
  chisq <- qchisq(1 - pvals, 1)
  lambda <- median(chisq, na.rm = TRUE) / qchisq(0.5, 1)
  return(lambda)
}

# ---------------------------
# 定义主函数：绘图 + 输出λ
# ---------------------------
plot_mlma_result <- function(file) {
  # message("📂 正在处理: ", basename(file))
  df <- fread(file)
  
  # 标准化列名
  colnames(df) <- toupper(colnames(df))
  if (!all(c("CHR", "BP", "SNP", "P") %in% colnames(df))) {
    warning(paste("⚠️ 缺少必要列:", file))
    return(NULL)
  }
  
  # 去掉无效行
  df <- df[!is.na(P) & P > 0 & P <= 1, ]
  
  # 计算 lambda
  lambda_gc <- calc_lambda(df$P)
  
  # 文件名
  base_name <- tools::file_path_sans_ext(basename(file))
  manhattan_png <- file.path(output_dir, paste0(base_name, "_Manhattan.png"))
  qq_png <- file.path(output_dir, paste0(base_name, "_QQ.png"))
  
  # ---------------------------
  # 绘制 Manhattan 图
  # ---------------------------
  png(manhattan_png, width = 1600, height = 800, res = 150)
  manhattan(df,
            chr = "CHR", bp = "BP", p = "P", snp = "SNP",
            main = paste("Manhattan Plot -", base_name),
            cex = 0.6, cex.axis = 0.8,
            suggestiveline = -log10(1e-5),
            genomewideline = -log10(5e-8),
            col = c("skyblue3", "grey40"))
  dev.off()
  
  # ---------------------------
  # 绘制 QQ 图（标注 λ）
  # ---------------------------
  png(qq_png, width = 800, height = 800, res = 150)
  qq(df$P, main = paste0("QQ Plot - ", base_name, "\nλ = ", round(lambda_gc, 3)))
  dev.off()
  
  message("✅ 完成绘图: ", base_name, " | λ = ", round(lambda_gc, 3))
  
  return(data.table(File = base_name, Lambda = lambda_gc, N = nrow(df)))
}

# ---------------------------
# 批量运行
# ---------------------------
results <- rbindlist(lapply(files, function(f) try(plot_mlma_result(f))), fill = TRUE)

# ---------------------------
# 汇总 λ 并输出表格
# ---------------------------
lambda_out <- file.path(output_dir, "lambda_summary.tsv")
fwrite(results, lambda_out, sep = "\t")
message("📄 λ 结果已保存到: ", lambda_out)
message("🎉 所有分析绘图完成！")

