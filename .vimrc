set nocompatible

""" Initialize Vundle {

    filetype off
    " set the runtime path to include Vundle
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()

    Plugin 'gmarik/Vundle.vim'

""" /Initialize Vundle }

""" { Plugins

    Plugin 'scrooloose/syntastic'
    Plugin 'kien/ctrlp.vim'
    Plugin 'bling/vim-airline'
    Plugin 'mileszs/ack.vim'
    Plugin 'Lokaltog/vim-easymotion'
    Plugin 'scrooloose/nerdtree'
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'pangloss/vim-javascript'
    Plugin 'scrooloose/nerdcommenter'
    Plugin 'airblade/vim-gitgutter'
    Plugin 'SirVer/ultisnips'
    Plugin 'honza/vim-snippets'
    Plugin 'jiangmiao/auto-pairs'
    Plugin 'Valloric/YouCompleteMe'
    Plugin 'ervandew/supertab'

    """ Give control to Vundle
    call vundle#end()
    filetype plugin indent on
" /Plugins }

""" { Configuration

    " don't beep, do visual bell
    set visualbell

    " no swap files
    set noswapfile

    " enable vim colors (solarized)
    syntax enable
    set background=dark
    colorscheme solarized

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

    " persist undo
    set undodir=~/.vim/undo
    set undofile

    " relative line numbers
    set rnu

    " higlight /search
    set hlsearch

    " change git-gutter's gutter background color
    highlight clear SignColumn

    " make YCM compatible with UltiSnips (using supertab)
    let g:ycm_key_list_select_completion = ['<S-j>', '<Down>']
    let g:ycm_key_list_previous_completion = ['<S-k>', '<Up>']
    let g:SuperTabDefaultCompletionType = '<C-n>'

    " better key bindings for UltiSnipsExpandTrigger
    let g:UltiSnipsExpandTrigger = "<tab>"
    let g:UltiSnipsJumpForwardTrigger = "<tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

    " force closed-pair jumping instead of inserting
    let g:AutoPairsFlyMode = 1

" /Configuration }

""" { Keybindings

    " escape insert -> jf
    imap jf <Esc>

    " <leader> -> ','
    let mapleader = ","

    " map NERDTree to Ctrl+n
    map <C-n> :NERDTreeToggle<CR>

    " insert newline without entering insert mode
    nmap <CR> o<Esc>

    " reselect text block after paste with gV
    nnoremap <expr> gV '`[' . getregtype(v:register)[0] . '`]'
" /Keybindings }
