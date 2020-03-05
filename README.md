# Problems + Solutions

## Clone and symlink
Clone this repo to ~/.vim and link the .vimrc file to the expected vim location
```
cd ~/.vim
git clone git@github.com:lwhorton/vim.git
ln -s ~/.vim/vim/.vimrc ~/.vimrc

## Installing plugins
[ Plug ](https://github.com/junegunn/vim-plug) must be installed before we can
install the rest of the suite. Make a ~/.vim/bundle.
```
## Ack actually needs to exist on your system
```
brew install ack

## UltiSnips filetype recognotion doesn't work
Vundle doesn't complete the installation process. UltiSnips needs a few more
source files, but Vim only allows this directly in the home directory, so make a
sym link:
```bash
mkdir -p ~/.vim/after/plugin
ln -s ~/.vim/bundle/ultisnip/after/plugin/* ~/.vim/after/plugin
mkdir ~/.vim/ftdetect
ln -s ~/.vim/bundle/ultisnip/ftdetect/* ~/.vim/ftdetect
```
Also if you have custom snippets, symlink them into the vim root:
```bash
ln -s ~/my_custom_snips ~/.vim/my_custom_snips
```
For typescript/javascript, just `ln -s /path/to/javascript.snippets
/path/to/typescript.snippets` because they should be basically identical.

## Get persistent undo's in different vim sessions
```bash
mkdir ~/.vim/undo
```

## Install LSP for Clojure programming

- install clojure-lsp binary https://github.com/snoe/clojure-lsp
- install coc https://github.com/neoclide/coc.nvim for intellisense
- sym-link coc-settings.json to ~/.config/nvim/coc-settings.json
