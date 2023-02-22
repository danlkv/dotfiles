
set nocompatible              " be iMproved, required
filetype off                  " required

"set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/

call plug#begin('~/.vim/plugged')

" BASIC
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

"Plug 'MunifTanjim/nui.nvim', {'branch':'main'}
"Plug 'VonHeikemen/fine-cmdline.nvim', {'branch':'main'}
Plug 'sheerun/vim-polyglot'

Plug 'easymotion/vim-easymotion'  "Fly on the vim
"Plug 'anschnapp/move-less'        " Move less folding
Plug 'tpope/vim-fugitive'			"Git plugin
Plug 'vim-python/python-syntax'	"Python syntax
"Plug 'SirVer/ultisnips'			" Code snippets
Plug 'kshenoy/vim-signature'    " visual marks
"Plug 'zxqfl/tabnine-vim'          "autocompletion
Plug 'neoclide/coc.nvim', {'branch':'release'}          "autocompletion
Plug 'puremourning/vimspector'

Plug 'christoomey/vim-tmux-navigator'
Plug 'nvie/vim-flake8'            "Python linting
Plug 'vim-test/vim-test'

"" Needs compilation or additional soft
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'danlkv/spaceduck', { 'branch': 'main' }
Plug 'vim-airline/vim-airline'
" Plug 'soywod/kronos.vim'          " time manager

Plug 'JuliaEditorSupport/julia-vim'
"Plug 'wincent/Command-T'
" Plug 'valloric/youcompleteme'
" Plug 'christoomey/vim-tmux-navigator'
Plug 'github/copilot.vim', { 'branch': 'main' }

" Elm
" Plug 'ElmCast/elm-vim'

" Rust
Plug 'rust-lang/rust.vim' 


" Python
Plug 'vim-scripts/indentpython.vim'
"Plug 'williamjameshandley/vimteractive'
"Plug 'jupyter-vim/jupyter-vim'
"Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

" WEB
"Plug 'KabbAmine/vCoolor.vim'      "color selector
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'kchmck/vim-coffee-script'
"Plug 'mattn/emmet-vim'
Plug 'posva/vim-vue'


" BELLS
" Plug 'itchyny/lightline.vim'

" Theme
Plug 'tomasiser/vim-code-dark'
Plug 'altercation/vim-colors-solarized'
Plug 'nightsense/cosmic_latte'
Plug 'Sammyalhashe/random_colorscheme.vim'
"Plug 'chriskempson/base16-vim'

" Plug 'vim-scripts/colorsupport.vim'

" All of your Plugs must be added before the following line
call plug#end()

filetype plugin indent on    " required

set cursorline
set cursorcolumn
set number 
set relativenumber
set cmdheight=0
"hi ColorColumn guifg=NONE ctermfg=NONE guibg=#323232 ctermbg=236 gui=NONE cterm=NONE 

" Python settings
"autocmd BufWritePost *.py call flake8#Flake8()
"autocmd BufEnter * :SemanticHighlight

nnoremap Q :
tnoremap <c-[> <C-\><C-n>
inoremap <c-b> <c-[>

set tabstop=4
set shiftwidth=4
set smarttab
set expandtab 
set softtabstop=4 
set autoindent

" coc
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

nmap <c-c>s :call SynGroup()<CR>

hi LspReferenceWrite guibg=lightblue
hi LspReferenceRead guibg=lighgreen
" vim function to highlight references to current symbol
function! HighlightReferences()
    try | 
        lua vim.lsp.buf.clear_references()
        lua vim.lsp.buf.document_highlight()
        | catch | endtry
endfunction
"autocmd CursorHold * silent call HighlightReferences()
nnoremap <silent> <c-c>h :silent! call HighlightReferences()<cr>

"autocmd! CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()

inoremap <C-s> <c-[>:w<cr>

let python_highlight_all = 1
autocmd FileType coffee setlocal ts=2 sts=2 sw=2
autocmd FileType yaml setlocal ts=2 sts=2 sw=2

syntax enable
let g:solarized_termcolors=256
let g:heman_termcolors=256
set termguicolors
"colorscheme default
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

colorscheme surface_light
"colorscheme pinky
"colorscheme surface_light
let g:airline_theme = 'surface_dark'
let g:airline_extensions = []

if !empty($THEME_ADAPTIVE)
    if $THEME_ADAPTIVE == 'dark'
        colorscheme surface_dark
        let g:airline_theme = 'surface_dark'
    elseif $THEME_ADAPTIVE == 'light'
        colorscheme surface_light
        let g:airline_theme = 'light_carrot'
    endif
endif

set background=dark

set guifont=Ubuntu\ Mono\ 14
set guifont=CMU\ Typewriter\ Text\ \Roman\ 15
set guifont=Hack\ Regular\ 11
let g:autoclose_on=1

set guioptions-=T  "remove toolbar
set guioptions-=m  "remove menu bar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

set noswapfile

" Debugger setup
"
let g:vimspector_enable_mappings = 'HUMAN'

" Line numbers
" set nu
" set relativenumber

" Highlight every occurence of searched thing
set hlsearch
"hi EasyMotionTarget ctermbg=none ctermfg=green
"hi EasyMotionShade ctermbg=none ctermfg=blue
"
"let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'
" If you want gitignored files:
"let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs --hidden'

let g:fzf_action = {
  \ 'ctrl-r': 'up',
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~30%' }
    nnoremap <c-e> <cmd>Telescope find_files<cr>
    " FZF {{{
    " <C-p> or <C-t> to search files
    nnoremap <silent> <C-t> :FZF -m<cr>

    " <M-p> for open buffers
    "nnoremap <silent> <c-l> :GFiles<cr>
    command! GitFiles call fzf#run(fzf#wrap({'source':'git ls-files', 'options':'--bind ctrl-s:up,ctrl-h:down'}))
    nnoremap <silent> <c-l> :GitFiles<cr>

    " <M-p> for open buffers
    nnoremap <silent> <c-g> :Telescope buffers<cr>
    " for Lines
    nnoremap <silent> <c-f> :Lines<cr>

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

" In Neovim, you can set up fzf window using a Vim command
" let g:fzf_layout = { 'window': 'enew' }
"let g:fzf_layout = { 'window': '-tabnew' }
"let g:fzf_layout = { 'window': '10split' }

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


let g:test#python#runner = 'pytest'
let g:test#strategy = 'neovim'
map <c-m>t :TestNearest<CR>
map <c-m>T :TestSuit<CR>
map <c-m>f :call flake8#Flake8()<c-r>
" Save on ctrl-S
nmap <c-s> :w<CR>

" Snippets configuration. not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger="<c-q>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

let g:ycm_server_python_interpreter = '/usr/bin/python'

let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_disable_for_files_larger_than_kb = 1

let maplocalleader = "\<space>"
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

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to
" EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )

nmap <C-g>s :Gstatus<CR>
nmap <C-g>w :Gwrite<CR>
nmap <C-g>c :Gcommit<CR>

"nmap <c-t> :CommandT<cr>
let g:Gstatus="<c-g>s"

map <C-n> :NvimTreeToggle<CR>
map <C-b> :NvimTreeFindFile<CR>

map K i<CR><Esc>
" Useful to quit insert mode
imap jj <Esc>
imap <C-d> <Esc>
" fugitive git bindings
nnoremap <space>ga :Git add %:p<CR><CR>
nnoremap <space>gs :Git<CR>
nnoremap <space>G :Git<CR>
nnoremap <space>gc :Git commit -v -q<CR>
nnoremap <space>gt :Git commit -v -q %:p<CR>
nnoremap <space>gp :Git push<CR>
nnoremap <space>gd :Gdiff<CR>
nnoremap <space>ge :Gedit<CR>
nnoremap <space>gr :Gread<CR>
nnoremap <space>gw :Gwrite<CR><CR>


" For setting paste modde 
set pastetoggle=<A-p>

" Do paste in the usual way
imap <c-v> <c-[>:set paste<cr>"+p:set nopaste<cr>
nnoremap <C-q> :q<CR>
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
