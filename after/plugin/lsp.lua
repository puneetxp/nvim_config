-- Modern Neovim v0.11+ Native LSP Setup with blink.cmp
local lspconfig = require('lspconfig')
local blink = require('blink.cmp')

-- Setup Mason package manager
require('mason').setup({})

-- Get capabilities from blink.cmp to enable completion in LSP servers
local capabilities = blink.get_lsp_capabilities()

-- Setup Mason-LSPconfig to handle server setup automatically
require('mason-lspconfig').setup({
  ensure_installed = { 'ts_ls', 'volar' },
  handlers = {
    -- Default handler setups all servers automatically with blink capabilities
    function(server_name)
      lspconfig[server_name].setup({
        capabilities = capabilities
      })
    end,
  },
})

-- Common keymaps and diagnostics configured when an LSP server attaches to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Configure LSP actions and keymaps',
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, remap = false }

    -- Primeagen LSP Keybindings & Navigation
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "gy", function() vim.lsp.buf.type_definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    -- Vue (volar) specific formatting mapping & auto-format on save
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'volar' then
      vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end, { buffer = bufnr })
      
      -- Auto-format on save for Vue files
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        callback = function()
          if vim.bo[bufnr].filetype == 'vue' then
            vim.lsp.buf.format({ bufnr = bufnr })
          end
        end,
      })
    end
  end,
})

-- Diagnostic configurations
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
})

vim.g.markdown_fenced_languages = {
  "ts=typescript"
}
