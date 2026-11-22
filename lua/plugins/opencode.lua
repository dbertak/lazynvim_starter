return {
  "sudo-tee/opencode.nvim",
  -- Both plugins are named `opencode.nvim` upstream, so give this one a
  -- distinct lazy.nvim name.
  name = "opencode-tee",
  -- Load at startup so :Opencode, its autocmds, and its default <leader>o
  -- keymaps are ready immediately.
  lazy = false,
  opts = {
    ui = {
      input = {
        -- Wrap long prompts instead of scrolling horizontally. The plugin
        -- also enables 'linebreak' so wrapping happens on word boundaries.
        text = { wrap = true },
      },
    },
  },
  -- Optional: styled Markdown in the chat output. This only affects the
  -- plugin's own `opencode_output` buffer, not regular Markdown files.
  -- dependencies = {
  --   {
  --     "MeanderingProgrammer/render-markdown.nvim",
  --     ft = { "opencode_output" },
  --     opts = {
  --       anti_conceal = { enabled = false },
  --       file_types = { "opencode_output" },
  --     },
  --   },
  -- },
}
