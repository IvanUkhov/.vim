call pathogen#infect()

" General
set nocompatible
set encoding=utf-8
set number
set imdisable
set mouse=a
set ttymouse=xterm2
set backspace=indent,eol,start
set history=1000
set showcmd
set showmode
set linespace=4
set visualbell t_vb=
set iskeyword=a-z,A-Z,48-57,_
set hidden
set cryptmethod=blowfish

syntax on
filetype plugin indent on

" Searching
set incsearch
set hlsearch
set ignorecase

" Line wrapping
set wrap
set linebreak
set showbreak=↪\ "

" Invisible characters
set list
set listchars=tab:▸\ ,trail:•,extends:❯,precedes:❮

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

" Shortcuts
let mapleader=" "

function GetCurrentDirectory()
  return substitute(expand("%:p:h"), " ", '\\\ ', "g")
endfunction

map ,, :e <C-R>=GetCurrentDirectory() . "/" <CR><Space><Backspace>
cmap ,, <C-R>=GetCurrentDirectory() . "/" <CR><Space><Backspace>

nmap <C-s> :w<CR>
nmap <Leader><Leader> <C-^>

" Navigation
nmap <Down> gj
nmap <Up> gk

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nmap <Tab> gt
nmap <S-Tab> gT

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

" Plugins
let g:CommandTMaxHeight=10
let g:CommandTMatchWindowAtTop=1

nmap <Leader>f :CommandTFlush<CR>

if has("mac")
  nmap <silent> <D-d> :NERDTreeToggle<CR>
  nmap <silent> <D-x> :BufExplorer<CR>
  nmap <silent> <D-f> :CommandT<CR>
else
  nmap <silent> <M-d> :NERDTreeToggle<CR>
  nmap <silent> <M-x> :BufExplorer<CR>
  nmap <silent> <M-f> :CommandT<CR>
endif
