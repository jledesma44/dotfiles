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
    vim.filetype.add({
      extension = {
        kit = function(path, bufnr)
          return "html"
        end,
      },
    }),
  },
}
