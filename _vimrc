"------------------------------------------------------------
"neobundle�ɂ��v���O�C���Ǘ�
"------------------------------------------------------------

" vim�N�����̂�runtimepath��neobundle.vim��ǉ�
if has('vim_starting')
  set nocompatible
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

" �g�p����v���g�R����ύX����(�v���L�V�΍�)
"let g:neobundle_default_git_protocol='https'

" neobundle.vim�̏����� 
call neobundle#begin(expand('~/.vim/bundle'))

" NeoBundle���X�V���邽�߂̐ݒ�
NeoBundleFetch 'Shougo/neobundle.vim'

" �ǂݍ��ރv���O�C�����L��
NeoBundle 'Shougo/unite.vim'
NeoBundle 'fuenor/qfixgrep'
NeoBundle 'fuenor/qfixhowm'
NeoBundle 'tpope/vim-surround'
NeoBundle 'sakuraiyuta/commentout.vim'
"NeoBundle 'itchyny/calendar.vim'
if has("gui_running") && ( has("win32unix") || has ("win64unix") || has("win32") || has ("win64") )
    NeoBundle 'nathanaelkane/vim-indent-guides'
    NeoBundle 'junegunn/seoul256.vim'
    NeoBundle 'w0ng/vim-hybrid'
else
    NeoBundle "KyleOndy/wombat256mod"
endif
NeoBundle "osyo-manga/unite-qfixhowm"
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimproc'

call neobundle#end()

" �ǂݍ��񂾃v���O�C�����܂߁A�t�@�C���^�C�v�̌��o�A�t�@�C���^�C�v�ʃv���O�C��/�C���f���g��L��������
filetype plugin indent on

" �C���X�g�[���̃`�F�b�N
NeoBundleCheck


"------------------------------------------------------------
"��{�ݒ�
"------------------------------------------------------------

set nocompatible

set guioptions=

:set viminfo+=n~/.vim/viminfo.txt
:set nu

"�X�e�[�^�X���C���ɕ����R�[�h���\��
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

"�E�B���h�E�T�C�Y��ύX�i�f�t�H���g�ōő�ɂ���j
au GUIEnter * simalt ~x


"�^�u�ƍs���̃X�y�[�X�\��
set list
set listchars=tab:>\ ,trail:_


"vimgrep���f�t�H���g��grep�v���O�����Ƃ��Ďg�p����
:set grepprg=internal


set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab

:filetype plugin on

"�����N�ɃN���b�v�{�[�h�𗘗p����
set clipboard=unnamed,autoselect

"IME��on/off���m�F�ł���悤�ɂ���
hi CursorIM  guifg=black  guibg=red  gui=NONE  ctermfg=black  ctermbg=white  cterm=reverse


"�o�C�i���ҏW(xxd)���[�h�ivim -b �ł̋N���A�������� *.bin �t�@�C�����J���Ɣ������܂��j
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
"�R�}���h��`
"------------------------------------------------------------
command! Big wincmd _|wincmd |


"------------------------------------------------------------
"�L�[�}�b�v
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


"�J�b�R������������J�[�\����߂�
imap �g�h �g�h<Left>
imap �h �h<Left>
imap �g �g<Left>
imap "" ""<Left>
imap '' ''<Left>
"imap {} {}<Left>
"imap () ()<Left>
"imap <> <><Left>
"imap [] []<Left>
imap { {}<Left>
imap ( ()<Left>
imap < <><Left>

"Visual mode �őI�������e�L�X�g����������
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>


"------------------------------------------------------------
"�v���O�C��
"------------------------------------------------------------
" vim-indent-guides
"
" vim�𗧂��グ���Ƃ��ɁA�����I��vim-indent-guides���I���ɂ���
let g:indent_guides_enable_on_vim_startup = 1

" qfixhowm
"
"�p�X��ʂ�
let QFixHowm_Key = 'g'
let howm_dir = 'd:/MyDoc/howm'
let howm_filename = '%Y/%m/%Y-%m-%d-%H%M%S.howm'
let howm_fileencoding = 'cp932'
let howm_fileformat = 'dos'
let QFixHowm_RecentDays = 30
let g:buftabs_only_basename=1 " �t�@�C���������\��
let g:buftabs_in_statusline=1 " �X�e�[�^�X���C���ɕ\��
noremap <Space> :bnext<CR> " Space, Shift+Space �Ńo�b�t�@��؂�ւ�
noremap <S-Space> :bprev<CR>

"�܂肽���݂̃p�^�[��
let QFixHowm_FoldingPattern = '^[=.*[]'

"�O��grep(yagrep)���g�p����
if has("gui_running") && ( has("win32unix") || has ("win64unix") || has("win32") || has ("win64") )
    let mygrepprg = 'yagrep'
    let MyGrepcmd_useropt = '-i --include="*.howm"'
endif

let QFix_Height = 20

"calendar.vim��howm�̘A�g
let calendar_action = "QFixHowmCalendarDiary"
let calendar_sign = "QFixHowmCalendarSign"

"���L
let QFixHowm_DiaryFile = '%Y/%m/%Y-%m-%d-000000.howm'

" �^�C�g���s���ʎq
if !exists('g:QFixHowm_Title')
  let g:QFixHowm_Title = '='
endif

" �^�C�g�������̃G�X�P�[�v�p�^�[��
if !exists('g:QFixHowm_EscapeTitle')
  let g:QFixHowm_EscapeTitle = '~*.\'
endif

"�^�C�g���ɉ���������Ă��Ȃ��ꍇ�A�G���g��������K���ȕ���T���Đݒ肷��B
"�������͔��p���Z�ōő� QFixHowm_Replace_Title_len �����܂Ŏg�p����B0�Ȃ牽�����Ȃ��B
let QFixHowm_Replace_Title_Len = 64
"�ΏۂɂȂ�̂� QFixHowm_Replace_Title_Pattern �̐��K�\���Ɉ�v����^�C�g���p�^�[���B
"�f�t�H���g�ł͎��̐��K�\�����ݒ肳��Ă���B
let QFixHowm_Replace_Title_Pattern = '^'.escape(g:QFixHowm_Title, g:QFixHowm_EscapeTitle).'\s*\(\[[^\]]*\]\s*\)\=$'

"�V�K�G���g���̍ہA�{�����珑���n�߂�B
let QFixHowm_Cmd_New = "i".QFixHowm_Title." \<CR>\<C-r>=strftime(\"[%Y-%m-%d %H:%M]\")\<CR>\<CR>\<ESC>$a"
",C�ő}�������V�K�G���g���̃R�}���h  
let QFixHowm_Key_Cmd_C = "o<ESC>".QFixHowm_Cmd_New


"vim�ŊJ���g���q�̐��K�\��
let QFixHowm_OpenVimExtReg  = '\.txt$\|\.howm$\|\.vim$'

"goto�����N���J���u���E�U�̎w��
if has('win32')
  "Internet explorer
  "let QFixHowm_OpenURIcmd = '!start "C:/Program Files/Internet Explorer/iexplore.exe" %s'
  "firefox
  "let QFixHowm_OpenURIcmd  = '!start "C:/Program Files/Mozilla Firefox/firefox.exe" %s'
  let QFixHowm_OpenURIcmd  = '!start "C:\Program Files (x86)\Mozilla Firefox\firefox.exe" %s'
elseif has('unix')
  let QFixHowm_OpenURIcmd = "call system('firefox %s &')"
endif

"����N�����Ɏ��s�������R�}���h
let QFixHowm_VimEnterCmd = 't'
"�����N���R�}���h�\���̊m�F�p���b�Z�[�W
let QFixHowm_VimEnterMsg = '�����̗\���\�����܂�'

let QFixHowm_ShowScheduleTodo = 10
let QFixHowm_ShowTodayLine = 3

let QFixHowm_HolidayFile = 'd:\MyDoc\howm\holiday\Sche-Hd-0000-00-00-000000.cp932'

"Calendar�\��
"autocmd BufWinEnter *.howm :Calendar


" unite
"
"unite prefix key.
nnoremap [unite] <Nop>
"nmap <Space>f [unite]
nmap ,u [unite]

"�C���T�[�g���[�h�ŊJ�n���Ȃ�
let g:unite_enable_start_insert = 0

" For ack.
if executable('ack-grep')
  let g:unite_source_grep_command = 'ack-grep'
  let g:unite_source_grep_default_opts = '--no-heading --no-color -a'
  let g:unite_source_grep_recursive_opt = ''
endif

"file_mru�̕\���t�H�[�}�b�g���w��B��ɂ���ƕ\���X�s�[�h�������������
let g:unite_source_file_mru_filename_format = ''

"bookmark�����z�[���f�B���N�g���ɕۑ�
let g:unite_source_bookmark_directory = $HOME . '/.unite/bookmark'

"���݊J���Ă���t�@�C���̃f�B���N�g�����̃t�@�C���ꗗ�B
"�J���Ă��Ȃ��ꍇ�̓J�����g�f�B���N�g��
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
"�o�b�t�@�ꗗ
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
"���W�X�^�ꗗ
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
"�ŋߎg�p�����t�@�C���ꗗ
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
"�u�b�N�}�[�N�ꗗ
nnoremap <silent> [unite]c :<C-u>Unite bookmark<CR>
"�u�b�N�}�[�N�ɒǉ�
nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>
"unite���J���Ă���Ԃ̃L�[�}�b�s���O
augroup vimrc
  autocmd FileType unite call s:unite_my_settings()
augroup END
function! s:unite_my_settings()
  "ESC��unite���I��
  nmap <buffer> <ESC> <Plug>(unite_exit)
  "���̓��[�h�̂Ƃ�jj�Ńm�[�}�����[�h�Ɉړ�
  imap <buffer> jj <Plug>(unite_insert_leave)
  "���̓��[�h�̂Ƃ�ctrl+w�Ńo�b�N�X���b�V�����폜
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  "s��split
  nnoremap <silent><buffer><expr> s unite#smart_map('s', unite#do_action('split'))
  inoremap <silent><buffer><expr> s unite#smart_map('s', unite#do_action('split'))
  "v��vsplit
  nnoremap <silent><buffer><expr> v unite#smart_map('v', unite#do_action('vsplit'))
  inoremap <silent><buffer><expr> v unite#smart_map('v', unite#do_action('vsplit'))
  "f��vimfiler
  nnoremap <silent><buffer><expr> f unite#smart_map('f', unite#do_action('vimfiler'))
  inoremap <silent><buffer><expr> f unite#smart_map('f', unite#do_action('vimfiler'))
endfunction


" unite-qfixhowm
"
nnoremap g,u :Unite qfixhowm<CR>


" vimfiler
"
let g:vimfiler_as_default_explorer = 1
"�Z�[�t���[�h�𖳌��ɂ�����ԂŋN������
let g:vimfiler_safe_mode_by_default = 0
"���݊J���Ă���o�b�t�@�̃f�B���N�g�����J��
nnoremap <silent> <Leader>fe :<C-u>VimFilerBufferDir -quit<CR>
"���݊J���Ă���o�b�t�@��IDE���ɊJ��
nnoremap <silent> <Leader>fi :<C-u>VimFilerBufferDir -split -simple -winwidth=35 -no-quit<CR>

"�f�t�H���g�̃L�[�}�b�s���O��ύX
augroup vimrc
  autocmd FileType vimfiler call s:vimfiler_my_settings()
augroup END
function! s:vimfiler_my_settings()
  nmap <buffer> q <Plug>(vimfiler_exit)
  nmap <buffer> Q <Plug>(vimfiler_hide)
endfunction
