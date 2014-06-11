# .Vim
The `~/.vim` directory of the [Vim editor](http://www.vim.org/).
Best enjoyed responsibly.

## Installation

    $ rm -rf ~/.vimrc ~/.gvimrc ~/.vim
    $ git clone https://github.com/IvanUkhov/dot-vim.git ~/.vim --recursive
    $ ln -s ~/.vim/vimrc ~/.vimrc
    $ ln -s ~/.vim/gvimrc ~/.gvimrc
    $ cd ~/.vim/bundle/command-t/ruby/command-t
    $ ruby extconf.rb
    $ make
