# New dev environment setup

It's a little chicken and the egg with zsh, .zshrc, and some of our deps (brew,
asdf, etc.). You might have to deal with errors while installing all these deps.

- attempt to git clone this repo, which should prompt to install xcode tools
	- if the prompt does not happen, manually run `xcode-select --install`
- install kitty (from binary source)
- make a bunch of config dirs that we will need shortly
    ```sh
    mkdir -p ~/.config/nvim 
    mkdir -p ~/.config/kitty
    mkdir -p ~/.config/nvim/undo
    ```
- install the profile for kitty via its conf: `ln -s {path_to/vim/}kitty.conf ~/.config/kitty/`
- restart kitty
- install [brew](https://brew.sh)
- install [ohmyzsh](https://ohmyz.sh/#install) 
- install neovim `brew install neovim`
- install .zshrc `ln -s {path_to/vim/}.zshrc ~/.zshrc`
- install nvim configs:

```
ln -s {path_to/vim/}init.lua ~/.config/nvim/init.lua
ln -s {path_to/vim/}lua ~/.config/nvim/lua
ln -s {path_to/vim/}colors ~/.config/nvim/colors
```

- install deps with brew:

    fzf
    rg
    ack
    asdf

- install powerline (to ~/dev/me, probably) `git clone https://github.com/powerline/fonts.git --depth=1`
- install zsh-syntax (https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)
- opening vim for the first time should trigger lazy.nvim to install a bunch of
plugins. some plugins have follow up steps, read those in the
nvim/lua/plugin-configs.lua. 
    - :TSInstall all
- generate an ssh key and add it to github (https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

## colors

there are layers to colors.

1. for zsh, we _try_ to simply utilize whatever color scheme kitty has
   configured.

2. for kitty, you can manually setup colors, if you have the conf file, via
   `set-colors`. alternatively, you can run `kitten themes` and pick a color,
then set (inside .zshrc) `them_conf="$HOME/.config/kitty/{theme}.conf`. then set
~/.config/nvim/lua/plugins.lua:vim.cmd.colorscheme('...theme') for now, it's
gruvbox dark across the board.

https://sw.kovidgoyal.net/kitty/remote-control/#kitten-set-colors
`$ kitty @ set-colors ~/dev/me/vim/kitty.neosolarized-dark.conf`

3. for our code itself (neovim syntax highlighting, basically), we set our theme
   in 'plugins.lua'. it's hard being so cool.

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
lua/snippets/{language-name}.snippets.

## LSP

in general, we probably need tsserver installed for most things, even though
nobody wants node on their system.

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
