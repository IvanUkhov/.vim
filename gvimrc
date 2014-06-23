" Input
set mousemodel=extend

" Interface
colorscheme xoria256

let &colorcolumn=81
highlight ColorColumn guibg=#663333

set guioptions-=T
set guioptions-=m
set guioptions+=b

if has("mac")
  set transparency=0
  set guifont=Menlo:h17
else
  set guifont=Courier\ 10\ Pitch\ 11
endif

" Window
winpos 0 0

function! ResizeWindow()
  let width = 84

  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      let width = width + g:NERDTreeWinSize + 1
    endif
  endif

  let height = 100

  execute 'winsize ' . width . ' ' . height
endfunction
call ResizeWindow()

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

" Shortcuts
if has("mac")
  macmenu &File.Print key=<nop>
  macmenu &Edit.Cut key=<nop>
  macmenu &Edit.Find.Find\.\.\. key=<nop>
endif
