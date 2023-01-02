let g:polyglot_disabled = ['markdown']
call plug#begin()

" Themes
Plug 'drewtempelmeyer/palenight.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'morhetz/gruvbox'
" Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
" Plug 'nerdypepper/vim-colors-plain', { 'branch': 'duotone' }
" Plug 'sainnhe/vim-color-forest-night'
Plug 'franbach/miramare'
Plug 'cormacrelf/vim-colors-github'
" Plug 'fehawen/cs.vim'
Plug 'nightsense/carbonized'
Plug 'NerdyPepper/vim-colors-plain'
Plug 'romgrk/doom-one.vim'
Plug 'chriskempson/base16-vim'

" Enhancements
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
" Plug 'tpope/vim-vinegar'
Plug 'Yggdroot/indentLine'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'christoomey/vim-tmux-navigator'

" Comfort
Plug 'tpope/vim-sleuth'
"Plug 'tpope/vim-commentary'

" Languages
" Plug 'sheerun/vim-polyglot'
" Plug 'tmhedberg/SimpylFold'
" Plug 'masukomi/vim-markdown-folding'

" :^)
Plug 'vimwiki/vimwiki'
" Plug 'neovim/nvim-lsp'
" Plug 'neovim/nvim-lspconfig'


Plug 'farmergreg/vim-lastplace'
let g:miramare_transparent_background = 1
let g:miramare_enable_bold = 1
let g:dracula_colorterm = 0

Plug 'raimondi/delimitMate'

Plug 'preservim/vim-markdown'

Plug 'ap/vim-css-color'



call plug#end()


" ==== Syntax Highlighting ====
set termguicolors
syntax on


let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
let g:lastplace_ignore_buftype = "quickfix,nofile,help"
let g:lastplace_open_folds = 0

" set background=light

" ====== Plugin Configs ======
" indentline
let g:indentLine_char = '│'

" goyo
let g:goyo_width = '50%'
let g:goyo_height = '100%'

let g:airline_theme = 'dracula'

" ======= Vim Config =======
"set guicursor
set exrc
set relativenumber
set nu
set nohlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
"set nowrap
set nobackup
set undodir=~/.vim/undodir
set incsearch
set termguicolors
set scrolloff=8
"set noshowmode
set completeopt=menuone,noinsert,noselect
"set colorcolumn=80
"set signcolumn=yes

" Give more space for displaying messages
set cmdheight=2

" Having longer updatetime (default is 4000ms) leads to noticeable
" dispaly and poor user experience
set updatetime=50

" Don't pass messages to |ins-completion-menu|
set shortmess+=c
set cmdheight=2



"let base16colorspace=256
colorscheme base16

