local lint = require("lint")
local pattern = '[^:]+:(%d+):(%d+):(%w+):(.+)'
local groups = { 'line', 'start_col', 'code', 'message' }
local severities = {
    fatal = vim.lsp.protocol.DiagnosticSeverity.Fatal,
    error = vim.lsp.protocol.DiagnosticSeverity.Error,
    warning = vim.lsp.protocol.DiagnosticSeverity.Warning,
    refactor = vim.lsp.protocol.DiagnosticSeverity.Information,
    convention = vim.lsp.protocol.DiagnosticSeverity.Hint,
}

lint.linters.dapc_flake8 = {
    cmd = 'flake8',
    stdin = true,
    args = {
        '--format=%(path)s:%(row)d:%(col)d:%(code)s:%(text)s',
        '--per-file-ignores = **/test_*:D100,D103',
        '--no-show-source',
        '-',
    },
    ignore_exitcode = true,
    parser = require('lint.parser').from_pattern(pattern, groups, nil, {
        ['source'] = 'flake8',
        ['severity'] = vim.lsp.protocol.DiagnosticSeverity.Warning,
    }),
}

lint.linters.dapc_pylint = {
    cmd = 'pylint',
    stdin = false,
    args = {
        '-f', 'json', 
    },
    ignore_exitcode = true,
    parser = function(output)
        local decoded = vim.fn.json_decode(output)
        local diagnostics = {}
        for _, item in ipairs(decoded or {}) do
            local column = 0
            if item.column > 0 then
                column = item.column - 1
            end
            table.insert(diagnostics, {
                range = {
                    ['start'] = {
                        line = item.line - 1,
                        character = column,
                    },
                    ['end'] = {
                    line = item.line - 1,
                    character = column,
                },
            },
            severity = assert(severities[item.type], 'missing mapping for severity ' .. item.type),
            source = 'pylint',
            code = (item["message-id"] and item["message-id"] or nil),
            message = item.message .. "(" .. item.symbol .. ")",
        })
    end
    return diagnostics
end,
}

lint.linters_by_ft = {
    python = {"dapc_flake8", "dapc_pylint",}
}
