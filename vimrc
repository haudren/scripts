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
