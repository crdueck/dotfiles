autocmd BufRead,BufNewFile */templates/*.yaml,*/templates/*.tpl set ft=helm

autocmd FileType helm setlocal commentstring={{/*\ %s\ */}}
