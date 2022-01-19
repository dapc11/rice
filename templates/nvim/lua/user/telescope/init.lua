local telescope = require("telescope")
local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")

telescope.setup {
    defaults = {
        mappings = {
            n = {
                ["<C-p>"] = action_layout.toggle_preview
            },
            i = {
                ["<C-p>"] = action_layout.toggle_preview,
                ["<esc>"] = actions.close
            },
        },
        preview = {
            filesize_hook = function(filepath, bufnr, opts)
                local max_bytes = 10000
                local cmd = {"head", "-c", max_bytes, filepath}
                require('telescope.previewers.utils').job_maker(cmd, bufnr, opts)
            end
        }
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
        }
    }
}
telescope.load_extension('fzf')
