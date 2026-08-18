return {
  -- 1. Ensure Neovim knows how to parse QML syntax
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        table.insert(opts.ensure_installed, "qml")
      end
    end,
  },

  -- 2. Register the qmlls server to nvim-lspconfig via LazyVim's config
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        qmlls = {
          -- Tell LazyVim NOT to search for this inside Mason since it's installed locally
          mason = false,
          filetypes = { "qml", "qmljs" },
          settings = {},
        },
      },
    },
  },
}
