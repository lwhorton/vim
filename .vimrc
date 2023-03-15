set nocompatible

""" Initialize Plug {
  call plug#begin('~/.vim/bundle')

""" /Initialize Plug }

""" { Plugs

    Plug 'google/vim-searchindex'
    Plug 'scrooloose/nerdcommenter'
    Plug 'tpope/vim-vinegar'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'
    Plug 'vim-scripts/dbext.vim'
    Plug 'cohama/lexima.vim'
    Plug 'vim-scripts/YankRing.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    Plug 'iCyMind/NeoSolarized'
    Plug 'kien/rainbow_parentheses.vim'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'

    Plug 'christoomey/vim-tmux-navigator'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'guns/vim-sexp'
    Plug 'tpope/vim-sexp-mappings-for-regular-people'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-fireplace'
    Plug 'tpope/vim-salve'
    Plug 'yssl/QFEnter'

    " lsp for elixir
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " lsp for clojure
    "Plug 'neoclide/coc.nvim', {'branch': 'release'}

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
    Plug 'wavded/vim-stylus'
    Plug 'b4b4r07/vim-sqlfmt'

    " markdown preview, without npm support
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

    call plug#end()
    filetype plugin indent on
" /Plugs }

""" { Configuration

    set updatetime=300

    " don't beep, do visual bell
    set visualbell

    " no swap files
    set noswapfile

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
    "set background=light
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
    "let g:rbpt_colorpairs = [
      "\ [ '13', '#6c71c4'],
      "\ [ '5',  '#d33682'],
      "\ [ '1',  '#dc322f'],
      "\ [ '9',  '#cb4b16'],
      "\ [ '3',  '#b58900'],
      "\ [ '2',  '#859900'],
      "\ [ '6',  '#2aa198'],
      "\ [ '4',  '#268bd2'],
      "\ ]

    """ enable rainbow parentheses for all buffers
    "augroup rainbow_parentheses
      "au!
      "au VimEnter * RainbowParenthesesActivate
      "au BufEnter * RainbowParenthesesLoadRound
      "au BufEnter * RainbowParenthesesLoadSquare
      "au BufEnter * RainbowParenthesesLoadBraces
    "augroup END

    " parse build.boot files as clj
    autocmd BufNewFile,BufRead *.boot setf clojure
    autocmd BufNewFile,BufRead *.boot set syntax=clojure

    " remove text width limits on these filetype
    autocmd bufreadpre *.csv setlocal textwidth=0

    " clj-static formatting, per aclaimant
    let g:clojure_fuzzy_indent_patterns = ['^doto', '^with', '^def', '^let', 'go-loop', 'match', '^context', '^GET', '^PUT', '^POST', '^PATCH', '^DELETE', '^ANY', 'this-as', '^are', '^dofor', 'attempt-all', 'when-failed']
    let g:clojure_align_multiline_strings = 1

    " fzf: pin preview to bottom
    let g:fzf_layout = {'down': '80%'}

    " enable symbol-searching via rg through fzf window (with reasonable defaults/ignores)
    function! RipgrepFzfSymbol(query, fullscreen)
      let thing = "rg --column --line-number --no-heading --color=always --smart-case"
          \ . " -g '*.{ex,exs,eex,clj,cljc,cljs,edn,js,json,md,styl,html,config,conf,scss,yml,env}'"
          \ . " -g '{resources/migrations}/*'"
          \ . " -g '!*.{min.js,js.map,cache.json,externs.js,swp,o,zip,beam}'"
          \ . " -g '!*.{beam}'"
          \ . " -g '!*/{ebin,_build,build}/*'"
          \ . " -g '!*/{deps}/*'"
          \ . " -g '!{.git,node_modules,vendor,_build,build,deps,tmp,test,helm,deps}/*'"
          \ . " "
          \ . shellescape(a:query)
      call fzf#vim#grep(thing, 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4.. --bind ctrl-j:up,ctrl-k:down'}), a:fullscreen)
    endfunction

    " invoke symbol searching fzf
    command! -nargs=* -bang Rgs call RipgrepFzfSymbol(<q-args>, <bang>0)

    " file searching fzf
    command! -nargs=* -bang -complete=dir Files
          \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--delimiter', ':', '--bind', 'ctrl-j:up,ctrl-k:down', '--info', 'inline', '--height', '40%']}), <bang>0)

    " status bar customization
    let g:airline#extensions#tabline#fnamemod = ':.'
    let g:airline#extensions#tabline#fnamecollapse = 0

    " render airline when only 1 files is open
    set laststatus=2

    " disable auto-insert / auto-delete mode for clojure expressions
    let g:sexp_enable_insert_mode_mappings = 0

    " markdown preview to ctrl-m
    nmap <C-m> <Plug>MarkdownPreview

    " display yankring w/ leader-p (copy/paste history)
    nnoremap <leader>p :YRShow<CR>
    " unmap the ctrl-p/n craziness
    let g:yankring_replace_n_pkey = ''
    let g:yankring_replace_n_nkey = ''

    " dont auto-insert for strings (super annoying) by overriding defaults
    call lexima#add_rule({'char': '"', 'input_after': ''})
    call lexima#add_rule({'char': "'", 'input_after': ''})

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
    let g:qfenter_keymap.hopen = ['<leader>j']
    let g:qfenter_keymap.vopen = ['<leader>k']

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

    " } /Functions

""" { Custom workflow commands

    " optional, configure as-you-type completions
    set completeopt=menu,menuone,preview,noselect,noinsert

    """ coc/LSP stuff
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gr <Plug>(coc-references)
    nmap <silent> gi <Plug>(coc-implementation)
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    " coc auto-format
    vmap <leader>f <Plug>(coc-format-selected)
    nmap <leader>f <Plug>(coc-format-selected)

    " coc symbol renaming
    nmap <leader>rn <Plug>(coc-rename)

    " coc show-doc
    function! s:show_documentation()
     if (index(['vim','help'], &filetype) >= 0)
       execute 'h '.expand('<cword>')
     else
       if CocAction('hasProvider', 'hover')
         call CocActionAsync('doHover')
       else
         call feedkeys('K', 'in')
       endif
     endif
    endfunction

    "" clojure coc/LSP stuff
    " auto-import missing clojure libs
    "nnoremap <silent> cram :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'add-missing-libspec', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
    "" clean clojure namespaces (sort them)
    "nnoremap <silent> crcn :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'clean-ns', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
    "" move form into let
    "nnoremap <silent> crml :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'move-to-let', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1, input('Binding name: ')]})<CR>
    "" extract form into function
    "nnoremap <silent> cref :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'extract-function', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1, input('Function name: ')]})<CR>
    "" rename symbol under cursor
    "nmap <silent> crrn <Plug>(coc-rename)
    "" auto threaders / unwinders
    "nnoremap <silent> crtf :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-first', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
    "nnoremap <silent> crtl :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-last', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
    "nnoremap <silent> crtfa :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-first-all', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
    "nnoremap <silent> crtla :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-last-all', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
    "nnoremap <silent> cruw :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'unwind-thread', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
    "nnoremap <silent> crua :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'unwind-all', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>

    " reloaded workflow reset, refresh
    "nnoremap <leader>rs :Eval (user/reset)<CR>
    "nnoremap <leader>rf :Eval (clojure.tools.namespace.repl/refresh)<CR>
    "nnoremap <leader>ra :Eval (clojure.tools.namespace.repl/refresh-all)<CR>

    " search across file contenis with rip-grep, using fzfs syntax and window
    nnoremap <silent> <C-s> :Rgs<CR>
    nnoremap <silent> <C-p> :Files<CR>

    " highlight words without jumping the cursor randomly
    nnoremap * *``

    " /Custom workflow commands }
