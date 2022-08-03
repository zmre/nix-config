-- This is a mega file. Rather than make each plugin have its own config file,
-- which is how I managed my packer-based nvim config prior to Nix, I'm
-- putting everything in here in sections and themed functions. It just makes it
-- easier for me to quickly update things and it's cleaner when there's
-- interdependencies between plugins. We'll see how it goes.
local M = {}

M.signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" }
}
M.kind_icons = {
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

----------------------- UI --------------------------------
-- Tree, GitSigns, Indent markers, Colorizer, bufferline, lualine, treesitter
M.ui = function()
  -- following options are the default
  -- each of these are documented in `:help nvim-tree.OPTION_NAME`
  local nvim_tree_config = require("nvim-tree.config")
  local tree_cb = nvim_tree_config.nvim_tree_callback
  require 'nvim-tree'.setup {
    renderer = {
      icons = {
        webdev_colors = true,
        git_placement = "before",
        padding = " ",
        symlink_arrow = " ➛ ",
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true
        },
        glyphs = {
          default = "",
          symlink = "",
          git = {
            unstaged = "",
            staged = "✓",
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
      }
    },
    -- disables netrw completely
    disable_netrw = true,
    -- hijack netrw window on startup
    hijack_netrw = true,
    -- open the tree when running this setup function
    open_on_setup = false,
    update_cwd = true,
    -- update_to_buf_dir = { enable = true, auto_open = true },
    update_focused_file = { enable = true, update_cwd = true },
    -- show lsp diagnostics in the signcolumn
    diagnostics = {
      enable = true,
      icons = { hint = "", info = "", warning = "", error = "" }
    },
    view = {
      width = 30,
      height = 30,
      hide_root_folder = false,
      side = "left",
      -- auto_resize = true,
      mappings = {
        custom_only = false,
        list = {
          { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
          { key = "h", cb = tree_cb "close_node" },
          { key = "v", cb = tree_cb "vsplit" }
        }
      },
      number = false,
      relativenumber = false
    }
  }

  for _, sign in ipairs(M.signs) do
    vim.fn.sign_define(sign.name,
      { texthl = sign.name, text = sign.text, numhl = "" })
  end

  require("nvim-surround").setup({})

  require("todo-comments").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    signs = false, -- show icons in the signs column
    keywords = {
      FIX = {
        icon = " ", -- icon used for the sign, and in search results
        color = "error", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
        -- signs = false, -- configure signs for some keywords individually
      },
      TODO = { icon = " ", color = "info", alt = { "PWTODO", "TK" } },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    },
    merge_keywords = true, -- when true, custom keywords will be merged with the defaults
    -- highlighting of the line containing the todo comment
    -- * before: highlights before the keyword (typically comment characters)
    -- * keyword: highlights of the keyword
    -- * after: highlights after the keyword (todo text)
    highlight = {
      before = "", -- "fg" or "bg" or empty
      keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
      after = "fg", -- "fg" or "bg" or empty
      pattern = [[.*<(KEYWORDS)\s*:*]], -- pattern or table of patterns, used for highlightng (vim regex)
      comments_only = false, -- uses treesitter to match keywords in comments only
      max_line_len = 400, -- ignore lines longer than this
      exclude = {}, -- list of file types to exclude highlighting
    },
    -- list of named colors where we try to extract the guifg from the
    -- list of hilight groups or use the hex color if hl not found as a fallback
    colors = {
      error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
      warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
      info = { "DiagnosticInfo", "#2563EB" },
      hint = { "DiagnosticHint", "#10B981" },
      default = { "Identifier", "#7C3AED" },
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      -- regex that will be used to match keywords.
      -- don't replace the (KEYWORDS) placeholder
      pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
    },
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

  vim.g.indentLine_enabled = 1
  vim.g.indent_blankline_char = '┊'
  -- vim.g.indent_blankline_char = "▏"
  vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
  vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
  vim.g.indent_blankline_char_highlight = 'LineNr'
  vim.g.indent_blankline_show_trailing_blankline_indent = false
  vim.g.indent_blankline_filetype_exclude = {
    "help", "startify", "dashboard", "packer", "neogitstatus", "NvimTree",
    "Trouble"
  }
  vim.g.indent_blankline_use_treesitter = true
  vim.g.indent_blankline_show_current_context = true
  vim.g.indent_blankline_context_patterns = {
    "class", "return", "function", "method", "^if", "^while", "jsx_element",
    "^for", "^object", "^table", "block", "arguments", "if_statement",
    "else_clause", "jsx_element", "jsx_self_closing_element",
    "try_statement", "catch_clause", "import_statement", "operation_type"
  }
  -- HACK: work-around for https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
  vim.wo.colorcolumn = "99999"
  require('indent_blankline').setup({ show_current_context = true })

  require("colorizer").setup()
  require('lualine').setup {
    options = {
      theme = 'papercolor_light',
      icons_enabled = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' }
    },
    extensions = { 'quickfix', 'nvim-tree', 'fugitive' },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = { 'nvim-tree', 'filename' },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = {
        {
          'diagnostics',
          sources = { 'nvim_diagnostic' },
          -- displays diagnostics from defined severity
          sections = { 'error', 'warn' }, -- 'info', 'hint'},}}
          color_error = "#E06C75", -- changes diagnostic's error foreground color
          color_warn = "#E5C07B"
        }
      }
    }
  }
  require 'nvim-treesitter.configs'.setup {
    highlight = { enable = true, additional_vim_regex_highlighting = { "markdown" } },
    indent = { enable = true, disable = { "yaml" } },
    context_commentstring = {
      enable = true,
      enable_autocmd = false -- per directions for kommentary integration https://github.com/joosepalviste/nvim-ts-context-commentstring/
    }
  }
  require 'treesitter-context'.setup {
    patterns = {
      markdown = { "atx_heading" }
    },
  }

  require 'bufferline'.setup {
    options = {
      numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
      close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
      right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
      left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
      middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
      indicator_icon = "▎",
      buffer_close_icon = "",
      -- buffer_close_icon = '',
      modified_icon = "●",
      close_icon = "",
      -- close_icon = '',
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 40,
      max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
      tab_size = 20,
      name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
        -- remove extension from markdown files for example
        if buf.name:match('%.md') then
          return vim.fn.fnamemodify(buf.name, ':t:r')
        end
      end,
      diagnostics = false, -- | "nvim_lsp" | "coc",
      diagnostics_update_in_insert = false,
      offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      show_tab_indicators = true,
      persist_buffer_sort = false, -- whether or not custom sorted buffers should persist
      -- can also be a table containing 2 custom separators
      -- [focused and unfocused]. eg: { '|', '|' }
      separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
      enforce_regular_tabs = false, -- if true, all tabs same width
      always_show_bufferline = true
    },
    highlights = {
      fill = {
        guifg = { attribute = "fg", highlight = "#ff0000" },
        guibg = { attribute = "bg", highlight = "TabLine" }
      },
      background = {
        guifg = { attribute = "fg", highlight = "TabLine" },
        guibg = { attribute = "bg", highlight = "TabLine" }
      },

      buffer_visible = {
        guifg = { attribute = "fg", highlight = "TabLine" },
        guibg = { attribute = "bg", highlight = "TabLine" }
      },

      close_button = {
        guifg = { attribute = "fg", highlight = "TabLine" },
        guibg = { attribute = "bg", highlight = "TabLine" }
      },
      close_button_visible = {
        guifg = { attribute = "fg", highlight = "TabLine" },
        guibg = { attribute = "bg", highlight = "TabLine" }
      },
      tab_selected = {
        guifg = { attribute = "fg", highlight = "Normal" },
        guibg = { attribute = "bg", highlight = "Normal" }
      },
      tab = {
        guifg = { attribute = "fg", highlight = "TabLine" },
        guibg = { attribute = "bg", highlight = "TabLine" }
      },
      tab_close = {
        -- guifg = {attribute='fg',highlight='LspDiagnosticsDefaultError'},
        guifg = { attribute = "fg", highlight = "TabLineSel" },
        guibg = { attribute = "bg", highlight = "Normal" }
      },

      duplicate_selected = {
        guifg = { attribute = "fg", highlight = "TabLineSel" },
        guibg = { attribute = "bg", highlight = "TabLineSel" },
        gui = "italic"
      },
      duplicate_visible = {
        guifg = { attribute = "fg", highlight = "TabLine" },
        guibg = { attribute = "bg", highlight = "TabLine" },
        gui = "italic"
      },
      duplicate = {
        guifg = { attribute = "fg", highlight = "TabLine" },
        guibg = { attribute = "bg", highlight = "TabLine" },
        gui = "italic"
      },

      modified = {
        guifg = { attribute = "fg", highlight = "TabLine" },
        guibg = { attribute = "bg", highlight = "TabLine" }
      },
      modified_selected = {
        guifg = { attribute = "fg", highlight = "Normal" },
        guibg = { attribute = "bg", highlight = "Normal" }
      },
      modified_visible = {
        guifg = { attribute = "fg", highlight = "TabLine" },
        guibg = { attribute = "bg", highlight = "TabLine" }
      },

      separator = {
        guifg = { attribute = "bg", highlight = "TabLine" },
        guibg = { attribute = "bg", highlight = "TabLine" }
      },
      separator_selected = {
        guifg = { attribute = "bg", highlight = "Normal" },
        guibg = { attribute = "bg", highlight = "Normal" }
      },
      indicator_selected = {
        guifg = {
          attribute = "fg",
          highlight = "LspDiagnosticsDefaultHint"
        },
        guibg = { attribute = "bg", highlight = "Normal" }
      }
    }
  }

end -- UI setup

----------------------- DIAGNOSTICS --------------------------------
M.diagnostics = function()
  vim.diagnostic.config({
    virtual_text = false,
    signs = { active = { M.signs } },
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
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded" })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

  local function attached(client, bufnr)
    local function buf_set_keymap(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    local opts = { noremap = true, silent = false }
    if client.name == "tsserver" or client.name == "jsonls" or client.name ==
        "rnix" or client.name == "eslint" or client.name == "html" then
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end

    print("LSP attached " .. client.name)

    local which_key = require("which-key")
    local local_leader_opts = {
      mode = "n", -- NORMAL mode
      prefix = "<leader>",
      buffer = bufnr, -- Local mappings.
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = true -- use `nowait` when creating keymaps
    }
    local local_leader_opts_visual = {
      mode = "v", -- VISUAL mode
      prefix = "<leader>",
      buffer = bufnr, -- Local mappings.
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = true -- use `nowait` when creating keymaps
    }

    local leader_mappings = {
      ["q"] = { "<cmd>TroubleToggle<CR>", "Show Trouble list" },
      l = {
        name = "Local LSP",
        s = { "<cmd>SymbolsOutline<CR>", "Show Symbols" },
        d = {
          "<Cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition"
        },
        D = {
          "<cmd>lua vim.lsp.buf.implementation()<CR>",
          "Implementation"
        },
        i = { "<Cmd>lua vim.lsp.buf.hover()<CR>", "Info hover" },
        I = {
          "<Cmd>Telescope lsp_implementations<CR>", "Implementations"
        },
        r = { "<cmd>Telescope lsp_references<CR>", "References" },
        f = {
          "<cmd>Telescope lsp_code_actions theme=cursor<CR>",
          "Fix Code Actions"
        },
        t = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature" },
        e = {
          "<cmd>lua vim.diagnostic.open_float()<CR>",
          "Show Line Diags"
        }
      },
      f = {
        ["sd"] = {
          "<cmd>Telescope lsp_document_symbols<CR>",
          "Find symbol in document"
        },
        ["sw"] = {
          "<cmd>Telescope lsp_workspace_symbols<CR>",
          "Find symbol in workspace"
        }
      }
    }
    which_key.register(leader_mappings, local_leader_opts)
    -- Create a new note after asking for its title.
    buf_set_keymap('', "#7", "<cmd>SymbolsOutline<CR>", opts)
    buf_set_keymap('!', "#7", "<cmd>SymbolsOutline<CR>", opts)
    buf_set_keymap('', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    -- override standard tag jump
    buf_set_keymap('', 'C-]', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('!', 'C-]', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
      which_key.register({
        l = {
          ["="] = {
            "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", "Format"
          }
        }
      }, local_leader_opts)
      vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
            ]])
    end
    if client.resolved_capabilities.implementation then
      which_key.register({
        l = {
          ["I"] = {
            "<cmd>Telescope lsp_implementations<CR>",
            "Implementations"
          }
        }
      }, local_leader_opts)
    end
    if client.resolved_capabilities.document_range_formatting then
      which_key.register({
        l = {
          ["="] = {
            "<cmd>lua vim.lsp.buf.range_formatting()<CR>",
            "Format Range"
          }
        }
      }, local_leader_opts_visual)
    end
    if client.resolved_capabilities.rename then
      which_key.register({
        l = { ["R"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" } }
      }, local_leader_opts)
    end
  end

  -- LSP stuff - minimal with defaults for now
  local null_ls = require("null-ls")

  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = null_ls.builtins.formatting
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
  local diagnostics = null_ls.builtins.diagnostics
  local codeactions = null_ls.builtins.code_actions

  null_ls.setup {
    debug = false,
    sources = {
      -- sumneko seems to also have formatting now
      -- formatting.lua_format,
      formatting.nixfmt, formatting.prettier.with {
        -- extra_args = {
        --     "--no-semi", "--single-quote", "--jsx-single-quote"
        -- },
        -- Disable markdown because formatting on save conflicts in weird ways
        -- with the taskwiki (roam-task) stuff.
        disabled_filetypes = { "markdown" }
      }, diagnostics.eslint_d.with {
        args = {
          "-f", "json", "--stdin", "--stdin-filename", "$FILENAME"
        }
      }, diagnostics.proselint, codeactions.proselint, -- diagnostics.vale
      null_ls.builtins.hover.dictionary
      -- removed formatting.rustfmt since rust_analyzer seems to do the same thing
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
  lspconfig.tsserver.setup { capabilities = capabilities, on_attach = attached }
  lspconfig.sumneko_lua.setup {
    settings = { Lua = { diagnostics = { globals = { "vim" } } } },
    on_attach = attached,
    capabilities = capabilities
  }
  lspconfig.svelte.setup { on_attach = attached, capabilities = capabilities }
  lspconfig.tailwindcss.setup {
    on_attach = attached,
    capabilities = capabilities,
    settings = { files = { exclude = { "**/.git/**", "**/node_modules/**", "**/*.md" } } }
  }
  lspconfig.rnix.setup { on_attach = attached, capabilities = capabilities }
  lspconfig.cssls.setup {
    on_attach = attached,
    capabilities = capabilities,
    settings = { css = { lint = { unknownAtRules = "ignore" } } }
  }
  lspconfig.eslint.setup { on_attach = attached, capabilities = capabilities }
  lspconfig.html.setup { on_attach = attached, capabilities = capabilities }
  lspconfig.jsonls.setup {
    on_attach = attached,
    settings = {
      json = {
        schemas = {
          -- Find more schemas here: https://www.schemastore.org/json/
          {
            description = "TypeScript compiler configuration file",
            fileMatch = { "tsconfig.json", "tsconfig.*.json" },
            url = "https://json.schemastore.org/tsconfig.json"
          }, {
            description = "Babel configuration",
            fileMatch = {
              ".babelrc.json", ".babelrc", "babel.config.json"
            },
            url = "https://json.schemastore.org/babelrc.json"
          }, {
            description = "ESLint config",
            fileMatch = { ".eslintrc.json", ".eslintrc" },
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
            fileMatch = { "package.json" },
            url = "https://json.schemastore.org/package.json"
          }
        }
      }
    },
    setup = {
      commands = {
        Format = {
          function()
            vim.lsp.buf.range_formatting({}, { 0, 0 },
              { vim.fn.line "$", 0 })
          end
        }
      }
    },
    capabilities = capabilities
  }

  require 'lspsaga'.init_lsp_saga({
    -- TODO: re-enable this at next update - getting error 2022-08-02
    --code_action_lightbulb = {
    --enable = false,
    --sign = true,
    --enable_in_insert = true,
    --sign_priority = 20,
    --virtual_text = false,
    --},
  })

  require('rust-tools').setup({
    server = { on_attach = attached },
    tools = { autoSetHints = true, inlay_hints = { only_current_line = true } }
  })
  require('crates').setup()

end -- Diagnostics setup

----------------------- TELESCOPE --------------------------------
M.telescope = function()
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  local function paste_selected_entry(prompt_bufnr)
    local entry = action_state.get_selected_entry(prompt_bufnr)
    actions.close(prompt_bufnr)
    -- ensure that the buffer can be written to
    if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(),
      "modifiable") then
      print("Paste!")
      vim.api.nvim_put({ entry.value }, "c", true, true)
    end
  end

  local function yank_selected_entry(prompt_bufnr)
    local entry = action_state.get_selected_entry(prompt_bufnr)
    actions.close(prompt_bufnr)
    -- Put it in the unnamed buffer and the system clipboard both
    vim.api.nvim_call_function("setreg", { '"', entry.value })
    vim.api.nvim_call_function("setreg", { "*", entry.value })
  end

  local function system_open_selected_entry(prompt_bufnr)
    local entry = action_state.get_selected_entry(prompt_bufnr)
    actions.close(prompt_bufnr)
    os.execute("open '" .. entry.value .. "'")
  end

  require('telescope').setup {
    file_ignore_patterns = { "*.bak", ".git/", "node_modules" },
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },
    defaults = {
      mappings = {
        n = {
          --["<C-p>"] = paste_selected_entry,
          ["<C-y>"] = yank_selected_entry,
          ["<C-o>"] = system_open_selected_entry,
          ["q"] = require("telescope.actions").close
        },
        i = {
          --["<C-p>"] = paste_selected_entry,
          ["<C-y>"] = yank_selected_entry,
          ["<C-o>"] = system_open_selected_entry
        }
      }
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    -- Telescope smart history
    history = {
      path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
      limit = 100,
    },
    layout_strategy = "flex",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 1,
    },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

    extensions = {
      fzy_native = {
        override_generic_sorter = true,
        override_file_sorter = true
      }
    }
  }
  require 'telescope'.load_extension('fzy_native')
  require("telescope").load_extension("zk")
  if vim.fn.has('mac') ~= 1 then
    -- doesn't currently work on mac
    require 'telescope'.load_extension('media_files')
  end

end -- telescope

----------------------- COMPLETIONS --------------------------------
-- cmp, luasnip
M.completions = function()
  require("luasnip/loaders/from_vscode").lazy_load()
  local luasnip = require("luasnip")
  local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
  end
  -- find more here: https://www.nerdfonts.com/cheat-sheet
  local cmp = require 'cmp'
  cmp.setup {
    enabled = function()
      local context = require 'cmp.config.context'
      local buftype = vim.api.nvim_buf_get_option(0, "buftype")
      -- prevent completions in prompts like telescope prompt
      if buftype == "prompt" then return false end
      -- allow completions in command mode
      if vim.api.nvim_get_mode().mode == 'c' then return true end
      -- forbid completions in comments
      return not context.in_treesitter_capture("comment") and
          not context.in_syntax_group("Comment")
    end,
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
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" })
    },
    window = { documentation = cmp.config.window.bordered() },
    sources = {
      { name = 'nvim_lsp' }, { name = 'buffer' }, { name = 'emoji' },
      { name = 'nvim_lua' }, { name = 'path' }, { name = "crates" },
      { name = 'luasnip' }
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        -- Kind icons
        vim_item.kind = string.format("%s", M.kind_icons[vim_item.kind])
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]"
        })[entry.source.name]
        return vim_item
      end
    },
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end }
  }
end -- completions

----------------------- NOTES --------------------------------
-- zk (zettelkasten lsp), taskwiki, goyo, grammar
M.notes = function()
  vim.g.taskwiki_disable_concealcursor = 'yes'
  vim.g.taskwiki_markdown_syntax = 'markdown'
  vim.g.taskwiki_markup_syntax = 'markdown'
  vim.g.taskwiki_dont_fold = 1
  vim.g.taskwiki_task_path = '~/Notes/t'
  vim.g.taskwiki_data_location = '~/.task'
  vim.g.taskwiki_task_note_root = 't'
  vim.g.wiki_root = '~/Notes'

  require("zk").setup({
    picker = "telescope",
    -- automatically attach buffers in a zk notebook that match the given filetypes
    lsp = {
      auto_attach = { enabled = true, filetypes = { "markdown", "vimwiki" } },
      config = {
        on_attach = function(_, bufnr)
          print("ZK attached")

          local which_key = require("which-key")
          local local_leader_opts = {
            mode = "n", -- NORMAL mode
            prefix = "<leader>",
            buffer = bufnr, -- Local mappings.
            silent = true, -- use `silent` when creating keymaps
            noremap = true, -- use `noremap` when creating keymaps
            nowait = true -- use `nowait` when creating keymaps
          }
          local local_leader_opts_visual = {
            mode = "v", -- VISUAL mode
            prefix = "<leader>",
            buffer = bufnr, -- Local mappings.
            silent = true, -- use `silent` when creating keymaps
            noremap = true, -- use `noremap` when creating keymaps
            nowait = true -- use `nowait` when creating keymaps
          }

          local leader_mappings = {
            n = {
              -- Create the note in the same directory as the current buffer after asking for title
              p = {
                "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
                "New peer note (same dir)"
              },
              l = { "<Cmd>ZkLinks<CR>", "Show note links" },
              -- the following duplicate with the ,l_ namespace on purpose because of programming muscle memory
              r = {
                "<cmd>Telescope lsp_references<CR>",
                "References to this note"
              },
              i = {
                "<Cmd>lua vim.lsp.buf.hover()<CR>",
                "Info preview"
              }
            },
            l = {
              name = "Local LSP",
              -- Open notes linking to the current buffer.
              r = {
                "<cmd>Telescope lsp_references<CR>",
                "References to this note"
              },
              i = {
                "<Cmd>lua vim.lsp.buf.hover()<CR>",
                "Info preview"
              },
              f = {
                "<cmd>Telescope lsp_code_actions theme=cursor<CR>",
                "Fix Code Actions"
              },
              e = {
                "<cmd>lua vim.diagnostic.open_float()<CR>",
                "Show Line Diags"
              }
            }
          }
          which_key.register(leader_mappings, local_leader_opts)
          local leader_mappings_visual = {
            n = {
              p = {
                ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>",
                "New peer note (same dir) selection for title"
              }
              -- Create a new note in the same directory as the current buffer, using the current selection for title.
            }
          }
          which_key.register(leader_mappings_visual,
            local_leader_opts_visual)

          local opts = { noremap = true, silent = true }

          -- TODO: Make <CR> magic...
          --   in normal mode, if on a link, it should open the link (note or url)
          --   in visual mode, it should prompt for folder, create a note, and make a link
          -- Meanwhile, just go to definition
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<CR>",
            "<Cmd>lua vim.lsp.buf.definition()<CR>",
            opts)
          -- Preview a linked note.
          vim.api.nvim_buf_set_keymap(bufnr, "", "K",
            "<Cmd>lua vim.lsp.buf.hover()<CR>",
            opts)
        end
      }
    }
  })

  -- Focus mode
  -- Color name (:help cterm-colors) or ANSI code
  vim.g.limelight_conceal_ctermfg = 240
  vim.g.limelight_conceal_guifg = '#777777'

  -- Number of preceding/following paragraphs to include (default: 0)
  vim.g.limelight_paragraph_span = 1
  -- Max width for writing
  vim.g.goyo_width = 100

  function Goyo_enter()
    -- Keep cursor roughly centered on the screen in typewriter mode
    vim.opt.scrolloff = 999
    local ft = vim.api.nvim_buf_get_option(0, "filetype")
    if ft == "vimwiki" or ft == "markdown" then
      vim.cmd("Limelight") -- Turn on dimmimng of non-active paragraph
    end
  end

  function Goyo_leave()
    -- Keep cursor roughly centered on the screen in typewriter mode
    vim.opt.scrolloff = 8
    vim.cmd("Limelight!") -- Turn off dimmimng unconditionally
  end

  vim.cmd('autocmd! User GoyoEnter nested lua Goyo_enter()')
  vim.cmd('autocmd! User GoyoLeave nested lua Goyo_leave()')

  -- Grammar
  vim.g["grammarous#disabled_rules"] = {
    ['*'] = {
      'WHITESPACE_RULE', 'EN_QUOTES', 'ARROWS', 'SENTENCE_WHITESPACE',
      'WORD_CONTAINS_UNDERSCORE', 'COMMA_PARENTHESIS_WHITESPACE',
      'EN_UNPAIRED_BRACKETS', 'UPPERCASE_SENTENCE_START',
      'ENGLISH_WORD_REPEAT_BEGINNING_RULE', 'DASH_RULE', 'PLUS_MINUS',
      'PUNCTUATION_PARAGRAPH_END', 'MULTIPLICATION_SIGN', 'PRP_CHECKOUT',
      'CAN_CHECKOUT', 'SOME_OF_THE', 'DOUBLE_PUNCTUATION', 'HELL',
      'CURRENCY', 'POSSESSIVE_APOSTROPHE', 'ENGLISH_WORD_REPEAT_RULE',
      'NON_STANDARD_WORD'
    }
  }
  -- Grammar stuff
  vim.cmd(
    [[command StartGrammar2 lua require('zmre.plugins').grammar_check()]])
end -- notes

M.grammar_check = function()
  vim.cmd('packadd vim-grammarous')
  local opts = { noremap = false, silent = true }
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(0, ...) end

  buf_set_keymap('', '<leader>gf', '<Plug>(grammarous-fixit)', opts)
  buf_set_keymap('', '<leader>gx', '<Plug>(grammarous-remove-error)', opts)
  buf_set_keymap('', ']g', '<Plug>(grammarous-move-to-next-error)', opts)
  buf_set_keymap('', '[g', '<Plug>(grammarous-move-to-previous-error)', opts)
  vim.cmd('GrammarousCheck')
end

----------------------- MISC --------------------------------
-- rooter, kommentary, autopairs, tmux, toggleterm
M.misc = function()
  -- Change project directory using local cd only
  -- vim.g.rooter_cd_cmd = 'lcd'
  -- Look for these files/dirs as hints
  -- vim.g.rooter_patterns = {
  --     '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json',
  --     '.zk', 'Cargo.toml', 'build.sbt', 'Package.swift', 'Makefile.in'
  -- }
  require('project_nvim').setup({
    active = true,
    on_config_done = nil,
    manual_mode = false,
    detection_methods = { "pattern", "lsp" },
    patterns = {
      ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json",
      ".zk", "Cargo.toml", "build.sbt", "Package.swift", "Makefile.in"
    },
    show_hidden = false,
    silent_chdir = true,
    ignore_lsp = {}
  })
  require('telescope').load_extension('projects')

  vim.g.kommentary_create_default_mappings = false
  require('kommentary.config').configure_language({ "lua", "rust" }, {
    prefer_single_line_comments = true
  })
  require('kommentary.config').configure_language({ "lua", "vim", "svelte", "typescriptreact", "markdown", "html",
    "javascriptreact" }, {
    single_line_comment_string = 'auto',
    multi_line_comment_strings = 'auto',
    hook_function = function()
      require('ts_context_commentstring.internal').update_commentstring()
    end,

  })
  vim.api.nvim_set_keymap('n', '<leader>c<space>',
    '<Plug>kommentary_line_default', {})
  vim.api.nvim_set_keymap('v', '<leader>c<space>',
    '<Plug>kommentary_visual_default', {})

  require('nvim-autopairs').setup({})

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
    { noremap = true })

end -- misc

return M
