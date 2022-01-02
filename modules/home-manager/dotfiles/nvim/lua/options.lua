local M = {}

M.defaults = function()
    local opt = vim.opt

    -- disable builtin vim plugins
    vim.g.loaded_gzip = 0
    vim.g.loaded_tar = 0
    vim.g.loaded_tarPlugin = 0
    vim.g.loaded_zipPlugin = 0
    vim.g.loaded_2html_plugin = 0
    vim.g.loaded_netrw = 0
    vim.g.loaded_netrwPlugin = 0
    -- vim.g.loaded_matchit = 0
    -- vim.g.loaded_matchparen = 0
    vim.g.loaded_spec = 0

    opt.spell = true
    opt.spelllang = "en_us"
    opt.ruler = true -- show the cursor position all the time
    opt.secure = true -- don't execute shell cmds in .vimrc not owned by me
    opt.history = 50 -- keep 50 lines of command line history
    opt.shell = "zsh"
    opt.modelines = 0 -- Don't allow vim settings embedded in text files for security reasons
    opt.showcmd = true -- display incomplete commands
    opt.showmode = true -- display current mode
    opt.backup = false
    opt.writebackup = true
    opt.backupcopy = "auto"
    opt.hidden = true
    opt.cf = true -- jump to errors based on error files
    opt.listchars = "tab:⇥ ,trail:␣,extends:⇉,precedes:⇇,nbsp:·"
    opt.list = true -- render special chars (tabs, trails, ...)
    opt.ttyfast = true
    opt.expandtab = true
    opt.splitbelow = true -- allow splits below
    opt.splitright = true -- and to the right
    opt.dictionary = opt.dictionary +
                         {'/usr/share/dict/words', '~/.aspell.english.pws'}
    opt.complete = opt.complete + {'k', ']'}
    opt.complete = opt.complete - {'i'}
    opt.encoding = "utf-8"
    opt.backspace = "indent,eol,start" -- allow backspacing over everything in insert mode
    opt.joinspaces = false -- don't insert two spaces after sentences on joins
    opt.binary = false
    opt.display = "lastline"
    opt.viewoptions = "folds,cursor,unix,slash" -- better unix / windows compatibility
    opt.shortmess = "filnxtToSAcOF"
    opt.foldnestmax = 5

    -- wrapping
    opt.wrap = true
    opt.sidescroll = 2 -- min number of columns to scroll from edge
    opt.scrolloff = 4 -- when 4 away from edge start scrolling
    opt.sidescrolloff = 4 -- keep cursor one col from end of line
    opt.textwidth = 0
    opt.breakindent = true
    opt.showbreak = "» "
    opt.breakat = opt.breakat - {'/', '*', '_', '`'}
    opt.linebreak = true -- wraps on word boundaries but only if nolist is set

    -- Make tabs be spaces of 4 characters by default
    opt.tabstop = 4
    opt.shiftwidth = 4
    opt.softtabstop = 4
    opt.expandtab = true -- turn tabs to spaces by default

    opt.autoindent = true -- autoindent to same level as previous line
    opt.smartindent = true -- indent after { and cinwords words
    opt.smartcase = true -- intelligently ignore case in searches
    opt.ignorecase = true -- default to not being case sensitive
    opt.smarttab = true
    opt.icm = "nosplit" -- show substitutions as you type
    opt.hlsearch = false
    opt.updatetime = 250 -- Decrease update time
    vim.wo.signcolumn = 'yes'
    opt.visualbell = true
    opt.autoread = true -- auto reload files changed on disk if not changed in buffer
    opt.cursorline = false
    opt.ttyfast = true
    opt.formatoptions = 'jcroqlt' -- t=text, c=comments, q=format with "gq"
    opt.showmatch = true -- auto hilights matching bracket or paren
    opt.nrformats = opt.nrformats - {'octal'}
    opt.shiftround = true
    opt.ttimeout = true
    opt.ttimeoutlen = 50
    opt.fileformats = "unix,dos,mac"
    opt.matchpairs = "(:),{:},[:],<:>"
    opt.number = false
    opt.relativenumber = false
    opt.completeopt = "menu,menuone,noselect" -- needed for autocompletion stuff

    -- Globals
    vim.g.vimsyn_embed = 'l' -- Highlight Lua code inside .vim files
    vim.g.polyglot_disabled = {'markdown'}
    vim.g.foldlevelstart = 3

    -- map the leader key
    vim.api.nvim_set_keymap('n', ',', '', {})
    vim.g.mapleader = ',' -- Namespace for custom shortcuts

    -- TODO: Do this a more lua native way
    vim.cmd([[filetype plugin indent on]])
    vim.cmd('syn sync minlines=5000')
    vim.cmd('syntax on')
    vim.cmd('runtime vim/colors.vim')

    -- Brief highlight on yank
    vim.api.nvim_exec([[
    augroup YankHighlight
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank()
    augroup end
    ]], false)
end

M.gui = function()
    vim.opt.title = true
    vim.opt.switchbuf = "useopen,usetab,newtab"
    -- vim.opt.guifont = "Liga MesloLGL Nerd Font:h16"
    -- vim.opt.guifont = "Liga DejaVuSansMono Nerd Font:h16"
    -- vim.opt.guifont = "FiraCode Nerd Font:h16" -- no italics
    vim.opt.guifont = "Hasklug Nerd Font:h9"
    if vim.g.neovide ~= nil then
        vim.g.neovide_transparency = 0.8
        vim.g.neovide_cursor_animation_length = 0.01
        vim.g.neovide_cursor_trail_length = 0.1
        vim.g.neovide_cursor_antialiasing = true
        -- Needed so Neovide can find rustfmt and probably other rust tools
        vim.env.PATH = vim.env.PATH .. ':/Users/pwalsh/.cargo/bin'
    end
    vim.opt.mouse = "nv" -- only use mouse in normal and visual modes (notably not insert and command)
    vim.opt.mousemodel = "popup_setpos"
    -- use the system clipboard for all unnamed yank operations
    vim.opt.clipboard = "unnamedplus"

    -- 2021-07-18 something wacky with guioptions right now
    -- print(vim.inspect(vim.api.nvim_get_option_info("guioptions")))
    -- if vim.opt["guioptions"] ~= nil then
    -- vim.api.nvim_set_option("guioptions", "gmrLae")
    -- print(vim.inspect(vim.api.nvim_get_option("guioptions")))
    -- end
    vim.g.neovide_cursor_animation_length = 0.01
    vim.g.neovide_cursor_trail_length = 0.1
    vim.g.neovide_refresh_rate = 140
    -- vim.g.neovide_transparency=0.8
    vim.g.neovide_input_use_logo = true

    -- nvim-qt options
    -- Disable GUI Tabline
    vim.api.nvim_exec([[
      if exists(':GuiTabline')
          GuiTabline 0
      endif
    ]], false)
end

M.twospaceindent = function()
    vim.bo.textwidth = 0
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true -- turn tabs to spaces by default
    vim.bo.autoindent = true
    -- vim.cmd('retab')
end

M.fourspaceindent = function()
    vim.bo.textwidth = 0
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true -- turn tabs to spaces by default
    vim.bo.autoindent = true
    -- vim.cmd('retab')
end

M.tabindent = function()
    vim.bo.textwidth = 0
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = false -- don't turn tabs to spaces
    vim.bo.autoindent = true
    -- vim.cmd('retab')
end

M.programming = function()
    vim.wo.number = true
    vim.wo.spell = false
    vim.cmd 'syn keyword PWTODO FIXME TODO Todo todo contained'

    M.twospaceindent()
    -- Setup Ctrl and Cmd-/ to toggle comments
    vim.api.nvim_buf_set_keymap(0, 'n', '<D-/>',
                                '<Plug>kommentary_line_default', {})
    vim.api.nvim_buf_set_keymap(0, 'v', '<D-/>',
                                '<Plug>kommentary_visual_default', {})
    vim.api.nvim_buf_set_keymap(0, 'i', '<D-/>', '<C-O>,c<space>', {})
    vim.api.nvim_buf_set_keymap(0, 'n', '<C-/>',
                                '<Plug>kommentary_line_default', {})
    vim.api.nvim_buf_set_keymap(0, 'v', '<C-/>',
                                '<Plug>kommentary_visual_default', {})
    vim.api.nvim_buf_set_keymap(0, 'i', '<C-/>', '<C-O>,c<space>', {})

    -- Could be a performance penalty on this
    -- Will make periodic checks to see if the file changed
    vim.api.nvim_exec([[
    augroup programming
      autocmd!
      autocmd CursorHold,CursorHoldI * silent! checktime
    augroup END
  ]], false)

end

return M
