local signs = {
    {name = "DiagnosticSignError", text = ""},
    {name = "DiagnosticSignWarn", text = ""},
    {name = "DiagnosticSignHint", text = ""},
    {name = "DiagnosticSignInfo", text = ""}
}
-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
vim.g.nvim_tree_icons = {
    default = "",
    symlink = "",
    git = {
        unstaged = "",
        staged = "S",
        unmerged = "",
        renamed = "➜",
        deleted = "",
        untracked = "U",
        ignored = "◌"
    },
    folder = {
        default = "",
        open = "",
        empty = "",
        empty_open = "",
        symlink = ""
    }
}
local nvim_tree_config = require("nvim-tree.config")
local tree_cb = nvim_tree_config.nvim_tree_callback
require'nvim-tree'.setup {
    -- disables netrw completely
    disable_netrw = true,
    -- hijack netrw window on startup
    hijack_netrw = true,
    -- open the tree when running this setup function
    open_on_setup = false,
    auto_close = true,
    update_to_buf_dir = {enable = true, auto_open = true},
    update_focused_file = {enable = true, update_cwd = true},
    -- show lsp diagnostics in the signcolumn
    diagnostics = {
        enable = true,
        icons = {hint = "", info = "", warning = "", error = ""}
    },
    view = {
        width = 30,
        height = 30,
        hide_root_folder = false,
        side = "left",
        auto_resize = true,
        mappings = {
            custom_only = false,
            list = {
                {key = {"l", "<CR>", "o"}, cb = tree_cb "edit"},
                {key = "h", cb = tree_cb "close_node"},
                {key = "v", cb = tree_cb "vsplit"}
            }
        },
        number = false,
        relativenumber = false
    }
}
for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name,
                       {texthl = sign.name, text = sign.text, numhl = ""})
end
vim.diagnostic.config({
    virtual_text = false,
    signs = {active = {signs}},
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = ""
    }
})
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})

vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded"})

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
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = {"smart"},
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
-- TODO: make this attempt only on linux
require'telescope'.load_extension('media_files')

-- Change project directory using local cd only
vim.g.rooter_cd_cmd = 'lcd'
-- Look for these files/dirs as hints
vim.g.rooter_patterns = {
    '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', '.zk',
    'Cargo.toml', 'build.sbt', 'Package.swift', 'Makefile.in'
}

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

require("luasnip/loaders/from_vscode").lazy_load()
local luasnip = require("luasnip")
local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end
local kind_icons = {
    Text = "",
    Method = "m",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = ""
}
-- find more here: https://www.nerdfonts.com/cheat-sheet
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
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expandable() then
                luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif check_backspace() then
                fallback()
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {"i", "s"})
    },
    documentation = true,
    sources = {
        {name = 'nvim_lsp'}, {name = 'buffer'}, {name = 'emoji'},
        {name = 'nvim_lua'}, {name = 'path'}, {name = "crates"},
        {name = 'luasnip'}
    },
    formatting = {
        fields = {"kind", "abbr", "menu"},
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]"
            })[entry.source.name]
            return vim_item
        end
    },
    snippet = {expand = function(args) luasnip.lsp_expand(args.body) end}
}

require('crates').setup()
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

-- vim.g.neoformat_try_formatprg = 1
-- -- Enable alignment
-- vim.g.neoformat_basic_format_align = 1

-- -- Enable tab to spaces conversion
-- vim.g.neoformat_basic_format_retab = 1

-- -- Enable trimmming of trailing whitespace
-- vim.g.neoformat_basic_format_trim = 1
-- vim.g.neoformat_run_all_formatters = 1
-- vim.api.nvim_exec([[
--   augroup fmt
--     autocmd!
--     autocmd BufWritePre * undojoin | Neoformat
--   augroup END
-- ]], false)

vim.g.tmux_navigator_no_mappings = 1

require("toggleterm").setup {
    open_mapping = [[<c-\>]],
    insert_mappings = true, -- from normal or insert mode
    start_in_insert = true,
    hide_numbers = true,
    direction = 'vertical',
    size = function(_) return vim.o.columns * 0.3 end,
    close_on_exit = true
}
vim.api.nvim_set_keymap('t', [[<C-\]], "<Cmd>ToggleTermToggleAll<cr>",
                        {noremap = true})

require("zk").setup({
    picker = "telescope",
    -- automatically attach buffers in a zk notebook that match the given filetypes
    lsp = {
        auto_attach = {enabled = true, filetypes = {"markdown", "vimwiki"}},
        config = {
            on_attach = function(_, bufnr)
                local opts = {noremap = true, silent = true}
                -- Create a new note after asking for its title.
                vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>zn",
                                            "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
                                            opts)
                -- Open notes.
                vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>zo",
                                            "<Cmd>ZkNotes<CR>", opts)
                -- Open notes associated with the selected tags.
                vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>zt",
                                            "<Cmd>ZkTags<CR>", opts)

                -- Search for the notes matching a given query.
                vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>zf",
                                            "<Cmd>ZkNotes { match = vim.fn.input('Search: ') }<CR>",
                                            opts)
                -- Search for the notes matching the current visual selection.
                vim.api.nvim_buf_set_keymap(bufnr, "v", "<leader>zf",
                                            ":'<,'>ZkMatch<CR>", opts)
                -- Open the link under the caret.
                vim.api.nvim_buf_set_keymap(bufnr, "n", "<CR>",
                                            "<Cmd>lua vim.lsp.buf.definition()<CR>",
                                            opts)
                -- Create the note in the same directory as the current buffer after asking for title
                vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>znt",
                                            "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
                                            opts)
                -- Create a new note in the same directory as the current buffer, using the current selection for title.
                vim.api.nvim_buf_set_keymap(bufnr, "v", "<leader>znt",
                                            ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>",
                                            opts)
                -- Open notes linking to the current buffer.
                vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>zb",
                                            "<Cmd>lua vim.lsp.buf.references()<CR>",
                                            opts)
                -- Open notes linked by the current buffer.
                vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>zl",
                                            "<Cmd>ZkLinks<CR>", opts)
                -- Preview a linked note.
                vim.api.nvim_buf_set_keymap(bufnr, "n", "K",
                                            "<Cmd>lua vim.lsp.buf.hover()<CR>",
                                            opts)
                -- Open the code actions for a visual selection.
                vim.api.nvim_buf_set_keymap(bufnr, "v", "<leader>za",
                                            ":'<,'>lua vim.lsp.buf.range_code_action()<CR>",
                                            opts)
            end
        }
    }
})

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
                sources = {'nvim_diagnostic'},
                -- displays diagnostics from defined severity
                sections = {'error', 'warn'}, -- 'info', 'hint'},}}
                color_error = "#E06C75", -- changes diagnostic's error foreground color
                color_warn = "#E5C07B"
            }
        }
    }
}

local function attached(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local opts = {noremap = true, silent = false}
    if client.name == "tsserver" then
        client.resolved_capabilities.document_formatting = false
    end
    print("LSP attached")

    -- Create a new note after asking for its title.
    buf_set_keymap('', "#7", "<cmd>SymbolsOutline<CR>", opts)
    buf_set_keymap('!', "#7", "<cmd>SymbolsOutline<CR>", opts)
    buf_set_keymap('', '<leader>gs', '<cmd>SymbolsOutline<CR>', opts)
    buf_set_keymap('', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('', "<leader>gD",
                   "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap('', "<leader>gi", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap('', "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>",
                   opts)
    buf_set_keymap('', "<leader>gr", "<Cmd>Telescope lsp_references<CR>", opts)
    buf_set_keymap('', "<leader>fsd",
                   "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
    buf_set_keymap('', "<leader>fsw",
                   "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
    -- buf_set_keymap('n', "<leader>gf", "<cmd>lua vim.lsp.buf.code_action()<CR>",
    -- opts)
    buf_set_keymap('n', "<leader>gf",
                   "<cmd>Telescope lsp_code_actions theme=cursor<CR>", opts)
    buf_set_keymap('v', "<leader>gf",
                   "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
    buf_set_keymap('', "<leader>gt",
                   "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap('', "<leader>ge",
                   "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>",
                   opts)
    buf_set_keymap('', "<leader>q", ":TroubleToggle<CR>", opts)
    buf_set_keymap('', "[e", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap('', "]e", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<leader>g=",
                       "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", opts)
        buf_set_keymap("v", "<leader>g=",
                       "<cmd>lua vim.lsp.buf.rang_formatting()<CR>", opts)
        vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
            ]])
    end
    if client.resolved_capabilities.implementation then
        buf_set_keymap('', "<leader>gI", ":Telescope lsp_implementations<CR>",
                       opts)
    end
    if client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("v", "<leader>=",
                       "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end
    if client.resolved_capabilities.rename then
        buf_set_keymap('', "<leader>gR", "<cmd>lua vim.lsp.buf.rename()<CR>",
                       opts)
    end
end

-- LSP stuff - minimal with defaults for now
local null_ls = require("null-ls")

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup {
    debug = false,
    sources = {
        formatting.lua_format, formatting.nixfmt, formatting.prettier.with {
            extra_args = {"--no-semi", "--single-quote", "--jsx-single-quote"}
        }, formatting.rustfmt, diagnostics.eslint_d
    },
    on_attach = attached
}
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
cmp_nvim_lsp.update_capabilities(capabilities)

lspconfig.rust_analyzer.setup {
    on_attach = attached,
    capabilities = capabilities
}
lspconfig.tsserver.setup {
    -- Needed for inlayHints. Merge this table with your settings or copy
    -- it from the source if you want to add your own init_options.
    -- init_options = require("nvim-lsp-ts-utils").init_options
    capabilities = capabilities
}
lspconfig.sumneko_lua.setup {
    settings = {Lua = {diagnostics = {globals = {"vim"}}}},
    on_attach = attached,
    capabilities = capabilities
}
lspconfig.rnix.setup {on_attach = attached, capabilities = capabilities}
lspconfig.cssls.setup {capabilities = capabilities}
lspconfig.eslint.setup {capabilities = capabilities}
lspconfig.html.setup {capabilities = capabilities}
lspconfig.jsonls.setup {
    settings = {
        json = {
            schemas = {
                -- Find more schemas here: https://www.schemastore.org/json/
                {
                    description = "TypeScript compiler configuration file",
                    fileMatch = {"tsconfig.json", "tsconfig.*.json"},
                    url = "https://json.schemastore.org/tsconfig.json"
                }, {
                    description = "Babel configuration",
                    fileMatch = {
                        ".babelrc.json", ".babelrc", "babel.config.json"
                    },
                    url = "https://json.schemastore.org/babelrc.json"
                }, {
                    description = "ESLint config",
                    fileMatch = {".eslintrc.json", ".eslintrc"},
                    url = "https://json.schemastore.org/eslintrc.json"
                }, {
                    description = "Prettier config",
                    fileMatch = {
                        ".prettierrc", ".prettierrc.json",
                        "prettier.config.json"
                    },
                    url = "https://json.schemastore.org/prettierrc"
                }, {
                    description = "Stylelint config",
                    fileMatch = {
                        ".stylelintrc", ".stylelintrc.json",
                        "stylelint.config.json"
                    },
                    url = "https://json.schemastore.org/stylelintrc"
                }, {
                    description = "Json schema for properties json file for a GitHub Workflow template",
                    fileMatch = {
                        ".github/workflow-templates/**.properties.json"
                    },
                    url = "https://json.schemastore.org/github-workflow-template-properties.json"
                }, {
                    description = "NPM configuration file",
                    fileMatch = {"package.json"},
                    url = "https://json.schemastore.org/package.json"
                }
            }
        }
    },
    setup = {
        commands = {
            Format = {
                function()
                    vim.lsp.buf.range_formatting({}, {0, 0},
                                                 {vim.fn.line "$", 0})
                end
            }
        }
    },
    capabilities = capabilities
}

-- temporarily disabled due to bugs editing nix files 2021-12
-- require'lspsaga'.init_lsp_saga()
require('rust-tools').setup({server = {on_attach = attached}})

require'nvim-treesitter.configs'.setup {
    highlight = {enable = true, additional_vim_regex_highlighting = true},
    indent = {enable = true, disable = {"yaml"}}
}
