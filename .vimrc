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
set encoding=utf-8 "内部エンコーディングをUTF8に変更"
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
"rails.vim
nnoremap ,r <Esc>:R<CR>
nnoremap ,rv <Esc>:Rview<Space>
nnoremap ,rc <Esc>:Rcontroller<Space>
nnoremap ,rh <Esc>:Rhelper<Space>


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
":autocmd BufWinEnter *.rb :TlistOpen
":autocmd BufWinEnter *.java :TlistOpen

"yanktmp.vim
map <silent> sy :call YanktmpYank()<CR>
map <silent> sp :call YanktmpPaste_p()<CR>
map <silent> sP :call YanktmpPaste_P()<CR>

"redmine.vim
let g:redmine_auth_site = 'http://192.168.0.20'
let g:redmine_auth_key = 'ccf1cfd4f0c32ed4204239a565d445d3d52c0b87'
let g:redmine_author_id = '4'
let g:redmine_project_id = 'keii-prototype-rails'

"unite.vim
" 入力モードで開始する
let g:unite_enable_start_insert=1
" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
"unite-help
nnoremap <silent> ,uh :<C-u>Unite help<CR>

" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
""unite-grep
let g:unite_source_grep_default_opts = '-iRHn'
nnoremap <silent> ,ug :<C-u>Unite grep<CR>
""unite-file_rec
nnoremap <silent> ,uF :<C-u>Unite file_rec -buffer-name=files file<CR>
