return {
  "nvim-neo-tree/neo-tree.nvim",
  name = "neo-tree",
  branch = "v3.x",
  dependencies = { "nvim-Lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = { ".git", ".DS_Store", "thumbs.db", "package-lock.json" },
        never_show = { ".git", ".DS_Store" },
      },
    },
  },
  config = function()
    vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
  end,
}
