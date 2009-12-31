"=============================================================================
"    Description: プレビュー、絞り込み検索付Quickfix
"     Maintainer: fuenor@gmail.com
"                 http://sites.google.com/site/fudist/Home/grep
"  Last Modified: 2009-10-22 23:51
"        Version: 1.48
"=============================================================================
scriptencoding utf-8

if exists('disable_MyQFix') && disable_MyQFix == 1
  finish
endif
if exists("loaded_MyQFix") && !exists('fudist')
  finish
endif
if v:version < 700 || &cp
  finish
endif
let loaded_MyQFix = 1

"ファイルの開き方を指定する。
if !exists('g:QFix_FileOpenMode')
  let g:QFix_FileOpenMode = 0
endif
"ファイルを開くとQuickfixウィンドウを閉じる
if !exists('g:QFix_CloseOnJump')
  let g:QFix_CloseOnJump = 0
endif

"プレビューを有効にする
if !exists('g:QFix_PreviewEnable')
  let g:QFix_PreviewEnable = 1
endif
"カーソル強調表示を有効にする
if !exists('g:QFix_CursorLine')
  let g:QFix_CursorLine = 1
endif
"プレビューウィンドウのカーソル強調表示を有効にする
if !exists('g:QFix_PreviewCursorLine')
  let g:QFix_PreviewCursorLine = 1
endif
"プレビューでシンタックス表示を有効にする
if !exists('g:QFix_PreviewFtypeHighlight')
  let g:QFix_PreviewFtypeHighlight = 1
endif
"プレビューする間隔
if !exists('g:QFix_PreviewUpdatetime')
  let g:QFix_PreviewUpdatetime = 10
endif

"ファイルを開いたときの最小ウィンドウ高さを指定する。
"0なら全てのウィンドウサイズを同じ高さにする。
if !exists('g:QFix_WindowHeightMin')
  let g:QFix_WindowHeightMin = 0
endif

"Quickfixウィンドウのリストからファイル名を探す。
if !exists('g:QFix_GetFilename')
  let g:QFix_GetFilename = 0
endif

"Quickfixウィンドウのリストからジャンプ先を探す。
if !exists('g:QFix_GetJumpLine')
  let g:QFix_GetJumpLine = 0
endif

"howmファイル読込の際に、ファイルエンコーディングを指定する/しない
if !exists('g:QFixHowm_ForceEncoding')
  let g:QFixHowm_ForceEncoding = 1
endif

"常駐モードウィンドウリスト
if !exists('g:QFix_PermanentWindow')
  let g:QFix_PermanentWindow = []
endif

"QFixWin のwincmd o を使用する
if !exists('g:QFix_Wincmd_O')
  let g:QFix_Wincmd_O = 1
endif

"検索時のパス
if !exists('g:QFix_SearchPathEnable')
  let g:QFix_SearchPathEnable = 1
endif
let g:QFix_SearchPath = ''
let g:QFix_SelectedLine = 1
let g:QFix_SearchResult = []
let s:QFixPreviewfile = ''
let g:QFix_DefaultUpdatetime = 0
let g:QFix_MyJump = 0
let g:QFix_PreviewName = 'QuickfixPreview'
let g:QFixPrevQFList = []
let g:QFix_PrevWinnr = -1

""""""""""""""""""""""""""""""
"augroup
""""""""""""""""""""""""""""""
augroup QFixPre
  autocmd!
  autocmd QuickFixCmdPre * call <SID>QFixCmdPre()
augroup END

augroup QFix
  autocmd!
  autocmd BufWritePost       * call <SID>QFixBufWritePost()
  autocmd BufWinLeave        * call <SID>QFixBufWinLeave()
  autocmd BufLeave           * call <SID>QFixBufLeave()
  autocmd BufEnter           * call <SID>QFixBufEnter()
  autocmd BufWinEnter quickfix call <SID>QFixSetup()
  autocmd QuickFixCmdPost *vimgrep* call QFixSetEnv()
  autocmd CursorHold * call <SID>QFPreview()
  if !exists('g:MRU_Resize')
    let g:MRU_Resize = 0
    au BufWinEnter __MRU_Files__ let g:MRU_Resize = 1
    au BufEnter * if exists('g:loaded_MyQFix')|call QFixBufEnterResize(g:MRU_Resize)|let g:MRU_Resize = 0|endif
  endif
augroup END

if exists('disable_MyQFix') && disable_MyQFix == 2
  augroup! QFix
endif

""""""""""""""""""""""""""""""
"Quickfixウィンドウの初期化
""""""""""""""""""""""""""""""
function! s:QFixSetup(...)
  let qf = getqflist()
  if g:QFix_Modified
    let g:QFixPrevQFList = qf
    let g:QFix_Modified = 0
  elseif QFixModified(qf)
    call QFixDisable()
    silent! pclose!
    silent! cclose
    silent! copen
    call MyGrepSetqflist(qf)
    let g:QFixPrevQFList = qf
  endif
  if g:QFix_MyJump == 0
    return
  endif
  if a:0 == 0
    let g:QFix_Win = expand('<abuf>')
  endif
  if g:QFix_PreviewUpdatetime
    if g:QFix_PreviewUpdatetime != &updatetime
      let g:QFix_DefaultUpdatetime = &updatetime
    endif
    exec 'setlocal updatetime='.g:QFix_PreviewUpdatetime
  endif
  if g:QFix_CursorLine
"      hi CursorLine guifg=NONE guibg=NONE gui=underline
    setlocal cursorline
  else
    setlocal nocursorline
  endif
  setlocal nobuflisted
  setlocal nowrap
  nnoremap <buffer> <silent> <CR> :QFixMyJump <CR>
  nnoremap <buffer> <silent> <S-CR> :call <SID>QFixMyJump(1)<CR>
  nnoremap <buffer> <silent> <C-CR> :call <SID>QFixMyJump(2)<CR>
  nnoremap <buffer> <silent> <C-w>.     :QFixWinDefaultSize<CR>
  nnoremap <buffer> <silent> <C-w><C-r> :QFixWinDefaultSize<CR>
  nnoremap <buffer> <silent> <C-w>h     :call QFixAltWincmd_('h')<CR>
  nnoremap <buffer> <silent> <C-w>j     :call QFixAltWincmd_('j')<CR>
  nnoremap <buffer> <silent> <C-w>k     :call QFixAltWincmd_('k')<CR>
  nnoremap <buffer> <silent> <C-w>l     :call QFixAltWincmd_('l')<CR>
  nnoremap <buffer> <silent> <C-w><C-h> :call QFixAltWincmd_('h')<CR>
  nnoremap <buffer> <silent> <C-w><C-j> :call QFixAltWincmd_('j')<CR>
  nnoremap <buffer> <silent> <C-w><C-k> :call QFixAltWincmd_('k')<CR>
  nnoremap <buffer> <silent> <C-w><C-l> :call QFixAltWincmd_('l')<CR>
  nnoremap <buffer> <silent> i :call TogglePreview()<CR>
  nnoremap <buffer> <silent> I :call QFixCmd_I()<CR>
  nnoremap <buffer> <silent> J :call QFixCmd_J()<CR>
  nnoremap <buffer> <silent> q :CloseQFixWin<CR>
  nnoremap <buffer> <silent> A :call MyGrepWriteResult(0, '')<CR>
  nnoremap <buffer> <silent> <C-o> :call MyGrepWriteResult(0, '')<CR>
  nnoremap <buffer> <silent> <C-i> :MyGrepReadResult<CR>
  nnoremap <buffer> <silent> O :MyGrepReadResult<CR>
  nnoremap <buffer> <silent> s :call QFixSearchStrings()<CR>
  silent! nnoremap <buffer> <unique> <silent> S :call QFixSortExec()<CR>
  nnoremap <buffer> <silent> u :call SetModifiable('save')<CR>:setlocal modifiable<CR>:silent! exec 'silent! u'<CR>:call SetModifiable('restore')<CR>:call <SID>QFixSaveqflist()<CR>
  nnoremap <buffer> <silent> U :call <SID>QFixUndo()<CR>
  nnoremap <buffer> <silent> <C-r> :call SetModifiable('save')<CR>:setlocal modifiable<CR><C-r>:call SetModifiable('restore')<CR>:call <SID>QFixSaveqflist()<CR>
  nnoremap <buffer> <silent> <C-Q> :call ToggleModifiable()<CR>
  call PreviewEnable()
endfunction

""""""""""""""""""""""""""""""
"コマンド
""""""""""""""""""""""""""""""
command! DisableQFixWin call <SID>QFixCmdPre()
command! SetupQFixWin let g:QFix_MyJump = 1|call <SID>QFixSetup()
command! -count OpenQFixWin  call OpenQFixWin()
command! CloseQFixWin call CloseQFixWin()
command! -nargs=? -bang ResizeQFixWin call ResizeQFixWin(<args>)
command! QFixCclose   call CloseQFixWin()
command! ToggleModifiable if &modifiable |setlocal nomodifiable|else|setlocal modifiable|endif|echo 'Quickfix Modifiable '.(&modifiable?'ON':'OFF')
command! -count QFixWinDefaultSize call QFixWinDefaultSize(count)

""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
function! OpenQFixWin()
  if exists('g:QFix_Win') && bufnr('%') == g:QFix_Win
    return QFixWinDefaultSize(count)
  endif
  if count > 1
    let g:QFix_Height = count
  endif
  if exists('+autochdir')
    let saved_ac = &autochdir
    set noautochdir
  endif
  let prevPath = getcwd()
  let prevPath = escape(prevPath, ' ')
  if &lines - g:QFix_HeightMax > 0 && g:QFix_Height > &lines - g:QFix_HeightMax
    let g:QFix_Height = &lines - g:QFix_HeightMax
  endif
  if g:QFix_HeightFixMode == 1
    let g:QFix_Height = g:QFix_HeightDefault
  endif
  QFixCopen
  call s:QFixRestoreqflist('forced')
"    silent! call s:HighlightSearchWord(1)
  silent! exec 'normal! '.g:QFix_SelectedLine.'G'
  if g:QFix_MyJump && g:QFix_PreviewCursorLine
    silent! exec 'normal! zz'
  endif
  silent exec 'lchdir ' . prevPath
  if exists('+autochdir')
    let &autochdir = saved_ac
  endif
endfunction

""""""""""""""""""""""""""""""
function! QFixWinDefaultSize(count)
  let size = g:QFix_HeightDefault
  if a:count > 1
    let size = a:count
  endif
  exe 'QFixCopen '.size
endfunction

""""""""""""""""""""""""""""""
"Quickfix ウィンドウmodifiable ON/OFF。
""""""""""""""""""""""""""""""
function! ToggleModifiable()
  if &modifiable
    setlocal nomodifiable
    call s:QFixSaveqflist()
  else
    setlocal modifiable
  endif
  echo 'Quickfix Modifiable '.(&modifiable?'ON':'OFF')
endfunction

""""""""""""""""""""""""""""""
"Quickfix ウィンドウmodifiable ON/OFF。
""""""""""""""""""""""""""""""
let b:gmodifiable = 0
function! SetModifiable(cmd)
  if !exists('b:gmodifiable')
    let b:gmodifiable = 0
  endif
  if a:cmd =~ 'save'
    let b:gmodifiable = &modifiable
  elseif a:cmd =~ 'restore'
    if b:gmodifiable != 0
      setlocal modifiable
    else
      setlocal nomodifiable
    endif
  endif
endfunction

""""""""""""""""""""""""""""""
"Quickfix ウィンドウPreview ON/OFF。
""""""""""""""""""""""""""""""
function! TogglePreview()
  if !exists('g:QFix_Win')
    let g:QFix_Win = bufnr('%')
    let prevPath = getcwd()
    let prevPath = escape(prevPath, ' ')
    if g:QFix_SearchPathEnable && g:QFix_SearchPath != ''
      silent exec 'lchdir ' . escape(g:QFix_SearchPath, ' ')
    endif
    silent exec 'lchdir ' . prevPath
    return
  endif
  if g:QFix_PreviewEnable <= 0
    let g:QFix_PreviewEnable = 1
  else
    let g:QFix_PreviewEnable = 0
    call QFixPclose()
  endif
endfunction

""""""""""""""""""""""""""""""
"Quickfix ウィンドウをON/OFF。
""""""""""""""""""""""""""""""
command! -count -bang -nargs=? ToggleQFixWin call ToggleQFixWin(<bang>0)
command! -count MoveToQFixWin call MoveToQFixWin()

""""""""""""""""""""""""""""""
"Quickfixウィンドウのトグル
""""""""""""""""""""""""""""""
function! ToggleQFixWin(forced)
  let saved_pel = s:PreviewEnableLock
  if !exists('g:QFix_Win') || a:forced
    if count > 1
      let g:QFix_Height = count
    endif
    call OpenQFixWin()
"    if exists('+autochdir')
"      let saved_ac = &autochdir
"      set noautochdir
"    endif
"    let prevPath = getcwd()
"    let prevPath = escape(prevPath, ' ')
"    if &lines - g:QFix_HeightMax > 0 && g:QFix_Height > &lines - g:QFix_HeightMax
"      let g:QFix_Height = &lines - g:QFix_HeightMax
"    endif
"    if g:QFix_HeightFixMode == 1
"      let g:QFix_Height = g:QFix_HeightDefault
"    endif
"    QFixCopen
"    call s:QFixRestoreqflist('forced')
""    silent! call s:HighlightSearchWord(1)
"    silent! exec 'normal! '.g:QFix_SelectedLine.'G'
"    if g:QFix_MyJump && g:QFix_PreviewCursorLine
"      silent! exec 'normal! zz'
"    endif
"    silent exec 'lchdir ' . prevPath
"    if exists('+autochdir')
"      let &autochdir = saved_ac
"    endif
  else
    call CloseQFixWin()
    if count
      let g:QFix_Height = count
    endif
  endif
  let s:PreviewEnableLock = saved_pel
endfunction

""""""""""""""""""""""""""""""
"Quickfixウィンドウを閉じる
""""""""""""""""""""""""""""""
function! CloseQFixWin(...)
  let saved_pel = s:PreviewEnableLock
  call QFixSaveHeight(0)
  call PreviewDisable()
  silent! cclose
  unlet! g:QFix_Win
  let s:PreviewEnableLock = saved_pel
  return
endfunction

""""""""""""""""""""""""""""""
"Quickfixウィンドウを閉じる前チェック
""""""""""""""""""""""""""""""
function! QFixPreClose()
  silent! let bufnr = s:GetQFixbufnr('active')
  let bufname = bufname(bufnr)
  if bufnr == -1
    exec 'split ' . bufname
  else
    exec 'b ' . bufnr
    OpenQFixWin
    exe 'QFixCopen '.g:QFix_HeightDefault
  endif
endfunction

""""""""""""""""""""""""""""""
"Quickfix ウィンドウを探す。
""""""""""""""""""""""""""""""
function! s:GetQFixbufnr(mode)
  if a:mode == ''
    return
  endif
  redir => searchResult
  if a:mode == 'all'
    buffers!
  elseif a:mode == 'active' || a:mode == 'qfactive'
    buffers
  endif
  redir END
  let searchResult = searchResult . "\<NL>"
"  let cbuf = bufnr('%')
  let cbuf = expand('<abuf>')
  let blist = []
  while 1
    let idx = matchend(searchResult, "\<NL>")
    if idx == -1
      break
    endif
    let buf = strpart(searchResult, 0, idx)
    let searchResult = strpart(searchResult, idx + 1)
    let bufnr = str2nr(matchstr(buf, '^\s*\d\+'))
    if bufnr < 1 || bufnr == cbuf
      continue
    endif
    if exists('g:QFix_Win') && bufnr == g:QFix_Win
      continue
    endif
"    if bufwinnr(bufnr) != -1
    if bufname(bufnr) == ''
      call insert(blist, buf)
    else
      call add(blist, buf)
    endif
  endwhile
  if len(blist) == 0
    return -1
  endif
  let bufnr = str2nr(matchstr(blist[0], '^\s*\d\+'))
  return bufnr
endfunction

""""""""""""""""""""""""""""""
"pclose代替
""""""""""""""""""""""""""""""
function! QFixPclose()
  let saved_pel = s:PreviewEnableLock
  let s:PreviewEnableLock = 1
  let s:UseQFixPreviewOpen = 0
  silent! pclose!
  let s:UseQFixPreviewOpen = 1
  let s:PreviewEnableLock = saved_pel
endfunction

""""""""""""""""""""""""""""""
"Quickfixウィンドウのサイズを保管
""""""""""""""""""""""""""""""
function! QFixSaveHeight(saveline)
  let s:dmes = g:QFix_Height
  if exists('g:QFix_Win') && winbufnr(winnr()) == g:QFix_Win
    if a:saveline != 0
      let g:QFix_SelectedLine = line('.')
    endif
  endif
  if exists('g:QFix_Win') && bufwinnr(g:QFix_Win) > -1
    let w = winheight(bufwinnr(g:QFix_Win))
    if w > 0
      let g:QFix_Height = winheight(bufwinnr(g:QFix_Win))
      if &lines - g:QFix_HeightMax > 0 && g:QFix_Height > &lines - g:QFix_HeightMax
        let g:QFix_Height = &lines - g:QFix_HeightMax
      endif
      if g:QFix_HeightFixMode == 1
        let g:QFix_Height = g:QFix_HeightDefault
      endif
    endif
  endif
endfunction

""""""""""""""""""""""""""""""
"Quickfixウィンドウからジャンプ。
""""""""""""""""""""""""""""""
command! -count -bang -nargs=? QFixMyJump if count > 0 | call cursor(count, 0) | endif| call s:QFixMyJump(<bang>0)
function! s:QFixMyJump(mode)
  if g:QFix_MyJump == 0
    return feedkeys("\<CR>", 'n')
  endif
  let saved_pel = s:PreviewEnableLock
  let s:PreviewEnableLock = 1
  let prevPath = getcwd()
  let prevPath = escape(prevPath, ' ')
  if g:QFix_SearchPathEnable && g:QFix_SearchPath != ''
    silent exec 'lchdir ' . escape(g:QFix_SearchPath, ' ')
  endif
  call QFixSaveHeight(1)
  let closejump = g:QFix_CloseOnJump
  let movecursor = 1
  if a:mode == 2
    let movecursor = 0
"    let closejump = !g:QFix_CloseOnJump
  endif
  let line  = getline('.')
  let fname = substitute(matchstr(line, '^[^|]*'), '\\', '/', 'g')
  let line  = matchstr(line, '^[^|]*|.*|')
  let lnum  = str2nr(substitute(matchstr(line, '|[0-9]\+'), '|', '', ''))
  let cnum  = str2nr(substitute(matchstr(line, ' [0-9]\+|'), '|', '', ''))
  let qfname = s:GetFilename(fname, lnum)
  if qfname != ''
    let fname = qfname
  endif
  let text = substitute(getline('.'), '\(^.*\d\+| \)\{-1}','','')
  let qflnum = GetJumpLine(fname, text, 'qflist')
  if qflnum
    let lnum = qflnum
  endif
  if !filereadable(fname)
    if exists('+autochdir')
      let &autochdir = saved_ac
    endif
    silent exec 'lchdir ' . prevPath
    let s:PreviewEnableLock = saved_pel
    echohl ErrorMsg
    redraw|echom 'File does not exist : '.fname
    echohl None
    return
  endif
  if filereadable(getcwd() . '/' . fname)
    let fname = getcwd() . '/' . fname
    let fname = substitute(fname, '\\', '/', 'g')
  endif
  call PreviewDisable()
  let fname = substitute(fname, ' ', '\\ ', 'g')

  let saved_fom = g:QFix_FileOpenMode
  if a:mode == 1
    let g:QFix_FileOpenMode = !g:QFix_FileOpenMode
  endif
  call QFixEditFile(fname)
  let g:QFix_FileOpenMode = saved_fom
  if movecursor
    call cursor(lnum, cnum)
    if cnum == 0
      silent! exec 'normal! ^n'
      if (line('.') != lnum)
        call cursor(lnum, cnum)
      endif
    endif
    if exists("*QFixAfterJump")
      call QFixAfterJump()
    endif
  else
    exec "normal! g`\""
  endif
  if closejump == 0
    call s:QFixWindowResize()
  else
    CloseQFixWin
    unlet! g:QFix_Win
  endif
  silent! exec 'normal! zz'
  silent exec 'lchdir ' . prevPath
  let s:PreviewEnableLock = saved_pel
endfunction

""""""""""""""""""""""""""""""
"Quickfixウィンドウを文字列で絞り込み。
""""""""""""""""""""""""""""""
function! QFixSearchStrings()
  let _key = input('input search strings : ')
  if _key == ''
    return
  endif
  call MyRegisterBackup('save')
  call SetModifiable('save')
  setlocal modifiable
  silent! exec ':g!/'._key.'/d'
  silent! exec 'normal! gg'
  call SetModifiable('restore')
  call MyRegisterBackup('restore')
  call s:QFixSaveqflist()
  let @/=_key
  call s:HighlightSearchWord(1)
endfunction

""""""""""""""""""""""""""""""
"quickfixソートをトグル
""""""""""""""""""""""""""""""
function! QFixSortExec(...)
  let mes = 'Sort type? (r:reverse)+(m:mtime, n:name, t:text) : '
  if a:0
    let pattern = a:1
  else
    let pattern = input(mes, '')
  endif
  if pattern =~ 'r\?m'
    let g:QFix_Sort = substitute(pattern, 'm', 'mtime', '')
  elseif pattern =~ 'r\?n'
    let g:QFix_Sort = substitute(pattern, 'n', 'name', '')
  elseif pattern =~ 'r\?t'
    let g:QFix_Sort = substitute(pattern, 't', 'text', '')
  elseif pattern == 'r'
    let g:QFix_Sort = 'reverse'
  else
    return
  endif
  let pv = g:QFix_PreviewEnable
  call PreviewDisable()
  if g:QFix_Sort =~ 'mtime'
    let sq = QFixSort(g:QFix_Sort)
  elseif g:QFix_Sort =~ 'name'
    let sq = QFixSort(g:QFix_Sort)
  elseif g:QFix_Sort =~ 'text'
    let sq = QFixSort(g:QFix_Sort)
  elseif g:QFix_Sort =~ 'reverse'
    let sq = getqflist()
    let sq = reverse(sq)
  endif
  "CloseQFixWin
  call MyGrepSetqflist(sq)
  let g:QFix_SelectedLine = 1
  OpenQFixWin
  setlocal modifiable
  silent! exec 'normal! 9999999999u'
  setlocal nomodifiable
  call s:QFixSaveqflist()
  call cursor(1,1)
  if pv > 0
    call PreviewEnable()
  endif
  redraw|echo 'Sorted by '.g:QFix_Sort.'.'
endfunction

""""""""""""""""""""""""""""""
"quickfixをソート
""""""""""""""""""""""""""""""
let g:QFix_Sort = ''
function! QFixSort(cmd)
  let save_qflist = getqflist()
  if a:cmd =~ 'mtime'
    let bname = ''
    let bmtime = 0
    for d in save_qflist
      if bname == bufname(d.bufnr)
        let d['mtime'] = bmtime
      else
        let d['mtime'] = getftime(bufname(d.bufnr))
      endif
      let bname  = bufname(d.bufnr)
      let bmtime = d.mtime
    endfor
    let save_qflist = sort(save_qflist, "QFixCompareTime")
  elseif a:cmd =~ 'name'
    let save_qflist = sort(save_qflist, "QFixCompareName")
  elseif a:cmd =~ 'text'
    let save_qflist = sort(save_qflist, "QFixCompareText")
  endif
  if g:QFix_Sort =~ 'r.*'
    let save_qflist = reverse(save_qflist)
  endif
  let g:QFix_SearchResult = []
  return save_qflist
endfunction

""""""""""""""""""""""""""""""
"quickfix比較
""""""""""""""""""""""""""""""
function! QFixCompareName(v1, v2)
  if a:v1.bufnr == a:v2.bufnr
    return (a:v1.lnum > a:v2.lnum?1:-1)
  endif
  return (bufname(a:v1.bufnr) . a:v1.lnum> bufname(a:v2.bufnr).a:v2.lnum?1:-1)
endfunction
function! QFixCompareTime(v1, v2)
  if a:v1.mtime == a:v2.mtime
    if a:v1.bufnr != a:v2.bufnr
      return (bufname(a:v1.bufnr) < bufname(a:v2.bufnr)?1:-1)
    endif
    return (a:v1.lnum > a:v2.lnum?1:-1)
  endif
  return (a:v1.mtime < a:v2.mtime?1:-1)
endfunction
function! QFixCompareText(v1, v2)
  if a:v1.text == a:v2.text
    return (bufname(a:v1.bufnr) < bufname(a:v2.bufnr)?1:-1)
  endif
  return (a:v1.text > a:v2.text?1:-1)
endfunction

""""""""""""""""""""""""""""""
"quickfixからファイル名を取り出し。
""""""""""""""""""""""""""""""
function! QFixGet(cmd, ...)
  let line  = getline('.')
  if a:0
    let line  = a:1
  endif
  let fname = substitute(matchstr(line, '^[^|]*'), '\\', '/', 'g')
  let line  = matchstr(line, '^[^|]*|.*|')
  let lnum  = str2nr(substitute(matchstr(line, '|[0-9]\+'), '|', '', ''))
  if a:cmd == 'lnum'
    return lnum
  endif
  let cnum  = str2nr(substitute(matchstr(line, ' [0-9]\+|'), '|', '', ''))
  if a:cmd == 'cnum'
    return cnum
  endif
  if a:cmd == 'file'
    let qfname = s:GetFilename(fname, lnum)
    if qfname != ''
      let fname = qfname
    endif
"    let fname = substitute(fname, ' ', '\\ ', 'g')
    return fname
  endif
  return substitute(line, '^\(.*\d\+\s*|\)\{-1}', '', '') == e.title
endfunction

""""""""""""""""""""""""""""""
"quickfixのリストからファイル名を取り出し。
""""""""""""""""""""""""""""""
function! s:GetFilename(name, lnum)
  if g:QFix_GetFilename == 0
    return ''
  endif
  let save_qflist = getqflist()
  for d in save_qflist
    if d.lnum == a:lnum
      if bufname(d.bufnr) =~ a:name
        let fname = bufname(d.bufnr)
        return fname
      endif
    endif
  endfor
  return ''
endfunction

""""""""""""""""""""""""""""""
"quickfixリストからジャンプ先を取り出し。
""""""""""""""""""""""""""""""
function! GetJumpLine(name, text,...)
  "絞り込みされていなければ直接ジャンプ
"  let qf = g:QFixPrevQFList
  if s:QFixDispModified == 0 || g:QFix_SearchResult == []
    let cline = line('.') - 1
    if a:0
      let qf = getqflist()
    else
      let qf = g:QFixPrevQFList
    endif
    if len (qf) > cline
      return qf[cline]['lnum']
    endif
  endif
  if g:QFix_GetJumpLine == 0 || a:name == ''
    return 0
  endif
  "TODO:絞り込み時は複数ジャンプ先が存在する
  for d in g:QFixPrevQFList
    if bufname(d.bufnr) =~ a:name && d.text == a:text
      return d.lnum
    endif
  endfor
  return 0
endfunction

""""""""""""""""""""""""""""""
" searchWord にしたがって、ハイライトを設定する
" searchWordType を見て searchWord の解釈を変える
"  0: 固定文字列
"  1: 正規表現 ( grep )
"  2: 正規表現 ( Vim )
""""""""""""""""""""""""""""""
function! s:HighlightSearchWord(searchWordType)
  let searchWord = @/
  let searchWordType = a:searchWordType
  if searchWord == ''
    return
  endif
  if searchWordType == 0
    let pat = '\c\V' . escape(searchWord, '\')
  elseif searchWordType == 1
    let pat = '\c\v' . escape(searchWord, '=~@%()[]+|')
  elseif searchWordType == 2
    let pat = searchWord
  else
    return
  endif
  silent! syntax clear QFixSearchWord
  hi QFixSearchWord ctermfg=Red ctermbg=Grey guifg=Red guibg=bg
  silent! exec 'syntax match QFixSearchWord display "' . escape(pat, '"') . '"'
endfunction

function! QFixSetEnv(...)
  call s:QFixCmdPre()
  let g:QFix_MyJump = 1
  let g:QFix_Modified = 1
  let g:QFix_SearchPath = getcwd()
  if a:0 > 0
    let g:QFix_SearchPath = a:1
  endif
endfunction

""""""""""""""""""""""""""""""
"初期化
""""""""""""""""""""""""""""""
function! s:QFixCmdPre()
"  unlet! g:QFix_Win
"  silent! cclose
"  mapclear <buffer>
  let g:QFix_MyJump = 0
  let g:QFix_Sort = 'default'
  let g:QFix_SearchPath = ''
  let g:QFix_SelectedLine = 1
  let g:QFix_SearchResult = []
  let s:QFixPreviewfile = ''
  let s:UseQFixPreviewOpen = 1
  let g:QFix_Modified = 0
endfunction

""""""""""""""""""""""""""""""
"Previewを有効にする。
""""""""""""""""""""""""""""""
let s:PreviewEnableLock = 0
function! PreviewEnable()
  if s:PreviewEnableLock
    return
  endif
  if g:QFix_PreviewEnable < 0
    let g:QFix_PreviewEnable = 1
  endif
endfunction

""""""""""""""""""""""""""""""
"Previewを無効にする。
""""""""""""""""""""""""""""""
function! PreviewDisable()
  if g:QFix_PreviewEnable == 1
    let g:QFix_PreviewEnable = -1
  endif
  call QFixPclose()
endfunction

""""""""""""""""""""""""""""""
"BufEnter イベント
""""""""""""""""""""""""""""""
if !exists('g:QFix_nowinfixReg')
  let QFix_nowinfixReg = '\.[0-9a-zA-Z]\+$\|vimrc$'
endif
if !exists('g:QFix_winfixReg')
  let QFix_winfixReg = ''
endif
function! s:QFixBufEnter(...)
  if exists('g:QFix_Win') && (expand('<abuf>') == g:QFix_Win)
"    echoe 'QFixBufEnter'
    if g:QFix_PreviewUpdatetime
      if g:QFix_PreviewUpdatetime != &updatetime
        let g:QFix_DefaultUpdatetime = &updatetime
      endif
      exec 'setlocal updatetime='.g:QFix_PreviewUpdatetime
    endif
    call PreviewEnable()
  elseif g:QFix_DefaultUpdatetime
    exec 'setlocal updatetime='.g:QFix_DefaultUpdatetime
    if &previewwindow == 0
      let g:QFix_PrevWinnr = winnr()
    endif
  endif
  if expand('%') !~ '__'
    if expand('%') =~ g:QFix_nowinfixReg && &previewwindow == 0
      setlocal nowinfixheight
      setlocal nowinfixwidth
    endif
  endif
endfunction

""""""""""""""""""""""""""""""
"BufWritePost イベント
""""""""""""""""""""""""""""""
function! s:QFixBufWritePost(...)
  let g:QFixPrevQFList = getqflist()
endfunction

""""""""""""""""""""""""""""""
"BufWinLeave イベント
""""""""""""""""""""""""""""""
function! s:QFixBufWinLeave(...)
  if exists('g:QFix_Win') && (expand('<abuf>') == g:QFix_Win)
    unlet! g:QFix_Win
"    echoe 'QFixBufWinLeave'
  endif
endfunction

""""""""""""""""""""""""""""""
"BufLeave イベント
""""""""""""""""""""""""""""""
function! s:QFixBufLeave(...)
  if exists('g:QFix_Win') && (expand('<abuf>') == g:QFix_Win)
    let g:QFix_SelectedLine = line('.')
    call QFixSaveHeight(0)
    call PreviewDisable()
    call s:QFixSaveqflist()
  endif
endfunction

""""""""""""""""""""""""""""""
"BufDelete イベント
""""""""""""""""""""""""""""""
function! s:QFixBufDelete(...)
  if exists('g:QFix_Win') && &filetype == 'qf'
"    unlet! g:QFix_Win
"    echoe 'QFixBufDelete'
  endif
endfunction

""""""""""""""""""""""""""""""
"CursorHold/CursorMoved用ハンドラ
""""""""""""""""""""""""""""""
function! s:QFPreview()
  if g:QFix_PreviewUpdatetime != &updatetime
    let g:QFix_DefaultUpdatetime = &updatetime
  endif
  if g:QFix_MyJump == 0
    return
  endif
  if exists('g:QFix_Win') && expand('<abuf>') == g:QFix_Win
    let g:QFix_SelectedLine = line('.')
    if g:QFix_PreviewEnable > 0
      call QFixPreview()
    endif
  endif
  return
endfunction

""""""""""""""""""""""""""""""
"Quickfixプレビュー。
""""""""""""""""""""""""""""""
let s:UseQFixPreviewOpen = 1
function! QFixPreview()
  if g:QFix_PreviewEnable < 1 || g:QFix_MyJump == 0
    return
  endif
  let saved_ei = &eventignore
  set eventignore=CursorMoved,BufLeave
  if g:QFix_PreviewEnable > 0
    let file = QFixGet('file')
    let file = escape(file, ' ')
    let lnum  = GetJumpLine('', '')
    if lnum == 0
      let lnum = QFixGet('lnum')
    endif
    if file != '' && s:UseQFixPreviewOpen
      call QFixPreviewOpen(file, lnum)
    endif
  endif
  let &eventignore = saved_ei
  return
endfunction

""""""""""""""""""""""""""""""
"Quickfixプレビュー本体。
""""""""""""""""""""""""""""""
let QFix_PreviewWindow = 0
function! QFixPreviewOpen(file, line, ...)
  let file = a:file
  let file = substitute(file, '\s$', '', '')
  if s:QFixPreviewfile == file
    silent! wincmd P
    if &previewwindow
      if a:line == line('.')
        silent! wincmd p
        return
      endif
      silent! exec 'normal '. a:line .'Gzz'
      if g:QFix_PreviewCursorLine
"        hi CursorLine guifg=NONE guibg=NONE gui=underline
        setlocal cursorline
      else
        setlocal nocursorline
      endif
      silent! wincmd p
      return
    endif
  endif
  let s:QFixPreviewfile = file
  if &previewwindow
  else
    silent! exec 'silent! pedit! '.g:QFix_PreviewName
  endif
  silent! wincmd P
  " set options
  setlocal nobuflisted
  setlocal noswapfile
  setlocal buftype=nofile
  setlocal bufhidden=delete
  setlocal nowinfixheight
  setlocal nowinfixwidth
  setlocal modifiable

  if g:QFix_PreviewCursorLine
"    hi CursorLine guifg=NONE guibg=NONE gui=underline
    setlocal cursorline
  else
    setlocal nocursorline
  endif
"    setlocal syntax=none
  let prevPath = getcwd()
  let prevPath = escape(prevPath, ' ')
  if g:QFix_SearchPathEnable && g:QFix_SearchPath != ''
    silent exec 'lchdir ' . escape(g:QFix_SearchPath, ' ')
  endif

  silent! %delete _
  let cmd = '-r '
  "howmの場合はファイルエンコードを指定してやる
  let ftype = substitute(file, '.*\.', '', '')
  if exists('g:QFixHowm_FileExt') && ftype == g:QFixHowm_FileExt
    if exists('g:howm_fileencoding') && exists('g:QFixHowm_ForceEncoding') && g:QFixHowm_ForceEncoding
      let cmd = cmd.' ++enc='.g:howm_fileencoding
    endif
  endif
  silent! exec cmd.' ' file
  silent! $delete _
  silent! exec 'normal! 0gg'
  setlocal nomodifiable
  silent exec 'lchdir ' . prevPath
  silent! exec 'normal! '. a:line .'Gzz'
  if g:QFix_PreviewFtypeHighlight != 0
    if exists('g:QFixHowm_FileExt') && exists('g:QFixHowm_FileType') && ftype == g:QFixHowm_FileExt
      let ftype = g:QFixHowm_FileType
    endif
    if ftype != ""
      silent! exec 'setlocal filetype='.ftype
    endif
"    silent! call s:HighlightSearchWord(1)
  else
    silent! call s:HighlightSearchWord(1)
  endif
  silent! wincmd p
endfunction

""""""""""""""""""""""""""""""
"レジスタのバックアップ
""""""""""""""""""""""""""""""
let g:MyRegisterBackup = [@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @/, @", @"]
function! MyRegisterBackup(cmd)
  if a:cmd == 'save'
    let g:MyRegisterBackup = [@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @/, @", @"]
    if has('gui')
      let g:MyRegisterBackup[12] = @*
    endif
  elseif a:cmd == 'restore'
    for n in range(10)
      silent! exec 'let @'.n.'=g:MyRegisterBackup['.n.']'
    endfor
    let @/ = g:MyRegisterBackup[10]
    let @" = g:MyRegisterBackup[11]
    if has('gui')
      let @* = g:MyRegisterBackup[12]
    endif
  endif
endfunction

""""""""""""""""""""""""""""""
"現在のQuickfix画面の状態を保存
""""""""""""""""""""""""""""""
let s:QFixDispModified = 0
function! s:QFixSaveqflist()
  if &modified == 0
    let g:QFix_SearchResult = []
    let s:QFixDispModified = 0
    return
  endif
  let g:QFix_SearchResult = [getline(1)]
  for i in range(2,line('$'))
    call add(g:QFix_SearchResult, getline(i))
  endfor
  let g:QFix_SearchResultDisp = g:QFix_SearchResult
  let s:QFixDispModified = 1
  return

endfunction

""""""""""""""""""""""""""""""
"保存したQuickfix画面をリストア
""""""""""""""""""""""""""""""
function! s:QFixRestoreqflist(...)
  if len(g:QFix_SearchResult) <= 1
    return
  endif
  let l:QFix_SearchResult = [getline(1)]
  for i in range(2,line('$'))
    call add(l:QFix_SearchResult, getline(i))
  endfor
  if g:QFix_SearchResult == l:QFix_SearchResult
    return
  endif
  setlocal modifiable
  silent! exec 'normal! 9999999999u'
  silent! %delete _
  call append(0, g:QFix_SearchResult)
  silent! $delete _
  setlocal nomodifiable
  silent! exec 'normal! '.g:QFix_SelectedLine.'G'
endfunction

""""""""""""""""""""""""""""""
"ジャンプ後にカーソル位置を設定
""""""""""""""""""""""""""""""
function! QFixAfterJump()
"ジャンプ後<C-o>で最後の編集位置へ
  silent! exec "normal! m`"
  silent! exec "normal! `\""
  silent! exec "normal! ``"
  return
"ジャンプ後<C-i>で最後の編集位置へ
  exec "normal! `\""
  exec "normal! \<C-o>"
  return
endfunction

""""""""""""""""""""""""""""""
"ジャンプ後のウィンドウ動作切替
""""""""""""""""""""""""""""""
function! QFixCmd_J()
  let g:QFix_CloseOnJump = !g:QFix_CloseOnJump
  echo 'Close on jump : ' . (g:QFix_CloseOnJump? 'ON' : 'OFF')
endfunction

""""""""""""""""""""""""""""""
"ハイライト切替
""""""""""""""""""""""""""""""
function! QFixCmd_I()
  let g:QFix_PreviewFtypeHighlight = !g:QFix_PreviewFtypeHighlight
  let s:QFixPreviewfile = ''
  echo 'FileType syntax : ' . (g:QFix_PreviewFtypeHighlight? 'ON' : 'OFF')
endfunction

""""""""""""""""""""""""""""""
"ファイルが存在するので開く
""""""""""""""""""""""""""""""
function! QFixEditFile(fname)
  let saved_pel = s:PreviewEnableLock
  let s:PreviewEnableLock = 1
  let fname = a:fname
  let prevPath = getcwd()
  let prevPath = escape(prevPath, ' ')
  let maxheight = &window-&cmdheight-winheight(0)

  if g:QFix_FileOpenMode == 0
    let winnum = bufwinnr('' . a:fname . '$')
    if winnum != -1 && winnum != winnr()
      exec winnum . 'wincmd w'
      silent exec 'lchdir ' . prevPath
      let s:PreviewEnableLock = saved_pel
      return
    endif
    let openwin = 0
    if exists('g:QFix_Win') && bufwinnr(g:QFix_Win) > -1
"      silent! wincmd w
      if g:QFix_PrevWinnr > -1
"          echom g:QFix_PrevWinnr.'wincmd w'
        exec g:QFix_PrevWinnr.'wincmd w'
      else
        silent! wincmd w
      endif
      CloseQFixWin
      let openwin = 1
    endif
    if maxheight == 0 && g:QFix_CopenCmd !~ 'vertical'
      split
    endif
    silent exec 'lchdir ' . prevPath
    let bufnr = bufnr(fname)
    if bufnr != -1
      silent! exec 'b ' . bufnr
    else
      silent! exec 'edit ' . fname
    endif
    if openwin
      OpenQFixWin
      if maxheight== 0
        let g:QFix_Height = g:QFix_HeightDefault
"        exec 'resize '. g:QFix_Height
      endif
      silent! wincmd p
    endif
    silent exec 'lchdir ' . prevPath
    let s:PreviewEnableLock = saved_pel
    return
  endif
  MoveToQFixWin

  silent! wincmd p
  silent exec 'lchdir ' . prevPath
  let cmd = ''
  if g:QFix_CopenCmd =~ 'vertical'
"    silent! wincmd w
  endif
  if &modified || &buftype != '' || &previewwindow
    exec cmd .'split ' . fname
  else
    exec cmd .'split ' . fname
  endif
  silent exec 'lchdir ' . prevPath
  let s:PreviewEnableLock = saved_pel
endfunction

""""""""""""""""""""""""""""""
"exec代替
""""""""""""""""""""""""""""""
function! QFixAltExec(cmd)
  exec a:cmd
endfunction

""""""""""""""""""""""""""""""
"QFix対応close
""""""""""""""""""""""""""""""
function! QFixAltClose()
  if exists('g:QFix_Win') && bufwinnr('%') == g:QFix_Win
    silent! pclose!
    if winnr('$') >= 2
      CloseQFixWin
    else
      silent! let bufnr = s:GetQFixbufnr('active')
      let bufname = bufname(bufnr)
      if bufnr == -1
        split
      else
        exec 'split ' . bufname
      endif
    endif
    CloseQFixWin
    return
  endif
  if winnr('$') == 2 && exists('g:QFix_Win') && bufwinnr(g:QFix_Win) != -1
    CloseQFixWin
    return
  endif
  confirm close
endfunction

""""""""""""""""""""""""""""""
"QFix対応wincmd o
""""""""""""""""""""""""""""""
if g:QFix_Wincmd_O
  silent! nnoremap <unique> <silent> <C-w><C-o> :call QFixAltWincmd_O()<CR>
  silent! nnoremap <unique> <silent> <C-w>o     :call QFixAltWincmd_O()<CR>
endif
function! QFixAltWincmd_O()
  "TODO:常駐させたいウィンドウを消さないようにする
  let buf = bufnr('%')
  let qfwin = -1
  if exists('g:QFix_Win')
    let qfwin = bufwinnr(g:QFix_Win)
  endif
  if qfwin == winnr()
    silent! wincmd o
    return
  endif
  for pw in g:QFix_PermanentWindow
    let pw['active'] = 0
    for d in range(0, winnr('$')-1)
      if bufname(winbufnr(d)) == pw['name']
        let pw['active'] = 1
        break
      endif
    endfor
  endfor
  CloseQFixWin
  if winnr('$') == 1
    return
  endif
  silent! wincmd o
  for pw in g:QFix_PermanentWindow
    if pw['active']
      exec ' '.pw['cmd']
    endif
  endfor
  if qfwin > -1
    OpenQFixWin
  endif
  let w = bufwinnr(buf)
  exec w.'wincmd w'
endfunction

""""""""""""""""""""""""""""""
"QFixWindow限定 wincmd
""""""""""""""""""""""""""""""
function! QFixAltWincmd_(cmd)
  silent! pclose!
  exec 'wincmd '.a:cmd
  return
endfunction

""""""""""""""""""""""""""""""
"Quickfixウィンドウに移動する
""""""""""""""""""""""""""""""
silent! nnoremap <unique> <silent> <C-w>,     :ToggleQFixWin<CR>
silent! nnoremap <unique> <silent> <C-w>.     :MoveToQFixWin<CR>
function! MoveToQFixWin()
  if count > 1
    let g:QFix_Height = count
    "CloseQFixWin
    OpenQFixWin
    return
  endif
  if exists('g:QFix_Win') && bufwinnr(g:QFix_Win) > -1
    let winnum = bufwinnr(g:QFix_Win)
    if winnum != winnr()
      exec winnum . 'wincmd w'
    endif
  else
    "CloseQFixWin
    OpenQFixWin
  endif
endfunction

function! ResizeQFixWin(...)
  if !exists('g:QFix_Win') || bufwinnr(g:QFix_Win) == -1
    return
  endif
  let size = g:QFix_HeightDefault
  if a:0
    let size = a:1
  endif
  MoveToQFixWin
  exec 'resize '.size
  silent! wincmd p
endfunction

""""""""""""""""""""""""""""""
"ファイルを開いたときのウィンドウ高さを設定
"0なら全てのウィンドウ高さを同じにする
""""""""""""""""""""""""""""""
function! s:QFixWindowResize()
  if g:QFix_WindowHeightMin
    let wh = winheight(0)
    if wh < g:QFix_WindowHeightMin
      exe 'resize ' . g:QFix_WindowHeightMin
    endif
  else
    silent! wincmd =
  endif
endfunction

""""""""""""""""""""""""""""""
"echo debug messages
""""""""""""""""""""""""""""""
let s:dmes = ''
function! QFixDMes()
  let qwin = -1
  if exists('g:QFix_Win')
    let qwin = g:QFix_Win
  endif
  redraw|echom s:dmes ' (s:QFin_Win :' qwin ')'
endfunction

""""""""""""""""""""""""""""""
"常駐ウィンドウを登録
""""""""""""""""""""""""""""""
function! QFixPermanentWindow(title, cmd)
  let title = a:title
  let cmd = a:cmd
  let list = {'name':title, 'cmd':cmd}
  call add(g:QFix_PermanentWindow, list)
endfunction

""""""""""""""""""""""""""""""
"他のウィンドウなどでサイズ変更された場合、元のウィンドウサイズに戻す
"1ならデフォルトサイズ、それ以外は指定サイズに変更する
"au BufWinEnter __MRU_Files__ let MRU_Resize = g:QFix_Height
"au BufEnter * call QFixBufEnterResize(MRU_Resize)|let MRU_Resize = 0
""""""""""""""""""""""""""""""
function! QFixBufEnterResize(resize)
  if !exists('g:QFix_Win') || bufwinnr(g:QFix_Win) == -1
    return
  endif
  if g:QFix_CopenCmd =~ 'vertical'
    return
  endif
  let size = a:resize
  if size == 1
    let size = g:QFix_HeightDefault
  endif
  if size
    ResizeQFixWin size
  endif
endfunction

""""""""""""""""""""""""""""""
"改変チェック
""""""""""""""""""""""""""""""
function! QFixModified(qf)
  if a:qf == g:QFixPrevQFList
    return 0
  endif
  if len(a:qf) != len(g:QFixPrevQFList)
    return 1
  endif
  for n in range(len(a:qf))
    if a:qf[n]['bufnr'] != g:QFixPrevQFList[n]['bufnr'] || a:qf[n]['text'] != g:QFixPrevQFList[n]['text']
      return 1
    endif
    if a:qf[n]['lnum'] != g:QFixPrevQFList[n]['lnum']
      let qflnum = a:qf[n]['lnum']
      let qffile = bufname(a:qf[n]['bufnr'])
      let plnum  = g:QFixPrevQFList[n]['lnum']
      let g:QFixPrevQFList[n]['lnum'] = qflnum
      "TODO:ここでQuickfix上の表示も書き換えないとジャンプ行がずれる
      for d in g:QFix_SearchResult
        let file = matchstr(d, '\(^.*|\d\+\)\{-1}')
        if file =~ qffile.'|'.plnum
          let d = substitute('|\d\+', '|'.qflnum, '')
          break
        endif
      endfor
      let g:QFix_SearchResult = []
      call s:QFixRestoreqflist()
    endif
  endfor
  return 0
endfunction

function! <SID>QFixUndo()
  let g:QFix_SearchResult = []
  setlocal modifiable
  silent! exec 'normal! 9999999999u'
  setlocal nomodifiable
endfunction
