# New dev environment setup

- attempt to git clone this repo, which should prompt to install xcode tools
- install brew
- install kitty
- install profile for kitty.conf `ln -s ~/.vim/vim/kitty.conf ~/.config/kitty/`
- install profile for .zshrc `ln -s ~/.vim/vim/.zshrc ~/.zshrc`
- install profile for .vimrc `ln -s ~/.vim/vim/.vimrc ~/.vimrc`
- install nvim, then setup initialization properly https://neovim.io/doc/user/nvim.html#nvim-from-vim
- install ohmyzsh, and [zsh-dircolors](https://github.com/joel-porquet/zsh-dircolors-solarized)
- install with brew:

    fzf
    rg
    ack
    asdf

- install powerline (git clone https://github.com/powerline/fonts.git --depth=1e
- install zsh-syntax (https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)
- run `:PlugInstall` after sourcing (`:source %`) the vimrc file
- generate an ssh key and add it to github (https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

## Reasonable git aliases

```
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global user.email lwhorton@users.noreply.github.com
git config --global user.name "lwhorton"
git config --global core.editor "nvim"
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

- install elixir-lsp binary (typically ~/.elixir/), and probably rebuild build elixir-ls with the
  version you are using in the application (use asdf and .tool-versions):
  https://github.com/elixir-lsp/coc-elixir#server-fails-to-start
- install coc-{language} `CoCInstall coc-elixir`
- leverage `asdf local elixir/erlang {version}` and rebuild elixir-ls

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

- install clojure-lsp binary https://github.com/snoe/clojure-lsp (typically to
  /usr/local/bin)
- install coc (automcompletion) https://github.com/neoclide/coc.nvim for intellisense
- install coc-{language} `CoCInstall coc-clojure`
- sym-link coc-settings.json to ~/.config/nvim/coc-settings.json
