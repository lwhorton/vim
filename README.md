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

## Ack actually needs to exist on your system for greps to work

```
brew install ack
```

## UltiSnips filetype recognition doesn't work

Packagers vundle/plug don't complete the installation process. UltiSnips needs a
few more source files, but Vim only allows this directly in the home directory,
so make a sym link:

```bash
mkdir -p ~/.vim/after/plugin
ln -s ~/.vim/bundle/ultisnip/after/plugin/* ~/.vim/after/plugin
mkdir ~/.vim/ftdetect
ln -s ~/.vim/bundle/ultisnip/ftdetect/* ~/.vim/ftdetect
```

Also given my custom snippets, symlink them into the path described in the
.vimrc ("my_ulti_snips"):

```bash
ln -s ~/.vim/my_custom_snips ~/my_ulti_snips
```

For typescript/javascript, just `ln -s /path/to/javascript.snippets
/path/to/typescript.snippets` because they should be basically identical.

## Get persistent undo's in different vim sessions
```bash
mkdir ~/.vim/undo
```

## Install dependencies for markdown editing
`brew install grip`

## Install LSP for Clojure programming

- install clojure-lsp binary https://github.com/snoe/clojure-lsp
- install coc https://github.com/neoclide/coc.nvim for intellisense
- sym-link coc-settings.json to ~/.config/nvim/coc-settings.json
