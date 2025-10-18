---@type vim.lsp.Config
return {
    cmd = { 'bash-language-server', 'start' },
    settings = {
        bashIde = {
            -- globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
            globPattern = "*@(.sh|.inc|.bash|.command)",
        },
    },
    filetypes = { "sh", "bash", "zsh" },
    root_markers = { '.git' },
    root_dir = vim.fs.dirname(vim.fs.find({ ".git", ".bashrc" }, { upward = true })[1]),
}
