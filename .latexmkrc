# 本项目统一使用 XeLaTeX -> XDV -> xdvipdfmx -> PDF。
$pdf_mode = 5;
$xelatex = 'xelatex -halt-on-error %O %S';

# Beamer 与 BibTeX 的辅助文件也参与清理；不删除 pic/ 中的素材。
$clean_ext .= ' nav snm vrb bbl';

# Ghostscript 9.50+ 默认启用 SAFER。只开放本示例实际需要的四个
# PSTricks prolog 文件供读取，保留 SAFER，并启用 PSTricks 的透明操作。
my @pstricks_prologs;
for my $header (qw(pstricks.pro pst-algparser.pro pst-tools.pro pst-dots.pro)) {
    open(my $kpse, '-|', 'kpsewhich', $header)
        or die "Cannot run kpsewhich for $header: $!\n";
    chomp(my $path = <$kpse> // '');
    close($kpse);
    die "Missing PSTricks prolog: $header\n" unless -f $path;
    push @pstricks_prologs, $path;
}
$ENV{'GS_OPTIONS'} = join ' ', grep { length } (
    $ENV{'GS_OPTIONS'} // '',
    '-dALLOWPSTRANSPARENCY',
    '--permit-file-read=' . join(':', @pstricks_prologs)
);
