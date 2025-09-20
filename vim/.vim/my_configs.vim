call plug#begin('~/.vim/plugged')

" Navegación
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Statusline
Plug 'itchyny/lightline.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Edición de texto
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'jiangmiao/auto-pairs'

" Multicursor + yank stack
Plug 'maxbrunsfeld/vim-yankstack'

" Linting / formato
Plug 'dense-analysis/ale'

" Colores
Plug 'sickill/vim-monokai'
Plug 'morhetz/gruvbox'

Plug 'tpope/vim-sleuth'
Plug 'editorconfig/editorconfig-vim'

Plug 'tpope/vim-surround'
Plug 'neoclide/vim-jsx-improve'

call plug#end()

" ===== Mapeos de plugins =====

nnoremap <leader>n  :NERDTreeToggle<CR>
nnoremap <leader>f  :NERDTreeFind<CR>

" FZF (usa ripgrep en backend)
let $FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
nnoremap <leader>t  :Files<CR>
nnoremap <leader>b  :Buffers<CR>
nnoremap <leader>rg :Rg<Space>

" ===== ALE (lint/format) =====
let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1

let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'typescriptreact': ['prettier', 'eslint'],
\   'javascriptreact': ['prettier', 'eslint'],
\   'json': ['prettier'],
\   'css': ['prettier'],
\   'html': ['prettier'],
\}

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\   'typescriptreact': ['eslint'],
\   'javascriptreact': ['eslint'],
\   'css': [],
\   'html': [],
\}

" navegación de diagnósticos ALE (no choca con tus ]q/[q de quickfix)
"
nnoremap ]e :ALENextWrap<CR>
nnoremap [e :ALEPreviousWrap<CR>

"
nmap <leader>y <Plug>yankstack_substitute_older_paste
nmap <leader>Y <Plug>yankstack_substitute_newer_paste


let g:lightline = { 'colorscheme': 'wombat' }

set noshowmode
augroup seba_qol
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
  autocmd BufEnter * match ErrorMsg /\s\+$/
  autocmd FocusLost * silent! wa
augroup END


set background=dark
colorscheme monokai

