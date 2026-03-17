local builtin = require('telescope.builtin')

local ok, ts_parsers = pcall(require, 'nvim-treesitter.parsers')
if ok and ts_parsers and type(ts_parsers.ft_to_lang) ~= 'function' then
  local ts_lang = vim.treesitter.language
  ts_parsers.ft_to_lang = function(ft)
    if not ft or ft == '' then
      return nil
    end
    if ts_lang and ts_lang.get_lang then
      local ok_lang, lang = pcall(ts_lang.get_lang, ft)
      if ok_lang and lang then
        return lang
      end
    end
    return ft
  end
end

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

