return {
  {
    "williamboman/mason.nvim",
    name = "mason",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ruff_lsp",
          "marksman",
          "quick_lint_js",
          "html",
          "cssls",
          "bashls",
          "tailwindcss",
          "tsserver",
          "dockerls",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
      lspconfig.ruff_lsp.setup({})
      lspconfig.marksman.setup({})
      lspconfig.quick_lint_js.setup({})
      lspconfig.html.setup({})
      lspconfig.cssls.setup({})
      lspconfig.bashls.setup({})
      lspconfig.tailwindcss.setup({})
      lspconfig.tsserver.setup({})
      lspconfig.dockerls.setup({})
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
