-- Markdown wrap settings. Loaded after the builtin markdown ftplugin so these
-- overrides stick. Required by agent_edit.nvim's :AgentWrap (`gq` on inserted
-- text), and useful for manual `gq` / `gqap` on prose.

vim.opt_local.textwidth = 100

-- formatoptions:
--   t  auto-wrap text at textwidth while typing
--   c  auto-wrap comments while typing (no-op for prose, kept for safety)
--   q  allow `gq` to format comments
--   n  recognize numbered/bulleted list items — preserves continuation indent
--      on every wrapped line (the missing piece that was breaking line 3+ of
--      list items)
--   l  don't break long existing lines on insert (lets `gq` be the only force)
-- removed:
--   o  don't insert comment leader on `o`/`O` (already removed globally)
vim.opt_local.formatoptions:append('n')
vim.opt_local.formatoptions:append('q')
vim.opt_local.formatoptions:append('l')
-- Remove `*`, `-`, `+` from comments.
vim.opt_local.comments = 'n:>'


-- Recognize markdown list markers so `n` knows where items start:
--   numbered:   `1.` / `1)` / `12.` / `12)`
--   bulleted:   `-` / `*` / `+`
--   blockquote: `> `
-- The post-marker indent (column at which continuation lines align) is
-- everything matched up to the trailing `\s\+`.
vim.opt_local.formatlistpat = [[^\s*\d\+[.)]\s\+\|^\s*[-*+]\s\+\|^\s*>\s\+]]
