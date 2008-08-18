" ~/.vimrc

" This is Vim, not vi
set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn on automatic file type detection with indentation and plugins.
filetype on
filetype indent on
filetype plugin on

" Turn on syntax highlighting.
syntax on

" Show line numbers on the left.
set number

" Show current mode (INSERT, REPLACE, or VISUAL) on last line.
set showmode

" Show the command in the status line.
set showcmd

" Show line and column number of cursor at the bottom.
set ruler

" Don't wrap lines longer than the given window width. I hate that!
set nowrap

" Use a lighter background. Better for the eyes?
set background=light

" Use incremental search.
set incsearch

" Highlight the search patterns in the text.
set hlsearch

" Don't insert two spaces after '.', '!', or '?'.
set nojoinspaces

" Default tabstop in number of characters.
set tabstop=8

" Default shiftwidth in number of characters.
set shiftwidth=2

" Allow backspacing over autoindent, line breaks, and start of insert.
set backspace=2

" Don't beep at me!
set visualbell

" I don't like tabs, so put spaces in their place.
set expandtab

" Wrap lines at 80 characters in insert mode.
set textwidth=80

if has("win32")
  " Set the font for GUI in Windows.
  if has("gui_running")
    set guifont=Lucida_Console:h9:
  endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Macros
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

source $VIMRUNTIME/macros/matchit.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocommands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"autocmd BufReadPost * if exists("b:current_syntax")
"autocmd BufReadPost *   if b:current_syntax == "verilog"
"autocmd BufReadPost *   endif
"autocmd BufReadPost *   if b:current_syntax == "c"
"autocmd BufReadPost *      set cindent
"autocmd BufReadPost *   endif
"autocmd BufReadPost *   if b:current_syntax == "cpp"
"autocmd BufReadPost *      set cindent
"autocmd BufReadPost *   endif
"autocmd BufReadPost *   if b:current_syntax == "java"
"autocmd BufReadPost *      set cindent
"autocmd BufReadPost *   endif
"autocmd BufReadPost * endif

augroup filetypedetect

" Jak
au BufNewFile,BufRead *.jak             setf java

" VPP and SystemVerilog
au BufNewFile,BufRead *.vpp,*.sv,*.svpp setf verilog

" JFlex
au BufNewFile,BufRead *.flex,*.jflex    setf jflex

" YACC
au BufNewFile,BufRead *.yacc            setf yacc

" Generic Haskell
au BufNewFile,BufRead *.ghs             setf haskell

augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Format the current paragraph (based on formatoptions) and leave the cursor
" where it is. I forget where the use of CTRL-J came from, but it's stuck in my
" head, so why not live with it?
map <C-J> gwap

" Same as gwap, except only do the lines from the cursor position to the end of
" the paragraph.
map <C-K> gw}

