# New dev environment setup

- install brew
- install kitty
- install profile for kitty.conf `ln -s ~/.vim/vim/kitty.conf ~/.config/kitty/`
- install profile for .zshrc `ln -s ~/.vim/vim/.zshrc ~/.zshrc`
- install nvim, then setup initialization properly https://neovim.io/doc/user/nvim.html#nvim-from-vim
- install ohmyzsh, and [zsh-dircolors](https://github.com/joel-porquet/zsh-dircolors-solarized)
- install fzf, rg, ack
- install powerline/nerd font and zsh-syntax (https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)
- download [solarized color themes](https://github.com/overcache/NeoSolarized)
- install addon dependencies, like ack (see below), [vim-fugitive](https://github.com/tpope/vim-fugitive#installation)
- run `:PlugInstall` after sourcing (`:source %`) the vimrc file
- probably generate an ssh key and add it to some githubs (https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

## Reasonable git aliases

```
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
```

## Clone and symlink

Clone this repo to ~/.vim and link the .vimrc file to the expected vim location

```
cd ~/.vim
git clone git@github.com:lwhorton/vim.git
ln -s ~/.vim/vim/.vimrc ~/.vimrc

## Installing plugins
- [ Plug ](https://github.com/junegunn/vim-plug) must be installed before we can
install the rest of the suite
- from inside ~/.vimrc, run `:PlugInstall`
```

## snippets (using vim-vsnip for now, which requires no python/jvm/node nonsense)

we have to symlink the persisted snips (in snips/*) to the vsnip dir

`echo g:vsnip_snippet_dir (~/.vsnip by default)`

```bash
mkdir -p ~/.vim/.vsnip
ln -s ~/.vim/.vsnip ~/.vim/snips/*
```

For typescript/javascript, just `ln -s /path/to/javascript.snippets
/path/to/typescript.snippets` because they should be basically identical.

## Get persistent undo's in different vim sessions
```bash
mkdir ~/.vim/undo
```

## pick an lsp

### elixir

```
plug 'dense-analysis/ale'
...
git clone git@github.com:elixir-lsp/elixir-ls.git
cd elixir-ls && mkdir rel

checkout the latest release
git checkout tags/v0.4.0

$ mix deps.get && mix compile

$ mix elixir_ls.release -o rel
```

### clojure

- install clojure-lsp binary https://github.com/snoe/clojure-lsp
- install coc https://github.com/neoclide/coc.nvim for intellisense
- install coc-{language} `CoCInstall coc-clojure coc-elixir`
- sym-link coc-settings.json to ~/.config/nvim/coc-settings.json
