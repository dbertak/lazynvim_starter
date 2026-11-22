-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- LazyVim already sets 'termguicolors' and 'clipboard' (to "unnamedplus",
-- except over SSH), so only 'autoread' is added here for the tmux setup.
-- See https://tmux.app/doc/neovim-tmux/
vim.opt.autoread = true -- reload files changed outside Neovim (e.g. git checkout in another pane)
