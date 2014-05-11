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
