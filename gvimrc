" General
set mousemodel=extend

" Colors
colorscheme xoria256

" Window
winpos 0 0

if has("mac")
  winsize 84 40
else
  winsize 84 50
endif

function! RestoreScreen()
  let file = $HOME.'/.gvimscreen'
  if filereadable(file)
    let data = split(readfile(file)[0])
    silent! execute 'winpos '.data[0].' '.data[1]
  endif
endfunction

function! SaveScreen()
  let file = $HOME.'/.gvimscreen'
  let data = [
    \ (getwinposx() < 0 ? 0 : getwinposx()) . ' ' .
    \ (getwinposy() < 0 ? 0 : getwinposy()) ]
  call writefile(data, file)
endfunction

autocmd VimEnter * call RestoreScreen()
autocmd VimLeavePre * call SaveScreen()

" Interface
set guioptions-=T
set guioptions-=m
set guioptions+=b

if has("mac")
  set transparency=0
  set guifont=Menlo:h17
else
  set guifont=Courier\ 10\ Pitch\ 11
endif

" Shortcuts
if has("mac")
  macmenu &File.Print key=<nop>
  macmenu &Edit.Cut key=<nop>
  macmenu &Edit.Find.Find\.\.\. key=<nop>
endif
