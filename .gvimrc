"----------------------------------------------------
"デザイン
colorscheme slate
set guioptions-=T    "ツールバー削除
"挿入モード・検索モードでのデフォルトのIME状態設定
set transparency=10
set guifont=Menlo:h12
set lines=70 columns=130
hi CursorIM  guifg=black  guibg=red  gui=NONE  ctermfg=black  ctermbg=white  cterm=reverse
"----------------------------------------------------------------------
"キーバインド関係
nnoremap <space>. <Esc>:edit $MYGVIMRC<CR>
