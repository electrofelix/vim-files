" setup vim
" see for the original that contained many of these settings
" http://www.pixelbeat.org/settings/.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

"finish


" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

if has('win32') || has('win64')
    exec 'set runtimepath=$HOME/.vim,' . escape(&runtimepath, ' ')
endif


" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
  set backupdir=~/.vim/backups
endif
set history=1000	" keep 1000 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching


" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Set terminal title to filename
"set titlestring = \"%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}"
"set title
"let &titleold = getcwd()
" Title can break some terminal windows, so disable by default unless you
" don't mid the mangling effect it has on the window title.
set notitle

" This is necessary to allow pasting from outside vim. It turns off auto stuff.
" You can tell you are in paste mode when the ruler is not visible
set pastetoggle=<F2>

" generally don't care about case when searching most text
set ignorecase

" Show menu with possible tab completions
set wildmenu

" Ignore these files when completing names and in Explorer
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

" for pathogen plugins
if has("autocmd")
    call pathogen#infect()
    silent! call pathogen\#helptags()
    silent! call pathogen\#runtime_append_all_bundles()
    
    " for vim-flake8
    let g:flake8_max_line_length = 99
endif

" Some general configuration
scriptencoding utf-8
set shortmess+=filmnrxoOtT
set viewoptions=folds,options,cursor,unix,slash
set spell " enable spell checking
helptags ~/.vim/doc

set shellslash
let g:tex_flavor='latex'

call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'JamshedVesuna/vim-markdown-preview'

Plugin 'fatih/vim-go'

Plugin 'mzlogin/vim-markdown-toc'

Plugin 'vim-ruby/vim-ruby'

" Provided by xenial
"Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required

let vim_markdown_preview_github=1 " use grip for github flavour markdown
let vim_markdown_preview_browser='Mozilla Firefox' " bugfix for window name searching
let vim_markdown_preview_toggle=1 " display on Ctrl+P with images
let vim_markdown_preview_use_xdg_open=1

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
	au!

	" For all text files set 'textwidth' to 78 characters.
	autocmd FileType text setlocal textwidth=78

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	autocmd BufReadPost *
	    \ if line("'\"") > 0 && line("'\"") <= line("$") |
	    \   exe "normal g`\"" |
	    \ endif

    augroup END

else

    set autoindent		" always set autoindenting on

endif " has("autocmd")

" enable minibufexplorer
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplForceSyntaxEnable = 1
map <F4> :TlistToggle<CR>
map <F5> :MiniBufExplorer<CR>

""""""""""""""""""""""""""""""""""""""""""""""""
" Indenting
""""""""""""""""""""""""""""""""""""""""""""""""
"
" Default to autoindenting of C like languages
" This is overridden per filetype below
set noautoindent smartindent

set smarttab
set tabstop=8
set softtabstop=4
set nojoinspaces
set shiftwidth=4
set shiftround


""""""""""""""""""""""""""""""""""""""""""""""""
" Dark background
""""""""""""""""""""""""""""""""""""""""""""""""
"
 
" set personal preferences
set background=dark
colorscheme elflord

" set highlight plugin colors
let g:lcolor_bg = "magenta,green,magenta,lightred,lightgreen,lightblue,darkmagenta,darkmagenta"
let g:pcolor_bg = "yellow,blue,green,magenta,cyan,brown,yellow,red"

""""""""""""""""""""""""""""""""""""""""""""""""
" Key bindings
""""""""""""""""""""""""""""""""""""""""""""""""
" Note <leader> is the user modifier key (like g is the vim modifier key)
" One can change it from the default of \ using: let mapleader = ","

" \n to turn off search highlighting
nmap <silent> <leader>n :silent :nohlsearch<CR>
" \l to toggle visible whitespace
nmap <silent> <leader>l :set list!<CR>
" Shift-tab to insert a hard tab
imap <silent> <S-tab> <C-v><tab>

" <home> toggles between start of line and start of text
imap <khome> <home>
nmap <khome> <home>
inoremap <silent> <home> <C-O>:call Home()<CR>
nnoremap <silent> <home> :call Home()<CR>
function! Home()
    let curcol = wincol()
    normal ^
    let newcol = wincol()
    if newcol == curcol
    normal 0
    endif
endfunction

" <end> goes to end of screen before end of line
imap <kend> <end>
nmap <kend> <end>
inoremap <silent> <end> <C-O>:call End()<CR>
nnoremap <silent> <end> :call End()<CR>
function! End()
    let curcol = wincol()
    normal g$
    let newcol = wincol()
    if newcol == curcol
        normal $
    endif
    " The following is to work around issue for insert mode only.
    " normal g$ doesn't go to pos after last char when appropriate.
    " More details and patch here:
    " http://www.pixelbeat.org/patches/vim-7.0023-eol.diff
    if virtcol(".") == virtcol("$") - 1
        normal $
    endif
endfunction

" Ctrl-{up,down} to scroll.
" The following only works in gvim?
" Also vim doesn't have default C-{home,end} bindings?
if has("gui_running")
    nmap <C-up> <C-y>
    imap <C-up> <C-o><C-y>
    nmap <C-down> <C-e>
    imap <C-down> <C-o><C-e>
endif

""""""""""""""""""""""""""""""""""""""""""""""""
" file type handling
""""""""""""""""""""""""""""""""""""""""""""""""

if has("autocmd")
    " override defaults for subsets of filetypes
    au BufRead,BufNewFile *.json set shiftwidth=2 softtabstop=4 tabstop=8 expandtab
    au BufRead,BufNewFile *.sh set shiftwidth=4 softtabstop=4 tabstop=8 expandtab
    au BufRead,BufNewFile *.bash set shiftwidth=4 softtabstop=4 tabstop=8 expandtab

    " then add custom settings
    augroup tcl
	au!
	au FileType tcl set shiftwidth=2 softtabstop=4 tabstop=8 expandtab
    augroup END

    augroup Ruby
        au!
	au FileType ruby set shiftwidth=2 softtabstop=4 tabstop=8 expandtab
        au FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
        au FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
        au FileType ruby,eruby let g:rubycomplete_rails = 1
        " <C-x><C-o> to autocomplete
        au FileType ruby,eruby set omnifunc=rubycomplete#Complete
        " Don't show docs in preview window
        au FileType ruby,eruby set completeopt-=preview
    augroup END

    augroup Python
	" See $VIMRUNTIME/ftplugin/python.vim
	au!
	" smart indent really only for C like languages
	" See $VIMRUNTIME/indent/python.vim
	au FileType python set nosmartindent autoindent
	au FileType python set expandtab
	" Allow gf command to open files in $PYTHONPATH
	au FileType python let &path = &path . "," . substitute($PYTHONPATH, ';', ',', 'g')
	if v:version >= 700
	    " See $VIMRUNTIME/autoload/pythoncomplete.vim
	    " <C-x><C-o> to autocomplete
	    au FileType python set omnifunc=pythoncomplete#Complete
	    " Don't show docs in preview window
	    au FileType python set completeopt-=preview
	endif
    augroup END

    au BufWritePre * let &bex = '-' . strftime("%Y%m%d-%H%M%S") . '.vimbackup'

    autocmd ColorScheme,BufWinEnter * highlight ExtraWhitespace ctermbg=red guibg=red
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$\|\t\+/
    autocmd InsertLeave,BufRead,BufNewFile * match ExtraWhitespace /\s\+$\|\t\+/
    autocmd BufWinLeave * call clearmatches()
    highlight ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+$\|\t\+/
endif
