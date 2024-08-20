"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""               
"               
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║     
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"               
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""               


set termguicolors

" Set color scheme
colorscheme catppuccin_mocha

" Set tab width when Tab key is pressed.
set tabstop=4
set shiftwidth=4
" Use spaces for Tab.
set expandtab
" Enable relative line numbers on left-hand side.
set number
set relativenumber
" Highlight cursor line underneath the cursor horizontally.
set cursorline
" Do not save backup files.
set nobackup
" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=8
" Incrementally highlight match during search.
set incsearch
" Use highlighting when doing a search.
set hlsearch
" Show matching words during a search.
set showmatch
" Set the commands to save in history. Default number is 20.
set history=20
" Enable auto completion menu after pressing TAB.
set wildmenu
" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest
" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Syntax highlighting.
syntax on
" Enable file type detection.
filetype on
" Enable plugins and load plugin for detected file type.
filetype plugin on
" Load an indent file for the detected file type.
filetype indent on


" PLUGINS ---------------------------------------------------------------- {{{
"
" How to add plugins. Run the command below in the terminal
" For Linux/Mac :
" curl -fLo ~/dotfiles/vim/.vim/autoload/plug.vim --create-dirs \
"   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" For Powershell :
" iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
"    ni $HOME/vimfiles/autoload/plug.vim -Force
"
" Next, open vim and type ':PlugInstall' to download and install plugins
"
" Plugin code goes here.

call plug#begin('~/.vim/plugged')

" To install a plugin use:
" Plug '<username>/<plugin-name>'

" ALE (Asynchronous Lint Engine): syntax checking, semantic errors, LSP
Plug 'dense-analysis/ale'

" NERDTree for file system explora
Plug 'preservim/nerdtree'

"Catppuccin theme
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

call plug#end()

" }}}


" MAPPINGS --------------------------------------------------------------- {{{

" Mappings code goes here.

" Remap leader key from default '\' to '<space>'
let mapleader = " "

" Clear highlights from search
nnoremap <leader>h :nohlsearch<CR>

" Center the cursor vertically when moving to next word during a search
nnoremap n nzz
nnoremap N Nzz

" Navigate split windows in Vim using hjkl
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
noremap <C-up> <C-w>+
noremap <C-down> <C-w>-
noremap <C-left> <C-w>>
noremap <C-right> <C-w><

" NERDTree specific mappings.
" Map the <leader>n key to toggle NERDTree open and close.
" nnoremap <F3> :NERDTreeToggle<CR>
nnoremap <C-n> :NERDTreeToggle<CR>

" Navigate buffers back and for with <laader>p/n
" And remove buffer using <leader>x
nnoremap <leader>n :bn<CR>
nnoremap <leader>p :bp<CR>
nnoremap <leader>x :bd<CR>

" Have nerdtree ignore certain files and directories.
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']

" }}}


" VIMSCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
" Enable the marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" More Vimscripts code goes here.

" If the current file type is HTML, set indentation to 2 spaces.
autocmd Filetype html setlocal tabstop=2 shiftwidth=2 expandtab

" If Vim version is equal to or greater than 7.3 enable undofile.
" This allows you to undo changes to a file even after saving it.
" if version >= 703
"     set undodir=~/.vim/backup
"     set undofile
"     set undoreload=10000
" endif

" If GUI version of Vim is running set these options.
if has('gui_running')

    " Set the background tone.
    set background=dark

    " Set the color scheme.
    colorscheme molokai

    " Set a custom font you have installed on your computer.
    " Syntax: set guifont=<font_name>\ <font_weight>\ <size>
    set guifont=Monospace\ Regular\ 12

    " Display more of the file by default.
    " Hide the toolbar.
    set guioptions-=T

    " Hide the the left-side scroll bar.
    set guioptions-=L

    " Hide the the right-side scroll bar.
    set guioptions-=r

    " Hide the the menu bar.
    set guioptions-=m

    " Hide the the bottom scroll bar.
    set guioptions-=b

    " Map the F4 key to toggle the menu, toolbar, and scroll bar.
    " <Bar> is the pipe character.
    " <CR> is the enter key.
    nnoremap <F4> :if &guioptions=~#'mTr'<Bar>
        \set guioptions-=mTr<Bar>
        \else<Bar>
        \set guioptions+=mTr<Bar>
        \endif<CR>

endif

" }}}


" STATUS LINE ------------------------------------------------------------ {{{

" Status bar code goes here.

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R\ %n

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\ row:\ %l\ col:\ %c\ percent:\ %p%%

" Show the status on the second to last line.
set laststatus=2

" }}}
