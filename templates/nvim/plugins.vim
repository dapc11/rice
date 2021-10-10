" auto-install vim-plug
"
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' " Find everything
Plug 'junegunn/goyo.vim' " Zen mode
Plug 'ap/vim-css-color' " CSS Colors ?
Plug 'tpope/vim-commentary' " Neat comments
Plug 'tpope/vim-fugitive' " Git integration
Plug 'airblade/vim-rooter' " Change PWD to project root of open buffer
Plug 'Yggdroot/indentLine'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } " Go support
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/nvim-treesitter-refactor' " Refactor with LST and highlgiht current block
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'Townk/vim-autoclose' " Autoclose quotes and brackets
Plug 'lilydjwg/colorizer' " CSS colors
Plug 'neovim/nvim-lspconfig' " LSP
Plug 'hrsh7th/cmp-nvim-lsp' " Auto suggestions from LSP
Plug 'hrsh7th/cmp-buffer' " Auto suggestions
Plug 'hrsh7th/nvim-cmp' " Auto suggestions
" For vsnip user.
Plug 'hrsh7th/cmp-vsnip' " Snippets
Plug 'hrsh7th/vim-vsnip' " Snippets
Plug 'hrsh7th/cmp-path' " Auto complete paths
Plug 'mfussenegger/nvim-lint' " Linting
" Track the engine.
" Snippets are separated from the engine. Add this if you want them:
Plug 'SirVer/ultisnips' " Snippets
Plug 'honza/vim-snippets' " Snippets
Plug 'quangnguyen30192/cmp-nvim-ultisnips' " Snippets
Plug 'ray-x/lsp_signature.nvim' " Signature help
Plug 'jose-elias-alvarez/null-ls.nvim' " formatting and possibly linting
Plug 'lewis6991/gitsigns.nvim' " Lua gitsigns
call plug#end()

let g:rooter_patterns = ['.git', 'src', 'pom.xml', 'Makefile', '*.sln', 'build/env.sh']
let g:rooter_change_directory_for_non_project_files = 'home'
let g:indentLine_setConceal = 0
let g:python3_host_prog = '~/dev/bin/python3'


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
