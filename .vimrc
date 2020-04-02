syntax on

colorscheme badwolf

set cursorline          " highlight current line
set expandtab             	" use spaces instead of tabs
set ignorecase            	" Make searches case-insensitive.
set incsearch             	" But do highlight as you type your search.
set laststatus=2          	" last window always has a statusline
set mouse=a               	" enable the mouse
set nobackup              	" I manage my backups
set hlsearch            	" highlight searched phrases.
set noswapfile            	" don't let it create swap files
set nowrap                	" don't wrap text
set number                	" show line numbers
set pastetoggle=<F2>      	" switch to paste mode
set ruler                 	" Always show info along bottom.
set shiftround            	" always indent/outdent to the nearest tabstop
set shiftwidth=4          	" indent/outdent by 4 columns
set showcmd             	" show command in bottom bar
set showmatch           	" highlight matching [{()}]
set smarttab              	" use tabs at the start of a line, spaces elsewhere
set softtabstop=4         	" unify
set tabstop=4				" tab spacing
set t_Co=256 				" enable 256-color mode.
set spell                	" turn on spell checking
set backspace=indent,eol,start "make backspace work like anything else

" Vundle setup
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" PLACE ADDONS HERE "
Plugin 'bash-support.vim'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/syntastic'
Plugin 'SuperTab'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'rodjek/vim-puppet'
Plugin 'honza/vim-snippets'
Plugin 'vim-coffee-script'
Plugin 'davidhalter/jedi-vim'
Plugin 'Indent-Guides' 
Plugin 'pangloss/vim-javascript'
Plugin 'digitaltoad/vim-jade'
Plugin 'plasticboy/vim-markdown'
Plugin 'flazz/vim-colorschemes'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on     " required!

let g:syntastic_enable_signs=1
let g:syntastic_auto_jump=1
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
let g:vim_markdown_folding_disabled=1

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set pastetoggle=<F2>
syntax on

" Key Maps
map <C-n> :NERDTreeToggle<CR>
