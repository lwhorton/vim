# Problems + Solutions

## Clone and symlink
Clone this repo to ~/.vim and link the .vimrc file to the expected vim location
```
cd ~/.vim
git clone git@github.com:lwhorton/vim.git
ln -s ~/.vim/vim/.vimrc ~/.vimrc
```

## Installing plugins
Vundle must be installed before we can install the rest of the suite:
```
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim .
:PluginInstall
```

## Ack actually needs to exist on your system
```
brew install ack
```

## UltiSnips filetype recognotion doesn't work
Vundle doesn't complete the installation process. UltiSnips needs a few more source files, but Vim only allows this directly in the home directory, so make a sym link:
```bash
mkdir -p ~/.vim/after/plugin
ln -s ~/.vim/bundle/ultisnip/after/plugin/* ~/.vim/after/plugin
mkdir ~/.vim/ftdetect
ln -s ~/.vim/bundle/ultisnip/ftdetect/* ~/.vim/ftdetect
```

## Get persistent undo's in different vim sessions
```bash
mkdir ~/.vim/undo
```
