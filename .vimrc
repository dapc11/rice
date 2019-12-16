"Download plug.vim
"curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"                                  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

let mapleader = ","
call plug#begin('~/.vim/plugged')

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
call plug#end()
let g:fzf_commands_expect = 'alt-enter,ctrl-x'
let g:fzf_nvim_statusline = 0 " disable statusline overwriting

  nnoremap <silent> <leader>f :F<CR>
" Open files in horizontal split
nnoremap <silent> <Leader>s :call fzf#run({
\   'down': '40%',
\   'sink': 'botright split' })<CR>

" Open files in vertical horizontal split
nnoremap <silent> <Leader>v :call fzf#run({
\   'right': winwidth('.') / 2,
\   'sink':  'vertical botright split' })<CR>

"" statusline
set laststatus=2
set statusline=                          " left align
set statusline+=%2*\                     " blank char
set statusline+=%2*\%{StatuslineMode()}
set statusline+=%2*\                     " black char
set statusline+=%1*\ <<
set statusline+=%1*\ %f                  " short filename
set statusline+=%1*\ >>
set statusline+=%=                       " right align
set statusline+=%*
set statusline+=%3*\%h%m%r               " file flags (help, read-only, modified)
set statusline+=%1*\%{b:gitbranch}       " include git branch
set statusline+=%2*\%.35F                " long filename (trimmed to 25 chars)
set statusline+=%2*\::
set statusline+=%2*\%l/%L\\|             " line count
set statusline+=%2*\%y                   " file type
hi User1 ctermbg=black ctermfg=grey guibg=black guifg=grey
hi User2 ctermbg=green ctermfg=black guibg=green guifg=black
hi User3 ctermbg=black ctermfg=lightgreen guibg=black guifg=lightgreen

"" statusline functions
function! StatuslineMode()
    let l:mode=mode()
    if l:mode==#"n"
        return "NORMAL"
    elseif l:mode==?"v"
        return "VISUAL"
    elseif l:mode==#"i"
        return "INSERT"
    elseif l:mode==#"R"
        return "REPLACE"
    endif
endfunction

function! StatuslineGitBranch()
  let b:gitbranch=""
  if &modifiable
    lcd %:p:h
    let l:gitrevparse=system("git rev-parse --abbrev-ref HEAD")
    lcd -
    if l:gitrevparse!~"fatal"
      let b:gitbranch="(".substitute(l:gitrevparse, '\n', '', 'g').") "
    endif
  endif
endfunction

augroup GetGitBranch
  autocmd!
  autocmd VimEnter,WinEnter,BufEnter * call StatuslineGitBranch()
augroup END

filetype on
au FileType gitcommit set tw=72
set t_Co=16
set mouse=r
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$/
set noshowmode
