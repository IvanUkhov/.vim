call pathogen#infect()

" General
set number
set imdisable
set mouse=a
set ttymouse=xterm2
set nocompatible
set backspace=indent,eol,start
set history=1000
set showcmd
set showmode
set incsearch
set hlsearch
set ignorecase
set showbreak=>\
set wrap linebreak nolist
set linespace=4
set visualbell t_vb=
set iskeyword=a-z,A-Z,48-57,_
set hidden
set cryptmethod=blowfish

syntax on
filetype plugin indent on
scriptencoding utf-8

" Status line
set statusline=%f
set statusline+=%=
set statusline+=%c,
set statusline+=%l/%L
set statusline+=\ %P
set laststatus=2

" Folding
set foldmethod=indent
set foldnestmax=3
set nofoldenable

" Tab completion
set wildmode=list:longest
set wildmenu
set wildignore=*.o,*~

" Scrolling
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

" Navigation
nmap <Down> gj
nmap <Up> gk

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nmap <Tab> gt
nmap <S-Tab> gT

" Shortcuts
let mapleader=" "

map ,, :e <C-R>=expand("%:p:h") . "/" <CR><SPACE><BACKSPACE>
cmap ,, <C-R>=expand("%:p:h") . "/" <CR><SPACE><BACKSPACE>
map ,a :A <CR>
nmap <C-s> :w<CR>
nmap <leader><leader> <C-^>

" Indentation
function SwitchToTabs()
  set shiftwidth=4
  set softtabstop=0
  set tabstop=4
  set noexpandtab
  set cindent
endfunction
autocmd BufEnter *.c,*.cpp,*.h,*.hpp call SwitchToTabs()

function SwitchToSpaces()
  set shiftwidth=2
  set softtabstop=2
  set tabstop=2
  set expandtab
  set autoindent
endfunction
autocmd BufEnter *.rb,*.py,*.tex,*.m call SwitchToSpaces()

call SwitchToSpaces()

" Spell checking
set nospell

function CheckSpelling()
  set spelllang=en_us
  syntax spell toplevel
  set spell
endfunction
autocmd BufEnter *.tex,*.html call CheckSpelling()

" Cursor position
function! RestoreCursorPosition()
  if &filetype !~ 'commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  end
endfunction
autocmd BufReadPost * call RestoreCursorPosition()

" Trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace guibg=red

function! FindTrailingWhitespace()
  if @% == "GoToFile" " The search window of CommandT
    return
  endif
  match ExtraWhitespace /\s\+$/
endfunction
autocmd BufEnter * call FindTrailingWhitespace()
autocmd InsertEnter * call FindTrailingWhitespace()
autocmd InsertLeave * call FindTrailingWhitespace()

function! StripTrailingWhitespace()
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction
autocmd BufWritePre * call StripTrailingWhitespace()

" Plugins
let g:CommandTMaxHeight=10
let g:CommandTMatchWindowAtTop=1

if has("mac")
  nmap <silent> <D-d> :NERDTreeToggle<CR>
  nmap <silent> <D-x> :BufExplorer<CR>
  nmap <silent> <D-f> :CommandT<CR>
else
  nmap <silent> <M-d> :NERDTreeToggle<CR>
  nmap <silent> <M-x> :BufExplorer<CR>
  nmap <silent> <M-f> :CommandT<CR>
endif
