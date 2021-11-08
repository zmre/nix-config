-- This file is for mappings that will work regardless of filetype. Always available.
local options = {noremap = true, silent = true}

-- Make F1 act like escape for accidental hits
vim.api.nvim_set_keymap('', '#1', '<Esc>', options)
vim.api.nvim_set_keymap('!', '#1', '<Esc>', options)

-- TODO: try using the WinNew and WinClosed autocmd events with CHADtree filetype
-- to remap #2 to either open or close commands. Or BufDelete, BufAdd, BufWinLeave, BufWinEnter
-- Make F2 bring up a file browser
-- vim.api.nvim_set_keymap('', '#2', ':NvimTreeToggle<CR>', options)
-- vim.api.nvim_set_keymap('!', '#2', '<ESC>:NvimTreeToggle<CR>', options)
-- vim.api.nvim_set_keymap('', '-', ':NvimTreeFindFile<CR>', options)
vim.api.nvim_set_keymap('', '#2',
                        ':lua require("plugins.nvim-tree").toggle()<CR>',
                        options)
vim.api.nvim_set_keymap('!', '#2',
                        '<ESC>:lua require("plugins.nvim-tree").toggle()<CR>',
                        options)
vim.api.nvim_set_keymap('', '-', ':lua require("plugins.nvim-tree").find()<CR>',
                        options)

-- Make F3 bring up project search (cmd-t or ack/ag/rg)
vim.api.nvim_set_keymap('', '#3', ':Ack<Space>', options)
vim.api.nvim_set_keymap('!', '#3', '<ESC>:Ack<Space>', options)

-- Make ctrl-p open a file finder
-- When using ctrl-p, screen out media files that we probably don't want
-- to open in vim. And if we really want, then we can use ,ff
vim.api.nvim_set_keymap('', '<c-p>',
                        ':silent Telescope find_files find_command=/usr/local/bin/fd,--type,f,-L,--color,never,--ignore-file,/Users/pwalsh/.ignoremedia<CR>',
                        options)
vim.api.nvim_set_keymap('!', '<c-p>',
                        '<ESC>:silent Telescope find_files find_command=/usr/local/bin/fd,--type,f,-L,--color,never,--ignore-file,/Users/pwalsh/.ignoremedia<CR>',
                        options)

vim.api.nvim_set_keymap('', '<leader>f', ':silent Telescope file_browser<CR>',
                        options)
vim.api.nvim_set_keymap('', '<leader>ff', ':silent Telescope find_files<CR>',
                        options)
vim.api.nvim_set_keymap('', '<leader>fg', ':silent Telescope live_grep<CR>',
                        options)
vim.api.nvim_set_keymap('', '<leader>fb', ':silent Telescope buffers<CR>',
                        options)
vim.api.nvim_set_keymap('', '<leader>fh', ':silent Telescope oldfiles<CR>',
                        options)
vim.api.nvim_set_keymap('', '<leader>fq', ':silent Telescope quickfix<CR>',
                        options)
vim.api.nvim_set_keymap('', '<leader>fl', ':silent Telescope loclist<CR>',
                        options)
vim.api.nvim_set_keymap('', '<leader>fd',
                        ':silent Telescope lsp_document_symbols<CR>', options)
vim.api.nvim_set_keymap('', '<leader>fz', ':silent Telescope zoxide list<CR>',
                        options)

-- Make F4 toggle showing invisible characters
vim.api.nvim_set_keymap('', '_z', ':set list<CR>:map #4 _Z<CR>', {})
vim.api.nvim_set_keymap('', '_Z', ':set nolist<CR>:map #4 _z<CR>', {})
vim.api.nvim_set_keymap('', '#4', '_Z', {})

-- Enter the date on F8
vim.api.nvim_set_keymap('', '#8', '"=strftime("%Y-%m-%d")<CR>P', options)
vim.api.nvim_set_keymap('!', '#8', '<C-R>=strftime("%Y-%m-%d")<CR>', options)

-- Make F9 toggle distraction-free writing setup
vim.api.nvim_set_keymap('', '#9', ':Goyo<CR>', options)
vim.api.nvim_set_keymap('!', '#9', '<ESC>:Goyo<CR>i', options)

-- Make F12 restart highlighting
vim.api.nvim_set_keymap('', '<F12>', ':syntax sync fromstart<CR>', options)
vim.api
    .nvim_set_keymap('!', '<F12>', '<C-o>:syntax sync fromstart<CR>', options)

-- Quickly change indent defaults in a file
vim.api.nvim_set_keymap('', '<leader>1',
                        ":lua require('options').tabindent()<CR>", options)
vim.api.nvim_set_keymap('', '<leader>2',
                        ":lua require('options').twospaceindent()<CR>", options)
vim.api.nvim_set_keymap('', '<leader>4',
                        ":lua require('options').fourspaceindent()<CR>", options)

-- use ',/' to clear the search
vim.api.nvim_set_keymap('', '<leader>/', ':noh<CR>', options)
-- reduce multiple blank lines to one
vim.api.nvim_set_keymap('', '<leader>b', 'GoZ<Esc>:g/^$/.,/./-j<CR>Gddgi',
                        options)
-- TODO: use ,W to kill trailing whitespace on lines
-- vim.api.nvim_set_keymap('', '<leader>W', ':call StripTrailingWhitespaces()<CR>', options)
-- Set cwd to current file's dir
vim.api.nvim_set_keymap('', '<leader>cd', ':cd %:h<CR>', options)
vim.api.nvim_set_keymap('', '<leader>lcd', ':lcd %:h<CR>', options)
-- Debug syntax files
vim.api.nvim_set_keymap('', '<leader>sd',
                        [[:echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<CR>]],
                        options)

-- [[:echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
-- \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
-- \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>]],
-- options)

vim.api.nvim_set_keymap('', '<leader>q',
                        [["<cmd>".(get(getqflist({"winid": 1}), "winid") != 0? "cclose" : "botright copen")."<cr>"]],
                        {silent = true, expr = true, noremap = true})

-- """"""""" Global Shortcuts """""""""""""

-- Have ctrl-l continue to do what it did, but also temp clear search match highlighting
vim.api.nvim_set_keymap('', '<C-l>', ':<C-u>nohlsearch<CR><C-l>',
                        {silent = true})
vim.api.nvim_set_keymap('', '<D-j>', 'gj', options)
vim.api.nvim_set_keymap('', '<D-4>', 'g$', options)
vim.api.nvim_set_keymap('', '<D-6>', 'g^', options)
vim.api.nvim_set_keymap('', '<D-0>', 'g^', options)

-- Yank to end of line using more familiar method
vim.api.nvim_set_keymap('', 'Y', 'y$', options)
-- Bubble lines up and down using the unimpaired plugin
vim.api.nvim_set_keymap('n', '<C-Up>', '[e', options)
vim.api.nvim_set_keymap('n', '<C-Down>', ']e', options)
vim.api.nvim_set_keymap('v', '<C-Up>', '[egv', options)
vim.api.nvim_set_keymap('v', '<C-Down>', ']egv', options)

-- Visually select the text that was last edited/pasted
-- Similar to gv but works after paste
vim.api.nvim_set_keymap('', 'gV', '`[v`]', options)

-- What do these do?
-- inoremap <C-U> <C-G>u<C-U>
-- nnoremap & :&&<CR>
-- xnoremap & :&&<CR>

-- Indent/outdent shortcuts
vim.api.nvim_set_keymap('n', '<D-[>', '<<', options)
vim.api.nvim_set_keymap('v', '<D-[>', '<gv', options)
vim.api.nvim_set_keymap('!', '<D-[>', '<C-o><<', options)
vim.api.nvim_set_keymap('n', '<D-]>', '>>', options)
vim.api.nvim_set_keymap('v', '<D-]>', '>gv', options)
vim.api.nvim_set_keymap('!', '<D-]>', '<C-o>>>', options)

-- TODO: this should be in programming setup
-- nmap <D-b> :make<CR>
-- imap <D-b> <C-o>:make<CR>

-- easy expansion of the active directory with %% on cmd
vim.api.nvim_set_keymap('c', '%%',
                        "getcmdtype() == ':' ? expand('%:h').'/' : '%%'",
                        options)

-- gx is a built-in to open URLs under the cursor, but when
-- not using netrw, it doesn't work right. Or maybe it's just me
-- but anyway this command works great.
vim.api.nvim_set_keymap('', 'gx', ":sil !open <c-r><c-a><cr>", options)

-- open/close folds with space bar
vim.api.nvim_set_keymap('', '<Space>',
                        [[@=(foldlevel('.')?'za':"\<Space>")<CR>]], options)

-- Make nvim terminal more sane
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], options)
vim.api.nvim_set_keymap('t', '<M-[>', "<Esc>", options)
vim.api.nvim_set_keymap('t', '<C-v><Esc>', "<Esc>", options)

-- gui nvim stuff
-- Adjust font sizes
vim.api.nvim_set_keymap('', '<D-=>', [[:silent! let &guifont = substitute(
  \ &guifont,
  \ ':h\zs\d\+',
  \ '\=eval(submatch(0)+1)',
  \ '')<CR>]], options)
vim.api.nvim_set_keymap('', '<D-->', [[:silent! let &guifont = substitute(
  \ &guifont,
  \ ':h\zs\d\+',
  \ '\=eval(submatch(0)-1)',
  \ '')<CR>]], options)

-- Need to map cmd-c and cmd-v to get natural copy/paste behavior
vim.api.nvim_set_keymap('n', '<D-v>', '"*p', options)
vim.api.nvim_set_keymap('v', '<D-v>', '"*p', options)
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>*', options)
vim.api.nvim_set_keymap('c', '<D-v>', '<C-R>*', options)
vim.api.nvim_set_keymap('v', '<D-c>', '"*y', options)

-- cmd-w to close the current buffer
vim.api.nvim_set_keymap('', '<D-w>', ':bd<CR>', options)
vim.api.nvim_set_keymap('!', '<D-w>', '<ESC>:bd<CR>', options)

-- cmd-t or cmd-n to open a new buffer
vim.api.nvim_set_keymap('', '<D-t>', ':enew<CR>', options)
vim.api.nvim_set_keymap('!', '<D-t>', '<ESC>:enew<CR>', options)
vim.api.nvim_set_keymap('', '<D-n>', ':tabnew<CR>', options)
vim.api.nvim_set_keymap('!', '<D-n>', '<ESC>:tabnew<CR>', options)

-- cmd-s to save
vim.api.nvim_set_keymap('', '<D-s>', ':w<CR>', options)
vim.api.nvim_set_keymap('!', '<D-s>', '<ESC>:w<CR>', options)

-- cmd-q to quit
vim.api.nvim_set_keymap('', '<D-q>', ':q<CR>', options)
vim.api.nvim_set_keymap('!', '<D-q>', '<ESC>:q<CR>', options)

-- cmd-o to open
vim.api.nvim_set_keymap('', '<D-o>', ':Telescope file_browser cmd=%:h<CR>',
                        options)
vim.api.nvim_set_keymap('!', '<D-o>',
                        '<ESC>:Telescope file_browser cmd=%:h<CR>', options)

-- TODO:
-- Use ctrl-x, ctrl-u to complete :emoji: symbols, then use
-- ,e to turn it into a symbol if desired
vim.api.nvim_set_keymap('!', '<leader>e',
                        [[:%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g<CR>]],
                        options)

local options = {noremap = true, silent = true}
-- Move to previous/next
vim.api.nvim_set_keymap('', '[b', ':BufferPrevious<CR>', options)
vim.api.nvim_set_keymap('', ']b', ':BufferNext<CR>', options)
-- Goto buffer in position...
vim.api.nvim_set_keymap('', '[1', ':BufferGoto 1<CR>', options)
vim.api.nvim_set_keymap('', '[2', ':BufferGoto 2<CR>', options)
vim.api.nvim_set_keymap('', ']2', ':BufferGoto 2<CR>', options)
vim.api.nvim_set_keymap('', '[3', ':BufferGoto 3<CR>', options)
vim.api.nvim_set_keymap('', ']3', ':BufferGoto 3<CR>', options)
vim.api.nvim_set_keymap('', '[4', ':BufferGoto 4<CR>', options)
vim.api.nvim_set_keymap('', ']4', ':BufferGoto 4<CR>', options)
vim.api.nvim_set_keymap('', '[5', ':BufferGoto 5<CR>', options)
vim.api.nvim_set_keymap('', ']5', ':BufferGoto 5<CR>', options)
vim.api.nvim_set_keymap('', '[6', ':BufferGoto 6<CR>', options)
vim.api.nvim_set_keymap('', ']6', ':BufferGoto 6<CR>', options)
vim.api.nvim_set_keymap('', '[7', ':BufferGoto 7<CR>', options)
vim.api.nvim_set_keymap('', ']7', ':BufferGoto 7<CR>', options)
vim.api.nvim_set_keymap('', '[8', ':BufferGoto 8<CR>', options)
vim.api.nvim_set_keymap('', ']8', ':BufferGoto 8<CR>', options)
vim.api.nvim_set_keymap('', '[9', ':BufferGoto 9<CR>', options)
vim.api.nvim_set_keymap('', ']9', ':BufferGoto 9<CR>', options)
-- Close buffer
vim.api.nvim_set_keymap('', '<D-w>', ':BufferClose<CR>', options)
vim.api.nvim_set_keymap('!', '<D-w>', '<ESC>:BufferClose<CR>', options)
vim.api.nvim_set_keymap('', '<A-w>', ':BufferClose<CR>', options)
vim.api.nvim_set_keymap('!', '<A-w>', '<ESC>:BufferClose<CR>', options)
vim.api.nvim_set_keymap('', '<M-w>', ':BufferClose<CR>', options)
vim.api.nvim_set_keymap('!', '<M-w>', '<ESC>:BufferClose<CR>', options)
vim.api.nvim_set_keymap('', '<leader>x', ':BufferClose<CR>', options)
-- Magic buffer-picking mode
vim.api.nvim_set_keymap('', '<M-b>', ':BufferPick<CR>', options)
vim.api.nvim_set_keymap('!', '<M-b>', '<ESC>:BufferPick<CR>', options)
vim.api.nvim_set_keymap('', '[0', ':BufferPick<CR>', options)
vim.api.nvim_set_keymap('', ']0', ':BufferPick<CR>', options)
vim.api.nvim_set_keymap('', '[\\', ':BufferPick<CR>', options)
vim.api.nvim_set_keymap('', ']\\', ':BufferPick<CR>', options)

-- Grammar stuff
vim.cmd([[command StartGrammar lua require("plugins.grammarous").check()]])
vim.api.nvim_set_keymap('', '<leader>gg', ':StartGrammar<CR>', options)

-- Hop
vim.api.nvim_set_keymap('', '}', ":HopWord<CR>", {silent = true})
vim.api.nvim_set_keymap('', '{', ":HopChar1<CR>", {silent = true})


