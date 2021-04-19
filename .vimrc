set nocompatible

""" Initialize Plug {
  call plug#begin('~/.vim/bundle')

""" /Initialize Plug }

""" { Plugs

    Plug 'google/vim-searchindex'
    Plug 'jremmen/vim-ripgrep'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'scrooloose/nerdcommenter'
    Plug 'tpope/vim-vinegar'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'
    Plug 'vim-scripts/dbext.vim'
    Plug 'vim-scripts/YankRing.vim'

    Plug 'iCyMind/NeoSolarized'
    Plug 'kien/rainbow_parentheses.vim'

    Plug 'christoomey/vim-tmux-navigator'
    Plug 'cohama/lexima.vim'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'guns/vim-sexp'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-sexp-mappings-for-regular-people'
    Plug 'tpope/vim-surround'

    Plug 'JamshedVesuna/vim-markdown-preview'
    Plug 'tpope/vim-fireplace'
    Plug 'tpope/vim-salve'

    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'yssl/QFEnter'
    Plug 'Yggdroot/indentLine'
    Plug 'Chiel92/vim-autoformat'
    Plug 'elixir-editors/vim-elixir'
    Plug 'guns/vim-clojure-static'
    Plug 'udalov/kotlin-vim'
    Plug 'jparise/vim-graphql'
    Plug 'leafgarland/typescript-vim'
    Plug 'mhinz/vim-mix-format'
    Plug 'mxw/vim-jsx'
    Plug 'pangloss/vim-javascript'
    Plug 'plasticboy/vim-markdown'
    Plug 'wavded/vim-stylus'
    Plug 'b4b4r07/vim-sqlfmt'
    Plug 'SirVer/ultisnips'

    call plug#end()
    filetype plugin indent on
" /Plugs }

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

    "" enable vim colors (solarized dark, high contrast)
    set termguicolors
    syntax enable
    colorscheme NeoSolarized
    set background=dark
    let g:neosolarized_contrast = "high"

    " limit syntax highlighting otherwise the world stops
    set synmaxcol=256

    " modify line-indent color
    let g:indentLine_color_term = 239

    " turn off indentLine's fucked up concealevel and concealcursor
    let g:indentLine_conceallevel = 0
    let g:indentLine_concealcursor = ''

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

    "" turn off all character hiding (like hiding of ": in json/markdown files)
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

    " remove text width limits on these filetype
    autocmd bufreadpre *.csv setlocal textwidth=0

    " clj-static formatting, per aclaimant
    let g:clojure_fuzzy_indent_patterns = ['^doto', '^with', '^def', '^let', 'go-loop', 'match', '^context', '^GET', '^PUT', '^POST', '^PATCH', '^DELETE', '^ANY', 'this-as', '^are', '^dofor', 'attempt-all', 'when-failed']
    let g:clojure_align_multiline_strings = 1

    " use ag instead of ack (much faster)
    if executable('ag')
        let g:ackprg = 'ag --vimgrep --nogroup --nocolor --column'
    endif

    " use ag / silver_searcher for ctrl-p
    if executable('ag')
      let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    endif

    " additional files to ignore when searching with ctrl-p
    let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]((\.(git|hg|svn))|(build|dist|node_modules|target|out|_build|deps|resources))$',
      \ 'file': '\v\.(exe|so|dll)$',
      \ 'link': 'some_bad_symbolic_links',
      \ }

    " set local working dir accordingly
    let g:ctrlp_working_path_mode = 'ra'

    " speed up ctrl p by caching in a single place
    let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'

    " make UltiSnips pick up custom snippets (which must be symlinked to .vim/*)
    let g:UltiSnipsSnippetDirectories=[$HOME, "UltiSnips", "my_ulti_snips"]

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

    " display yankring w/ leader-p (copy/paste history)
    nnoremap <leader>p :YRShow<CR>
    " unmap the ctrl-p/n craziness
    let g:yankring_replace_n_pkey = ''
    let g:yankring_replace_n_nkey = ''

    " CoC code navigation
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gr <Plug>(coc-references)
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    " CoC show-doc
    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction

" /Configuration }

""" { Keybindings

    " escape insert -> jf
    imap jf <Esc>

    " <leader> -> ','
    let mapleader = ","
    let maplocalleader = ","

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

    " in quickfix window, open file under cursor vertical/horizontal
    let g:qfenter_keymap = {}
    let g:qfenter_keymap.open = ['<CR>']
    let g:qfenter_keymap.hopen = ['<Leader>j']
    let g:qfenter_keymap.vopen = ['<Leader>k']

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

    function! Expand(exp) abort
      let l:result = expand(a:exp)
      return l:result ==# '' ? '' : "file://" . l:result
    endfunction

    "

    " } /Functions

""" { Custom workflow commands
    " reloaded workflow reset, refresh
    nnoremap <leader>rs :Eval (user/reset)<CR>
    nnoremap <leader>rf :Eval (clojure.tools.namespace.repl/refresh)<CR>
    nnoremap <leader>ra :Eval (clojure.tools.namespace.repl/refresh-all)<CR>

    " auto-import missing clojure libs
    nnoremap <silent> cram :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'add-missing-libspec', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
    " clean clojure namespaces (sort them)
    nnoremap <silent> crcn :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'clean-ns', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
    " move form into let
    nnoremap <silent> crml :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'move-to-let', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1, input('Binding name: ')]})<CR>
    " extract form into function
    nnoremap <silent> cref :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'extract-function', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1, input('Function name: ')]})<CR>
    " rename symbol under cursor
    nmap <silent> crrn <Plug>(coc-rename)

    " auto-format
    vmap <leader>f <Plug>(coc-format-selected)
    nmap <leader>f <Plug>(coc-format-selected)
    nmap <leader>rn <Plug>(coc-rename)

    " highlight words without jumping the cursor randomly
    nnoremap * *``

    " /Custom workflow commands }
