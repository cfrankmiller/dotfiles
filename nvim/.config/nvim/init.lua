
-- https://vonheikemen.github.io/devlog/tools/simple-neovim-config/

vim.o.number = true
vim.o.signcolumn = 'yes'
vim.o.wrap = false

vim.o.hlsearch = true
vim.o.breakindent = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.cursorline = true

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- mouse
vim.o.mouse = 'n'
vim.o.mousehide = true

-- filetype styles
vim.cmd([[
function! SetEsriStyle()
  set list et sts=2 sw=2 nowrap tw=120 fo=cqro
  set cindent cino={:0,g0,c0,(0,(s,m1
  set comments=://!,://:,:///,://
endfunction
 
autocmd FileType cmake set nowrap et sts=2 sw=2 tw=100 fo=cqro nospell nocindent comments=b:#,fb:-
autocmd FileType cpp   call SetEsriStyle()
autocmd FileType sh    set list et sts=2 sw=2 nowrap tw=0
autocmd FileType lua   set list et sts=2 sw=2 nowrap tw=0
autocmd FileType json  set list et sts=2 sw=2 nowrap tw=0
]])

-- diff
vim.o.diffopt = "internal,filler,closeoff,vertical"
vim.o.fillchars = "diff:╱"

-- clipboard
vim.o.clipboard = "unnamed,unnamedplus"
--vim.keymap.set({'n', 'x'}, 'gy', '"+y', {desc = 'Copy to clipboard'})
--vim.keymap.set({'n', 'x'}, 'gp', '"+p', {desc = 'Paste clipboard text'})

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noinsert,noselect'

-- lsp
vim.lsp.enable({'clangd', 'cmake'})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {desc = '[G]oto [D]efinition'})
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {desc = '[G]oto [D]eclaration'})
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {desc = '[G]oto [I]mplementation'})
vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, {desc = '[G]oto Code [A]ction'})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {desc = 'Hover Documentation'})
vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, {desc = 'Signature Documentation'})

vim.keymap.set('n', '<leader>ee', vim.diagnostic.open_float)

--vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {desc = '[G]oto [R]eferences'})
--vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, {desc = 'Type [D]efinition'})
--vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, {desc = '[D]ocument [S]ymbols'})
--vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, {desc = '[W]orkspace [S]ymbols'})

-- clang-format
vim.cmd([[
:let g:clang_format_path = 'clang-format-19'
]])
local clangformat = '/home/frank/bin/clang-format.py'
vim.keymap.set({'n', 'v'}, '<c-K>', ':py3f ' .. clangformat .. '<cr>')
vim.keymap.set('i', '<c-K>', '<c-o>:py3f ' .. clangformat .. '<cr>')

--------------------------------------------------------------------------------------------
-- Pluggins

-- nightfox colorscheme
vim.pack.add({'https://github.com/edeneast/nightfox.nvim'})
local nightfox = require('nightfox')
local palette = require('nightfox.palette').load('nightfox')
local color = require("nightfox.lib.color")
local mybg0 = color.from_hex(palette.bg0):shade(-0.25):to_css()
local mybg1 = color.from_hex(palette.bg1):shade(-0.25):to_css()
local diff0 = color.from_hex(palette.green.base):shade(-0.70):to_css()
local diff1 = color.from_hex(palette.green.base):shade(-0.60):to_css()
local diffd = color.from_hex(palette.red.base):shade(-0.75):to_css()
nightfox.setup({
    options = {
        dim_inactive = true,
    },
    specs = {
        nightfox = {
            bg0 = mybg0,
            bg1 = mybg1,
            diff = {
                add = diff0,
                change = diff0,
                delete = diffd,
                text = diff1
            },
        },
    },
    groups = {
        nightfox = {
            CursorLine = { bg = "#000000" },
            CursorColumn = { bg = "#000000" },
            DiffDelete = { fg = diff1 },
            --IncSearch  = { fg = palette.fg1, bg = palette.sel1 }, -- dont do this https://github.com/EdenEast/nightfox.nvim/pull/215
        },
    },
})
vim.cmd.colorscheme('nightfox')

-- lsp
vim.pack.add({'https://github.com/neovim/nvim-lspconfig'})

-- mini
vim.pack.add({'https://github.com/nvim-mini/mini.nvim'})

-- mini.files
require('mini.icons').setup({style = 'ascii'})
require('mini.files').setup({
  mappings = {
    go_in = 'L',
    go_in_plus = 'l',
  }
})
--vim.keymap.set('n', '<leader>fe', '<cmd>lua MiniFiles.open()<cr>', {desc = 'File explorer'})
--vim.keymap.set('n', '<leader>fe', '<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<cr>', {desc = 'File explorer'})
vim.keymap.set('n', '<leader>fe', function()
  local MiniFiles = require('mini.files')
  
  -- Open mini.files focused on the current file buffer path
  -- if no valid file is active, it falls back to the current directory
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    
    -- Defer revealing the workspace CWD so mini.files has time to render
    vim.defer_fn(function()
      MiniFiles.reveal_cwd()
    end, 30)
  end
end, { desc = 'File explorer' })

-- mini.pick
require('mini.pick').setup({
    mappings = {
      mark_all          = '<C-e>',
      choose_marked     = '<C-q>',
    }
})
vim.keymap.set('n', '<leader>ff', '<cmd>Pick buffers<cr>', {desc = 'Search open files'})
vim.keymap.set('n', '<leader>fs', '<cmd>Pick files<cr>', {desc = 'Search all files'})
vim.keymap.set('n', '<leader>fh', '<cmd>Pick help<cr>', {desc = 'Search help tags'})

function grep_from_search()
  search = vim.api.nvim_eval([[getreg('/')]])
  search = search:gsub("\\[<>]", "\\b")
  require('mini.pick').builtin.grep({tool = 'rg', pattern = search })
end
vim.keymap.set('n', '<leader>ss', ':lua grep_from_search()<CR>', {desc = 'Search all files with grep'})

-- git
vim.pack.add({'https://github.com/tpope/vim-fugitive'})
vim.pack.add({'https://github.com/lewis6991/gitsigns.nvim'})

require('gitsigns').setup({})

vim.keymap.set('n', '<leader>vd', '<cmd>Gdiffsplit!<cr>', {desc = 'Git diff'})
vim.keymap.set('n', '<leader>vs', '<cmd>Git<cr>', {desc = 'Git status'})

-- A.vim
vim.pack.add({'https://github.com/Kris2k/A.vim'})

vim.cmd([[
  let g:alternateNoDefaultAlternate=1
  let g:alternateSearchPath = 'reg:|\([^/]*\)/src|\1/include/\1|'
  let g:alternateSearchPath .= ',reg:|/include/\([^/]*\)|/src|'

  let g:alternateExtensions_h   = "c,cpp,cxx,tpp,txx,cc,CC"
  let g:alternateExtensions_cpp = "hpp,h"
  let g:alternateExtensions_hpp = "cpp"
  let g:alternateExtensions_tpp = "hpp"
  let g:alternateExtensions_txx = "hxx,h"
]])

-- diffview
vim.pack.add({'https://github.com/sindrets/diffview.nvim'})
require("diffview").setup({
  use_icons = false,
  file_panel = {
    win_config = {
      position = "bottom",
      height = 16,
    },
  },
  file_history_panel = {
    win_config = {
      position = "bottom",
      height = 16,
    },
  },
  signs = {
    fold_closed = " ",
    fold_open = " ",
    done = "✓",
  },
  hooks = {
      diff_buf_read = function(bufnr)
          -- Change local options in diff buffers
          vim.opt_local.wrap = false
      end,
  }
})

--------------------------------------------------------------------------------------------
-- Basic Keymaps

--vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', {desc = 'Save file'})

local function map_(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

local function nmap(shortcut, command)
  map_('n', shortcut, command)
end

local function imap(shortcut, command)
  map_('i', shortcut, command)
end

local function vmap(shortcut, command)
  map_('v', shortcut, command)
end

local function cmap(shortcut, command)
  map_('c', shortcut, command)
end

local function tmap(shortcut, command)
  map_('t', shortcut, command)
end

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


-- leader combos
-- b: bookmarks
-- c: general vim (edit/source rcfile, quick fix, ...)
-- e: diagnostics (errors)
-- d: debug
-- f: file (or buffer)
-- s: search
-- v: version control (git)
-- w: window
-- n: notes
nmap('<leader>b', '<nop>')
nmap('<leader>c', '<nop>')
nmap('<leader>d', '<nop>')
nmap('<leader>f', '<nop>')
nmap('<leader>e', '<nop>')
nmap('<leader>s', '<nop>')
nmap('<leader>v', '<nop>')
nmap('<leader>w', '<nop>')
nmap('<leader>n', '<nop>')

-- escape
imap('<C-l>', '<Esc>')
vmap('<C-l>', '<Esc>')
cmap('<C-l>', '<C-c>')
tmap('<Esc>', '<C-\\><C-n>')
tmap('<C-l>', '<C-\\><C-n>')

-- exit
nmap('<F8>', ':qa<CR>')

-- stop from hitting F1 by accident
imap('<F1>', '<Esc>')
vmap('<F1>', '<Esc>')

-- turn off highlighted search
nmap('<C-N>', ':noh<CR>')

-- window size
nmap('<leader>l', '20<C-W>>')
nmap('<leader>h', '20<C-W><')
nmap('<leader>k', '5<C-W>-')
nmap('<leader>j', '5<C-W>+')
nmap('<leader>L', '40<C-W>>')
nmap('<leader>H', '40<C-W><')

-- movements
nmap('J', '}')
vmap('J', '}')
nmap('K', '{')
vmap('K', '{')

nmap('Q', 'J')
vmap('Q', 'J')

-- yank the current file name
vim.cmd([[
:nnoremap <silent> <leader>fy :let @+ = expand("%")<cr>
]])

-- Quick Fix
nmap('<leader>co', ':copen<CR>')
nmap('<leader>cc', ':cclose<CR>')
nmap('<leader>cn', ':cnext<CR>')
nmap('<leader>cf', ':cfile<CR>')


-- clang-format
--vim.cmd([[
--:let g:clang_format_path = '/usr/local/rtc/llvm/19.1.2/bin/clang-format'
--]])
--local clangformat = '/usr/local/rtc/llvm/19.1.2/share/clang/clang-format.py'
--nmap('<c-K>', ':py3f ' .. clangformat .. '<cr>')
--vmap('<c-K>', ':py3f ' .. clangformat .. '<cr>')
--imap('<c-K>', '<c-o>:py3f ' .. clangformat .. '<cr>')
--
--local clangformat_frank = '/home/frank/bin/clang-format.py'
--nmap('<c-F>', ':py3f ' .. clangformat_frank .. '<cr>')
--vmap('<c-F>', ':py3f ' .. clangformat_frank .. '<cr>')
--imap('<c-F>', '<c-o>:py3f ' .. clangformat_frank .. '<cr>')

