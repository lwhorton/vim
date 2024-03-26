# New dev environment setup

- attempt to git clone this repo, which should prompt to install xcode tools
- install brew
- install kitty
- install profile for kitty.conf `ln -s ~/.vim/vim/kitty.conf ~/.config/kitty/`
- install profile for .zshrc `ln -s ~/.vim/vim/.zshrc ~/.zshrc`
- install nvim lua configs:

```
ln -s ~/.vim/vim/init.lua ~/.config/nvim/init.lua
ln -s ~/.vim/vim/lua ~/.config/nvim/lua
ln -s ~/.vim/vim/colors ~/.config/nvim/colors
mkdir -p ~/.config/nvim/undo
```

- install nvim, then setup initialization properly https://neovim.io/doc/user/nvim.html#nvim-from-vim
- install ohmyzsh, and [zsh-dircolors](https://github.com/joel-porquet/zsh-dircolors-solarized)
- install with brew:

    fzf
    rg
    ack
    asdf

- install powerline `git clone https://github.com/powerline/fonts.git --depth=1e`
- install zsh-syntax (https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)
- opening vim should trigger lazy.nvim to install a bunch of plugins. some
  plugins have follow up steps, read those in the nvim/lua/plugin-configs.lua.
- generate an ssh key and add it to github (https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

## colors

https://sw.kovidgoyal.net/kitty/remote-control/#kitten-set-colors

`$ kitty @ set-colors ~/.vim/vim/kitty.neosolarized-dark.conf`

## Reasonable git aliases

```
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global user.email lwhorton@users.noreply.github.com
git config --global user.name "lwhorton"
git config --global core.editor "vim"
git config --global push.default current
git config --global rerere.enabled true
```

## snippets 

we use luasnip and nvim-cmp for completion/snippets. snippets are stored under
lua/snippets/{language-name}.snippets .

## Get persistent undo's in different vim sessions

```bash
mkdir ~/.vim/undo
```

## LSP

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

- install the language server: clojure-lsp https://clojure-lsp.io/
- use this nvim lsp client for the rest: https://github.com/neovim/nvim-lspconfig
