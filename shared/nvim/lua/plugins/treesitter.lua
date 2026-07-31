return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "c",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "javascript",
      "typescript",
      "tsx",
      "jsx",
      "json",
      "css",
      "html",
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<Leader>ss",
        node_incremental = "<Leader>si",
        scope_incremental = "<Leader>sc",
        node_decremental = "<Leader>sd",
      },
    },
    vim.filetype.add({
      extension = {
        kit = function(path, bufnr)
          return "html"
        end,
      },
    }),
  },
}
