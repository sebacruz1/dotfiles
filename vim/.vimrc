" ===== Núcleo =====
set nocompatible
filetype plugin indent on
syntax on
set hidden
set number relativenumber
set cursorline
set signcolumn=yes
set termguicolors
set splitright splitbelow
set updatetime=200
set timeoutlen=400

" ===== Búsqueda =====
set ignorecase smartcase
set incsearch hlsearch
" ===== Tabs / Indent =====
filetype plugin indent on
set expandtab shiftwidth=2 tabstop=2
set autoindent smartindent
" ===== Portapapeles / Persistencia =====
set undofile | set undodir=~/.vim/undo//
set backupdir=~/.vim/backup// | set directory=~/.vim/swap//

" ===== Leader y atajos mínimos =====
let mapleader = ","
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>h :nohlsearch<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>co :copen<CR>
nnoremap <leader>cc :cclose<CR>
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>

" ===== Statusline simple =====
set laststatus=2
set statusline=%f\ %m%r%h%w%=\ [%{&filetype}]\ %y\ %p%%\ %l:%c
"
" No continuar comentarios automáticamente
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Toggle de paste manual
set pastetoggle=<F2>

" Pegar con Cmd+V / Ctrl+V sin autoindent
inoremap <C-v> <C-o>:set paste<CR><C-r>+<C-o>:set nopaste<CR>


if filereadable(expand("~/.vim/my_configs.vim"))
  source ~/.vim/my_configs.vim
endif

