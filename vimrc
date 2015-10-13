runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

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

let g:jedi#completions_command = "<C-N>"

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args='--ignore=E111,E126,E226,E302 --max-line-length=110 --max-complexity=10'

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
      \   'readonly': '%{&filetype=="help"?"":&readonly?"⭤":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }


augroup AutoSyntastic
    autocmd!
    autocmd BufWritePost *.c,*.cpp,*.py call s:syntastic()
augroup END

function! s:syntastic()
    SyntasticCheck
    call lightline#update()
endfunction

if !has('gui_running')
    set t_Co=256
endif
