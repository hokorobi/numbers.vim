" Maintainer: Zhenhuan Hu <zhu@mcw.edu>
" Version: Aug 05, 2016

" set verbose=15 vfile=$HOME/vfile.txt

" Self-defined functions
function! KenyToggleComment(leader, tail)
  let l:save_cpo   = &cpo
  let l:save_paste = &paste
  set cpo&vim
  set paste
  if getline('.') !=# ''
    let l:leader = escape(a:leader, '\/*')
    let l:tail   = escape(a:tail, '\/*')
    " Add or remove commenting syntax depending on
    " whether there is commenting syntax at the beginning of a line
    if getline('.') =~ '^' . l:leader . '\(.*\)' . l:tail . '$'
      silent exec 's/^' . l:leader . '\(.*\)' . l:tail . '$/\1/'
    else
      silent exec 's/^\(.*\)$/' . l:leader . '\1' . l:tail . '/'
    endif
  endif
  " Move cursor to the beginning of the next line
  silent exec 'normal! +'
  let &cpo   = l:save_cpo
  let &paste = l:save_paste
endfunction

function! KenySplitLineNicely()
  " Save previous value of last search register
  let l:saved_last_search_pattern = @/
  " :substitute replaces the content of the register with the
  " pattern highlighting all whitespaces in the file
  substitute /\s\+/\r/g
  " Restore previous search register
  let @/ = l:saved_last_search_pattern
endfunction

" General
filetype plugin indent on
set autoread nocp noswapfile nobackup
set backspace=2 whichwrap+=<,>,[,]
fixdel

" Addtional paths
if has("unix")
  set runtimepath+=$HOME/.vim/bundle/*,$HOME/.vim/bundle/*/after
  set viewdir=$HOME/.vim/view viewoptions-=options
elseif has("win32")
  set runtimepath+=$HOME/vimfiles/bundle/*,$HOME/vimfiles/bundle/*/after
  set viewdir=$HOME/vimfiles/view viewoptions-=options
endif

" File format options
set fileformats=unix,dos
if has("multi_byte")
  if &termencoding ==# ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8 fileencodings=utf-8,gb18030,big5,sjis,latin1
endif

" Basic interface elements
set number ruler wrap showcmd showmode wildmenu laststatus=2

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

" Indentation
set autoindent softtabstop=2 shiftwidth=2 expandtab

" Searching behaviors
set hlsearch incsearch ignorecase smartcase

" Key mappings
let mapleader = ','
nnoremap <leader>, ,
nnoremap <leader>es :vsplit $MYVIMRC<CR>
nnoremap <leader>ss :source $MYVIMRC<CR>
nnoremap <leader>ww :w<CR>
nnoremap <leader>qq :q<CR>
nnoremap <leader>cd :cd %:p:h<CR>
nnoremap <leader>fi mzgg=G`z
nnoremap <leader>it "= strftime('%b %d, %Y')<CR>p
nnoremap <leader>er /error<CR>
nnoremap <leader>wr /warning<CR>

nnoremap <leader><Space> za
vnoremap <leader><Space> zf
vnoremap <BS> d

xnoremap ( c(<C-r>")
xnoremap [ c[<C-r>"]
xnoremap { c{<C-r>"}
xnoremap ' c'<C-r>"'
xnoremap " c"<C-r>""

if !has("macunix")
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
  cnoremap <C-v> <C-r>+aa
  exec 'vnoremap <script> <C-v>' paste#paste_cmd['v']
  exec 'inoremap <script> <C-v>' paste#paste_cmd['i']

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
