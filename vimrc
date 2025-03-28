mapclear
autocmd!

" Basic
set nocompatible
set noswapfile

set langmenu=en_US
let $LANG = 'en_US'

set encoding=utf-8
set hidden
set history=10000

" Input
set backspace=indent,eol,start

set mouse=a
if !has('nvim')
  set ttymouse=xterm2
endif

set t_vb=
set visualbell

let mapleader=' '

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

" Scrolling
set scrolloff=1
set sidescroll=1
set sidescrolloff=1

" Window
nnoremap <C-Up> <C-W>2+
nnoremap <C-Down> <C-W>2-
nnoremap <C-Left> <C-W>2<
nnoremap <C-Right> <C-W>2>

" Status
set laststatus=2

set showcmd
set showmode

set statusline=%<%f\ %-4(%m%)%=%-8(%3l,%3c%)

" Search
set incsearch
set hlsearch
set iskeyword=a-z,A-Z,48-57,_

set ignorecase
nnoremap <Leader>si :set ignorecase! \| set ignorecase?<CR>

set smartcase

nnoremap <Leader>/ :silent nohlsearch<CR>
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

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

" Completion
set wildmode=list:longest
set wildmenu

set wildignore=*~
set wildignore+=.*
set wildignore+=*/.git/*

" Indentation
set autoindent

function! SwitchToSpaces(size)
  let &l:shiftwidth = a:size
  let &l:softtabstop = a:size
  let &l:tabstop = a:size
  setlocal expandtab
endfunction

function! SwitchToTabs(size)
  let &l:shiftwidth = a:size
  let &l:softtabstop = 0
  let &l:tabstop = a:size
  setlocal noexpandtab
endfunction

autocmd FileType
  \ *
  \ call SwitchToSpaces(2)
autocmd FileType
  \ python,rust,toml
  \ call SwitchToSpaces(4)
autocmd FileType
  \ go,make
  \ call SwitchToTabs(4)

" Folding
set foldmethod=indent
set foldnestmax=3
set nofoldenable

" Cursor position
set cursorcolumn
set cursorline

function! RestoreCursorPosition()
  if line("'\"") > 0 && line("'\"") <= line('$')
    exe 'normal! g`"'
    normal! zz
  endif
endfunction
autocmd BufReadPost * call RestoreCursorPosition()

autocmd BufLeave * let b:view = winsaveview()
autocmd BufEnter * if exists('b:view') | call winrestview(b:view) | endif

" Line wrapping
set nowrap
nnoremap <Leader>sw :set wrap! list! \| set wrap?<CR>

set display=lastline
set linebreak
set showbreak=↪\ "

" Invisible characters
set list
nnoremap <Leader>sl :set list! \| set list?<CR>

set listchars=tab:▸\ ,trail:•,extends:❯,precedes:❮

function! StripTrailingWhitespace()
  let pattern = @/
  let line = line('.')
  let column = col('.')
  silent! %s/\s\+$//
  let @/ = pattern
  call cursor(line, column)
endfunction
nnoremap <Leader>cl :call StripTrailingWhitespace()<CR>

" Syntax
syntax on
filetype plugin indent on

set synmaxcol=200
set colorcolumn=81,101

set number

set t_ut=
colorscheme zenburn
highlight SpellBad cterm=underline
highlight Search ctermbg=81 ctermfg=0 guibg=#5fd8fb guifg=#000000

" Writing
set autoread<
autocmd FocusGained * checktime

set nospell
set spelllang=en_us
nnoremap <Leader>ss :set spell! \| set spell?<CR>

function! AssistWriting()
  setlocal indentexpr=
  setlocal nocindent
  setlocal nosmartindent

  setlocal spell
  syntax spell toplevel

  setlocal wrap

  nnoremap <Leader>a :call
    \ FormatUntil(
    \   '\(^\s*$\)\\|\(^\s*\\begin\)\\|\(^\s*\\end\)\\|\(^\s*\\\[\)\\|\(^\$\$\)'
    \ )<CR>
endfunction
autocmd FileType
  \ bib,gitcommit,html,markdown,plaintex,rmd,tex,text
  \ call AssistWriting()

function! FormatUntil(pattern)
  let x = line('.')
  let y = col('.')
  call SelectUntil(a:pattern)
  execute 'normal gq'
  execute 'normal ' . x . 'G' . y . '|'
endfunction

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

set textwidth=80
set nofixendofline
set nojoinspaces

nnoremap <Leader>a gq}``
nnoremap <Leader>o mzvip:sort<CR>`z
vnoremap <Leader>o mz:sort<CR>`z

" File manipulation
nnoremap <Leader>vi :e $MYVIMRC<CR>
autocmd BufWritePost .vimrc source $MYVIMRC

autocmd FileType crontab setlocal nobackup nowritebackup

function! SanitizePath(path)
  return substitute(a:path, ' ', '\\\ ', 'g')
endfunction

function! GetDirectory()
  return SanitizePath(expand('%:p:h')) . '/'
endfunction

nnoremap <Leader>e :e <C-R>=GetDirectory()<CR><Space><Backspace>

function! MoveFile()
  let old_name = expand('%')
  let new_name = input('New name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . SanitizePath(new_name)
    exec ':silent !rm ' . SanitizePath(old_name)
    redraw!
  endif
endfunction
noremap <Leader>mv :call MoveFile()<CR>

nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

nnoremap <C-s> :w<CR>

" Plugins
let g:bufExplorerShowRelativePath = 1
let g:bufExplorerDisableDefaultKeyMapping = 1
nnoremap <Leader>b :BufExplorer<CR>

let g:ctrlp_map = ''
let g:ctrlp_cmd = ''
let g:ctrlp_working_path_mode = 'ra'
nnoremap <Leader>f :CtrlP<CR>
nnoremap <Leader>rf :CtrlPClearCache<CR>

nnoremap <Leader>t :NERDTreeToggle<CR>

" Miscellaneous
nnoremap K <Nop>
nnoremap Q @@

"-------------------------------------------------------------------------------
" GUI
"-------------------------------------------------------------------------------

if !has('gui_running')
  finish
end

" Text
set linespace=4
set guifont=Input\ Mono\ Narrow:h15,Monaco:h15,Menlo:h15

if has('nvim')
  finish
endif

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
  let file = $HOME . '/.vimsession'
  if filereadable(file)
    let data = split(readfile(file)[0])
    silent! execute 'winpos ' . data[0] . ' ' . data[1]
  else
    winpos 0 0
  endif
endfunction
autocmd VimEnter * call RestoreSession()

function! SaveSession()
  let file = $HOME . '/.vimsession'
  let data = [
    \ (getwinposx() < 0 ? 0 : getwinposx()) . ' ' .
    \ (getwinposy() < 0 ? 0 : getwinposy()) ]
  call writefile(data, file)
endfunction
autocmd VimLeavePre * call SaveSession()

" Interface
set guioptions-=T
set guioptions-=m
set guioptions+=b
