" Maintainer: Zhenhuan Hu <zhu@mcw.edu>
" Version: 2017-01-19

" set verbose=15 vfile=$HOME/vfile.txt

" General
filetype plugin indent on
set nocompatible noswapfile nobackup autoread
set backspace=indent,eol,start whichwrap+=<,>,[,]
fixdel

" Addtional paths
if has('unix')
  set runtimepath+=$HOME/.vim/bundle/*,$HOME/.vim/bundle/*/after
  set viewdir=$HOME/.vim/view viewoptions-=options
elseif has('win32')
  set runtimepath+=$HOME/vimfiles/bundle/*,$HOME/vimfiles/bundle/*/after
  set viewdir=$HOME/vimfiles/view viewoptions-=options
endif

" File format options
set fileformats=unix,dos
if has('multi_byte')
  if &termencoding ==# ''
    let &termencoding = &encoding
  endif
  set encoding=utf-8 fileencodings=utf-8,gb18030,big5,sjis,latin1
endif

" Basic interface elements
set number ruler showcmd showmode wildmenu laststatus=2

" Indentation, wrap, and white spaces
set autoindent softtabstop=2 shiftwidth=2 expandtab wrap
let &showbreak = "\u2192"
if version > 704
  set breakindent breakindentopt+=sbr
endif

" Searching behaviors
set incsearch ignorecase smartcase

" Color
set background=dark
colorscheme waikiki

" Syntax
if version >= 500
  if !exists('g:syntax_on')
    syntax enable
  endif
  syntax sync fromstart
endif

" Key mappings
let mapleader = ','
nnoremap <leader>, ,
nnoremap <leader>es :vsplit $MYVIMRC<CR>
nnoremap <leader>ss :source $MYVIMRC<CR>
nnoremap <leader>ww :w<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>qq :q<CR>
nnoremap <leader>cd :cd %:p:h<CR>
nnoremap <leader>fi mzgg=G`z
nnoremap <leader>it "= strftime('%b %d, %Y')<CR>p
nnoremap <leader>er /error<CR>
nnoremap <leader>wr /warning<CR>

nnoremap <leader><Space> za
vnoremap <leader><Space> zf
vnoremap <BS> d

inoremap <leader><Tab> <Esc>`^

xnoremap ( c(<C-r>")
xnoremap [ c[<C-r>"]
xnoremap { c{<C-r>"}
xnoremap ' c'<C-r>"'
xnoremap " c"<C-r>""

if !has('macunix')
  nnoremap <C-z> u
  vnoremap <C-z> <Esc>ugv
  inoremap <C-z> <C-o>u
  cnoremap <C-z> <C-c>u
  onoremap <C-z> <Esc>u

  nnoremap <C-y> <C-r>
  vnoremap <C-y> <Esc><C-r>gv
  inoremap <C-y> <C-o><C-r>
  cnoremap <C-y> <C-c><C-r>
  onoremap <C-y> <Esc><C-r>

  vnoremap <C-x> "+x
  vnoremap <C-c> "+y
  cnoremap <C-c> <C-y>
  nnoremap <C-v> "+gP
  cnoremap <C-v> <C-r>+

  " Pasting blockwise and linewise selections is not possible in Insert and
  " Visual mode without the +virtualedit feature. They are pasted as if they
  " were characterwise instead.
  " Uses the paste.vim autoload script.
  " Use CTRL-G u to have CTRL-Z only undo the paste.
  exec 'vnoremap <script> <C-v>' paste#paste_cmd['v']
  exec 'inoremap <script> <C-v>' '<C-g>u' . paste#paste_cmd['i']

  nnoremap <silent> <C-a> gggH<C-o>G
  vnoremap <C-a> <Esc>gggH<C-o>G
  inoremap <C-a> <C-o>gg<C-o>gH<C-o>G
  cnoremap <C-a> <C-c>gggH<C-o>G
  onoremap <C-a> <Esc>gggH<C-o>G

  nnoremap <C-s> :update<CR>
  vnoremap <C-s> <C-c>:update<CR>
  inoremap <C-s> <C-o>:update<CR>
endif

" Configure vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep = ' >>> '
let g:airline_right_sep = ' <<< '
