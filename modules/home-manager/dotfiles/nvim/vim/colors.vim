if has("nvim")
  set termguicolors
endif

function! OneDarkExtensions()
  " Needed for undercurl support
  let &t_Cs = "\e[4:3m"
  let &t_Ce = "\e[4:0m"
  " Needed for italic support
  let &t_ZH="\e[3m"
  let &t_ZR="\e[23m"

  let red = "#E06C75"
  let dark_red =  "#BE5046"
  let green =  "#98C379"
  let yellow =  "#E5C07B"
  let dark_yellow =  "#D19A66"
  let blue =  "#61AFEF"
  let purple =  "#C678DD"
  let cyan =  "#56B6C2"
  let white =  "#ABB2BF"
  let black =  "#282C34"
  let comment_grey =  "#5C6370"
  let gutter_fg_grey =  "#4B5263"
  let cursor_grey =  "#2C323C"
  let visual_grey =  "#3E4452"
  let menu_grey =  "#3E4452"
  let special_grey =  "#3B4048"
  let vertsplit =  "#181A1F"


  hi IndentBlanklineChar guifg=#444444 gui=nocombine

  hi pythonSpaceError ctermbg=red guibg=red

  hi! Comment guifg=#676f7e ctermfg=darkgray cterm=italic gui=italic
  hi! Todo    guifg=#282c34 guibg=#dddb4d  gui=bold      ctermfg=black        ctermbg=180       cterm=bold         guisp=NONE

  hi! VertSplit        guifg=#202020     guibg=#606060     gui=NONE      ctermfg=darkgray    ctermbg=darkgray    cterm=NONE
  hi! Folded           guifg=#c0c8d0     guibg=#384058     gui=NONE      ctermfg=NONE        ctermbg=NONE        cterm=NONE


  hi! SpellBad        guifg=NONE        guibg=bg       gui=undercurl ctermfg=red      ctermbg=NONE     cterm=undercurl    guisp=#ff0000
  hi! SpellCap        guifg=NONE        guibg=bg       gui=undercurl ctermfg=magenta  ctermbg=NONE     cterm=undercurl    guisp=#0000ff
  hi! SpellLocal      guifg=NONE        guibg=bg       gui=undercurl ctermfg=magenta  ctermbg=NONE     cterm=undercurl    guisp=#0000ff
  hi! SpellRare       guifg=NONE        guibg=bg       gui=NONE      ctermfg=NONE     ctermbg=NONE     cterm=NONE         guisp=NONE
  hi! VimwikiHeader1  guifg=#dddb4d     guibg=bg       gui=bold      ctermfg=yellow   ctermbg=NONE     cterm=bold         guisp=NONE
  hi! VimwikiHeader2  guifg=#dddb4d     guibg=bg       gui=bold      ctermfg=yellow   ctermbg=NONE     cterm=bold         guisp=NONE
  hi! VimwikiHeader3  guifg=#dddb4d     guibg=bg       gui=NONE      ctermfg=yellow   ctermbg=NONE     cterm=NONE         guisp=NONE
  hi! VimwikiHeader4  guifg=#98c379     guibg=bg       gui=bold      ctermfg=114      ctermbg=NONE     cterm=italic       guisp=NONE
  hi! VimwikiHeader5  guifg=#98c379     guibg=bg       gui=NONE      ctermfg=114      ctermbg=NONE     cterm=italic       guisp=NONE
  hi! VimwikiHeader6  guifg=#98c379     guibg=bg       gui=italic    ctermfg=114      ctermbg=NONE     cterm=italic       guisp=NONE
  hi! VimwikiLink     guifg=#61afef     guibg=bg       gui=underline ctermfg=39       ctermbg=NONE     cterm=underline    guisp=#313a59
  hi! VimwikiListTodo guifg=#ffffff     guibg=bg       gui=bold      ctermfg=white    ctermbg=NONE     cterm=bold         guisp=NONE


  hi! YcmErrorSection     guifg=NONE    guibg=bg       gui=bold,italic,undercurl ctermfg=NONE ctermbg=1 cterm=undercurl   guisp=#ff0000
  hi! YcmWarningSection   guifg=NONE    guibg=bg       gui=bold,italic,undercurl ctermfg=NONE ctermbg=4 cterm=undercurl   guisp=#ffff00
  hi! YcmWarningSign      guifg=#ffff00 guibg=bg       gui=NONE      ctermfg=yellow   ctermbg=NONE      cterm=NONE        guisp=NONE
  hi! YcmErrorSign        guifg=#ff0000 guibg=bg       gui=NONE      ctermfg=red      ctermbg=NONE      cterm=NONE        guisp=NONE
  " Some more readable "highlights for neomake
  hi link NeomakeWarningSign YcmWarningSign
  hi link NeomakeErrorSign YcmErrorSign
  hi! NeomakeInfoSign     guifg=NONE    guibg=bg       gui=bold,italic,undercurl ctermfg=NONE ctermbg=4 cterm=underline   guisp=#4dc3ff
  hi! NeomakeMessageSign  guifg=NONE    guibg=bg       gui=bold,italic,undercurl ctermfg=NONE ctermbg=4 cterm=underline   guisp=#4dc3ff
  " - NeomakeError: links to "SpellBad" (|hl-SpellBad|)
  " - NeomakeWarning: links to "SpellCap" (|hl-SpellCap|)
  " - NeomakeInfo: links to "NeomakeWarning"
  " - NeomakeMessage: links to "NeomakeWarning"

  " Markdown {{{

  hi link markdownHeadingRule Function
  hi link markdownHeadingDelimeter Statement
  hi link markdownOrderedListMarker Statement
  hi link markdownListMarker Statement
  hi markdownBold         guifg=fg      guibg=bg ctermfg=NONE gui=bold cterm=bold
  hi markdownItalic       guifg=fg      guibg=bg ctermfg=NONE gui=italic cterm=italic
  hi markdownBoldItalic   guifg=fg      guibg=bg ctermfg=NONE gui=bold,italic cterm=bold,italic
  hi! markdownH1  guifg=#dddb4d     guibg=bg         gui=bold      ctermfg=yellow      ctermbg=NONE       cterm=bold         guisp=NONE
  hi! markdownH2  guifg=#dddb4d     guibg=bg         gui=bold      ctermfg=yellow      ctermbg=NONE       cterm=bold         guisp=NONE
  hi! markdownH3  guifg=#dddb4d     guibg=bg         gui=NONE      ctermfg=yellow      ctermbg=NONE       cterm=NONE         guisp=NONE
  hi! markdownH4  guifg=#98c379     guibg=bg         gui=italic    ctermfg=114         ctermbg=NONE       cterm=italic       guisp=NONE
  hi! markdownH5  guifg=#98c379     guibg=bg         gui=italic    ctermfg=114         ctermbg=NONE       cterm=italic       guisp=NONE
  hi! markdownH6  guifg=#98c379     guibg=bg         gui=italic    ctermfg=114         ctermbg=NONE       cterm=italic       guisp=NONE
  hi! htmlH1  guifg=#dddb4d     guibg=bg         gui=bold      ctermfg=yellow      ctermbg=NONE       cterm=bold         guisp=NONE
  hi! htmlH2  guifg=#dddb4d     guibg=bg         gui=bold      ctermfg=yellow      ctermbg=NONE       cterm=bold         guisp=NONE
  hi! htmlH3  guifg=#dddb4d     guibg=bg         gui=NONE      ctermfg=yellow      ctermbg=NONE       cterm=NONE         guisp=NONE
  hi! htmlH4  guifg=#98c379     guibg=bg         gui=italic    ctermfg=114         ctermbg=NONE       cterm=italic       guisp=NONE
  hi! htmlH5  guifg=#98c379     guibg=bg         gui=italic    ctermfg=114         ctermbg=NONE       cterm=italic       guisp=NONE
  hi! htmlH6  guifg=#98c379     guibg=bg         gui=italic    ctermfg=114         ctermbg=NONE       cterm=italic       guisp=NONE
  hi markdownLinkText gui=underline cterm=underline
  hi link markdownCode String
  hi link markdownCodeBlock String
  hi link markdownUrldelimiter Delimiter
  hi link markdownUrlDelimiter Delimiter
  hi link markdownLinkDelimiter Delimiter
  hi link markdownLinkTextDelimiter Delimiter
  hi link markdownIdDelimiter Delimiter
  hi link markdownCodeDelimiter Statement
  hi markdownAutomaticLink gui=underline cterm=underline
  hi markdownUrl guifg=#61afef ctermfg=blue gui=underline cterm=underline
  hi link markdownUrlTitle PreProc
  hi link markdownIdDeclaration Type
  hi link markdownBlockQuote Type
  hi link markdownRule Type
  hi markdownId guifg=#888888 ctermfg=gray gui=underline cterm=underline

  " Darken the background on inactive windows
  "hi ActiveWindow guibg=#282C34
  "hi InactiveWindow guibg=#1A1C22
  " Deals with the barbar inactive tabs
  "hi TabLineFill guibg=#1A1C22
  "hi TabLineFill guibg=#1A1C22 guifg=special_grey
  "set winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow

  " }}}


endfunction

if v:version >= 600
  if &t_Co > 2 || has("gui_running")
    " Setup visual elements (except gui specific fonts, in gui.vim)
    augroup MyColors
      autocmd!
      autocmd ColorScheme onedark silent call OneDarkExtensions()
    augroup END
    " Turn this off if comments look like they're highlighted w/ bckgrnd color
    let g:onedark_terminal_italics=1
    let g:onedark_termcolors=256
    colorscheme onedark
    set background=dark

    " Switch syntax highlighting on, when the terminal has colors
    " Also switch on highlighting the last used search pattern.
    filetype plugin on
    filetype indent on
    set hlsearch
    syn keyword TODO TODO: PWTODO PWTODO: FIXME FIXME: TODO Todo todo contained
    syntax on
  endif
endif

