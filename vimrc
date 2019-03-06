call plug#begin('~/.vim/plugged/')

Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'Valloric/YouCompleteMe'
Plug 'dracula/vim'
Plug 'itchyny/lightline.vim'
Plug 'neomake/neomake'
Plug 'rust-lang/rust.vim'
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-fugitive'
Plug 'ivanov/vim-ipython'
Plug 'tpope/vim-obsession'
Plug 'racer-rust/vim-racer'
Plug 'taketwo/vim-ros'
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-sleuth'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'lervag/vimtex'
Plug 'vimwiki/vimwiki'

call plug#end()

set number
set splitbelow
set splitright
set autoindent
set title titlestring=

:au FocusLost * :set number
:au FocusGained * :set relativenumber
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

filetype plugin indent on

au BufRead,BufNewFile *.launch setfiletype xml
au BufRead,BufNewFile *.cnoid setfiletype yaml
au BufRead,BufNewFile *.md set filetype=markdown

set hlsearch
hi Search ctermbg=77 "PaleSeaGreen
set noshowmode

highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

exec "set listchars=tab:\u219d\u00b7,trail:\u2056"
set list

nnoremap ; :
nnoremap : ;

set wildmode=longest,list,full
set wildmenu

highlight SignColumn ctermbg=8

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

map <C-e> <Esc>;!%:p<CR>

set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], [  'fileformat', 'fileencoding'  ] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"書禁止":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_extra_conf_globlist = ['~/.ycm_extra_conf.py']

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Use okular for vimtex
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique @pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'
let g:vimtex_complete_recursive_bib = 1
let g:vimtex_quickfix_mode = 2

" Vimtex + ycm
if !exists('g:ycm_semantic_triggers')
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = [
      \ 're!\\[A-Za-z]*cite[A-Za-z]*(\[[^]]*\]){0,2}{[^}]*',
      \ 're!\\[A-Za-z]*ref({[^}]*|range{([^,{}]*(}{)?))',
      \ 're!\\hyperref\[[^]]*',
      \ 're!\\includegraphics\*?(\[[^]]*\]){0,2}{[^}]*',
      \ 're!\\(include(only)?|input){[^}]*',
      \ 're!\\\a*(gls|Gls|GLS)(pl)?\a*(\s*\[[^]]*\]){0,2}\s*\{[^}]*',
      \ 're!\\includepdf(\s*\[[^]]*\])?\s*\{[^}]*',
      \ 're!\\includestandalone(\s*\[[^]]*\])?\s*\{[^}]*',
      \ ]

if !has('gui_running')
    set t_Co=256
endif

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Add a mapping for autofix
map <C-S-f> :YcmCompleter FixIt<CR>

" netrw settings
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" Run flake8 via Neomake on saving python files
let g:neomake_flake8_args = ['--ignore=E111,E226', '--format=default']
let g:neomake_verbose = -1
autocmd! BufWritePost *.py Neomake flake8

syntax on
color dracula
