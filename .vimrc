set nocompatible
filetype off

""" Initialize Vundle

" set the runtime path to include Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

""" /Initialize Vundle


""" { Configuration }

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

" persist undo
set undodir=~/.vim/undo
set undofile

" relative line numbers
set rnu

""" { Keybindings }

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

""" { Plugins }

Bundle 'scrooloose/syntastic'
Bundle 'kien/ctrlp.vim'
Bundle 'bling/vim-airline'
Bundle 'mileszs/ack.vim'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'scrooloose/nerdtree'
Bundle 'altercation/vim-colors-solarized'
Bundle 'pangloss/vim-javascript'
Bundle 'scrooloose/nerdcommenter'
Bundle 'airblade/vim-gitgutter'

""" Give control to Vundle

call vundle#end()
filetype plugin indent on

