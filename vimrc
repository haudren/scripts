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

set hlsearch

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
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args='--ignore=E111,E126,E226,E302'
