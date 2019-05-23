" This is personal .vimrc of Danil Lykov http://lykov.tech
" Hope I will not become dependent on all these 
" plugins and be able to use raw vim :)
"
source ~/.vim/py.vim

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.fzf
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" BASIC
Plugin 'scrooloose/nerdtree'		"Dir explorer
Plugin 'easymotion/vim-easymotion'  "Fly on the vim
Plugin 'anschnapp/move-less'        " Move less folding
Plugin 'tpope/vim-fugitive'			"Git plugin
Plugin 'scrooloose/syntastic'
Plugin 'SirVer/ultisnips'			" Code snippets
Plugin 'kshenoy/vim-signature'

"" Needs compilation or additional soft
Plugin 'junegunn/fzf.vim'			"fuzzy search
"Plugin 'wincent/Command-T'
" Plugin 'valloric/youcompleteme'
Plugin 'christoomey/vim-tmux-navigator'

" Elm
Plugin 'ElmCast/elm-vim'

" Rust
Plugin 'rust-lang/rust.vim' 

" Python
Plugin 'vim-scripts/indentpython.vim'

" WEB
Plugin 'KabbAmine/vCoolor.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'kchmck/vim-coffee-script'
Plugin 'mattn/emmet-vim'

" BELLS
"Bundle 'pydave/AsyncCommand'
"Bundle 'mnick/vim-pomodoro'
Plugin 'itchyny/lightline.vim'

" Theme
Plugin 'tomasiser/vim-code-dark'
Plugin 'altercation/vim-colors-solarized'
Plugin 'nightsense/cosmic_latte'
" Plugin 'vim-scripts/colorsupport.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set cursorline
set cursorcolumn
hi ColorColumn guifg=NONE ctermfg=NONE guibg=#323232 ctermbg=236 gui=NONE cterm=NONE 

" Python settings
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab 
set softtabstop=4 
set autoindent

let python_highlight_all = 1
autocmd FileType coffee setlocal ts=2 sts=2 sw=2

syntax enable
let g:solarized_termcolors=256
let g:heman_termcolors=256
colorscheme default
colorscheme cosmic_latte
set background=dark

set guifont=Ubuntu\ Mono\ 14
set guifont=CMU\ Typewriter\ Text\ \Roman\ 15
set guifont=Hack\ Regular\ 11
let g:autoclose_on=0

set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

set noswapfile

" Line numbers
set nu
set relativenumber
" Highlight every occurence of searched thing
set hlsearch
"hi EasyMotionTarget ctermbg=none ctermfg=green
"hi EasyMotionShade ctermbg=none ctermfg=blue

" Use urxvt instead
let g:fzf_launcher = 'urxvt -geometry 120x30 -e sh -c %s'
" In Neovim, you can set up fzf window using a Vim command

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }
if executable('fzf')
  " FZF {{{
  " <C-p> or <C-t> to search files
  nnoremap <silent> <C-t> :FZF -m<cr>
  nnoremap <silent> <C-p> :FZF -m<cr>

  " <M-p> for open buffers
  nnoremap <silent> <M-p> :Buffers<cr>
  " for Lines
  nnoremap <silent> <c-f> :Lines<cr>
  " <M-S-p> for MRU
  nnoremap <silent> <M-S-p> :History<cr>

  " Use fuzzy completion relative filepaths across directory
  imap <expr> <c-x><c-f> fzf#vim#complete#path('git ls-files $(git rev-parse --show-toplevel)')

  " Better command history with q:
  command! CmdHist call fzf#vim#command_history({'top': '40'})
  nnoremap q: :CmdHist<CR>

  " Better search history
  command! QHist call fzf#vim#search_history({'top': '40'})
  nnoremap q/ :QHist<CR>

  command! -bang -nargs=* Ack call fzf#vim#ag(<q-args>, {'down': '40%', 'options': --no-color'})
  " }}}
else
  " CtrlP fallback
end

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10split' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'
" easymotion highlight colors
hi link EasyMotionTarget Search
hi link EasyMotionTarget2First Search
hi link EasyMotionTarget2Second Search
hi link EasyMotionShade Comment
set shiftwidth=4
set pumheight=8
set foldmethod=indent
set foldlevel=2

nmap ;w :w<CR>

" Snippets configuration. not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger="<c-q>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

let g:ycm_server_python_interpreter = '/usr/bin/python2'

let g:ycm_autoclose_preview_window_after_insertion = 1
" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)
let g:EasyMotion_smartcase = 1

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)
" Gif config
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to
" EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

nmap <C-g>s :Gstatus<CR>
nmap <C-g>w :Gwrite<CR>
nmap <C-g>c :Gcommit<CR>

"nmap <c-t> :CommandT<cr>
let g:Gstatus="<c-g>s"

map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

map K i<CR><Esc>
" Useful to quit insert mode
imap jj <Esc>
" fugitive git bindings
nnoremap <space>ga :Git add %:p<CR><CR>
nnoremap <space>gs :Gstatus<CR>
nnoremap <space>gc :Gcommit -v -q<CR>
nnoremap <space>gt :Gcommit -v -q %:p<CR>
nnoremap <space>gd :Gdiff<CR>
nnoremap <space>ge :Gedit<CR>
nnoremap <space>gr :Gread<CR>
nnoremap <space>gw :Gwrite<CR><CR>


" For setting paste modde 
set pastetoggle=<A-p>

" Do paste in the usual way
imap <c-v> <c-[>:set paste<cr>"+p:set nopaste<cr>i

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" Tab navigation
nnoremap tj gt
nnoremap tk gT
nnoremap tx :tabclose

"indentaion for python
set softtabstop=4
set tabstop=4
set autoindent
let python_highlight_all=1

" Always show statusline
set laststatus=2
