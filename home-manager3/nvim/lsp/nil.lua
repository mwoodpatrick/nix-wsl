-- [nil](https://github.com/oxalica/nil)
--
return {
  -- Command and arguments to start the server.
  cmd = { vim.fn.expand("~/.nix-profile/bin/nil") },

  -- Filetypes to automatically attach to.
  filetypes = { "nix" },

  -- Sets the "root directory" to the parent directory of the file in the
  -- current buffer that contains either a ".luarc.json" or a
  -- ".luarc.jsonc" file. Files that share a root directory will reuse
  -- the connection to the same LSP server.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = { 'flake.nix', '.git' },

  -- Specific settings to send to the server. The schema for this is
  -- defined by the server. For example the schema for lua-language-server
  -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {
  }
}
