"""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Author: Colors Huang
" Email: windnameh@gmail.com
"
" ~/.vimrc
"
"""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible

"""""""""""""""""""""""""""""
"" vim-plug
"""""""""""""""""""""""""""""
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'ludovicchabant/vim-gutentags', { 'for': ['c', 'cpp'], 'on' : [] }
  Plug 'skywind3000/gutentags_plus', { 'for': ['c', 'cpp'], 'on' : [] }

" theme
Plug 'nanotech/jellybeans.vim'
Plug 'jacoborus/tender.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'sickill/vim-monokai'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(EasyAlign)' }
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" YCM
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py
  endif
endfunction

Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM'), 'on': [] }
let g:YouCompleteMeLazyLoaded = 0
function! LazyLoadingYMC()
  if g:YouCompleteMeLazyLoaded == 0
    let g:YouCompleteMeLazyLoaded = 1
    call plug#load('YouCompleteMe') | call youcompleteme#Enable()
  endif
endfunction
autocmd BufWinEnter * call timer_start(1, {id->execute('call LazyLoadingYMC()')} )

" Initialize plugin system
call plug#end()


"""""""""""""""""""""""""""""
"" misc
"""""""""""""""""""""""""""""
set noic	"noic: case sensitive ic: case insensitive
set ruler
set number
set hlsearch
set history=1000

" Toggle line numbers and fold column for easy copying:
nnoremap <F2>n :set nonumber!<CR>:set foldcolumn=0<CR>


"""""""""""""""""""""""""""""
"" true color
"""""""""""""""""""""""""""""
" Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
" If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
" (see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    " For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  " For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  " Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif


""""""""""""""""""""""""""""""
"" shortcuts
""""""""""""""""""""""""""""""
" goto next buffer
map <C-Down> :bn<CR>
" goto previous buffer
map <C-Up> :bp<CR>


""""""""""""""""""""""""""""""
"" guifont
""""""""""""""""""""""""""""""
if has('gui_running')
	set guifont=Consolas\ 14
endif


""""""""""""""""""""""""""""""
"" back to last modified
""""""""""""""""""""""""""""""
" make vim save and load the folding of the document each time it loads
" also places the cursor in the last place that it was left.
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

""""""""""""""""""""""""""""""
"" file format
""""""""""""""""""""""""""""""
filetype on
filetype plugin on
filetype indent on


""""""""""""""""""""""""""""""
"" ignored file
""""""""""""""""""""""""""""""
set wildignore=*.o

""""""""""""""""""""""""""""""
"" default indent
""""""""""""""""""""""""""""""
set smartindent
set noexpandtab
set tabstop=4
set shiftwidth=4
set wrap
set textwidth=80
set colorcolumn=80


""""""""""""""""""""""""""""""
"" foldmethod
""""""""""""""""""""""""""""""
"set foldmethod=syntax
"set foldnestmax=3


""""""""""""""""""""""""""""""
"" terminal settings
""""""""""""""""""""""""""""""
" 256 colors at terminal
set t_Co=256
" remove background color
set t_ut=


""""""""""""""""""""""""""""""
"" 80 Column highlight
""""""""""""""""""""""""""""""
nnoremap <Leader>H :call<SID>LongLineHLToggle()<cr>
hi OverLength cterm=none ctermbg=none
match OverLength /\%>80v/
function! s:LongLineHLToggle()
	if !exists('w:longlinehl')
		let w:longlinehl = matchadd('ErrorMsg', '.\%>81v', 0)
		echo "Long lines highlighted"
	else
		call matchdelete(w:longlinehl)
		unl w:longlinehl
		echo "Long lines unhighlighted"
	endif
endfunction

""""""""""""""""""""""""""""""
"" colorscheme settting
"" with Line highlight
""""""""""""""""""""""""""""""
"" molokai, solarized-dark, solarized-light
function! SetColorScheme(vim_theme)
	if !exists('a:vim_theme') || a:vim_theme == "jellybeans"
		let g:jellybeans_background_color_256 = 233
		colorscheme jellybeans
		set cursorline
		highlight CursorLine cterm=none ctermbg=234 guibg=#1c1c1c
        let g:airline_theme='jellybeans'
		let g:lightline = { 'colorscheme': 'jellybeans' }
	elseif a:vim_theme == "tender"
		colorscheme tender
		set cursorline
		highlight CursorLine cterm=none ctermbg=234 guibg=#1c1c1c
		let g:airline_theme = 'tender'
		let g:lightline = { 'colorscheme': 'tender' }
	elseif a:vim_theme == "molokai"
		let g:molokai_original = 1
		let g:rehash256 = 1
		colorscheme molokai
		set cursorline
		highlight CursorLine cterm=none ctermbg=233 guibg=#1c1c1c
	elseif a:vim_theme == "solarized-dark"
		set background=dark
		if !has('gui_running')
			let g:solarized_termcolors=256
		endif
		colorscheme solarized
		set cursorline
		highlight CursorLine cterm=none ctermbg=235 guibg=#262626
	elseif a:vim_theme == "solarized-light"
		set background=light
		if !has('gui_running')
			let g:solarized_termcolors=256
		endif
		colorscheme solarized
		set cursorline
		highlight CursorLine cterm=none ctermbg=235 guibg=#262626
	endif
endfunction

if !has('gui_running')
	"call SetColorScheme("tender")
	call SetColorScheme("jellybeans")
else
	"call SetColorScheme("tender")
	call SetColorScheme("jellybeans")
endif

"autocmd FileType python call SetColorScheme("solarized-dark")
"autocmd FileType sh call SetColorScheme("solarized-dark")


""""""""""""""""""""""""""""""
"" disable toolbar at gui mode
""""""""""""""""""""""""""""""
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove Taglist scroll bar


""""""""""""""""""""""""""""""
"" cflow
""""""""""""""""""""""""""""""
autocmd BufNewFile,BufRead *.cflow setf cflow


""""""""""""""""""""""""""""""
"" gutentags
""""""""""""""""""""""""""""""
" enable gtags module
let g:gutentags_modules = ['ctags', 'gtags_cscope']

" config project root markers.
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project']

" generate datebases in my cache directory, prevent gtags files polluting my project
let g:gutentags_cache_dir = expand('~/.cache/tags')

" change focus to quickfix window after search (optional).
let g:gutentags_plus_switch = 1


""""""""""""""""""""""""""""""
"" airline
""""""""""""""""""""""""""""""
let g:airline#extensions#syntastic#enabled = 0
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#show_buffers = 0


""""""""""""""""""""""""""""""
"" YouCompleteMe
""""""""""""""""""""""""""""""
let g:ycm_confirm_extra_conf = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

" disable preview window
set completeopt-=preview
let g:ycm_add_preview_to_completeopt = 0


""""""""""""""""""""""""""""""
"" Tagbar
""""""""""""""""""""""""""""""
nmap <F12> :TagbarToggle<CR>
let g:tagbar_left = 1
let g:tagbar_sort = 0


""""""""""""""""""""""""""""""
"" vim-easy-align
""""""""""""""""""""""""""""""
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

""""""""""""""""""""""""""""""
"" NERDTree
""""""""""""""""""""""""""""""
nmap <leader>t :NERDTreeToggle<CR>
" Set the window width
let NERDTreeWinSize = 40
" Set the window position
let NERDTreeWinPos = "right"
" Auto centre
let NERDTreeAutoCenter = 0
" Not Highlight the cursor line
let NERDTreeHighlightCursorline = 0


""""""""""""""""""""""""""""""
"" gundo tree
""""""""""""""""""""""""""""""
let g:gundo_width = 60
let g:gundo_preview_height = 40
let g:gundo_right = 1
nnoremap <F5> :GundoToggle<CR>


""""""""""""""""""""""""""""""
"" clang-format
""""""""""""""""""""""""""""""
function! SetVimClangFormat()
	map <C-K> :pyf ~/.vim/clang-format.py<CR>
	imap <C-K> <ESC>:pyf ~/.vim/clang-format.py<CR>i
endfunction
autocmd FileType,BufNewFile,BufRead c,cpp,h,hh,hpp call SetVimClangFormat()


""""""""""""""""""""""""""""""
"" python yapf
""""""""""""""""""""""""""""""
autocmd FileType python nnoremap <LocalLeader>= :0,$!yapf<CR>


""""""""""""""""""""""""""""""
"" makrdown
""""""""""""""""""""""""""""""
let g:vim_markdown_folding_disabled = 1
