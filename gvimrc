" Input
set mousemodel=extend

" Window
winpos 0 0

function! ResizeWindow(...)
  if a:0 > 0
    let lines = a:1
  else
    let lines = &lines
  end

  let columns = 80 + &numberwidth

  if exists('t:NERDTreeBufName')
    if bufwinnr(t:NERDTreeBufName) != -1
      let columns = columns + g:NERDTreeWinSize + 1
    endif
  endif

  execute 'set lines=' . lines . ' columns=' . columns
endfunction
call ResizeWindow(100)

nmap <Leader>r :call ResizeWindow()<CR>

function! RestoreSession()
  let file = $HOME . '/.gvimsession'
  if filereadable(file)
    let data = split(readfile(file)[0])
    silent! execute 'winpos ' . data[0] . ' ' . data[1]
  endif
endfunction

function! SaveSession()
  let file = $HOME . '/.gvimsession'
  let data = [
    \ (getwinposx() < 0 ? 0 : getwinposx()) . ' ' .
    \ (getwinposy() < 0 ? 0 : getwinposy()) ]
  call writefile(data, file)
endfunction

autocmd VimEnter * call RestoreSession()
autocmd VimLeavePre * call SaveSession()

" Interface
set background=light

let &colorcolumn=81

set guioptions-=T
set guioptions-=m
set guioptions+=b

if has('mac')
  set transparency=0
  set guifont=Menlo:h17

  macmenu &File.Print key=<nop>
  macmenu &Edit.Cut key=<nop>
  macmenu &Edit.Find.Find\.\.\. key=<nop>
else
  set guifont=Monospace\ 11
endif
