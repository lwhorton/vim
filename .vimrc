set nocompatible

""" Initialize Plug {
  call plug#begin('~/.vim/bundle')

""" /Initialize Plug }

""" { Plugs

    " navigate kitty windows using vim motion
    Plug 'knubie/vim-kitty-navigator', {'do': 'cp ./*.py ~/.config/kitty/'}

    " repl!
    Plug 'tpope/vim-fireplace'
    "" auto connect to repl, auto-start with :Console, etc.
    Plug 'tpope/vim-salve'

    " file status bar
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    " search results
    Plug 'google/vim-searchindex'

    " git integration
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'

    " press - to get a project drawer / tree
    Plug 'tpope/vim-vinegar'

    " yank history
    Plug 'vim-scripts/YankRing.vim'

    " toggling commenting of lines
    Plug 'scrooloose/nerdcommenter'

    " db integration
    Plug 'vim-scripts/dbext.vim'

    " color schemes
    Plug 'overcache/NeoSolarized'

    " file/grep/buffer searching
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
    "" optional deps for ^
    Plug 'fannheyward/telescope-coc.nvim'

    " snippets
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'

    " auto insert matching \{ \[ \( etc.
    Plug 'cohama/lexima.vim'

    " vim motion to match to language constructs like [, {, if/do blocks 
    Plug 'andymass/vim-matchup'

    " editorconfig.org for vim
    Plug 'editorconfig/editorconfig-vim'

    " s-expression for lisps w/ better mappings
    Plug 'guns/vim-sexp'
    Plug 'tpope/vim-sexp-mappings-for-regular-people'

    " syntax-aware select / move / swap / peek for non-lisp shitters
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'

    " plugins can tap into "." repeat functionality
    Plug 'tpope/vim-repeat'

    " add/remove surrounding \( \" \:
    Plug 'tpope/vim-surround'

    " select how/where to open windows from quickfix menu
    Plug 'yssl/QFEnter'

    " lsp-based autocompletion
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    "Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}
    Plug 'neoclide/coc-tsserver'

    " markdown preview, without npm support
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

    "Plug 'Yggdroot/indentLine'

    " language autoformatters
    Plug 'Chiel92/vim-autoformat'
    Plug 'elixir-editors/vim-elixir'
    "" mix integration for elixir
    Plug 'mhinz/vim-mix-format'
    Plug 'guns/vim-clojure-static'
    Plug 'jparise/vim-graphql'
    Plug 'leafgarland/typescript-vim'
    Plug 'mxw/vim-jsx'
    Plug 'pangloss/vim-javascript'
    Plug 'wavded/vim-stylus'
    Plug 'b4b4r07/vim-sqlfmt'
    "Plug 'udalov/kotlin-vim'

    call plug#end()
    filetype plugin indent on
" /Plugs }

""" { Configuration

    set updatetime=750

    " dont leave splits off in buffer land to be lost to the ages
    set autowriteall
    set confirm

    " don't beep, do visual bell
    set visualbell

    " no swap files
    "set directory=~/.vim/swap
    set noswapfile

    "" no wrapping/auto-inserting of \n
    set nowrap
    set textwidth=80

    "" allow deleting text inserted before current insert mode started
    set backspace=indent,eol,start

    "" enable html/css highlighting in js files
    let g:javascript_enable_domhtmlcss=1

    " enable vim solarized color scheme via overcache/NeoSolarized
    syntax enable
    set termguicolors
    colorscheme NeoSolarized
    set background=light
    "set background=dark

    let g:neosolarized_contrast = "high"

    "" the default floating window colors and other such highlights for coc are awful
    func! s:my_colors_setup() abort
      hi CocFloating ctermbg=DarkBlue
      hi CocHintFloat ctermbg=Green
      hi CocHintSign ctermbg=Green
      hi CocHintHighlight ctermbg=Green
      hi CocHintVirtualText ctermbg=Green
      hi CocWarningFloat ctermbg=Yellow
      hi CocWarningSign ctermbg=Yellow
      hi CocWarningHighlight ctermbg=Yellow
      hi CocWarningVirtualText ctermbg=Yellow
      hi CocErrorFloat ctermfg=DarkRed
      hi CocErrorSign ctermfg=DarkBlue
      hi CocErrorHighlight ctermfg=DarkRed
      hi CocErrorVirtualText ctermfg=DarkRed
      hi FgCocErrorFloatBgCocFloating ctermfg=Red
    endfunc

    augroup colorscheme_coc_setup | au!
      au VimEnter * call s:my_colors_setup()
    augroup END

    "" the default matching cursor color is bad, so fix it
    "" https://stackoverflow.com/questions/10746750/set-vim-bracket-highlighting-colors
    hi MatchParen gui=bold guifg=Black guibg=none
    " cterm=bold ctermbg=none ctermfg=magenta

    " vim hardcodes background colors even if the terminfo file does
    " not contain bce (not to mention that libvte based terminals
    " incorrectly contain bce in their terminfo files). this causes
    " incorrect background rendering when using a color theme with a
    " background color.
    let &t_ut=''

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
    "TODO: reenable
    "autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

    "" setup not-stupid tabs
    set tabstop=2
    set shiftwidth=2
    set expandtab
    " make tab/shift-tab(undo tab) work
      " for command mode
    nnoremap <S-Tab> <<
      " for insert mode
    inoremap <S-Tab> <C-d>

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
    "set rnu " ? vim cannot handle relative line numbers on files > 100 lines, too slow
    set nu

    "" turn off all character hiding (like hiding of ": in json/markdown files)
    set conceallevel=0

    " change git-gutter's gutter background color
    highlight clear SignColumn
    let g:gitgutter_override_sign_column_highlight = 0

    " parse build.boot files as clj
    autocmd BufNewFile,BufRead *.boot setf clojure
    autocmd BufNewFile,BufRead *.boot set syntax=clojure

    " remove text width limits on these filetype
    autocmd bufreadpre *.csv setlocal textwidth=0

    " spellcheck readme, git commits
    autocmd FileType markdown setlocal spell
    autocmd FileType gitcommit setlocal spell

    " clj-static formatting, per aclaimant
    let g:clojure_fuzzy_indent_patterns = ['^doto', '^with', '^def', '^let', 'go-loop', 'match', '^context', '^GET', '^PUT', '^POST', '^PATCH', '^DELETE', '^ANY', 'this-as', '^are', '^dofor', 'attempt-all', 'when-failed']
    let g:clojure_align_multiline_strings = 1

    " airline status bar customization
    let g:airline_section_a = airline#section#create_left(['mode'])
    let g:airline_section_b = '%-0.30{getcwd()}'
    let g:airline_section_c = '%t'
    let g:airline_section_gutter = ''
    let g:airline_section_x = ''
    let g:airline_section_y = ''
    let g:airline_section_z = airline#section#create_right(['%3p%%', '%l/%L'])
    let g:airline#extensions#tabline#fnamemod = ':t'
    let g:airline#extensions#branch#enabled = 0
    let g:airline#extensions#tabline#fnamecollapse = 0

    " still render airline status if only 1 file is open
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

    " dont auto-insert for stringy things (super annoying)
    call lexima#add_rule({'char': '"', 'input_after': ''})
    call lexima#add_rule({'char': '""', 'input_after': ''})
    call lexima#add_rule({'char': "'", 'input_after': ''})
    call lexima#add_rule({'char': "''", 'input_after': ''})
    call lexima#add_rule({'char': "``", 'input_after': ''})
    "" dont auto-delete on backspace (really fucks with sexp/lisp) ?TODO?
    "call lexima#add_rule({'char': '<BS>', 'at': '\(#\)'})

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
        nmap ; %
        vmap ; %

        " remap vim-matchup to match
        nmap [; [%
        vmap [; [%
        nmap ]; ]%
        vmap ]; ]%

        " jump to end of line
        nnoremap ' $
        vnoremap ' $

    " make < > indent changes maintain selection
    vnoremap < <gv
    vnoremap > >gv

    " allow saving of files as sudo when I forgot to start using sudo
    cmap w!! w !sudo tee > /dev/null %

    " performance limiters for vim-matchup
    let g:matchup_delim_stopline = 25000 " for all matches 
    let g:matchup_matchparen_stopline = 400 " for match highlighting only

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

    " configure for telescope is done via vim/after/plugin/telescope.nvim.vim

    """ coc/LSP stuff
    nmap <silent> gd <Plug>(coc-definition)
    "nmap <silent> gr <Plug>(coc-references)
    "use telescope instead of coc-references
    nmap <silent> gr <cmd>Telescope coc references_used<cr>

    nmap <silent> gi <Plug>(coc-implementation)
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    " coc auto-format
    vmap <leader>f <Plug>(coc-format-selected)
    nmap <leader>f <Plug>(coc-format-selected)

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

    " coc autocomplete '{key} = accept auto complete suggestion'
    inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#_select_confirm() : "\<TAB>"

    " coc autocomplete next/prev as normal up/down but with ctrl
    inoremap <silent><expr> <C-j> coc#pum#visible() ? coc#pum#next(1) : "\<C-j>"
    inoremap <silent><expr> <C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-k>"

    "" clojure coc/LSP stuff
    " auto-import missing clojure libs
    nnoremap <silent> cram :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'add-missing-libspec', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
    "" clean clojure namespaces (sort them)
    nnoremap <silent> crcn :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'clean-ns', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
    "" move form into let
    nnoremap <silent> crml :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'move-to-let', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1, input('Binding name: ')]})<CR>
    "" extract form into function
    "nnoremap <silent> cref :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'extract-function', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1, input('Function name: ')]})<CR>
    "" rename symbol under cursor
    nnoremap <silent> crrn <Plug>(coc-rename)
    "" auto threaders / unwinders
    nnoremap <silent> crtf :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-first', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
    nnoremap <silent> crtl :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-last', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
    "nnoremap <silent> crtfa :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-first-all', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
    "nnoremap <silent> crtla :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-last-all', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
    nnoremap <silent> cruw :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'unwind-thread', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
    "nnoremap <silent> crua :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'unwind-all', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>

    " reloaded workflow reset, refresh
    "nnoremap <leader>rs :Eval (user/reset)<CR>
    "nnoremap <leader>rf :Eval (clojure.tools.namespace.repl/refresh)<CR>
    "nnoremap <leader>ra :Eval (clojure.tools.namespace.repl/refresh-all)<CR>

    " search across file contents with rip-grep, using fzfs syntax and window
    nnoremap <silent> <C-s> <cmd>Telescope live_grep<cr>
    nnoremap <silent> <C-p> <cmd>Telescope find_files<cr>
    " Find files using Telescope command-line sugar.
    nnoremap <leader>fb <cmd>Telescope buffers<cr>
    nnoremap <leader>fh <cmd>Telescope help_tags<cr>

    " highlight words without jumping the cursor randomly
    nnoremap * *``

    " after your search hit return in command mode to clear highlight
    nnoremap <CR> :noh<CR><CR>

    " /Custom workflow commands }
