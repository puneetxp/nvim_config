local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  'tsserver',
  'volar',
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()


local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

-- Define common LSP on_attach function
local function lsp_on_attach(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

  -- Ensure capabilities are properly set
  if client.server_capabilities then
    client.server_capabilities.codeActionProvider = true
    client.server_capabilities.referencesProvider = true
    client.server_capabilities.renameProvider = true
  end
end

lsp.on_attach(lsp_on_attach)

lsp.setup()

local nvim_lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Explicitly configure TypeScript server to ensure proper on_attach
nvim_lsp.ts_ls.setup({
  capabilities = capabilities,
  on_attach = lsp_on_attach,
  root_dir = nvim_lsp.util.root_pattern("package.json", "tsconfig.json", ".git"),
  single_file_support = true,
})

-- Configure Volar for Vue.js with 2-space indentation
nvim_lsp.volar.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- Run the common LSP on_attach first
    lsp_on_attach(client, bufnr)

    -- Enable formatting for Volar
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true

    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end, opts)

    -- Auto-format on save for Vue files
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        if vim.bo[bufnr].filetype == "vue" then
          vim.lsp.buf.format({ bufnr = bufnr })
        end
      end,
    })
  end,
  init_options = {
    typescript = {
      tsdk = vim.fn.getcwd() .. '/node_modules/typescript/lib'
    },
    preferences = {
      includeCompletionsForModuleExports = true,
      includeCompletionsWithInsertText = true
    }
  },
  settings = {
    volar = {
      formatting = {
        enable = true,
        tabSize = 2,
        indentSize = 2,
        insertSpaces = true
      }
    },
    typescript = {
      format = {
        enable = true,
        indentSize = 2,
        tabSize = 2,
        insertSpaceAfterCommaDelimiter = true,
        insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
        insertSpaceAfterKeywordsInControlFlowStatements = true,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyParentheses = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
        insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
        insertSpaceBeforeAndAfterBinaryOperators = true,
        convertTabsToSpaces = true
      }
    },
    javascript = {
      format = {
        enable = true,
        indentSize = 2,
        tabSize = 2,
        insertSpaceAfterCommaDelimiter = true,
        insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
        insertSpaceAfterKeywordsInControlFlowStatements = true,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyParentheses = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
        insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
        insertSpaceBeforeAndAfterBinaryOperators = true,
        convertTabsToSpaces = true
      }
    },
    vue = {
      format = {
        enable = true,
        indentSize = 2,
        tabSize = 2
      }
    }
  }
})
--[[
nvim_lsp.denols.setup {
    on_attach = on_attach,
    root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
}

nvim_lsp.tsserver.setup {
    on_attach = on_attach,
    root_dir = nvim_lsp.util.root_pattern("package.json"),
    single_file_support = false
}
--]]

lsp.on_attach(function(client)
  if nvim_lsp.util.root_pattern("package.json")(vim.fn.getcwd()) then
    if client.name == "denols" then
      client.stop()
      return
    end
  end
end)

vim.g.markdown_fenced_languages = {
  "ts=typescript"
}

-- Just need to set the directory for denols to startup in
-- if it detects either files thats what it will do
lsp.configure('denols', {
  root_dir = nvim_lsp.util.root_pattern("deno.json", "import_map.json"),
})

vim.diagnostic.config({
  virtual_text = true
})
