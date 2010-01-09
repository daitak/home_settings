scriptencoding cp932

if exists('disable_MyQFix') && disable_MyQFix
  finish
endif
if exists('disable_MyHowm') && disable_MyHowm
  finish
endif
if exists("loaded_QFixCalencdar_vim") && !exists('fudist')
  finish
endif
let loaded_QFixCalencdar_vim = 1
if v:version < 700 || &cp
  finish
endif

function! QFixHowmCalendarSign(day, month, year)
  let year  = printf("%4.4d",a:year)
  let month = printf("%2.2d",a:month)
  let day   = printf("%2.2d",a:day)
  let sfile = g:howm_dir.'/'.year.'/'.month.'/'.year.'-'.month.'-'.day.'-000000.howm'
  return filereadable(expand(sfile))
endfunction

function! QFixHowmCalendarDiary(day, month, year, week, dir)
  let ww = winwidth('%')
  let year  = printf("%4.4d",a:year)
  let month = printf("%2.2d",a:month)
  let day   = printf("%2.2d",a:day)
  let hfile = year.'/'.month.'/'.year.'-'.month.'-'.day.'-000000.howm'
  let sfile = g:howm_dir.'/'.hfile
  let winnr = bufwinnr(bufnr(expand(sfile)))
  let lwinnr = winnr('$')
  set winfixwidth
  wincmd w
  if filereadable(expand(sfile))
    if winnr > -1
      exec winnr.'wincmd w'
    else
      exe "e " . escape(expand(sfile), ' ')
    endif
  else
    call QFixHowmCreateNewFile(hfile)
  endif
  if lwinnr == 1
    Calendar
    wincmd p
  endif
endfunction

