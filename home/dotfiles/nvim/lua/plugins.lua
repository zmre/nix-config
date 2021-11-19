require'nvim-tree'.setup {
    -- disables netrw completely
    disable_netrw = true,
    -- hijack netrw window on startup
    hijack_netrw = false,
    -- open the tree when running this setup function
    open_on_setup = false,
    -- show lsp diagnostics in the signcolumn
    diagnostics = {
        enable = true,
        icons = {hint = "", info = "", warning = "", error = ""}
    }
}

local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local function paste_selected_entry(prompt_bufnr)
    local entry = action_state.get_selected_entry(prompt_bufnr)
    actions.close(prompt_bufnr)
    -- ensure that the buffer can be written to
    if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "modifiable") then
        print("Paste!")
        vim.api.nvim_put({entry.value}, "c", true, true)
    end
end

local function yank_selected_entry(prompt_bufnr)
    local entry = action_state.get_selected_entry(prompt_bufnr)
    actions.close(prompt_bufnr)
    -- Put it in the unnamed buffer and the system clipboard both
    vim.api.nvim_call_function("setreg", {'"', entry.value})
    vim.api.nvim_call_function("setreg", {"*", entry.value})
end

local function system_open_selected_entry(prompt_bufnr)
    local entry = action_state.get_selected_entry(prompt_bufnr)
    actions.close(prompt_bufnr)
    os.execute("open '" .. entry.value .. "'")
end

require('telescope').setup {
    file_ignore_patterns = {"*.bak"},
    defaults = {
        mappings = {
            n = {
                ["<C-p>"] = paste_selected_entry,
                ["<C-y>"] = yank_selected_entry,
                ["<C-o>"] = system_open_selected_entry
            },
            i = {
                ["<C-p>"] = paste_selected_entry,
                ["<C-y>"] = yank_selected_entry,
                ["<C-o>"] = system_open_selected_entry
            }
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = true,
            override_file_sorter = true
        }
    }
}
require'telescope'.load_extension('fzy_native')

require("gitsigns").setup {
    signs = {
        add = {
            hl = 'GitSignsAdd',
            text = '✚',
            numhl = 'GitSignsAddNr',
            linehl = 'GitSignsAddLn'
        },
        change = {
            hl = 'GitSignsChange',
            text = '│',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn'
        },
        delete = {
            hl = 'GitSignsDelete',
            text = '_',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn'
        },
        topdelete = {
            hl = 'GitSignsDelete',
            text = '‾',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn'
        },
        changedelete = {
            hl = 'GitSignsChange',
            text = '~',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn'
        }
    }
}

vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = {'help', 'packer'}
vim.g.indent_blankline_buftype_exclude = {'terminal', 'nofile'}
vim.g.indent_blankline_char_highlight = 'LineNr'
vim.g.indent_blankline_show_trailing_blankline_indent = false

require('kommentary.config').configure_language({"lua", "rust"}, {
    prefer_single_line_comments = true
})
vim.g.kommentary_create_default_mappings = false
vim.api.nvim_set_keymap('n', '<leader>c<space>',
                        '<Plug>kommentary_line_default', {})
vim.api.nvim_set_keymap('v', '<leader>c<space>',
                        '<Plug>kommentary_visual_default', {})
vim.o.completeopt = "menuone,noselect"

local cmp = require 'cmp'
cmp.setup {
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        },
        ['<Tab>'] = function(fallback)
            if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true,
                                                               true, true), 'n')
                --[[ elseif luasnip.expand_or_jumpable() then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
                                        '<Plug>luasnip-expand-or-jump', true,                                        true, true), '') ]]
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true,
                                                               true, true), 'n')
                --[[ elseif luasnip.jumpable(-1) then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
                                        '<Plug>luasnip-jump-prev', true, true,
                                        true), '') ]]
            else
                fallback()
            end
        end
    },
    sources = {
        {name = 'nvim_lsp'}, -- {name = 'luasnip'},
        {name = 'buffer'}, {name = 'emoji'}, {name = 'nvim_lua'},
        {name = "crates"}
    }

}

require('nvim-autopairs').setup({})
require("colorizer").setup()
vim.g.bufferline = {
    animation = true,
    closable = true,
    clickable = true,
    maximum_length = 40,
    icons = true
    -- exclude_name = {''},
    -- exclude_ft = {''},
}

vim.g.neoformat_try_formatprg = 1
-- Enable alignment
vim.g.neoformat_basic_format_align = 1

-- Enable tab to spaces conversion
vim.g.neoformat_basic_format_retab = 1

-- Enable trimmming of trailing whitespace
vim.g.neoformat_basic_format_trim = 1
vim.g.neoformat_run_all_formatters = 1
vim.api.nvim_exec([[
  augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
  augroup END
]], false)

require("toggleterm").setup {
    open_mapping = [[<c-\>]],
    direction = 'vertical',
    close_on_exit = true
}

require('lualine').setup {
    options = {
        theme = 'papercolor_light',
        icons_enabled = true,
        component_separators = {left = '', right = ''},
        section_separators = {left = '', right = ''}
    },
    extensions = {'quickfix', 'nvim-tree', 'fugitive'},
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch'},
        lualine_c = {'nvim-tree', 'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {
            {
                'diagnostics',
                sources = {'nvim_lsp'},
                -- displays diagnostics from defined severity
                sections = {'error', 'warn'}, -- 'info', 'hint'},}}
                color_error = "#E06C75", -- changes diagnostic's error foreground color
                color_warn = "#E5C07B"
                -- symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'}
            }
        }
    }
}
require'nvim-tmux-navigation'.setup {}

-- LSP stuff - minimal with defaults for now
local lspconfig = require("lspconfig")
lspconfig.rust_analyzer.setup {}
lspconfig.tsserver.setup {}
lspconfig.sumneko_lua.setup {}
lspconfig.rnix.setup {}
require'lspsaga'.init_lsp_saga()
require"lsp_signature".setup()
require('lspkind').init({})
require('rust-tools').setup({})
require'nvim-treesitter.configs'.setup {highlight = {enable = true}}
require("nvim-lsp-ts-utils").setup({})
