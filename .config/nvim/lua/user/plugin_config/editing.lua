-- Autocomplete menu
--
vim.opt.pumheight = 10
vim.cmd "set cinoptions+=(0"

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function(args)
    local float_bufnr, winid = vim.diagnostic.open_float(nil, { focus = false })
    -- Bail if nothing was opened (no diagnostics) or bad type
    if type(winid) ~= "number" or not vim.api.nvim_win_is_valid(winid) then
      return
    end
    -- Close the float when leaving the buffer/window
    vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave", "BufHidden" }, {
      once = true,
      buffer = args.buf,
      callback = function()
        if vim.api.nvim_win_is_valid(winid) then
          vim.api.nvim_win_close(winid, false)
        end
      end,
      desc = "Close diagnostic float opened on CursorHold",
    })
  end
})

vim.diagnostic.config({ virtual_text = true })

vim.keymap.set("n", "<leader>dt", function()
  -- Check the current status of diagnostics for hints
  if vim.diagnostic.is_enabled() then
    -- If hints are enabled, disable them
    vim.diagnostic.config({ virtual_text = true })
  end
end, { desc = "Toggle Hint Diagnostics" })
vim.o.updatetime = 500

-- Modules configuration
return {
  {
    'williamboman/mason.nvim',
    config = function()
      require("mason").setup({
        ui = { icons = { package_installed = "✓", }, },
      })
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      -- Quarantine on 07-04-2025 : Do I need this?
      -- local lsp_zero = require('lsp-zero')
      require("mason-lspconfig").setup({
        --handlers = { lsp_zero.default_setup },
        ensure_installed = {
          "lua_ls",
          --"cssls",
          --"jsonls",
          --"pyright",
          --"tsserver",
          --"eslint",
          --"html",
          --"svelte",
          "pyrefly",
          "rust_analyzer",
        },
      })
    end
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    config = function()
      -- This has to be run before `require lspconfig`
      -- Thus, there is a dependency on lspconfig of this module
      local lsp_zero = require('lsp-zero')
      vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
      vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
      vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
      vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
      vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
      vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
      vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
        -- Svelte workaround
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            if client.name == "svelte" then
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end
          end,
        })
      end)
    end
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'VonHeikemen/lsp-zero.nvim', },
    config = function()
      -- Quarantine on 07-04-2025 : Do I need this?
      --local capabilities = require('cmp_nvim_lsp').default_capabilities()
      --capabilities.textDocument.foldingRange = {
       -- dynamicRegistration = false,
        --lineFoldingOnly = true
      --}
      --local language_servers = require("lspconfig").util.available_servers()
      --for _, ls in ipairs(language_servers) do
       -- require('lspconfig')[ls].setup({
       --   capabilities = capabilities
       -- })
      --end
      --require('lspconfig').pyrefly.setup({})

      require('lspconfig').rust_analyzer.setup({
        cargo = {
          allFeatures = true,
        },
      })
      require('lspconfig').clangd.setup({
        name = "clangd",
        cmd = { "clangd",
          "--query-driver=/usr/bin/g++-13" },
        initialization_options = {
          fallback_flags = { "-std=c++20" },
        }
      })
    end
  },

  -- LLM editing
  --
  {
    'github/copilot.vim',
    enabled = false
  },
  {
    'Exafunction/windsurf.vim',
    event = 'BufEnter'
  },
  {
    "joshuavial/aider.nvim",
    opts = {
      auto_manage_context = true, -- automatically manage buffer context
      default_bindings = true,    -- use default <leader>A keybindings
      debug = false,              -- enable debug logging
    },
  },

  -- Nvim CMP
  --
  {
    'hrsh7th/nvim-cmp',
    event = { "InsertEnter" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = function(_, opts)
      local cmp = require 'cmp'
      return {
        sources = {
          { name = "lazydev", group_index = 0 },
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping.confirm({ select = true }),
          ["<CR>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          }),
        })
      }
    end
  },

  -- Function signature editing
  --
  {
    "ray-x/lsp_signature.nvim",
    opts = {},
    config = function(_, opts)
      require 'lsp_signature'.setup(opts)
    end
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {}
  },
}
