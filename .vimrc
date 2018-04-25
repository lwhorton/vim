set nocompatible

""" Initialize Vundle {

    filetype off
    " set the runtime path to include Vundle
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()

    Plugin 'VundleVim/Vundle.vim'

""" /Initialize Vundle }

""" { Plugins

    Plugin 'mileszs/ack.vim'
    Plugin 'scrooloose/nerdtree'
    Plugin 'scrooloose/nerdcommenter'
    "Plugin 'airblade/vim-gitgutter'
    Plugin 'kien/ctrlp.vim'
    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'

    Plugin 'altercation/vim-colors-solarized'
    Plugin 'kien/rainbow_parentheses.vim'

    Plugin 'pangloss/vim-javascript'
    Plugin 'guns/vim-clojure-static'
    Plugin 'wavded/vim-stylus'
    Plugin 'mxw/vim-jsx'

    Plugin 'SirVer/ultisnips'
    Plugin 'honza/vim-snippets'
    Plugin 'ervandew/supertab'
    Plugin 'godlygeek/tabular'
    Plugin 'ajh17/VimCompletesMe'

    Plugin 'guns/vim-sexp'
    Plugin 'tpope/vim-sexp-mappings-for-regular-people.git'
    Plugin 'Yggdroot/indentLine'
    Plugin 'cohama/lexima.vim'
    Plugin 'tpope/vim-surround'
    Plugin 'tpope/vim-fireplace'
    Plugin 'tpope/vim-repeat'
    Plugin 'editorconfig/editorconfig-vim'
    Bundle 'venantius/vim-eastwood'
    Bundle 'venantius/vim-cljfmt'

    Plugin 'jparise/vim-graphql'
    Plugin 'leafgarland/typescript-vim'

    """ Give control to Vundle
    call vundle#end()
    filetype plugin indent on
" /Plugins }

""" { Configuration

    " don't beep, do visual bell
    set visualbell

    " no swap files
    set noswapfile

    " automatically change current directory to open file
    set autochdir

    "" no wrapping/auto-inserting of \n
    set nowrap
    set textwidth=80

    "" allow deleting text inserted before current insert mode started
    set backspace=indent,eol,start

    "" enable html/css highlighting in js files
    let g:javascript_enable_domhtmlcss=1

    "" enable vim colors (solarized)
    syntax enable
    set background=dark
    colorscheme solarized

    "syntax enable
    "set background=light
    "colorscheme solarized

    " limit syntax highlighting otherwise the world stops
    set synmaxcol=128

    "" modify line-indent color
    let g:indentLine_color_term = 239

    "" remove trailing whitespace, persist cursor position on save
    function! <SID>StripTrailingWhitespaces()
        let l = line('.')
        let c = col('.')
        %s/\s\+$//e
        call cursor(l, c)
    endfun
    autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

    "" setup not-stupid tabs
    set tabstop=4
    set shiftwidth=4
    set expandtab

    "" smart case sensitivity while searching
    set ignorecase
    set smartcase

    "" higlight /search
    set hlsearch
    set incsearch

    "" persist undo
    set undodir=~/.vim/undo
    set undofile

    "" hybrid line numbers
    "set rnu " vim cannot handle relative line numbers on files > 100 lines, too slow
    set nu

    " change git-gutter's gutter background color
    highlight clear SignColumn

    " solarized rainbow parens colors
    let g:rbpt_colorpairs = [
      \ [ '13', '#6c71c4'],
      \ [ '5',  '#d33682'],
      \ [ '1',  '#dc322f'],
      \ [ '9',  '#cb4b16'],
      \ [ '3',  '#b58900'],
      \ [ '2',  '#859900'],
      \ [ '6',  '#2aa198'],
      \ [ '4',  '#268bd2'],
      \ ]

    "" enable rainbow parentheses for all buffers
    augroup rainbow_parentheses
      au!
      au VimEnter * RainbowParenthesesActivate
      au BufEnter * RainbowParenthesesLoadRound
      au BufEnter * RainbowParenthesesLoadSquare
      au BufEnter * RainbowParenthesesLoadBraces
    augroup END

    " parse build.boot files as clj
    autocmd BufNewFile,BufRead *.boot setf clojure
    autocmd BufNewFile,BufRead *.boot set syntax=clojure

    " use ag instead of ack (much faster)
    if executable('ag')
        let g:ackprg = 'ag --vimgrep --nogroup --nocolor --column'
    endif

    " additional files to ignore when searching with ctrl-p
    let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]((\.(git|hg|svn))|(build|dist|node_modules|target|out))$',
      \ 'file': '\v\.(exe|so|dll)$',
      \ 'link': 'some_bad_symbolic_links',
      \ }

    " cache ctrl-p to speed things up a bit
    let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'

    " use ag / silver_searcher for ctrl-p
    if executable('ag')
      let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    endif

    " make UltiSnips pick up custom snippets in the vim/UltiSnips dir
    let g:UltiSnipsSnippetDirectories=["UltiSnips", "vim/UltiSnips"]

    " better key bindings for UltiSnipsExpandTrigger
    let g:UltiSnipsExpandTrigger = "<tab>"
    let g:UltiSnipsJumpForwardTrigger = "<tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

    let g:SuperTabDefaultCompletionType = '<C-n>'

    " status bar customization
    let g:airline#extensions#tabline#fnamemod = ':.'
    let g:airline#extensions#tabline#fnamecollapse = 0

    " render airline when only 1 files is open
    set laststatus=2

    " disable auto-insert / auto-delete mode for clojure expressions
    let g:sexp_enable_insert_mode_mappings = 0

" /Configuration }

""" { Custom Commands
    " connect a cljs file to a running nREPL
    command Ctn execute ":Connect localhost:1337"
    command Ctc execute "Piggieback (figwheel-sidecar.repl-api/repl-env)"

    " /Custom Commands }

""" { Keybindings

    " escape insert -> jf
    imap jf <Esc>

    " <leader> -> ','
    let mapleader = ","

    " map NERDTree to Ctrl+n
    map <C-t> :NERDTreeToggle<CR>

    " enter to insert newline without entering insert mode
    nmap <CR> o<Esc>

    " reselect text block after paste with gV
    nnoremap <expr> gV '`[' . getregtype(v:register)[0] . '`]'

    " remap q record because we're using it elsewhere
    nnoremap Q q
    nnoremap q <Nop>

    " unmap many pain-inducing left hand ctrl-key sequences
        " unmap window movement
        nnoremap <C-w> <NOP>
        " unmap q to prevent stupid mistakes
        nnoremap qq <NOP>

        " window page up /down
        nnoremap <C-d> <NOP>
        nnoremap <C-u> <NOP>
        nnoremap q8 <C-d>
        nnoremap q9 <C-u>

        " window split / move
        nnoremap q <C-w>

        " remap autocomplete cylcling forward/back
        inoremap qj <C-n>
        inoremap qk <C-p>

        " redo
        nnoremap <C-r> <NOP>
        nnoremap <S-U> <C-r>

        " jump to the symbol matching the one under the cursor
        nnoremap ; %
        vnoremap ; %

        " jump to end of line
        nnoremap ' $
        vnoremap ' $

    " make < > indent changes maintain selection
    vnoremap < <gv
    vnoremap > >gv

    " allow saving of files as sudo when I forgot to start using sudo
    cmap w!! w !sudo tee > /dev/null %

    " /Keybindings }
