# Vim
The `~/.vim` directory of the [Vim editor](http://www.vim.org/).
Best enjoyed responsibly.

## Installation

    $ rm -rf ~/.vimrc ~/.gvimrc ~/.vim
    $ git clone https://github.com/IvanUkhov/vim.git ~/.vim
    $ ln -s ~/.vim/vimrc ~/.vimrc
    $ ln -s ~/.vim/gvimrc ~/.gvimrc
    $ cd ~/.vim
    $ git submodule init
    $ git submodule update
    $ cd ~/bundle/command-t/ruby/command-t
    $ ruby extconf.rb
    $ make
