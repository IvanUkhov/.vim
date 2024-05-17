set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

source ~/.vimrc

set noswapfile

if exists('g:neovide')
  let g:neovide_scroll_animation_length = 0
  let g:neovide_scroll_animation_far_lines = 0
  autocmd VimEnter * call timer_start(20, {tid -> execute('NeovideFocus')})
endif
