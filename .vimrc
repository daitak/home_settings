"----------------------------------------------------------------------
set nocompatible
"----------------------------------------------------------------------
"ステータスライン
set laststatus=2 "常にステータスラインを表示
set statusline=%<%F\ %r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%4v(ASCII=%03.3b,HEX=%02.2B)\ %l/%L(%P)%m
"----------------------------------------------------------------------
"基本設定
set vb t_vb=         "ビープ音をならさない
set nu               "行番号を表示する
syntax on
filetype on
filetype indent on
filetype plugin on
set autoindent
"----------------------------------------------------------------------
"キーバインド関係
"行単位で移動（１行が長い場合に便利）
nnoremap j gj
nnoremap k gk
nnoremap <space>, <Esc>:edit $MYVIMRC<CR>
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
"----------------------------------------------------------------------
"プラグインごとの設定
"qfixhowm.vim
set runtimepath+=~/.vim/plugin/qfixapp
inoremap <C-k> {<Space>}
inoremap <C-l> =>
"calendar.vim
nnoremap g,q <Esc>:Calendar<CR>
let calendar_action = "QFixHowmCalendarDiary"
let calendar_sign = "QFixHowmCalendarSign"
