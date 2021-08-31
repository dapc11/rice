" auto-install vim-plug
"
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'ap/vim-css-color'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-rooter'
Plug 'Yggdroot/indentLine'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
" Python IDE
Plug 'dense-analysis/ale' " Asynchronous Lint Engine
Plug 'davidhalter/jedi-vim'
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'Townk/vim-autoclose'
Plug 'lilydjwg/colorizer'
call plug#end()

let g:rooter_patterns = ['.git', 'src', 'pom.xml', 'Makefile', '*.sln', 'build/env.sh']
let g:rooter_change_directory_for_non_project_files = 'home'
let g:indentLine_setConceal = 0
let g:python3_host_prog = '~/dev/bin/python3'


""" ALE
let g:ale_echo_msg_format = '[%linter%] %code: %%s [%severity%]'
let g:ale_sign_error = '●'
let g:ale_sign_warning = '.'
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters = {'python': ['pylint', 'flake8']}
let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'python': ['add_blank_lines_for_python_control_statements', 'yapf', 'isort'],
            \}
let g:ale_python_auto_pipenv = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 0
let g:ale_completion_enabled = 0
let g:ale_completion_autoimport = 0
nmap L <Plug>(ale_fix)
nmap l <Plug>(ale_lint)
""" Jedi
let g:jedi#show_call_signatures = 1
let g:jedi#smart_auto_mappings = 1
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_stubs_command = "<leader>s"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"
" set completeopt+=noinsert
" set wildmode=list:longest
let g:jedi#completions_enabled = 0


""" Deopplete
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
\   'ignore_case': v:true,
\   'smart_case': v:true,
\})
" complete with words from any opened file
let g:context_filetype#same_filetypes = {}
let g:context_filetype#same_filetypes._ = '_'

" Treesitter
" Hightlight definitions
lua <<EOF
require'nvim-treesitter.configs'.setup {
    refactor = {
        highlight_definitions = { enable = true },
        },
    }
EOF

" TS Highlighting
lua <<EOF
require'nvim-treesitter.configs'.setup {
    highlight = {
    enable = true,
    custom_captures = {
        -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
        ["foo.bar"] = "Identifier",
        },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
    },
}
EOF

" TS Rename
lua <<EOF
require'nvim-treesitter.configs'.setup {
    refactor = {
        smart_rename = {
        enable = true,
        keymaps = {
            smart_rename = "grr",
            },
        },
    },
}
EOF

" TS Navigation
lua <<EOF
require'nvim-treesitter.configs'.setup {
    refactor = {
        navigation = {
        enable = true,
        keymaps = {
            goto_definition = "gnd",
            list_definitions = "gnD",
            list_definitions_toc = "gO",
            goto_next_usage = "<a-*>",
            goto_previous_usage = "<a-#>",
            },
        },
    },
}
EOF

" Goyo
let g:goyo_width = 120
let g:goyo_linenr = 1
nmap <C-w> :Goyo<CR>
nmap <C-e> :Goyo!<CR>

" Fugitive
nmap <leader>gs :Git<CR>
nmap <leader>gf :Git pull --rebase<CR>
nmap <leader>gp :Git push
nmap <leader>gc :Git commit
nmap <leader>ga :Git add
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>gdd :Gdiff<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>
