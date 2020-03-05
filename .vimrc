set nocompatible

""" Initialize Vundle {

    filetype off
    " set the runtime path to include Vundle
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()

    Plugin 'VundleVim/Vundle.vim'

""" /Initialize Vundle }

""" { Plugins

    Plugin 'google/vim-searchindex'
    Plugin 'jremmen/vim-ripgrep'
    Plugin 'kien/ctrlp.vim'
    Plugin 'scrooloose/nerdcommenter'
    Plugin 'tpope/vim-vinegar'
    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'
    Plugin 'tpope/vim-fugitive'

    Plugin 'altercation/vim-colors-solarized'
    Plugin 'kien/rainbow_parentheses.vim'

    Plugin 'SirVer/ultisnips'
    Plugin 'ajh17/VimCompletesMe'
    Plugin 'ervandew/supertab'
    Plugin 'prettier/vim-prettier'

    Plugin 'Yggdroot/indentLine'
    Plugin 'christoomey/vim-tmux-navigator'
    Plugin 'cohama/lexima.vim'
    Plugin 'editorconfig/editorconfig-vim'
    Plugin 'guns/vim-sexp'
    Plugin 'tpope/vim-repeat'
    Plugin 'tpope/vim-sexp-mappings-for-regular-people.git'
    Plugin 'tpope/vim-surround'

    Plugin 'JamshedVesuna/vim-markdown-preview'
    Plugin 'tpope/vim-fireplace'

    Plugin 'Chiel92/vim-autoformat'
    Plugin 'elixir-editors/vim-elixir'
    Plugin 'guns/vim-clojure-static'
    Plugin 'udalov/kotlin-vim'
    Plugin 'jparise/vim-graphql'
    Plugin 'leafgarland/typescript-vim'
    Plugin 'mhinz/vim-mix-format'
    Plugin 'mxw/vim-jsx'
    Plugin 'pangloss/vim-javascript'
    Plugin 'plasticboy/vim-markdown'
    Plugin 'wavded/vim-stylus'

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
    set tabstop=2
    set shiftwidth=2
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

    "" turn off json file quote hiding
    set conceallevel=0

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

    " clj-static formatting, per aclaimant
    let g:clojure_fuzzy_indent_patterns = ['^doto', '^with', '^def', '^let', 'go-loop', 'match', '^context', '^GET', '^PUT', '^POST', '^PATCH', '^DELETE', '^ANY', 'this-as', '^are', '^dofor']
    let g:clojure_align_multiline_strings = 1

    " use ag instead of ack (much faster)
    if executable('ag')
        let g:ackprg = 'ag --vimgrep --nogroup --nocolor --column'
    endif

    " additional files to ignore when searching with ctrl-p
    let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]((\.(git|hg|svn))|(build|dist|node_modules|target|out|_build|deps|resources))$',
      \ 'file': '\v\.(exe|so|dll)$',
      \ 'link': 'some_bad_symbolic_links',
      \ }

    " cache ctrl-p to speed things up a bit
    let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
    " set local working dir accordingly
    let g:ctrlp_working_path_mode = 'ra'

    " use ag / silver_searcher for ctrl-p
    if executable('ag')
      let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    endif

    " make UltiSnips pick up custom snippets (which must be symlinked to .vim/*)
    let g:UltiSnipsSnippetDirectories=["UltiSnips", "my_ulti_snips"]

    " better key bindings for UltiSnipsExpandTrigger
    let g:UltiSnipsExpandTrigger = "<tab>"
    let g:UltiSnipsJumpForwardTrigger = "<tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
    let g:UltiSnipsUsePythonVersion = 2

    " status bar customization
    let g:airline#extensions#tabline#fnamemod = ':.'
    let g:airline#extensions#tabline#fnamecollapse = 0

    " render airline when only 1 files is open
    set laststatus=2

    " disable auto-insert / auto-delete mode for clojure expressions
    let g:sexp_enable_insert_mode_mappings = 0

    " disable folding markdown and all keybinds
    let g:vim_markdown_folding_disabled = 1
    let g:vim_markdown_no_default_key_mappings = 1
    " don't automatically insert indent on list newline
    let g:vim_markdown_new_list_item_indent = 0
    " dont automatically insert bullets
     let g:vim_markdown_auto_insert_bullets = 0
    " disable syntax hiding
    let g:vim_markdown_conceal = 0

    " markdown preview to ctrl-m
    let vim_markdown_preview_hotkey='<C-m>'
    " use gh flavored markdown via grip
    let vim_markdown_preview_github=1
    let vim_markdown_preview_browser='Google Chrome'

" /Configuration }

""" { Keybindings

    " escape insert -> jf
    imap jf <Esc>

    " <leader> -> ','
    let mapleader = ","

    " enter to insert newline without entering insert mode
    nmap <CR> o<Esc>

    " reselect text block after paste with gV
    nnoremap <expr> gV '`[' . getregtype(v:register)[0] . '`]'

    " remap q record because we're using it elsewhere
    nnoremap Q q
    nnoremap q <Nop>

    " unmap many pain-inducing left hand ctrl-key sequences
        " plugin handles mapping C-direction for easier split nav

        " unmap q to prevent stupid mistakes
        nnoremap qq <NOP>

        " window page up /down
        nnoremap <C-d> <NOP>
        nnoremap <C-u> <NOP>
        nnoremap q8 <C-d>
        nnoremap q9 <C-u>

        " window split / move to q instead of C-w
        nnoremap q <C-w>

        " remap autocomplete cycling forward/back
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

    " Functions {
    " sort clojure namespace requires
    function! CljSortRequireFn(find)
      let l:initialLine = line(".")
      let l:initialCol = col(".")
      exec "keepjumps normal gg"
      exe "keepjumps /". a:find ."$"
      let l:startLine = line(".") + 1
      if l:startLine != 2
        exe "keepjumps normal ^%"
        keepjumps let l:endLine = line(".")
        exe "keepjumps normal i\<CR>\<ESC>"
        let l:closingLine = l:endLine + 1
        exe l:startLine.",".l:endLine."sort"
        exe "keepjumps normal ".l:closingLine."gg"
        exe "keepjumps normal kJ"
      endif
      call cursor(l:initialLine, l:initialCol)
    endfunction
    command! -nargs=1 CljSortRequire call CljSortRequireFn(<q-args>)
    " } /Functions

""" { Custom workflow commands
    " reloaded workflow reset, refresh
    nnoremap <leader>rs :Eval (user/reset)<CR>
    nnoremap <leader>rf :Eval (clojure.tools.namespace.repl/refresh)<CR>
    nnoremap <leader>ra :Eval (clojure.tools.namespace.repl/refresh-all)<CR>

    " /Custom workflow commands }
