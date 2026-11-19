# LaTeXmk configuration file
# 使用 xelatex 编译
$pdf_mode = 5;

# 默认编译器
$xelatex = 'xelatex -interaction=nonstopmode -synctex=1 %O %S';

# 自动清理临时文件
$clean_ext = 'aux log nav out snm toc vrb fdb_latexmk fls synctex.gz';
