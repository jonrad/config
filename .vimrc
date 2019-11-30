filetype plugin indent on
syntax on
set backspace=indent,eol,start
set ts=2
set softtabstop=0
set sw=2
set expandtab
set smarttab
set clipboard=unnamed
set incsearch
set hlsearch
set ignorecase
set smartcase

" Space to select current word under cursor
noremap <space> viw

" semicolon as colon
noremap ; :

" jj as escape
inoremap jj <esc>

" J and K to move up and down a page
nnoremap J <C-f>
nnoremap K <C-b>

" what are these?
nnoremap ,= gg=G
nnoremap >b mzvi}>'z
nnoremap <b mzvi}<'z
nnoremap ,de :g/^\s*$/d<cr>
nnoremap gj gT
nnoremap gk gt
nnoremap ,f :2,$s/pick/f<cr>
nnoremap ,<return> f,a<return><esc>

