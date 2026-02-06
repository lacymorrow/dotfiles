" Basic Vim configuration for development

" General settings
set number              " Show line numbers
set relativenumber      " Show relative line numbers
set tabstop=4          " Tab width
set shiftwidth=4        " Indent width
set expandtab          " Use spaces instead of tabs
set smartindent        " Smart autoindenting
set autoindent         " Auto indent
set wrap               " Wrap lines
set showbreak=↪        " Show line break character
set linebreak          " Break lines at word boundaries

" Search settings
set ignorecase         " Case insensitive search
set smartcase          " Case sensitive when uppercase used
set hlsearch           " Highlight search results
set incsearch          " Incremental search

" Visual settings
set syntax=on          " Syntax highlighting
set background=dark    " Dark background
set termguicolors      " True color support
set cursorline         " Highlight current line
set colorcolumn=80     " Show 80 character limit

" Navigation
set scrolloff=8        " Keep 8 lines visible when scrolling
set sidescrolloff=8    " Keep 8 columns visible when scrolling

" File handling
set backup             " Enable backup
set backupdir=~/.vim/backup " Backup directory
set directory=~/.vim/tmp   " Swap file directory
set undofile           " Enable undo
set undodir=~/.vim/undo    " Undo directory

" Performance
set lazyredraw         " Don't redraw during macros
set updatetime=300     " Faster update time

" Mouse support
set mouse=a            " Enable mouse in all modes

" Clipboard
set clipboard=unnamedplus " Use system clipboard

" Backspace behavior
set backspace=indent,eol,start

" Wild menu
set wildmenu           " Enhanced command completion
set wildmode=longest,list

" Status line
set laststatus=2       " Always show status line
set statusline=%f       " File name
set statusline+=%m      " Modified flag
set statusline+=%r      " Read-only flag
set statusline+=%h      " Help flag
set statusline+=%w      " Preview flag
set statusline+=%=      " Right align
set statusline+=%y      " File type
set statusline+=\ %l/%L " Line number/total lines
set statusline+=\ %c    " Column number
set statusline+=\ %P    " Percentage through file

" Netrw settings
let g:netrw_liststyle = 3 " Tree view
let g:netrw_banner = 0     " Remove banner
let g:netrw_winsize = 30   " Window size

" Create directories if they don't exist
if !isdirectory(expand('~/.vim/backup'))
    silent !mkdir -p ~/.vim/backup
endif
if !isdirectory(expand('~/.vim/tmp'))
    silent !mkdir -p ~/.vim/tmp
endif
if !isdirectory(expand('~/.vim/undo'))
    silent !mkdir -p ~/.vim/undo
endif
