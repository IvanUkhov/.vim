call pathogen#infect()

" General
set nocompatible
set encoding=utf-8
set hidden
set number
set linespace=4
set history=1000
set cryptmethod=blowfish

syntax on
filetype plugin indent on

" Input
set imdisable
set mouse=a
set ttymouse=xterm2
set backspace=indent,eol,start
set visualbell t_vb=

let mapleader=' '

" Window
nnoremap = <C-W>2+
nnoremap - <C-W>2-
nnoremap + <C-W>2>
nnoremap _ <C-W>2<

" Interface
let g:solarized_termcolors=256
set background=dark
colorscheme solarized

nmap <Leader>d :set background=dark \| colorscheme solarized<CR>
nmap <Leader>l :set background=light \| colorscheme solarized<CR>

" Status line
set laststatus=2

set showcmd
set showmode

set statusline=%<%f\ %-4(%m%)%=%-8(%3l,%3c%)

" Searching
set incsearch
set hlsearch
set iskeyword=a-z,A-Z,48-57,_

set ignorecase smartcase

nmap <Leader>i :set ignorecase! \| set ignorecase?<CR>

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  command -nargs=+ -complete=file -bar
    \ Ag silent! grep! <args>|cwindow|redraw!
  nmap \ :Ag<SPACE>
endif

nmap <Leader>g :grep! "\b<C-R><C-W>\b"<CR><CR>:cw<CR>

" Line wrapping
set nowrap
set linebreak
set showbreak=↪\ "

nmap <Leader>w :set wrap! list! \| set wrap?<CR>

" Invisible characters
set list
set listchars=tab:▸\ ,trail:•,extends:❯,precedes:❮

function! StripTrailingWhitespace()
  let pattern = @/
  let line = line('.')
  let column = col('.')

  silent! %s/\s\+$//

  let @/ = pattern
  call cursor(line, column)
endfunction

nmap <Leader>cl :call StripTrailingWhitespace()<CR>

" Folding
set foldmethod=indent
set foldnestmax=3
set nofoldenable

" Tab completion
set wildmode=list:longest
set wildmenu
set wildignore=*.o,*~

" Scrolling
set scrolloff=1
set sidescrolloff=7
set sidescroll=1

" Navigation
set nostartofline

nnoremap <Down> gj
nnoremap <Up> gk

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <Leader><Leader> <C-^>

nmap <Leader>x :w<CR>:bd<CR>
nmap <Leader>j :bn<CR>
nmap <Leader>k :bp<CR>

" Indentation
function! SwitchToTabs()
  set shiftwidth=4
  set softtabstop=0
  set tabstop=4
  set noexpandtab
  set cindent
endfunction
autocmd BufEnter *.js,*.c,*.cpp,*.h,*.hpp call SwitchToTabs()

function! SwitchToSpaces()
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

nmap <Leader>s :set spell! \| set spell?<CR>

function! CheckSpelling()
  set spelllang=en_us
  syntax spell toplevel
  set spell
endfunction
autocmd BufEnter *.txt,*.md,*.html,*.tex call CheckSpelling()

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

set cursorline

" Editing
set nojoinspaces

nmap <Leader>vi :e ~/.vimrc<CR>

function! SanitizePath(path)
  return substitute(a:path, ' ', '\\\ ', 'g')
endfunction

function! GetFileDirectory()
  return SanitizePath(expand('%:p:h'))
endfunction

nmap ,, :e <C-R>=GetFileDirectory() . '/' <CR><Space><Backspace>
cmap ,, <C-R>=GetFileDirectory() . '/' <CR><Space><Backspace>

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . SanitizePath(new_name)
    exec ':silent !rm ' . SanitizePath(old_name)
    redraw!
  endif
endfunction
map <Leader>mv :call RenameFile()<CR>

" Plugins
let g:ctrlp_map = ''
let g:ctrlp_cmd = ''
let g:ctrlp_working_path_mode = 'ra'

nmap <Leader>f :CtrlPClearCache<CR>

if has('mac')
  nmap <silent> <D-d> :NERDTreeToggle<CR>
  nmap <silent> <D-x> :BufExplorer<CR>
  nmap <silent> <D-f> :CtrlP<CR>
else
  nmap <silent> <M-d> :NERDTreeToggle<CR>
  nmap <silent> <M-x> :BufExplorer<CR>
  nmap <silent> <M-f> :CtrlP<CR>
endif

" Other
nmap <Leader>cd :cd %:p:h<CR>:pwd<CR>
nmap <C-s> :w<CR>
nnoremap Q @@
