return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<leader>re", ":Refactor extract",          mode={"x"}, desc = "Refactor extract" },
    { "<leader>rf", ":Refactor extract_to_file",  mode={"x"}, desc = "Refactor extract to file" },
    { "<leader>rv", ":Refcator extract_var",      mode={"x"}, desc = "Neotree buffers" },
  },
  config = function()
    require("refactoring").setup()
  end,
}
