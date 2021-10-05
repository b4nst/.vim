" //////////////////////////////////////////////////////////////////
" Plugin install
" //////////////////////////////////////////////////////////////////

" Install vim-plug if it does not exist
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:plug_window = 'botright new'

if strftime("%d") == 3
  autocmd VimEnter * PlugUpgrade
  autocmd VimEnter * PlugUpdate --sync | source $MYVIMRC
endif

" Plugin install condition helper
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin('~/.vim/pack/vim-plug')

" LSP client, autocompletion
Plug 'dense-analysis/ale'
Plug 'lifepillar/vim-mucomplete'

" Moves
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

" Tools
Plug 'christoomey/vim-tmux-navigator', Cond(executable('tmux'))
Plug 'lambdalisue/fern-git-status.vim', Cond(executable('git'))
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'LumaKernel/fern-mapping-fzf.vim', Cond(executable('fzf'))
Plug 'tpope/vim-obsession'
" Snippets
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'

" Languages
Plug 'blankname/vim-fish'
Plug 'cespare/vim-toml'
Plug 'fatih/vim-go'
Plug 'hashivim/vim-terraform'
Plug 'jjo/vim-cue'
Plug 'nathanielc/vim-tickscript'
Plug 'towolf/vim-helm'

call plug#end()

" //////////////////////////////////////////////////////////////////
" General configuration
" //////////////////////////////////////////////////////////////////
" Syntax color on
syntax on
" Display statusbar
set laststatus=2
" Hybrid line numbers
set nu rnu
" Set indent as 2 space
set tabstop=4 softtabstop=0 expandtab shiftwidth=2 smarttab
" remove trailling whitespaces
autocmd BufWritePre * %s/\s\+$//e
" Required for operations modifying multiple buffers like rename.
set hidden
" Enable modeline
set modelines=1

" //////////////////////////////////////////////////////////////////
" Mapping
" //////////////////////////////////////////////////////////////////

" Pane navigation
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
" Fern
nmap <C-O> :Fern .<CR>
" paste toggle
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode
" SnipMate
imap <C-j> <Plug>snipMateNextOrTrigger
smap <C-j> <Plug>snipMateNextOrTrigger

" //////////////////////////////////////////////////////////////////
" Plugins configuration
" //////////////////////////////////////////////////////////////////

" SnipMate
let g:snipMate = { 'snippet_version' : 1 }

" Fern
let g:fern#renderer = "nerdfont"

function! s:init_fern() abort
  echo "This function is called ON a fern buffer WHEN initialized"

  nmap <buffer><expr>
      \ <Plug>(fern-my-expand-or-collapse)
      \ fern#smart#leaf(
      \   "\<Plug>(fern-action-collapse)",
      \   "\<Plug>(fern-action-expand)",
      \   "\<Plug>(fern-action-collapse)",
      \ )

  nmap <buffer><expr> <Plug>(fern-my-open-or-expand)
	  \ fern#smart#leaf(
	  \   "<Plug>(fern-action-open)",
	  \   "<Plug>(fern-action-expand)",
      \   "<Plug>(fern-action-collapse)",
	  \ )

  nmap <buffer><nowait> l <Plug>(fern-my-expand-or-collapse)
  nmap <buffer><nowait> <C-h> <Plug>(fern-action-hidden)
  nmap <buffer><nowait> <CR> <Plug>(fern-my-open-or-expand)
  nmap <buffer> F <Plug>(fern-action-fzf-files)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

" Commentary
autocmd FileType yaml,make,terraform setlocal commentstring=#\ %s

" Ale configuration
let g:ale_sign_error             = '✘'
let g:ale_sign_warning           = '⚠'
highlight ALEErrorSign ctermbg   =NONE ctermfg=red
highlight ALEWarningSign ctermbg =NONE ctermfg=yellow
let g:ale_linters_explicit       = 1
let g:ale_lint_on_enter          = 0
let g:ale_lint_on_text_changed   = 0
let g:ale_lint_on_save           = 1
let g:ale_fix_on_save            = 1

let g:ale_linters = {
      \ 'dockerfile': ['dockerfile_lint'],
      \ 'fish': ['fish'],
      \ 'go': ['gopls'],
      \ 'json': ['spectral'],
      \ 'make': ['checkmake'],
      \ 'markdown': ['mdl', 'writegood'],
      \ 'terraform': ['terraform_ls'],
      \ 'vim': ['vimls'],
      \ 'yaml': ['spectral'],
      \ 'python': ['flake8', 'mypy'],
      \}

let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'go': ['gofmt', 'goimports', 'gomod'],
      \ 'terraform': ['terraform'],
      \ 'python': ['autoimport', 'reorder-python-imports'],
      \ 'json': ['jq'],
      \}

" Enable autocomplete
filetype plugin indent on
set omnifunc=ale#completion#OmniFunc
set completeopt+=menuone,noinsert,noselect
set shortmess+=c
set belloff+=ctrlg
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#completion_delay = 50
let g:mucomplete#reopen_immediately = 0

" Markdown
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
