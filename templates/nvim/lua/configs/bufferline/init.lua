require("bufferline").setup {
    options = {
        numbers = "ordinal",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator_icon = "▎",
        buffer_close_icon = "",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
            if buf.name:match("%.md") then
                return vim.fn.fnamemodify(buf.name, ":t:r")
            end
        end,
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 18,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count)
            return "("..count..")"
        end,
        -- NOTE: this will be called a lot so don't do any heavy processing here
        custom_filter = function(buf)
            -- filter out filetypes you don't want to see
            local ft = vim.bo[buf].filetype
            return ft ~= "gitcommit" or ft ~= "telescope" or ft ~= "toggleterm" or ft ~= "fugitive"
        end,
        show_buffer_icons = false,
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = "thin",
        always_show_bufferline = true,
        sort_by = "id",
        offsets = {
            {
                filetype = "NvimTree",
                text = "Explorer",
                text_align = "left"
            }
        }
    },
    highlights = {
        fill = {
            guibg = "{{base00}}"
        },
    }
}
