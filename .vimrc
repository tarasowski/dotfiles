"call plug#begin('~/.vim/plugged')
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'
"Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'voldikss/vim-floaterm'
" highlights end of blocks
"Plug 'andymass/vim-matchup'

" for sveltejs
"Plug 'othree/html5.vim'
"Plug 'pangloss/vim-javascript'
"Plug 'evanleck/vim-svelte', {'branch': 'main'}
"call plug#end()

filetype indent on
set filetype=html
set smartindent  

" This makes Vim automatically reload a file when it detects an external change.
" Setting for aider --watch-files command
set autoread

" when closing :wqall to auto close Floaterm
autocmd QuitPre * silent! FloatermKill!

" https://github.com/BryceVandegrift/pm
let g:plugins = [
\ "https://github.com/junegunn/fzf.git", 
\ "https://github.com/junegunn/fzf.vim.git", 
\ "https://github.com/neoclide/coc.nvim.git", 
\ "https://github.com/voldikss/vim-floaterm.git", 
\ "https://github.com/catppuccin/nvim.git", 
\ "https://github.com/andymass/vim-matchup.git",
\ "https://github.com/mattn/emmet-vim.git",
\ "https://github.com/othree/html5.vim.git",
\ "https://github.com/hashivim/vim-terraform.git",
\ "https://github.com/madox2/vim-ai.git",
\ "https://github.com/github/copilot.vim.git"
\ ]

" Delay loading coc.nvim after the buffer is displayed
autocmd VimEnter * call timer_start(500, {-> execute('CocStart')})

let g:coc_global_extensions = [
\ 'coc-css',
\ 'coc-emoji',
\ 'coc-eslint',
\ 'coc-html',
\ 'coc-json',
\ 'coc-python',
\ 'coc-tsserver',
\ 'coc-go',
\ ]

" Clear existing highlights
highlight clear Pmenu
highlight clear PmenuSel
highlight clear PmenuSbar
highlight clear PmenuThumb

" Set new highlights
highlight Pmenu ctermbg=236 ctermfg=255  " Dark grey background, white text
highlight PmenuSel ctermbg=33 ctermfg=255  " Blue background, white text
highlight PmenuSbar ctermbg=236  " Dark grey scrollbar
highlight PmenuThumb ctermbg=248  " Light grey scrollbar thumb

" doesn't wrap the lines it shows the lines fully
set nowrap

set shell=/bin/bash

" Backspace settings
set backspace=indent,eol,start

" for search highlights
highlight Search ctermbg=yellow ctermfg=black guibg=yellow guifg=black


inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use ctrl-j/k to navigate completion suggestions
inoremap <silent><expr> <C-j> coc#pum#visible() ? coc#pum#next(1) : "\<C-j>"
inoremap <silent><expr> <C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-k>"

" Use Tab to confirm completion
inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#confirm() : "\<Tab>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Trigger completion when typing and automatically complete on tab
" inoremap <silent><expr> <Tab>   pumvisible() ? coc#pum#refresh() : "\<Tab>"

" Accept completion on Enter (this will select the completion item)
" inoremap <silent><expr> <CR>    pumvisible() ? coc#pum#confirm() : "\<CR>"

" Navigate through suggestions using Ctrl+J (down) and Ctrl+K (up)
" inoremap <silent><expr> <C-j>   pumvisible() ? coc#pum#jump(1) : "\<C-j>"
" inoremap <silent><expr> <C-k>   pumvisible() ? coc#pum#jump(-1) : "\<C-k>"


" Go to definition
nmap gd <Plug>(coc-definition)

" CoC configuration for completing with Tab
" inoremap <silent><expr> <Tab> pumvisible() ? coc#refresh() : "\<Tab>"
" inoremap <silent><expr> <S-Tab> pumvisible() ? coc#refresh() : "\<S-Tab>"

" Set the leader key to the Space key
let mapleader = " "

" Function to set up a 3-pane layout
function! SetupThreePaneLayout()
    " Create a new vertical split for your main editing area
    vsplit
    vsplit


    " Go to the right most pane
    wincmd l
    wincmd l

    " Open the NetRW explorer in the rightmost split
    Explore

    " Resize the NetRW window to occupy 10% of the screen width
    exec "vertical resize 20"

    wincmd h
    exec "vertical resize 90"

    wincmd h
    exec "vertical resize 70"	

    " Go back to the first split (main editing area)
    " wincmd h
endfunction



" Automatically set up the three-pane layout on startup
autocmd VimEnter * call SetupThreePaneLayout()

" Map <Esc> to exit terminal mode and return to normal mode
tnoremap <Esc> <C-\><C-n>

" Toggle terminal with <leader>t
let g:floaterm_shell = "bash"
nnoremap <leader>t :FloatermToggle<CR>


" Set the colorscheme
augroup ReloadColorscheme
    autocmd!
    autocmd VimEnter * colorscheme catppuccin-mocha
augroup END

" Activate mouse support
set mouse=a


" General settings for all files (2 spaces indentation)
set tabstop=2        " Number of spaces a <Tab> counts for
set shiftwidth=2     " Number of spaces to use for auto-indent
set expandtab        " Convert tabs to spaces

" Configure tab settings for JavaScript
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 expandtab

" Configure tab settings for Python
autocmd FileType python setlocal tabstop=2 shiftwidth=2 expandtab

" Set the time in milliseconds for CursorHold
set updatetime=300

" Create an auto-save group
augroup AutoSave
  autocmd!
  " Save only if the buffer is modified
  autocmd CursorHold,CursorHoldI * if getbufinfo(bufnr(''))[0].changed == 1 | silent! write | endif
augroup END


syntax on
set t_Co=256
set autoread
set encoding=utf-8
set ruler
map q <nop>
" nmap <CR> o<Esc>
map <S-s> i<CR><Esc>
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <delete> <nop>
map <S-k> <nop>
map <S-j> <nop>
set vb
set t_vb=
set number
set smartindent

" Yank to clipboard
set clipboard=unnamedplus

" set highlight when you perform a search
set incsearch
set ignorecase
set smartcase


" sets the rights text highlighting color
set bg=light

" shows constantly in which file you are working
set laststatus=2
set statusline+=%F\ \%{Percent()}%%
set title

" shows the percentage of the file left
function! Percent()
  let byte = line2byte( line( "." ) ) + col( "." ) - 1
  let size = (line2byte( line( "$" ) + 1 ) - 1)
  " return byte . " " . size . " " . (byte * 100) / size
  return (byte * 100) / size
endfunction

" switch back and forth to the previous window
noremap <S-j> <C-w>j
noremap <S-k> <C-w>k
noremap <S-h> <C-w>h
noremap <S-l> <C-w>l

autocmd Filetype javascript nnoremap <leader><leader> :w!<CR>:! NODE_ENV=development clear && node %<CR>
autocmd Filetype python nnoremap <leader><leader> :w!<CR>:!clear && python3 %<CR>
autocmd Filetype go nnoremap <leader><leader> :w!<CR>:!clear && go run %<CR>

" This makes the explorer visible when you open a file with vim
let g:netrw_banner = 0
let g:netrw_winsize=15
let g:netrw_browse_split=4



set noswapfile

"for fzf to switch between buffers 
set rtp+=/usr/local/opt/fzf
" Mapping to search files in the buffer
nnoremap <leader>b :Buffer<CR>


" Mapping to search files in the current directory
nnoremap <leader>f :Files<CR>
nnoremap <Leader>n :Rg<Space>
