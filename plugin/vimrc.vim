" vimrc.vim - Extension of vim-sensible plugin with less sensible defaults.
" Maintainer:   Adam Stankiewicz <sheerun@sher.pl>

if exists('g:loaded_vimrc') || &compatible
  finish
else
  let g:loaded_vimrc = 'yes'
endif

"" Basics

" Disable strange Vi defaults.
set nocompatible

" Turn on filetype plugins (:help filetype-plugin).
if has('autocmd')
  filetype plugin indent on
endif

" Enable syntax highlighting.
if has('syntax')
  syntax enable
endif

" Autoindent when starting new line, or using `o` or `O`.
set autoindent

" Allow backspace in insert mode.
set backspace=indent,eol,start

" Don't scan included files. The .tags file is more performant.
set complete-=i

" Use 'shiftwidth' when using `<Tab>` in front of a line.
" By default it's used only for shift commands (`<`, `>`).
set smarttab

" Disable octal format for number processing.
set nrformats-=octal

" Allow for mappings including `Esc`, while preserving
" zero timeout after pressing it manually.
" (it only nvim needs fixing this)
if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

" Enable highlighted case-insensitive incremential search.
set incsearch

" Indent using two spaces.
set tabstop=2
set shiftwidth=2
set expandtab

" Use `Ctrl-L` to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Always show window statuses, even if there's only one.
set laststatus=2

" Show the line and column number of the cursor position.
set ruler

" Autocomplete commands using nice menu in place of window status.
" Enable `Ctrl-N` and `Ctrl-P` to scroll through matches.
set wildmenu

" When 'wrap' is on, display last line even if it doesn't fit.
set display+=lastline

" Force utf-8 encoding
set encoding=utf-8

" Set default whitespace characters when using `:set list`
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

" Delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j
endif

" Search upwards for tags file instead only locally
if has('path_extra')
  setglobal tags-=./tags tags^=./tags;
endif

" Reload unchanged files automatically.
set autoread

" Increase history size to 1000 items.
set history=1000

" Allow for up to 50 opened tabs on Vim start.
set tabpagemax=50

" Always save upper case variables to viminfo file.
set viminfo^=!

" Enable undofile and set undodir and backupdir
let s:dir = has('win32') ? '$APPDATA/Vim' : isdirectory($HOME.'/Library') ? '~/Library/Vim' : empty($XDG_DATA_HOME) ? '~/.local/share/vim' : '$XDG_DATA_HOME/vim'
let &backupdir = expand(s:dir) . '/backup//'
let &undodir = expand(s:dir) . '/undo//'
set undofile

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" `Ctrl-U` in insert mode deletes a lot. Use `Ctrl-G` u to first break undo,
" so that you can undo `Ctrl-U` without undoing what you typed before it.
inoremap <C-U> <C-G>u<C-U>

" Avoid problems with fish shell
" ([issue](https://github.com/tpope/vim-sensible/issues/50)).
if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif

"" Extras

" Set monako font if using macvim
if has("gui_macvim")
  set guifont=Monaco:h13
endif

" Keep flags when repeating last substitute command.
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Y yanks from the cursor to the end of line as expected. See :help Y.
nnoremap Y y$

" Automatically create directories for backup and undo files.
if !isdirectory(expand(s:dir))
  call system("mkdir -p " . expand(s:dir) . "/{backup,undo}")
end

" Highlight line under cursor. It helps with navigation.
set cursorline

" Keep 8 lines above or below the cursor when scrolling.
set scrolloff=8

" Keep 15 columns next to the cursor when scrolling horizontally.
set sidescroll=1
set sidescrolloff=15

" Set minimum window size to 79x5.
set winwidth=79
set winheight=5
set winminheight=5

" If opening buffer, search first in opened windows.
set switchbuf=usetab

" Hide buffers instead of asking if to save them.
set hidden

" Wrap lines by default
set wrap linebreak
set showbreak=" "

" Allow easy navigation between wrapped lines.
vmap j gj
vmap k gk
nmap j gj
nmap k gk

" For autocompletion, complete as much as you can.
set wildmode=longest,full

" Show line numbers on the sidebar.
set number

" Disable any annoying beeps on errors.
set noerrorbells
set visualbell

" Don't parse modelines (google "vim modeline vulnerability").
set nomodeline

" Do not fold by default. But if, do it up to 3 levels.
set foldmethod=indent
set foldnestmax=3
set nofoldenable

" Enable mouse for scrolling and window resizing.
set mouse=a

" Disable swap to prevent annoying messages.
set noswapfile

" Save up to 100 marks, enable capital marks.
set viminfo='100,f1

" Enable search highlighting.
set hlsearch

" Ignore case when searching.
set ignorecase

" Show mode in statusbar, not separately.
set noshowmode

" Don't ignore case when search has capital letter
" (although also don't ignore case by default).
set smartcase

" Use dash as word separator.
set iskeyword+=-

" Add gems.tags to files searched for tags.
set tags+=gems.tags

" Disable output, vcs, archive, rails, temp and backup files.
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=*.swp,*~,._*

" Auto center on matched string.
noremap n nzz
noremap N Nzz

" Visually select the text that was last edited/pasted (Vimcast#26).
noremap gV `[v`]

" Expand %% to path of current buffer in command mode.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Enable saving by `Ctrl-s`
nnoremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>

" Use Q to intelligently close a window
" (if there are multiple windows into the same buffer)
" or kill the buffer entirely if it's the last window looking into that buffer.
function! CloseWindowOrKillBuffer()
  let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))
  if matchstr(expand("%"), 'NERD') == 'NERD'
    wincmd c
    return
  endif
  if number_of_windows_to_this_buffer > 1
    wincmd c
  else
    bdelete
  endif
endfunction
nnoremap <silent> Q :call CloseWindowOrKillBuffer()<CR>

" Set window title by default.
set title

" Always focus on splited window.
set splitright
set splitbelow

" Don't display the intro message on starting Vim.
set shortmess+=I

" Use Silver Searcher for CtrlP plugin (if available)
" Fallback to git ls-files for fast listing.
" Because we use fast strategies, disable caching.
let g:ctrlp_use_caching = 0
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor
    let g:ctrlp_user_command = 'cd %s && ag -l --nocolor -g ""'
else
  let g:ctrlp_user_command = ['.git',
    \ 'cd %s && git ls-files . -co --exclude-standard',
    \ 'find %s -type f' ]
endif

" Accept CtrlP selections also with <Space>
let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("e")': ['<Space>', '<CR>', '<2-LeftMouse>'],
  \ }

" Make sure pasting in visual mode doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" Prevent common mistake of pressing q: instead :q
map q: :q

" Make a simple "search" text object.
" http://vim.wikia.com/wiki/Copy_or_change_search_hit
" It allows for replacing search matches with cs and then /././.
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>

" Disable writebackup because some tools have issues with it:
" https://github.com/neoclide/coc.nvim/issues/649
set nowritebackup

" Reduce updatetime from 4000 to 300 to avoid issues with coc.nvim
set updatetime=300

" Auto reload if file was changed somewhere else (for autoread)
au CursorHold * checktime

" Enable loading filetype plugins
filetype plugin on

" Merge signcolumn with number line (if supported)
if has("patch-8.1.1564")
  set signcolumn=number
endif

"" Color Scheme

" Vim color file
" Original Maintainer:  Lars H. Nielsen (dengmao@gmail.com)
" Last Change:  2014-05-31
"
" Modified version of wombat for 256-color terminals by
"   Adam Stankiewicz (sheerun@sher.pl)
" Modified version of wombat for 256-color terminals by
"   David Liang (bmdavll@gmail.com)
" based on version by
"   Danila Bespalov (danila.bespalov@gmail.com)

set background=dark

if version > 580
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
endif

let colors_name = "wombat256mod"

" General colors
hi  Normal        ctermfg=252  ctermbg=234    cterm=none     guifg=#e3e0d7  guibg=#242424  gui=none
hi  Cursor        ctermfg=234  ctermbg=228    cterm=none     guifg=#242424  guibg=#eae788  gui=none
hi  Visual        ctermfg=251  ctermbg=239    cterm=none     guifg=#c3c6ca  guibg=#554d4b  gui=none
hi  VisualNOS     ctermfg=251  ctermbg=236    cterm=none     guifg=#c3c6ca  guibg=#303030  gui=none
hi  Search        ctermfg=177  ctermbg=241    cterm=none     guifg=#d787ff  guibg=#636066  gui=none
hi  Folded        ctermfg=103  ctermbg=237    cterm=none     guifg=#a0a8b0  guibg=#3a4046  gui=none
hi  Title         ctermfg=230  cterm=bold     guifg=#ffffd7  gui=bold
hi  StatusLine    ctermfg=230  ctermbg=238    cterm=none     guifg=#ffffd7  guibg=#444444  gui=italic
hi  VertSplit     ctermfg=238  ctermbg=238    cterm=none     guifg=#444444  guibg=#444444  gui=none
hi  StatusLineNC  ctermfg=241  ctermbg=238    cterm=none     guifg=#857b6f  guibg=#444444  gui=none
hi  LineNr        ctermfg=241  ctermbg=232    cterm=none     guifg=#857b6f  guibg=#080808  gui=none term=none
hi  SpecialKey    ctermfg=241  ctermbg=235    cterm=none     guifg=#626262  guibg=#2b2b2b  gui=none
hi  WarningMsg    ctermfg=203  guifg=#ff5f55
hi  ErrorMsg      ctermfg=196  ctermbg=234    cterm=bold     guifg=#e3e0d7  guibg=#3a3a3a  gui=bold
hi  SpellBad      ctermfg=196  ctermbg=234    cterm=bold     guifg=#e3e0d7  guibg=#3a3a3a  gui=bold
hi  SpellCap      ctermfg=196  ctermbg=234    cterm=bold     guifg=#e3e0d7  guibg=#3a3a3a  gui=bold

" Vim >= 7.0 specific colors
if version >= 700
hi  CursorLine    ctermbg=236  cterm=none   guibg=#32322f
hi  CursorLineNr  ctermbg=234    cterm=none      guibg=#242424  gui=none
hi  MatchParen    ctermfg=228  ctermbg=101  cterm=bold     guifg=#eae788  guibg=#857b6f  gui=bold
hi  Pmenu         ctermfg=230  ctermbg=238  guifg=#ffffd7  guibg=#444444
hi  PmenuSel      ctermfg=232  ctermbg=192  guifg=#080808  guibg=#cae982
endif

" Diff highlighting
hi  DiffAdd     ctermbg=17   guibg=#2a0d6a
hi  DiffDelete  ctermfg=234  ctermbg=60     cterm=none     guifg=#242424  guibg=#3e3969  gui=none
hi  DiffText    ctermbg=53   cterm=none     guibg=#73186e  gui=none
hi  DiffChange  ctermbg=237  guibg=#382a37

"hi CursorIM
"hi Directory
"hi IncSearch
"hi Menu
"hi ModeMsg
"hi MoreMsg
"hi PmenuSbar
"hi PmenuThumb
"hi Question
"hi Scrollbar
"hi SignColumn
"hi SpellBad
"hi SpellCap
"hi SpellLocal
"hi SpellRare
"hi TabLine
"hi TabLineFill
"hi TabLineSel
"hi Tooltip
"hi User1
"hi User9
"hi WildMenu


" Syntax highlighting
hi  Keyword     ctermfg=111  cterm=none  guifg=#88b8f6  gui=none
hi  Statement   ctermfg=111  cterm=none  guifg=#88b8f6  gui=none
hi  Constant    ctermfg=173  cterm=none  guifg=#e5786d  gui=none
hi  Number      ctermfg=173  cterm=none  guifg=#e5786d  gui=none
hi  PreProc     ctermfg=173  cterm=none  guifg=#e5786d  gui=none
hi  Function    ctermfg=192  cterm=none  guifg=#cae982  gui=none
hi  Identifier  ctermfg=192  cterm=none  guifg=#cae982  gui=none
hi  Type        ctermfg=186  cterm=none  guifg=#d4d987  gui=none
hi  Special     ctermfg=229  cterm=none  guifg=#eadead  gui=none
hi  String      ctermfg=113  cterm=none  guifg=#95e454  gui=italic
hi  Comment     ctermfg=246  cterm=none  guifg=#9c998e  gui=italic
hi  Todo        ctermfg=101  cterm=none  guifg=#857b6f  gui=italic


" Links
hi! link FoldColumn    Folded
hi! link CursorColumn  CursorLine
hi! link NonText LineNr
hi! link SignColumn LineNr
hi! link CocErrorHighlight ErrorMsg
hi! link CocWarningHighlight WarningMsg
