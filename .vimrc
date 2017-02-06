set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'suxpert/vimcaps'
Plugin 'kien/ctrlp.vim'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'majutsushi/tagbar'
Plugin 'gerw/vim-HiLinkTrace'
Plugin 'hexHighlight.vim'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'gorodinskiy/vim-coloresque'
"Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'kshenoy/vim-signature'
"Plugin 'airblade/vim-gitgutter'
Plugin 'mileszs/ack.vim'
"Plugin 'tpope/vim-obsession'
"Plugin 'dhruvasagar/vim-prosession'
Plugin 'xolox/vim-session'
Plugin 'xolox/vim-misc'
"Plugin 'jeetsukumaran/vim-buffergator'
Plugin 'jlanzarotta/bufexplorer'
" Plugin 'freitass/todo.txt-vim'
" Plugin 'othree/yajs.vim'
Plugin 'pangloss/vim-javascript'
" Plugin 'laeder/progress-indent'
Plugin 'vim-scripts/Mark--Karkat'
Plugin 'godlygeek/tabular'
Plugin 'vim-scripts/FuzzyFinder'
Plugin 'vim-scripts/L9'
Plugin 'vim-scripts/BreakPts'
Plugin 'vim-scripts/genutils'

" Colorschemes
Plugin 'sjl/badwolf'
Plugin 'nanotech/jellybeans.vim'
Plugin 'tomasr/molokai'
Plugin 'altercation/vim-colors-solarized'
Plugin 'lsdr/monokai'

" My own plugins
" Plugin 'file:///C:/mikael/projekt/vim/progress-indent/'
" Plugin 'file:///C:/mikael/projekt/vim/progress-syntax/'
" Plugin 'file:///C:/mikael/projekt/vim/cylon/'

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
set fileencoding=utf8
set encoding=utf8
set guifont=Droid\ Sans\ Mono\ Dotted\ for\ Powerline

set ignorecase
set smartcase
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
" syn sync fromstart
" set foldmethod=syntax

" remove [T]oolbar, [m]enu, [r]ight scroll and [L]eft scroll
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=L

" Autocommand
autocmd BufRead,BufNewFile *.p set filetype=progress
autocmd BufRead,BufNewFile *.html set filetype=progress
autocmd BufRead,BufNewFile *.tex setlocal textwidth=80
autocmd BufRead,BufNewFile *.md setlocal textwidth=80
autocmd BufEnter * silent! lcd %:p:h

" Ctrl-p
let g:ctrlp_root_markers = ['.ctrlp']
let g:ctrlp_custom_ignore = '\v\.(exe|dll|r|zip|gz)$'

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline_theme = 'molokai'

" Tagbar
let g:tagbar_type_progress = {
    \ 'ctagstype' : 'progress',
    \ 'kinds'     : [
        \ 'm:parameters',
        \ 'p:procedures',
        \ 'f:functions',
        \ 't:temptables',
        \ 'b:buffers'
    \ ]
\ }

" mappings
let mapleader = ","
let maplocalleader = "_"
nnoremap <leader>p :setf progress<CR>
nnoremap <leader>c :CompileProgress c:\stamford\ue\comp.bat %:p<CR>
nnoremap <leader><space> :nohlsearch<CR>
nmap <F8> :TagbarToggle<CR>
nmap <F7> :NERDTreeToggle<CR>
nnoremap <leader>ww :call WinsizeWork()<CR>
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <leader>fi :let @"="{" . split(expand("%:p"), "wrk_dir\\")[1] . "}"<CR>
nmap <F9> <C-w>l<CR>
nmap <F10> <C-w>h<CR>
nmap <F6> :b #<CR>

" Copy the filename to the clipboard
" Convert slashes to backslashes for Windows.
if has('win32')
  nmap ,fs :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
  nmap ,fl :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>
else
  nmap ,fs :let @*=expand("%")<CR>
  nmap ,fl :let @*=expand("%:p")<CR>
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

function! s:CompileProgress(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('CompileProgress')
  silent! execute  winnr < 0 ? 'botright new ' . fnameescape('CompileProgress') : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Compiling...'
  silent! execute 'silent %!'. command
  silent! execute 'resize ' . line('$')
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>CompileProgress(''' . command . ''')<CR>'
  echo 'Compile finished.'
  wincmd p
endfunction
command! -complete=shellcmd -nargs=+ CompileProgress call s:CompileProgress(<q-args>)

function WinsizeWork()
    winpos 280 20
    set lines=76
    set columns=200
endfunction

function SvgToTemplate()
    " Titlar
    :%s/#03000\(.\)/%ctitle_\1%/g

    " Den vänstra månadsöversikten
    :%s/#010\(.\)0\(.\)/%cmd_1_\1_\2%/g
    :%s/>A\(.\)</>%md_1_1_\1%</g
    :%s/>B\(.\)</>%md_1_2_\1%</g
    :%s/>C\(.\)</>%md_1_3_\1%</g
    :%s/>D\(.\)</>%md_1_4_\1%</g
    :%s/>E\(.\)</>%md_1_5_\1%</g
    :%s/>F\(.\)</>%md_1_6_\1%</g
    :%s/>M\(.\)</>%mw_1_\1%</g
    :%s/>O\(.\)</>%mt_1_\1%</g

    " Den högra månadsöversikten
    :%s/#020\(.\)0\(.\)/%cmd_2_\1_\2%/g
    :%s/>G\(.\)</>%md_2_1_\1%</g
    :%s/>H\(.\)</>%md_2_2_\1%</g
    :%s/>I\(.\)</>%md_2_3_\1%</g
    :%s/>J\(.\)</>%md_2_4_\1%</g
    :%s/>K\(.\)</>%md_2_5_\1%</g
    :%s/>L\(.\)</>%md_2_6_\1%</g
    :%s/>N\(.\)</>%mw_2_\1%</g
    :%s/>P\(.\)</>%mt_2_\1%</g
endfunction

