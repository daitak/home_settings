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
set incsearch "インクリメンタルサーチ有効
set ignorecase "大文字・小文字を無視
set hlsearch
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
"----------------------------------------------------------------------
"キーバインド関係
"行単位で移動（１行が長い場合に便利）
nnoremap j gj
nnoremap k gk
nnoremap <space>, <Esc>:edit $MYVIMRC<CR>
nnoremap sv <C-w>v
nnoremap ss <C-w>s
nnoremap sc <C-w>c
nnoremap so <C-w>o
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sh <C-w>h
nnoremap sl <C-w>l
nnoremap Y y$
inoremap <silent> <C-o> <C-^>
nnoremap <C-a> 0
nnoremap <C-e> $

imap {} {}<Left>
imap [] []<Left>
imap () ()<Left>
imap “” “”<Left>
imap ” ”<Left>
imap <> <><Left>
imap “ “<Left>
imap "" ""<Left>
imap '' ''<Left>

"----------------------------------------------------------------------
"プラグインごとの設定
"qfixhowm.vim
set runtimepath+=~/.vim/plugin/qfixapp
inoremap <C-k> {<Space>}
inoremap <C-l> *<Space>
"calendar.vim
nnoremap g,q <Esc>:Calendar<CR>
let calendar_action = "QFixHowmCalendarDiary"
let calendar_sign = "QFixHowmCalendarSign"
let howm_dir = '~/Dropbox/howm'
"neocomplcache.vim
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_omni_patterns = {
      \ 'objc'   :  '\h\w\+\|\%(\h\w*\|)\)\%(\.\|->\)\h\w*'
      \}

"taglist.vim
:set tags=tags
:autocmd BufWinEnter *.rb :TlistOpen
:autocmd BufWinEnter *.java :TlistOpen

"yanktmp.vim
map <silent> sy :call YanktmpYank()<CR>
map <silent> sp :call YanktmpPaste_p()<CR>
map <silent> sP :call YanktmpPaste_P()<CR>
