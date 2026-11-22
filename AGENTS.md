# AGENTS.md

Guidance for AI coding agents working in this repository.

## Project

This is a personal Neovim configuration built on the [LazyVim](https://github.com/LazyVim/LazyVim) starter.
It is not a distributable plugin or application — it is the user's daily editor setup.
Prefer small, reversible changes and keep the configuration stable.

- Neovim: `>= 0.11.2` (LazyVim requirement; tested with `0.12.6`)
- Plugin manager: `lazy.nvim`, bootstrapped by `lua/config/lazy.lua`
- Language: Lua
- Formatting: StyLua, 2-space indent, 120-column limit (`stylua.toml`)
- Environment: Linux, tmux 3.6, OpenCode CLI v2

## Critical: two copies of this config

- **Repository:** `~/Projects/editor/lazynvim_starter` (this directory, git-tracked)
- **Live config:** `~/.config/nvim` (a separate copy, **not** a symlink)

By default, Neovim loads `~/.config/nvim`, regardless of the current working directory.
Therefore:

1. Make every change in this repository first.
2. Copy changed files to `~/.config/nvim` to make them take effect.
3. Never edit only the live copy; it will drift from git.
4. Do not replace `~/.config/nvim` with a symlink or delete it unless the user explicitly asks.

## Layout

| Path | Purpose |
| --- | --- |
| `init.lua` | Entry point; loads `config.lazy` |
| `lua/config/lazy.lua` | Bootstraps lazy.nvim and configures the plugin manager |
| `lua/config/options.lua` | Vim options |
| `lua/config/keymaps.lua` | Custom keymaps |
| `lua/config/autocmds.lua` | Custom autocmds |
| `lua/plugins/*.lua` | Plugin specs, auto-imported by lazy.nvim |
| `lua/plugins/example.lua` | Reference only; returns `{}` early |
| `stylua.toml` | Lua formatting rules |
| `.neoconf.json` | Lua LSP configuration |

## Common commands

Run from the repository root.

| Task | Command |
| --- | --- |
| Open Neovim | `nvim` (interactive; never use in automation) |
| Install missing plugins | `nvim --headless "+Lazy! install" +qa` |
| Check startup | `nvim --headless "+lua vim.wait(800)" +qa` |
| Health check | `nvim --headless "+checkhealth <name>" "+silent write! /tmp/health.txt" +qa` |
| Format check | `stylua --check .` (only if StyLua is installed) |
| Format | `stylua .` |

Notes:

- `:checkhealth` writes to a buffer, not stdout. Always write it to a file and inspect that file.
- Use the bang form (`Lazy!`) to avoid interactive prompts.
- Do **not** run `:Lazy! sync` or `:Lazy! update` unless the user asks; they change installed plugin versions and the lockfile.
- Avoid interactive/TTY commands in automation: plain `nvim`, `lazygit`, the OpenCode TUI, `tmux attach`.

## Validation checklist

After a change:

1. Copy changed files to `~/.config/nvim`.
2. Run `nvim --headless "+lua vim.wait(800)" +qa` and confirm there are no startup errors.
3. Run `:checkhealth` for any affected plugin (see command above).
4. If keymaps or commands changed, verify them, for example:
   `nvim --headless "+lua print(vim.fn.maparg('<leader>oi', 'n'))" +qa`
5. If the plugin set changed, run `Lazy! install` and confirm nothing is missing.
6. Report which files changed, what was verified, and whether the live copy was synced.

## Plugin rules

- Add one plugin per file under `lua/plugins/`.
- Prefer lazy.nvim's `opts` over a custom `config` function unless custom setup is required.
- Override a LazyVim plugin by adding a spec with the same repository name; do not duplicate it.
- Prefer LazyVim extras (for example `{ import = "lazyvim.plugins.extras.lang.typescript" }`) when one exists.
- Custom plugins load at startup by default (`defaults.lazy = false` in `lua/config/lazy.lua`). Add `keys`, `cmd`, or `event` when lazy loading is appropriate.
- Do not edit `lua/plugins/example.lua`; it is an upstream reference file that returns `{}`.
- Do not edit `lua/config/lazy.lua` unless the task is specifically about lazy.nvim or bootstrap behavior.
- Do not hand-edit `lazy-lock.json`. The repository does not track it; the live config has one. Add or edit it only when the task is about pinning versions.
- Removing a plugin: remove its spec, sync, and ask before running `Lazy! clean` or deleting plugin directories.

## Keymaps and conventions

- `<leader>` is `Space` (LazyVim default).
- `<leader>o*` is reserved for OpenCode.
- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`, and `<C-\>` navigate between Neovim splits and tmux panes via `vim-tmux-navigator`.
- Check for conflicts before adding a mapping (`:verbose map <lhs>` or `vim.fn.maparg`).
- Always provide a `desc` so which-key can display the mapping.
- Keep keymap changes minimal and explain any that replace defaults.

## OpenCode integration

The active plugin is `sudo-tee/opencode.nvim` in `lua/plugins/opencode.lua`.

- `name = "opencode-tee"` is required: both `sudo-tee/opencode.nvim` and `nickjvandyke/opencode.nvim` default to the lazy name `opencode.nvim`.
- Both plugins expose the same `opencode` Lua module. Never install or load both in one Neovim instance.
- `lazy = false` is intentional so `:Opencode`, autocmds, and default `<leader>o` mappings are ready at startup.
- Current `opts` enables `ui.input.text.wrap` so prompts wrap instead of scrolling horizontally.
- The OpenCode server is shared with the TUI. Do not restart or kill it unless the user asks.
- Do not send prompts to OpenCode or any LLM during validation unless the user asks; health checks are sufficient.

## Markdown

- Markdown support comes from LazyVim's `lazyvim.plugins.extras.lang.markdown` extra, imported in `lua/plugins/markdown.lua`.
- The extra provides `render-markdown.nvim` (`<leader>um` toggle), `markdown-preview.nvim` (`<leader>cp`), marksman, markdownlint, and `markdown-toc`.
- Do not add a separate `MeanderingProgrammer/render-markdown.nvim` spec; the extra already configures it. The commented `opencode_output` dependency in `lua/plugins/opencode.lua` is intentional — leave it unless the user asks to render chat output.

## tmux

- tmux configuration lives at `~/.tmux.conf`, outside this repository.
- Do not modify tmux settings as part of a Neovim config change unless the user requests it.
- `vim.opt.autoread = true` in `lua/config/options.lua` is intentional for the tmux/git workflow.

## Code style

- Lua: 2-space indentation, 120-column limit, double quotes, trailing commas.
- Match the surrounding code; do not reformat unrelated lines.
- Comments in English. Explain non-obvious decisions.
- Prefer modern Neovim APIs: `vim.keymap.set`, `vim.api.nvim_create_autocmd`, `vim.uv` over `vim.loop`.
- Avoid global variables and `_G` pollution unless the integration requires it.
- Keep plugin specs declarative and readable.

## Git and safety

- Do not commit, push, amend, rebase, or force-push unless the user asks.
- Keep diffs focused. Do not include generated files, logs, or the live `lazy-lock.json` in unrelated changes.
- Match the existing commit style: short imperative or conventional messages (`fix: ...`, `docs: ...`).
- Never commit secrets, tokens, SSH keys, OpenCode auth data, or machine-specific paths.
- Ask before destructive actions: deleting files or plugins, replacing keymaps, changing tmux, uninstalling tools.
- Do not install system packages or new tools without permission.

## Agent behavior

- Read the relevant files before editing.
- If a request is ambiguous, ask one concise clarifying question instead of guessing.
- Prefer the smallest change that satisfies the request.
- Do not "improve" unrelated configuration.
- Use timeouts for commands that could block.
- If a headless Neovim command hangs, assume a UI prompt is blocking it; stop it and retry with the bang form or `+qa!`.
- After changes, state what changed, what was tested, and any required follow-up (especially syncing to `~/.config/nvim`).
