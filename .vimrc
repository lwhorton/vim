set shell=/bin/sh
set nocompatible

""" Initialize Vundle {

    filetype off
    " set the runtime path to include Vundle
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()

    Plugin 'VundleVim/Vundle.vim'

""" /Initialize Vundle }

""" { Plugins

    Plugin 'kien/ctrlp.vim'
    Plugin 'bling/vim-airline'
    Plugin 'mileszs/ack.vim'
    Plugin 'easymotion/vim-easymotion'
    Plugin 'scrooloose/nerdtree'
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'pangloss/vim-javascript'
    Plugin 'scrooloose/nerdcommenter'
    Plugin 'airblade/vim-gitgutter'
    Plugin 'SirVer/ultisnips'
    Plugin 'honza/vim-snippets'
    Plugin 'Valloric/YouCompleteMe'
    Plugin 'Raimondi/delimitMate'
    Plugin 'ervandew/supertab'
    Plugin 'godlygeek/tabular'
    Plugin 'wavded/vim-stylus'
    Plugin 'mxw/vim-jsx'
    Plugin 'tpope/vim-fugitive'
    Plugin 'tpope/vim-surround'
    Plugin 'Yggdroot/indentLine'
    Plugin 'elmcast/elm-vim'

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

    " no wrapping/auto-inserting of \n
    set nowrap
    set textwidth=0

    " allow deleting text inserted before current insert mode started
    set backspace=indent,eol,start

    " enable html/css highlighting in js files
    let g:javascript_enable_domhtmlcss=1

    " enable vim colors (solarized)
    syntax on
    let g:solarized_termcolors=256
    set t_Co=256
    set background=dark
    colorscheme solarized

    " modify line-indent color
    let g:indentLine_color_term = 239

    " remove trailing whitespace, persist cursor position
    function! <SID>StripTrailingWhitespaces()
        let l = line('.')
        let c = col('.')
        %s/\s\+$//e
        call cursor(l, c)
    endfun
    autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

    " setup not-stupid tabs
    set tabstop=4
    set shiftwidth=4
    set expandtab

    " ignore case when searching
    set ignorecase
    set smartcase

    " persist undo
    set undodir=~/.vim/undo
    set undofile

    " hybrid line numbers
    set rnu
    set nu

    " higlight /search
    set hlsearch
    set incsearch

    " change git-gutter's gutter background color
    highlight clear SignColumn

    " additional files to ignore when searching with ctrl-p
    let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]((\.(git|hg|svn))|(build|dist|node_modules))$',
      \ 'file': '\v\.(exe|so|dll)$',
      \ 'link': 'some_bad_symbolic_links',
      \ }

    " make YCM compatible with UltiSnips (using supertab)
    let g:ycm_key_list_select_completion = ['<C-j>', '<Down>']
    let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
    let g:SuperTabDefaultCompletionType = '<C-n>'

    " make UltiSnips pick up custom snippets in the vim/UltiSnips dir
    let g:UltiSnipsSnippetDirectories=["UltiSnips", "vim/UltiSnips"]

    " better key bindings for UltiSnipsExpandTrigger
    let g:UltiSnipsExpandTrigger = "<tab>"
    let g:UltiSnipsJumpForwardTrigger = "<tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

    " force closed-pair jumping instead of inserting
    let g:AutoPairsFlyMode = 1

    " disable default easymotion
    let g:EasyMotion_do_mapping = 0

    " easymotion case insensitivity
    let g:EasyMotion_smartcase = 1

" /Configuration }

""" { Keybindings

    " escape insert -> jf
    imap jf <Esc>

    " <leader> -> ','
    let mapleader = ","

    " jump anywhere with s{char}
    nmap s <Plug>(easymotion-overwin-f)

    " map NERDTree to Ctrl+n
    map <C-t> :NERDTreeToggle<CR>

    " insert newline without entering insert mode
    nmap <CR> o<Esc>

    " reselect text block after paste with gV
    nnoremap <expr> gV '`[' . getregtype(v:register)[0] . '`]'

    " make < > shifts keep selection
    vnoremap < <gv
    vnoremap > >gv

    " build elm files
    nmap <leader>bb <Plug>(elm-make)
    nmap <leader>bm <Plug>(elm-make-main)

" /Keybindings }
