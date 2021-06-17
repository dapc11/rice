" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'ap/vim-css-color'
Plug 'chriskempson/base16-vim'
Plug 'gruvbox-community/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-rooter'
Plug 'dense-analysis/ale'
Plug 'Yggdroot/indentLine'
Plug 'honza/vim-snippets'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'preservim/nerdtree'
Plug 'terryma/vim-expand-region'
call plug#end()

let g:rooter_patterns = ['.git', 'src', 'pom.xml', 'Makefile', '*.sln', 'build/env.sh']
let g:rooter_change_directory_for_non_project_files = 'home'
let g:ale_echo_msg_format = '[%linter%] %code: %%s [%severity%]'
let g:ale_python_flake8_options = '--ignore=E704,E121,E126,W503,W504,E226,E24,E123,D103'
let g:ale_sign_error = '●'
let g:ale_sign_warning = '.'
let g:ale_lint_on_text_changed = 'never'
let g:ale_completion_enabled = 1
" Make sure to pip install python-language-server yamllint
let g:ale_linters = {'python': ['pyright','pyls', 'flake8']}
if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif
set omnifunc=ale#completion#OmniFunc
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['add_blank_lines_for_python_control_statements', 'autopep8', 'autoimport', 'isort'],
\}
let g:ale_python_auto_pipenv = 1
let g:ale_python_pyls_auto_pipenv = 1
let g:ale_python_pyls_config = {}
let g:ale_python_pyls_executable = 'pyls'
let g:ale_python_pyls_options = ''
let g:ale_python_pyls_use_global = 1
let g:ale_set_balloons = 1


" Write this in your vimrc file
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
nmap <silent> gd :ALEGoToDefinition<CR>
nmap <silent> gt :ALEToggle<CR>
nmap <silent> gr :ALEFindReferences<CR>
nmap <silent> gk :ALEHover<CR>
nmap <silent> gs :ALESymbolSearch

nmap <silent> gl :ALELint<CR>
nmap <silent> gn :ALENext<CR>
nmap <silent> gp :ALEPrevious<CR>
map <F3> :ALEFix<CR> :update<CR>


" Nerdtree
let NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
" map <Leader>k :call NERDTreeToggleAndRefresh()<CR>

" function NERDTreeToggleAndRefresh()
"   :NERDTreeToggle
"   if g:NERDTree.IsOpen()
"     :NERDTreeRefreshRoot
"   endif
" endfunction

" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()

function! ToggleNerdTree()
  set eventignore=BufEnter
  NERDTreeToggle
  set eventignore=
endfunction
nmap <Leader>k :call ToggleNerdTree()<CR>
let g:NERDTreeMouseMode=3

map J <Plug>(expand_region_expand)
map K <Plug>(expand_region_shrink)
