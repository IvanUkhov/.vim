call pathogen#infect()

mapclear
autocmd!

" Basic
set nocompatible

set backspace=indent,eol,start
set encoding=utf-8
set hidden
set history=10000
set number

set mouse=a
set ttymouse=xterm2

set t_vb=
set visualbell

syntax on
filetype plugin indent on

let mapleader=' '

" Window
nnoremap <C-Up> <C-W>2+
nnoremap <C-Down> <C-W>2-
nnoremap <C-Left> <C-W>2<
nnoremap <C-Right> <C-W>2>

" Interface
function! SwitchColorscheme(ambience)
  let ambience = a:ambience
  if ambience == ''
    if g:ambience == 'this'
      let ambience = 'that'
    else
      let ambience = 'this'
    endif
  endif

  if ambience == 'this'
    let g:zenburn_high_Contrast = 1
  else
    let g:zenburn_high_Contrast = 0
  endif

  set t_Co=256
  colorscheme zenburn
  highlight SpellBad cterm=underline
  highlight Search ctermbg=81 ctermfg=0 guibg=#5fd8fb guifg=#000000

  let g:ambience = ambience
endfunction

call SwitchColorscheme('that')

nnoremap <Leader>sc :call SwitchColorscheme('')<CR>

set colorcolumn=81,100

" Status line
set laststatus=2

set showcmd
set showmode

set statusline=%<%f\ %-4(%m%)%=%-8(%3l,%3c%)

" Searching
set incsearch
set hlsearch
set iskeyword=a-z,A-Z,48-57,_

set ignorecase
set smartcase

nnoremap <Leader>/ :silent nohlsearch<CR>
nnoremap <Leader>si :set ignorecase! \| set ignorecase?<CR>

if executable('ag')
  set grepprg=ag
    \\ --nogroup
    \\ --nocolor
else
  set grepprg=grep
    \\ --binary-files=without-match
    \\ --color=never
    \\ --line-number
    \\ --recursive
    \\ --with-filename
    \\ $*\ ./
endif

command! -nargs=+ -complete=file -bar
  \ Grep silent! grep! '<args>'|cwindow|redraw!

nnoremap <Leader>g :grep! "\b<C-R><C-W>\b"<CR><CR>:cw<CR>
nnoremap \ :Grep<Space>

" Line wrapping
set nowrap
set linebreak
set showbreak=↪\ "

nnoremap <Leader>sw :set wrap! list! \| set wrap?<CR>

" Invisible characters
set list
set listchars=tab:▸\ ,trail:•,extends:❯,precedes:❮

nnoremap <Leader>sl :set list! \| set list?<CR>

function! StripTrailingWhitespace()
  let pattern = @/
  let line = line('.')
  let column = col('.')

  silent! %s/\s\+$//

  let @/ = pattern
  call cursor(line, column)
endfunction

nnoremap <Leader>cl :call StripTrailingWhitespace()<CR>

" Folding
set foldmethod=indent
set foldnestmax=3
set nofoldenable

" Tab completion
set wildmode=list:longest
set wildmenu

set wildignore=*.swo,*.swp,*~
set wildignore+=*/.git/*
set wildignore+=*/target/debug/*
set wildignore+=*/target/doc/*
set wildignore+=*/target/package/*
set wildignore+=*/target/release/*

" Scrolling
set sidescroll=1

set scrolloff=1
set sidescrolloff=1

" Navigation
set nostartofline

nnoremap zh 5zh
nnoremap zl 5zl

nnoremap <Down> gj
nnoremap <Up> gk

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <Leader><Leader> <C-^>

nnoremap <Leader>n :bn<CR>
nnoremap <Leader>p :bp<CR>
nnoremap <Leader>d :bp<CR>:bd #<CR>

" Indentation
set autoindent

function! SwitchToTabs()
  set shiftwidth=4
  set softtabstop=0
  set tabstop=4
  set noexpandtab
endfunction
autocmd BufEnter *.c,*.cpp,*.h,*.hpp,*.java,*.json,*.go call SwitchToTabs()

function! SwitchToSpaces()
  set shiftwidth=2
  set softtabstop=2
  set tabstop=2
  set expandtab
endfunction

call SwitchToSpaces()

" Spell checking
set nospell

nnoremap <Leader>ss :set spell! \| set spell?<CR>

" Cursor position
function! RestoreCursorPosition()
  if line("'\"") > 0 && line("'\"") <= line('$')
    exe 'normal! g`"'
    normal! zz
  endif
endfunction
autocmd BufReadPost * call RestoreCursorPosition()

set cursorline

" File manipulation
nnoremap <Leader>vi :e $MYVIMRC<CR>
autocmd BufWritePost .vimrc source $MYVIMRC

function! SanitizePath(path)
  return substitute(a:path, ' ', '\\\ ', 'g')
endfunction

function! GetFile()
  return SanitizePath(expand('%'))
endfunction

function! GetDirectory()
  return SanitizePath(expand('%:p:h')) . '/'
endfunction

nnoremap ;; :e <C-R>=GetFile()<CR>
cnoremap ;; <C-R>=GetFile()<CR>

nnoremap ,, :e <C-R>=GetDirectory()<CR><Space><Backspace>
cnoremap ,, <C-R>=GetDirectory()<CR><Space><Backspace>

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . SanitizePath(new_name)
    exec ':silent !rm ' . SanitizePath(old_name)
    redraw!
  endif
endfunction
noremap <Leader>mv :call RenameFile()<CR>

nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

nnoremap <C-s> :w<CR>

" Writing
inoremap <Tab> <Esc>`^
vnoremap <Tab> <Esc>
inoremap <Right> <Tab>
inoremap <Left> <Backspace>

set textwidth=80
set nojoinspaces

nnoremap <Leader>a gq}``
nnoremap <Leader>o mzvip:sort<CR>`z
vnoremap <Leader>o mz:sort<CR>`z

function! SelectUntil(pattern)
  let stop = line('$')
  execute 'normal V'
  while 1
    if line('.') == stop
      break
    endif
    execute 'normal j'
    if getline('.') =~ a:pattern
      execute 'normal k'
      break
    endif
  endwhile
endfunction

function! FormatUntil(pattern)
  let x = line('.')
  let y = col('.') - 1
  call SelectUntil(a:pattern)
  execute 'normal gq'
  execute 'normal ' . x . 'G' . y . 'l'
endfunction

function! AssistWriting()
  set wrap
  set spell
  set spelllang=en_us
  syntax spell toplevel
  nnoremap <Leader>a :call FormatUntil('\(^\s*$\)\\|\(^\s*\\begin\)\\|\(^\s*\\end\)\\|\(^\s*\\\[\)')<CR>
endfunction

autocmd BufRead *.txt,*.md,*.html,*.tex,*.bib,COMMIT_* call AssistWriting()

" Plugins
nnoremap <Leader>t :NERDTreeToggle<CR>

let g:bufExplorerShowRelativePath = 1
let g:bufExplorerDisableDefaultKeyMapping = 1
nnoremap <Leader>b :BufExplorerHorizontalSplit<CR>

let g:ctrlp_map = ''
let g:ctrlp_cmd = ''
let g:ctrlp_working_path_mode = 'ra'
nnoremap <Leader>f :CtrlP<CR>
nnoremap <Leader>rf :CtrlPClearCache<CR>

" Miscellaneous
nnoremap Q @@
nnoremap K <Nop>

"-------------------------------------------------------------------------------
" GUI
"-------------------------------------------------------------------------------

if !has('gui_running')
  finish
end

" Input
set imdisable
set mousemodel=extend

" Window
function! ResizeWindow(...)
  if a:0 > 0
    let lines = a:1
  else
    let lines = &lines
  end

  let columns = 100 + &numberwidth

  if exists('t:NERDTreeBufName')
    if bufwinnr(t:NERDTreeBufName) != -1
      let columns = columns + g:NERDTreeWinSize + 1
    endif
  endif

  execute 'set lines=' . lines . ' columns=' . columns
endfunction
nnoremap <Leader>rw :call ResizeWindow()<CR>

function! RestoreSession()
  call ResizeWindow(100)

  let file = $HOME . '/.gvimsession'

  if filereadable(file)
    let data = split(readfile(file)[0])
    silent! execute 'winpos ' . data[0] . ' ' . data[1]
  else
    winpos 0 0
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
set guioptions-=T
set guioptions-=m
set guioptions+=b

set linespace=4
set guifont=Hack\ Regular:h15,Monaco:h15,Menlo:h15,Monospace\ 11
