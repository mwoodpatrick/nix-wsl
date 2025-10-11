-- [Custom Neovim statusline](https://vieitesss.github.io/posts/Neovim-custom-status-line/)
-- Core building blocks
-- Alignment: %= splits the bar into zones (left | right; add another %= for a middle).
-- Truncation: %< marks where text to its left may be shortened when space is tight.
-- Literals: %% prints a literal %.
-- Expressions: %{...} evaluates an expression.
-- Highlighting: %#Group# switches highlight; %* resets to the default group.
--
-- Common built-ins (quick ref)
-- File: %t (tail), %f (relative path), %F (full path), %y (filetype)
-- Flags: %m (modified +), %r (readonly)
-- Position: %l (line), %c (col), %L (total), %p%% (percent)

Statusline = {}

local state = {
    show_path = true,
    show_branch = true,
}

local config = {
    icons = {
        path_hidden = "", -- opened directory icon
        branch_hidden = "", -- crossed out eye icon
    },
}

local function git()
    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.head == "" then
    return ""
    end

    local head    = git_info.head
    local added   = git_info.added and (" +" .. git_info.added) or ""
    local changed = git_info.changed and (" ~" .. git_info.changed) or ""
    local removed = git_info.removed and (" -" .. git_info.removed) or ""
    if git_info.added == 0 then added = "" end
    if git_info.changed == 0 then changed = "" end
    if git_info.removed == 0 then removed = "" end

     if not state.show_branch then
        head = config.icons.branch_hidden
    end

    return table.concat({
        "[ ",
        head,
        added, changed, removed,
        "]",
    })
end

function Statusline.toggle_branch()
    state.show_branch = not state.show_branch
    vim.cmd("redrawstatus")
end

-- `sb` for `statusline branch`
vim.keymap.set("n", "<leader>sb", function() Statusline.toggle_branch() end, { desc = "Toggle statusline git branch" })

local function filepath()
    local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")

    if fpath == "" or fpath == "." then
        return ""
    end

    -- Whether to show the path or the icon
    if state.show_path then
        return string.format("%%<%s/", fpath)
    end

    return config.icons.path_hidden .. "/"
end

function Statusline.toggle_path()
    state.show_path = not state.show_path

    -- Draw the statusline manually
    vim.cmd("redrawstatus")
end

-- `sp` for "statusline path"
vim.keymap.set("n", "<leader>sp", function() Statusline.toggle_path() end, { desc = "Toggle statusline path" })

function Statusline.active()
    -- `%P` shows the scroll percentage but says 'Bot', 'Top' and 'All' as well.
    -- return "[%f]%=%y [%P %l:%c]"
    return table.concat {
        -- Before: `[%f]`
        -- `%t` shows only the file name
        "[", filepath(), "%t] ",
        git(),
        "%=",
        "%y [%P %l:%c]"
    }
end

function Statusline.inactive()
    return " %t"
end

local group = vim.api.nvim_create_augroup("Statusline", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = group,
    desc = "Activate statusline on focus",
    callback = function()
        vim.opt_local.statusline = "%!v:lua.Statusline.active()"
    end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = group,
    desc = "Deactivate statusline when unfocused",
    callback = function()
        vim.opt_local.statusline = "%!v:lua.Statusline.inactive()"
    end,
})
