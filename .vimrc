""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic settings.
""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable
set autoread
set noswapfile
set showtabline=2
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,shift_jis,cp932
set fileformats=unix,mac,dos
set wildmenu

""""""""""""""""""""""""""""""""""""""""""""""""""
" Key bind settings.
""""""""""""""""""""""""""""""""""""""""""""""""""
" Move window.
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
" Resize window.
nnoremap sj <C-w>+
nnoremap sk <C-w>-
nnoremap sh <C-w>>
nnoremap sl <C-w><
nnoremap s= <C-w>=
" Tabs.
nnoremap st :<C-u>tabnew<CR>
nnoremap sm gt
nnoremap sn gT
" Yank.
nnoremap Y y$
" Reset highlight.
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
" Move.
nnoremap j gj
nnoremap k gk

""""""""""""""""""""""""""""""""""""""""""""""""""
" Indent settings.
""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent
set smartindent
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4

""""""""""""""""""""""""""""""""""""""""""""""""""
" Cursor and display settings.
""""""""""""""""""""""""""""""""""""""""""""""""""
set ambiwidth=double
set number
set ruler
set cursorline
set cursorcolumn
set colorcolumn=78
set statusline=%m%r%h%w%F\ (%Y\(%{&fileencoding}.%{&ff}(%04l,%04v/%04L
set laststatus=2
set display=lastline
" set virtualedit=onemore
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,],~
highlight CursorColumn ctermbg=black
highlight ColorColumn ctermbg=blue

""""""""""""""""""""""""""""""""""""""""""""""""""
" Search settings.
""""""""""""""""""""""""""""""""""""""""""""""""""
set incsearch
set ignorecase
set smartcase
set wrapscan
set hlsearch
set showmatch matchtime=1

""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin.
""""""""""""""""""""""""""""""""""""""""""""""""""
let s:dein_path = expand('~/.vim/dein')
let s:dein_repo_path = s:dein_path . '/repos/github.com/Shougo/dein.vim'
"dein Scripts-----------------------------
if &compatible
  set nocompatible
endif

if !isdirectory(s:dein_repo_path)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_path
endif

" Required:
execute 'set runtimepath^=' . fnamemodify(s:dein_repo_path, ':p')

if dein#load_state(s:dein_path)
  " Required:
  call dein#begin(s:dein_path)
  " Required:
  call dein#add(s:dein_repo_path)
  
  " Add or remove your plugins here like this:
  call dein#add('Shougo/neosnippet')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('Shougo/neocomplete.vim')
  call dein#add('scrooloose/nerdtree')
  
  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
"End dein Scripts-------------------------

""""""""""""""""""""""""""""""""""""""""""""""""""
"https://github.com/Shougo/neocomplete.vim
""""""""""""""""""""""""""""""""""""""""""""""""""
"Note: This option must be set in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'


""""""""""""""""""""""""""""""""""""""""""""""""""
" https://github.com/Shougo/neosnippet.vim
""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif


""""""""""""""""""""""""""""""""""""""""""""""""""
" https://github.com/scrooloose/nerdtree
""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd vimenter * NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
