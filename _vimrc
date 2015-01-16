"------------------------------------------------------------
"neobundleによるプラグイン管理
"------------------------------------------------------------

" vim起動時のみruntimepathにneobundle.vimを追加
if has('vim_starting')
  set nocompatible
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

" 使用するプロトコルを変更する(プロキシ対策)
"let g:neobundle_default_git_protocol='https'

" neobundle.vimの初期化 
call neobundle#begin(expand('~/.vim/bundle'))

" NeoBundleを更新するための設定
NeoBundleFetch 'Shougo/neobundle.vim'

" 読み込むプラグインを記載
NeoBundle 'Shougo/unite.vim'
NeoBundle 'fuenor/qfitgrep'
NeoBundle 'fuenor/qfixhowm'
NeoBundle 'junegunn/seoul256.vim'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'tpope/vim-surround'
NeoBundle 'sakuraiyuta/commentout.vim'
"NeoBundle 'itchyny/calendar.vim'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle "osyo-manga/unite-qfixhowm"
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimshell.vim'
NeoBundle 'Shougo/neomru.vim'

call neobundle#end()

" 読み込んだプラグインも含め、ファイルタイプの検出、ファイルタイプ別プラグイン/インデントを有効化する
filetype plugin indent on

" インストールのチェック
NeoBundleCheck


"------------------------------------------------------------
"基本設定
"------------------------------------------------------------

set nocompatible

set guioptions=

:set viminfo+=n%VIM%/viminfo.txt

:set nu

"ステータスラインに文字コード等表示
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

"ウィンドウサイズを変更（デフォルトで最大にする）
au GUIEnter * simalt ~x


"タブと行末のスペース表示
set list
set listchars=tab:>\ ,trail:_


"vimgrepをデフォルトのgrepプログラムとして使用する
:set grepprg=internal


set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab

:filetype plugin on

"ヤンクにクリップボードを利用する
set clipboard=unnamed,autoselect

"IMEのon/offを確認できるようにする
hi CursorIM  guifg=black  guibg=red  gui=NONE  ctermfg=black  ctermbg=white  cterm=reverse


"バイナリ編集(xxd)モード（vim -b での起動、もしくは *.bin ファイルを開くと発動します）
augroup BinaryXXD
  autocmd!
  autocmd BufReadPre  *.bin let &binary =1
  autocmd BufReadPost * if &binary | silent %!xxd -g 1
  autocmd BufReadPost * set ft=xxd | endif
  autocmd BufWritePre * if &binary | %!xxd -r | endif
  autocmd BufWritePost * if &binary | silent %!xxd -g 1
  autocmd BufWritePost * set nomod | endif
augroup END


"------------------------------------------------------------
"コマンド定義
"------------------------------------------------------------
command! Big wincmd _|wincmd |


"------------------------------------------------------------
"キーマップ
"------------------------------------------------------------
inoremap <C-L> {_}
inoremap <C-K> {<Space>}
imap <C-D> <Esc>g,d

noremap <F6> :r!date/T<CR>

noremap / g/

noremap <C-h> ^
noremap <C-l> $

noremap <Space>j <C-f>
noremap <Space>k <C-b>

nnoremap sh <C-w>h
nnoremap sl <C-w>l
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sv <C-w>v
nnoremap ss <C-w>s
nnoremap so <C-w>o
nnoremap sc <C-w>c
nnoremap s= <C-w>=
nnoremap s\| <C-w>\|
noremap sb :Big<CR>

noremap ,, <Esc>:edit $MYVIMRC<CR>
noremap .. <Esc>:edit $MYGVIMRC<CR>

nnoremap Y y$


"カッコ等を書いたらカーソルを戻す
imap “” “”<Left>
imap ” ”<Left>
imap “ “<Left>
imap "" ""<Left>
imap '' ''<Left>
"imap {} {}<Left>
"imap () ()<Left>
"imap <> <><Left>
"imap [] []<Left>
imap { {}<Left>
imap ( ()<Left>
imap < <><Left>

"Visual mode で選択したテキストを検索する
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>


"------------------------------------------------------------
"プラグイン
"------------------------------------------------------------
" vim-indent-guides
"
" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup = 1

" qfixhowm
"
"パスを通す
let QFixHowm_Key = 'g'
let howm_dir = 'd:/MyDoc/howm'
let howm_filename = '%Y/%m/%Y-%m-%d-%H%M%S.howm'
let howm_fileencoding = 'cp932'
let howm_fileformat = 'dos'
let QFixHowm_RecentDays = 30
let g:buftabs_only_basename=1 " ファイル名だけ表示
let g:buftabs_in_statusline=1 " ステータスラインに表示
noremap <Space> :bnext<CR> " Space, Shift+Space でバッファを切り替え
noremap <S-Space> :bprev<CR>

"折りたたみのパターン
let QFixHowm_FoldingPattern = '^[=.*[]'

"外部grep(yagrep)を使用する
let mygrepprg = 'yagrep'
let MyGrepcmd_useropt = '-i --include="*.howm"'

let QFix_Height = 20

"calendar.vimとhowmの連携
let calendar_action = "QFixHowmCalendarDiary"
let calendar_sign = "QFixHowmCalendarSign"

"日記
let QFixHowm_DiaryFile = '%Y/%m/%Y-%m-%d-000000.howm'

" タイトル行識別子
if !exists('g:QFixHowm_Title')
  let g:QFixHowm_Title = '='
endif

" タイトル検索のエスケープパターン
if !exists('g:QFixHowm_EscapeTitle')
  let g:QFixHowm_EscapeTitle = '~*.\'
endif

"タイトルに何も書かれていない場合、エントリ内から適当な文を探して設定する。
"文字数は半角換算で最大 QFixHowm_Replace_Title_len 文字まで使用する。0なら何もしない。
let QFixHowm_Replace_Title_Len = 64
"対象になるのは QFixHowm_Replace_Title_Pattern の正規表現に一致するタイトルパターン。
"デフォルトでは次の正規表現が設定されている。
let QFixHowm_Replace_Title_Pattern = '^'.escape(g:QFixHowm_Title, g:QFixHowm_EscapeTitle).'\s*\(\[[^\]]*\]\s*\)\=$'

"新規エントリの際、本文から書き始める。
let QFixHowm_Cmd_New = "i".QFixHowm_Title." \<CR>\<C-r>=strftime(\"[%Y-%m-%d %H:%M]\")\<CR>\<CR>\<ESC>$a"
",Cで挿入される新規エントリのコマンド  
let QFixHowm_Key_Cmd_C = "o<ESC>".QFixHowm_Cmd_New


"vimで開く拡張子の正規表現
let QFixHowm_OpenVimExtReg  = '\.txt$\|\.howm$\|\.vim$'

"gotoリンクを開くブラウザの指定
if has('win32')
  "Internet explorer
  "let QFixHowm_OpenURIcmd = '!start "C:/Program Files/Internet Explorer/iexplore.exe" %s'
  "firefox
  "let QFixHowm_OpenURIcmd  = '!start "C:/Program Files/Mozilla Firefox/firefox.exe" %s'
  let QFixHowm_OpenURIcmd  = '!start "C:\Program Files (x86)\Mozilla Firefox\firefox.exe" %s'
elseif has('unix')
  let QFixHowm_OpenURIcmd = "call system('firefox %s &')"
endif

"初回起動時に実行したいコマンド
let QFixHowm_VimEnterCmd = 't'
"自動起動コマンド表示の確認用メッセージ
let QFixHowm_VimEnterMsg = '今日の予定を表示します'

let QFixHowm_ShowScheduleTodo = 10
let QFixHowm_ShowTodayLine = 3

let QFixHowm_HolidayFile = 'd:\MyDoc\howm\holiday\Sche-Hd-0000-00-00-000000.cp932'

"Calendar表示
"autocmd BufWinEnter *.howm :Calendar


" unite
"
"unite prefix key.
nnoremap [unite] <Nop>
"nmap <Space>f [unite]
nmap ,u [unite]

"インサートモードで開始しない
let g:unite_enable_start_insert = 0

" For ack.
if executable('ack-grep')
  let g:unite_source_grep_command = 'ack-grep'
  let g:unite_source_grep_default_opts = '--no-heading --no-color -a'
  let g:unite_source_grep_recursive_opt = ''
endif

"file_mruの表示フォーマットを指定。空にすると表示スピードが高速化される
let g:unite_source_file_mru_filename_format = ''

"bookmarkだけホームディレクトリに保存
let g:unite_source_bookmark_directory = $HOME . '/.unite/bookmark'

"現在開いているファイルのディレクトリ下のファイル一覧。
"開いていない場合はカレントディレクトリ
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
"バッファ一覧
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
"レジスタ一覧
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
"最近使用したファイル一覧
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
"ブックマーク一覧
nnoremap <silent> [unite]c :<C-u>Unite bookmark<CR>
"ブックマークに追加
nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>
"uniteを開いている間のキーマッピング
augroup vimrc
  autocmd FileType unite call s:unite_my_settings()
augroup END
function! s:unite_my_settings()
  "ESCでuniteを終了
  nmap <buffer> <ESC> <Plug>(unite_exit)
  "入力モードのときjjでノーマルモードに移動
  imap <buffer> jj <Plug>(unite_insert_leave)
  "入力モードのときctrl+wでバックスラッシュも削除
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  "sでsplit
  nnoremap <silent><buffer><expr> s unite#smart_map('s', unite#do_action('split'))
  inoremap <silent><buffer><expr> s unite#smart_map('s', unite#do_action('split'))
  "vでvsplit
  nnoremap <silent><buffer><expr> v unite#smart_map('v', unite#do_action('vsplit'))
  inoremap <silent><buffer><expr> v unite#smart_map('v', unite#do_action('vsplit'))
  "fでvimfiler
  nnoremap <silent><buffer><expr> f unite#smart_map('f', unite#do_action('vimfiler'))
  inoremap <silent><buffer><expr> f unite#smart_map('f', unite#do_action('vimfiler'))
endfunction


" unite-qfixhowm
"
nnoremap <silent> [unite]q :<C-u>Unite qfixhowm<CR>


" vimfiler
"
let g:vimfiler_as_default_explorer = 1
"セーフモードを無効にした状態で起動する
let g:vimfiler_safe_mode_by_default = 0
"現在開いているバッファのディレクトリを開く
nnoremap <silent> <Leader>fe :<C-u>VimFilerBufferDir -quit<CR>
"現在開いているバッファをIDE風に開く
nnoremap <silent> <Leader>fi :<C-u>VimFilerBufferDir -split -simple -winwidth=35 -no-quit<CR>

"デフォルトのキーマッピングを変更
augroup vimrc
  autocmd FileType vimfiler call s:vimfiler_my_settings()
augroup END
function! s:vimfiler_my_settings()
  nmap <buffer> q <Plug>(vimfiler_exit)
  nmap <buffer> Q <Plug>(vimfiler_hide)
endfunction
