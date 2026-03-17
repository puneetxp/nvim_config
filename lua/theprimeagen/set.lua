vim.opt.guicursor = ""

vim.opt.wrap = true
vim.opt.nu = true
vim.opt.linebreak = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

local uv = vim.loop
local function ensure_tmpdir()
  local tmp = vim.env.TMPDIR
  if tmp and uv.fs_access(tmp, "RWX") then
    return
  end

  local fallback = string.format("/tmp/nvim-%s", vim.env.USER or "user")
  vim.fn.mkdir(fallback, "p")
  vim.env.TMPDIR = fallback
end

ensure_tmpdir()
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 2
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "200"

-- Timeout for key sequences (for multi-key leader mappings)
vim.opt.timeoutlen = 1000

-- OSC52 clipboard configuration for SSH sessions and remote work
-- This enables clipboard functionality when working over SSH
-- OSC52 allows copying to system clipboard through terminal escape sequences
if vim.env.SSH_TTY or vim.env.SSH_CLIENT or vim.env.SSH_CONNECTION then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
else
  -- For local sessions, use system clipboard if available
  vim.opt.clipboard = "unnamedplus"
end

