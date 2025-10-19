-- Modern Neovim 0.12+ compatible logger module
local M = {}
-- Default log file (in Neovim’s state dir)
local function log_pack_diagnostics()
    local state_dir = vim.fn.stdpath("state") .. "/startup_logs"
    vim.fn.mkdir(state_dir, "p")
    local ts = os.date("%Y-%m-%d_%H-%M-%S")
    local log_file = string.format("%s/nvim_pack_diagnostics_%s.log", state_dir, ts)

    vim.notify("pkglog logfile:" .. log_file , vim.log.levels.INFO)

    local function append(lines, header)
        table.insert(lines, "")
        table.insert(lines, header)
    end
    local function write(lines)
        vim.fn.writefile(lines, log_file)
        vim.notify(string.format("🪵 vim.pack diagnostic log → %s", log_file), vim.log.levels.INFO)
    end

    -- Capture `require` calls
    local required_modules = {}
    local orig_require = require
    _G.require = function(name, ...)
        required_modules[name] = true
        return orig_require(name, ...)
    end
    local pre_rtp = vim.split(vim.o.runtimepath, ",")
    local lines = {
        "=== NEOVIM PACK DIAGNOSTIC LOG ===",
        "Timestamp: " .. os.date("%Y-%m-%d %H:%M:%S"),
        string.format("Neovim v%d.%d.%d", vim.version().major, vim.version().minor, vim.version().patch),
        "NVIM_APPNAME: " .. (vim.env.NVIM_APPNAME or "default"),
        "",
        "=== BEFORE vim.pack LOAD ===",
    }
    vim.list_extend(lines, pre_rtp)
    local t0 = vim.loop.hrtime()
    vim.api.nvim_create_autocmd("User", {
        pattern = "PackLoaded",
        callback = function()
            local post_rtp = vim.split(vim.o.runtimepath, ",")
            local elapsed = (vim.loop.hrtime() - t0) / 1e6
            append(lines, "=== AFTER vim.pack LOAD ===")
            vim.list_extend(lines, post_rtp)
            append(lines, string.format("=== PACK LOAD TIME: %.2f ms ===", elapsed))
            -- Diff
            append(lines, "=== RUNTIMEPATH DIFF (Added by vim.pack) ===")
            local added, existing = {}, {}
            for _, path in ipairs(pre_rtp) do existing[path] = true end
            for _, path in ipairs(post_rtp) do
                if not existing[path] then table.insert(added, path) end
            end
            if #added == 0 then
                table.insert(lines, "(no new paths added)")
            else
                vim.list_extend(lines, added)
            end
            -- Plugin mapping
            append(lines, "=== PLUGIN MAPPING FOR ADDED PATHS ===")
            local plugin_names = {}
            if #added > 0 then
                for _, path in ipairs(added) do
                    local plugin_name = path:match(".*/pack/[^/]+/(start|opt)/([^/]+)")
                    if plugin_name then
                        table.insert(plugin_names, plugin_name)
                        table.insert(lines, string.format("%s → %s", path, plugin_name))
                    else
                        table.insert(lines, string.format("%s → (unknown)", path))
                    end
                end
            else
                table.insert(lines, "(no new plugin paths found)")
            end

            -- Duplicates
            append(lines, "=== DUPLICATE RUNTIMEPATH ENTRIES ===")
            local seen, dupes = {}, {}
            for _, path in ipairs(post_rtp) do
                if seen[path] then table.insert(dupes, path) else seen[path] = true end
            end
            if #dupes > 0 then
                vim.list_extend(lines, dupes)
            else
                table.insert(lines, "(no duplicates)")
            end
            -- Missing or broken dirs
            append(lines, "=== MISSING / BROKEN RUNTIMEPATH ENTRIES ===")
            local missing = {}
            for _, path in ipairs(post_rtp) do
                if vim.fn.isdirectory(path) == 0 then
                    table.insert(missing, path)
                end
            end
            if #missing > 0 then
                vim.list_extend(lines, missing)
            else
                table.insert(lines, "(none missing)")
            end
            -- Actually loaded modules
            append(lines, "=== ACTUALLY LOADED LUA MODULES (via require) ===")
            local loaded = {}
            for name, _ in pairs(required_modules) do
                table.insert(loaded, name)
            end
            table.sort(loaded)
            vim.list_extend(lines, loaded)
            -- Lua & C search paths
            append(lines, "=== LUA MODULE PATHS ===")
            vim.list_extend(lines, vim.split(package.path, ";"))
            append(lines, "=== C MODULE PATHS ===")
            vim.list_extend(lines, vim.split(package.cpath, ";"))
            write(lines)
            -- 🧾 Summary in :messages
            local summary = string.format(
                [[
🪶 vim.pack summary:
  Plugins added: %d
  Lua modules required: %d
  Duplicates: %d
  Missing dirs: %d
  Load time: %.2f ms
  Log file: %s
        ]],
                #plugin_names,
                vim.tbl_count(required_modules),
                #dupes,
                #missing,
                elapsed,
                log_file
            )
            for _, line in ipairs(vim.split(summary, "\n")) do
                vim.schedule(function() vim.api.nvim_echo({ { line, "None" } }, false, {}) end)
            end
        end,
    })
end
vim.api.nvim_create_autocmd("VimEnter", { callback = log_pack_diagnostics })

function M.setup(opts)
    print "in pkglog"
    -- vim.fn.input("Press ENTER to acknowledge: ")
    opts = opts or {}
    -- vim.notify(string.format("🪵 vim.pack diagnostic log → %s", log_file), vim.log.levels.INFO)
    vim.notify("pkglog initialized", vim.log.levels.INFO)
    log_pack_diagnostics()
end

return M
