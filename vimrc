" These are my custom vim settings, to load
" save it as a .vimrc in your home folder.
" and also make a link to dot-vim from the dropbox as ~/.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The whole world may not be wrong, so --
" Actually I am not quite sure, why do we need this.
set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vundle settings
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" vim airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" nerdtree fro scrooloose
Plugin 'scrooloose/nerdtree'

" csv plugin from https://github.com/chrisbra/csv.vim#using-a-plugin-manager
" Plugin 'chrisbra/csv.vim'

" Nord colorscheme for vim
" https://github.com/arcticicestudio/nord-vim
Plugin 'arcticicestudio/nord-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
" filetype plugin indent on    " required, but I am doing it later
" To ignore plugin indent changes, instead use:
" filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autoload ~/.vimrc
augroup dot_vimrc
	au!
	au BufWritePost $HOME/.vimrc so $HOME/.vimrc | if has('gui_running') | so $HOME/.vimrc | endif
	" au BufWritePost ~/.vimrc so ~/.vimrc
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Get some env variables, might be useful in future
let username = $USER

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" To get rid of the trailing @ and ~ sign
set display+=lastline

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" this will first enable and no-wrapping which is my default, and then
" it can be toggled using F2 key.
set wrap! go+=b
nnoremap <silent><expr> <f2> ':set wrap! go'.'-+'[&wrap]."=b\r"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('gui_running')
    if hostname() == "khaled-general"
        colorscheme zenburn
    else
        colorscheme nord
    endif
else
	" colorscheme solarized
	" colorscheme digerati
	" colorscheme mustang
	" colorscheme liquidcarbon
	" colorscheme xoria256
	" colorscheme void
	" colorscheme parsec
	" colorscheme oxeded
	" colorscheme feral
	" colorscheme railcasts
	" colorscheme base16-atelierheath
	" colorscheme abbott
	" colorscheme wombat
	" colorscheme sandydune
	colorscheme heroku
	" colorscheme Revolution
	" colorscheme lumberjack
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setting the highlight during string search
set hls

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setting a convenient window size
if has("gui_running")
	" GUI is running or is about to start.
	" Maximize gvim window.
    if hostname() == "penguin"
        set lines=25 columns=110
    else
	    set lines=25 columns=110
    endif
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight the trailing whitespaces
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Remove trailing spaces
function TrimWhiteSpace()
    %s/\s*$//
    ''
endfunction

" set list listchars=trail:.,extends:>
" autocmd FileWritePre * call TrimWhiteSpace()
" autocmd FileAppendPre * call TrimWhiteSpace()
" autocmd FilterWritePre * call TrimWhiteSpace()
" autocmd BufWritePre * call TrimWhiteSpace()

map <C-W> :call TrimWhiteSpace()<CR>
map! <C-W> :call TrimWhiteSpace()<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" On windoze system, backspace doesn't work for some reason
if has("gui_win32")
    set backspace=indent,eol,start
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggle line numbering by pressing Ctrl-L twice.
:nmap <C-L><C-L> :set invnumber<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" To use the system clipboard for cut-copy-paste
" The below script is taken from here --
" http://raghavan.info/blog/2013/02/10/
" 	bind-ctrl-v-to-copy-paste-in-vim-without-affecting-blockwise-selection/
" CTRL-X CTRL-X and SHIFT-DEL are CUT
vnoremap <C-X><C-X> "+x
vnoremap <S-Del> "+x
" CTRL-C CTRL-C nd CTRL-INSERT are COPY
vnoremap <C-C><C-C> "+y
vnoremap <C-Insert> "+y
" CTRL-V CTRL-V snd SHIFT-INSERT are PASTE
map <C-V><C-V> "+gP
map <S-Insert> "+gP
" Mapping for the command line mode
cmap <C-V><C-V> <C-R>+
cmap <S-Insert> <C-R>+
" Pasting blockwise and linewise selection is not possible in INSERT and
" VISUAL mode without the +virtualedit feature. They are posted as if they
" were characterwise instead. It uses the paste.vim autoload script.
exe 'inoremap <script> <C-V><C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V><C-V>' paste#paste_cmd['v']
" Mapping for the insert and visual modes
imap <S-Insert> <C-V><C-V>
vmap <S-Insert> <C-V><C-V>
" Use CTRL-Q to do what CTRL-P used to do
noremap <C-Q> <C-V><C-V>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Some vim-latex related settings
set grepprg=grep\ -nH\ $*
" :wlet g:tex_flavor='latex'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" I have installed a new font called 'luculent' (http://eastfarthing.com/luculent/)
" this is nice, so I am using it as default guifont --
if has('gui_running')
    if hostname() == "ktalukder-mbp2"
        set guifont=luculent:h13
    elseif hostname() == "N-20KEPC10M813"
        set guifont=luculent\ 12
    elseif hostname() == "atlas-slave-node"
        set guifont=luculent\ 15
    elseif hostname() == "kopashamsu.local"
        set guifont=luculent:h17
    elseif hostname() == "penguin"
        set guifont=Hack\ 13
    elseif hostname() == "khaled-general"
        set guifont=SourceCodePro\ 15
    elseif hostname() == "INTERN6118"
        set guifont=Consolas:h11:cANSI
    else
        if has("gui_win32")
            set guifont=Consolas:h12:cANSI
        else
            set guifont=luculent\ 12
        endif
    endif
    "   set guifont=Hack\ 10
    "   set guifont=Hermit\ 10
    "   set guifont=SourceCodePro\ 10
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Some vala syntax highlighting stuffs
" Disable valadoc syntax highlight
" let vala_ignore_valadoc = 1
" Enable comment strings
let vala_comment_strings = 1
" Highlight space errors
let vala_space_errors = 1
" Disable trailing space errors
"let vala_no_trail_space_error = 1
" Disable space-tab-space errors
let vala_no_tab_space_error = 1
" Minimum lines used for comment syncing (default 50)
"let vala_minlines = 120

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" turn on the default auto completion
" set omnifunc=syntaxcomplete#Complete

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" twiddle case, visually select and then start pressing '~'
function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction
vnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" making all indentations and shit into 4 spaces
au BufNewFile,BufRead,BufReadPost * set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
function! SetTab(width)
    let &l:tabstop=a:width
    let &l:softtabstop=a:width
    let &l:shiftwidth=a:width
endfunction
:command -nargs=1 Tab call SetTab(<f-args>) | set expandtab
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" for vim airline
set laststatus=2
if hostname() == "khaled-general"
        let g:airline_theme = 'zenburn'
    else
        let g:airline_theme = 'night_owl'
    endif
let g:airline_powerline_fonts	=	1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerd tree related settings
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turning on the filetype detection, filetype plugin and filetype indent
" see :filetype <CR> for more details
:filetype plugin indent on
:syntax on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax highlighting stuffs
" Octave syntax
augroup filetypedetect
	au! BufRead,BufNewFile *.m,*.oct set filetype=octave
	au! BufRead,BufNewFile *.als set filetype=alloy
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" some test by me
inoremap <F5> <C-R>=ListMonths()<CR>
func! ListMonths()
  call complete(col('.'), ['January', 'February', 'March',
	\ 'April', 'May', 'June', 'July', 'August', 'September',
	\ 'October', 'November', 'December'])
  return ''
endfunc

" Function to put spaces around arithmetic operators
nmap <silent> ;ss :call SetSpacesAroundArithOps()<CR>
function! SetSpacesAroundArithOps()
    :%s/\v(\w) ?(\+|-|\*|\/|\>\=|\<\=|!\=|\=|\=\=) ?(\w|-)/\1 \2 \3/g
    :%s/\v(\w)\+\+/\1 ++/g
endfunction
