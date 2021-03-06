if filereadable("/etc/vim/vimrc")
	. "/etc/vim/vimrc"
endif

" ----------------------------------------------------------------------------
"  Text Formatting
" ----------------------------------------------------------------------------

inoremap # X<BS>#
set autoindent             " automatic indent new lines
set formatoptions+=tnblq
set noexpandtab
set nofoldenable
set shiftwidth=4           " ..
set smartindent            " be smart about it
set tabstop=4
set textwidth=80           " wrap at 80 chars by default
set virtualedit=block      " allow virtual edit in visual block ..

" ----------------------------------------------------------------------------
"  Remapping
" ----------------------------------------------------------------------------

" reflow paragraph with Q in normal and visual mode
nnoremap Q gqap
vnoremap Q gq

nmap <leader>t :TlistToggle<CR>

command! Q  quit
command! W  write
command! Wq wq

let Tlist_Process_File_Always = 1

" ----------------------------------------------------------------------------
"  UI
" ----------------------------------------------------------------------------

colorscheme zenburn

filetype plugin indent on

let g:zenburn_high_Contrast=1
let g:zenburn_high_Contrast=1
"let g:zenburn_italic_Comment=1
let g:vimclojure#FuzzyIndent=1
let g:vimclojure#ParenRainbow=1

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

set background=dark
set backspace=2            " allow backspacing over everything in insert mode
set nolazyredraw           " turn off lazy redraw
set noshowcmd              " don't display incomplete commands
set nostartofline          " don't jump to the start of line when scrolling
set previewheight=17
set report=0               " tell us about changes
set ruler                  " show the cursor position all the time
set scrolloff=2
set shortmess=filtIoOA     " shorten messages
set splitbelow                  " Split horizontal windows below to the current windows
set splitright                  " Split vertical windows right to the current windows
set statusline=%f\ %{fugitive#statusline()}%=%40(%{Tlist_Get_Tagname_By_Line()}%)\ %h%m%r%=%-10.(%l,%c%V%)\ %P
set wildignore+=*.dll,*.o,*.pyc,*.bak,*.exe,*.jpg,*.jpeg,*.png,*.gif,*$py.class,*.class,*/*.dSYM/*,*.dylib,*.so,*.swp,*.zip,*.tgz,*.gz
set wildmenu               " turn on wild menu
set wildmode=list:longest,full

syntax on

" ----------------------------------------------------------------------------
" Visual Cues
" ----------------------------------------------------------------------------

set showmatch              " brackets/braces that is
set mat=5                  " duration to show matching brace (1/10 sec)
set incsearch              " do incremental searching
set laststatus=2           " always show the status line
set ignorecase             " ignore case when searching
set smartcase              " except when you really mean it
set nohlsearch             " don't highlight searches
set hidden
set nobk


" ---------------------------------------------------------------------------
"  Strip all trailing whitespace in file
" ---------------------------------------------------------------------------

function! StripWhitespace ()
    exec ':%s/ \+$//gc'
endfunction
map ,s :call StripWhitespace ()<CR>

" site specific
if filereadable(expand("~/.vim/local/" . hostname() . ".vim"))
	exec "source " . expand("~/.vim/local/" . hostname() . ".vim")
endif

