local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")


telescope.setup {
    defaults = {
        prompt_prefix        = " ",
        selection_caret      = "❯ ",
        file_ignore_patterns = {"node_modules", ".git"},
        vimgrep_arguments    = {"rg", "--no-heading", "--color=never", "--with-filename", "--line-number", "--column", "--smart-case", "--trim"},
        mappings = {
            n = {
                ["<C-p>"]   = action_layout.toggle_preview,
                ["<M-q>"]   = actions.send_to_qflist + actions.open_qflist,
                ["<tab>"]   = actions.toggle_selection + actions.move_selection_next,
                ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
                ["<C-c>"]   = actions.close
            },
            i = {
                ["<C-p>"]   = action_layout.toggle_preview,
                ["<C-c>"]   = actions.close,
                ["<esc>"]   = actions.close,
                ["<M-q>"]   = actions.send_to_qflist + actions.open_qflist,
                ["<tab>"]   = actions.toggle_selection + actions.move_selection_next,
                ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
                ["<CR>"]    = actions.select_default,
                ["<C-x>"]   = actions.select_horizontal,
                ["<C-v>"]   = actions.select_vertical,
                ["<C-t>"]   = actions.select_tab
            }
        },
        preview = {
            filesize_hook = function(filepath, bufnr, opts)
                local max_bytes = 10000
                local cmd = {"head", "-c", max_bytes, filepath}
                require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
            end
        }
    },
    extensions = {
        fzf = {
            fuzzy                   = true,
            override_generic_sorter = true,
            override_file_sorter    = true,
            case_mode               = "smart_case" -- or "ignore_case" or "respect_case"
        }
    }
}
telescope.load_extension("fzf")
telescope.load_extension("projects")
