set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Plugins
Plugin 'suxpert/vimcaps'
Plugin 'kien/ctrlp.vim'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'majutsushi/tagbar'
Plugin 'gerw/vim-HiLinkTrace'
Plugin 'hexHighlight.vim'
Plugin 'bling/vim-airline'
Plugin 'gorodinskiy/vim-coloresque'
Plugin 'mhinz/vim-startify'
Plugin 'tpope/vim-fugitive'
" Plugin 'freitass/todo.txt-vim'
" Plugin 'laeder/progress-indent'

" Colorschemes
" Plugin 'morhetz/gruvbox'
Plugin 'sjl/badwolf'
" Plugin 'tpope/vim-vividchalk'
Plugin 'nanotech/jellybeans.vim'
Plugin 'tomasr/molokai'
Plugin 'altercation/vim-colors-solarized'
" Plugin 'gmarik/ingretu'
Plugin 'lsdr/monokai'
" Plugin 'w0ng/vim-hybrid'
" Plugin 'notpratheek/vim-luna'
" My own plugins
Plugin 'file:///C:/mikael/projekt/vim/progress-indent/'
Plugin 'file:///C:/mikael/projekt/vim/progress-syntax/'

call vundle#end()            " required
filetype plugin indent on    " required

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
set number
set background=dark
colorscheme molokai
syntax on
set tabstop=4
set shiftwidth=4
set expandtab
set fileencoding=cp1252
set encoding=utf8
set guifont=Droid_Sans_Mono_Dotted_for_Powe:h8
autocmd BufEnter * silent! lcd %:p:h
let g:ctrlp_root_markers = ['.ctrlp']
let g:ctrlp_custom_ignore = '\v\.(exe|dll|r|zip|gz)$'
set ignorecase
set smartcase
au BufRead,BufNewFile *.p set filetype=progress
set laststatus=2
" set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
set backspace=indent,eol,start
set wildmenu
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set tags=~\.ctags
" I hade to remove { and } from isfname because they where
" interfering with the way includes are done in Progress
set isfname=@,48-57,/,\\,.,-,_,,,#,$,%,[,],:,@-@,!,~,=
set path=.,b:/Perforce_WS/CKS/DEV_MAsp/wrk_dir/
" foldning
syn sync fromstart
set foldmethod=syntax

" remove [T]oolbar, [m]enu, [r]ight scroll and [L]eft scroll
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=L

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

"tagbar
let g:tagbar_type_progress = {
    \ 'ctagstype' : 'progress',
    \ 'kinds'     : [
        \ 'm:parameters',
        \ 'p:procedures',
        \ 'f:functions',
    \ ]
\ }

" mappings
let mapleader = ","
let maplocalleader = "_"
nnoremap <leader>p :setf progress<CR>
nnoremap <leader>c :Shell c:\stamford\ue\comp.bat %:p<CR>
nnoremap <leader><space> :nohlsearch<CR>
nmap <F8> :TagbarToggle<CR>

" Copy the filename to the clipboard
" Convert slashes to backslashes for Windows.
if has('win32')
  nmap ,cs :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
  nmap ,cl :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>
else
  nmap ,cs :let @*=expand("%")<CR>
  nmap ,cl :let @*=expand("%:p")<CR>
endif

" functions
function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! execute 'resize ' . line('$')
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
  wincmd p
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
