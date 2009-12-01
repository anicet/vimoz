
" General conf:
" ~~~~~~~~~~~~~

set modeline
set nocompatible

" Runtime path (adapt this to your host...):
"set runtimepath=~/.vim,$VIMRUNTIME

" Search options:
set incsearch               " set incrementalsearch
set ignorecase              " ignore case during searches
set shortmess+=aI           " Avoid some of the "hit-enter" messages + abbrev
set smartcase               " override ignorecase if search term contrains 
                            " uppercase characters.

" Over-ride LANG & LC_ALL
let $LANG = "en_US.UTF-8"
let $LC_ALL = "en_US.UTF-8"

" Look & feel:
" ~~~~~~~~~~~~

" Use jellybeans color scheme when running a GUI
if has("gui_running")
  colorscheme jellybeans
  set number
else
  colorscheme default
endif

set background=dark
set ruler                   " show ruler (line+column number, etc) 
"set number                  " Line number ?
set showmatch               " briefly show matching bracket on insert
set showfulltag             " show possible matches when completing (see doc)
set showmode                " show mode (visual, visual block, etc)
set undolevels=1000         " 1000 undo levels
set wig=*.o,*.obj,*~,#*#    " ignore these patterns when completing filename
set showcmd                 " show (partial) command in status line
set wildmenu                " show menu of completions
set laststatus=1            " status bar if window count >= 2
set lazyredraw              " don't redraw screen on macros & stuff
set noerrorbells            " quiet vim
set vb t_vb=""              " no blink or visual bell : silence.
set ttyfast                 " my tty is fast, I hope.
set term=builtin_ansi       " Fix arrow-keys behaviour in insert-mode"
set hidden                  " Allow buffer change even if it was changed.

" Status line (RTFM):
set laststatus=1
set statusline="%1*[%n]\ [%F\ %y%m%r%h]%=\ [%c,%l]\ [%L]\ [%P]"
set scrolloff=3             " Scroll window by 3 lines when buffer is scrolling

" Tab VS Spaces holy war:
" ~~~~~~~~~~~~~~~~~~~~~~~
set tabstop=4               " a tabulation is shown a 4 'spaces'
set shiftwidth=4            " number of spaces for each (auto)indent
set backspace=2             " backspace over eol/start/indent
set autoindent              " auto indent
set expandtab               " fill tabs with spaces (holy-war inside)
set softtabstop=4           " a tab = 4 spaces most of the time

" Text handling:
" ~~~~~~~~~~~~~~
set textwidth=72            " default text width = 72 chars
set smartindent             " indent correctly (like cindent but not C-ish)
set formatprg="/usr/bin/env par""           " text formater (par is great)
set autowrite               " autowrite on some commands (eg make)
set nojoinspaces            " don't double spaces after '.', '?', and '!'
                            " with join command (J) : one is enough in
                            " french (as opposed to english). :)
set showbreak="> "          " string to put at the beginning of wrapped lines
set foldenable              " use code folding when possible
set whichwrap+=><           " move cursor between lines with horiz. arrows

set viminfo=%,'50,\"100,:100,n~/.vim/.viminfo       " just RTFM please :)
nmap ' `
set history=1000            " longer history

" Don't match more than 25, to avoid sluggish interface...
let g:fuzzy_matching_limit=25
let g:fuzzy_ceiling = 100000
let g:fuzzy_ignore = ".svn;tmp;.sw*;*.png;*.gif;*.jpg;*.avi;*.swf;*.flv"

" Spell checking
" ~~~~~~~~~~~~~~
set spelllang=fr
set nospell

" X11/GUI options:
" ~~~~~~~~~~~~~~~~
set icon                    " set icon title (?) if supported
set title                   " set term title if supported
set guioptions-=m           " no menubar
set guioptions-=T           " no toolbar
set guioptions-=r           " no right scrollbar
set ttymouse=xterm2         " mouse handling if one is available
set mouse=a

" Running on Mac OS X
if has("gui_macvim")
  "set guifont=Monaco:h12        " Monaco's pretty :D
  set guifont=Inconsolata:h14.00 " Trying Inconsolata
  set transparency=1             " watch behind...
  set fuoptions=maxhorz,maxvert  " maximize both horizontaly & veritically when going fullscreen
  "set lines=45                   " Window geometry: height
  "set columns=170                " Window geometry: width
endif

" Running in GVIM (Gtk)
if has("gui_gtk")
  "set guifont=DejaVu\ Sans\ Mono\ 9
  set guifont=Bitstream\ Vera\ Sans\ Mono\ 8
endif

" Map mouse events
" ~~~~~~~~~~~~~~~~
" Scrolling with mouse-wheel
:map <MouseDown>   <C-Y>
:map <S-MouseDown> <C-U>
:map <MouseUp>     <C-E>
:map <S-MouseUp>   <C-D>
" Mappings for xterm
:map  <M-Esc>[62~ <MouseDown>
:map! <M-Esc>[62~ <MouseDown>
:map  <M-Esc>[63~ <MouseUp>
:map! <M-Esc>[63~ <MouseUp>
:map  <M-Esc>[64~ <S-MouseDown>
:map! <M-Esc>[64~ <S-MouseDown>
:map  <M-Esc>[65~ <S-MouseUp>
:map! <M-Esc>[65~ <S-MouseUp>

" Set username
if exists("$FULLNAME")
    let mename = $FULLNAME
else
    let mename = $USER
endif

" Is 'auto-command' available ?
if has("autocmd")
    filetype plugin indent on
endif

" ------------------------------------------------------------------------------
" Homemade shortcuts:
" ~~~~~~~~~~~~~~~~~~~

" Navigate through buffers:
nmap <F2> <Esc>:bp<CR>          " next buffer
nmap <F3> <Esc>:bn<CR>          " previous buffer
nmap <F4> <Esc>:bw<CR>          " wipe out current buffer (MDK!)

" Navigate through tabs:
"   - map tabnext to : Control + Shift + n
"   - map tabprev to : Control + Shift + p
nmap <C-S-N>  <Esc>:tabnext<CR>
nmap <C-S-P>  <Esc>:tabprev<CR>

" Make is good:
"imap <F6> <Esc>:make<CR>
"map  <F6> <Esc>:make<CR>

" NERDTree
"nmap <F7>  <Esc>:NERDTreeToggle<CR>
"nmap <C-T>  <Esc>:TlistToggle<CR>
"nmap <C-E>  <Esc>:NERDTreeToggle<CR>

" Map \t to Fuzzy File-Finder Textmate
map <leader>t :FuzzyFinderTextMate<CR>

" ------------------------------------------------------------------------------
" Text Editing (mail/news/etc):
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

au BufNewFile,BufRead   *.{txt,doc}  call TextHelper()
au FileType mail                     call TextHelper()

" Ctrl-j : re-format paragraph (j as in 'justify')
imap <C-j> <Esc> gqap
nmap <C-j>       gqap
vmap <C-j>       gq

" Mostly e-mail helpers
map  ,cel  :g/^$/d<CR>                       " Clear empty lines
map  ,cqoq :%s/^>\s\+/> /e<CR>
nmap ,ceql :g/^\(> \)\{2,}\s*$/d<CR>         " Clear empty quoted lines
nmap ,cqel :%s/^> \s*$//<CR>
nmap ,ule <Esc>yyp:s/./=/g<CR>               " Underline with '=' signs
nmap ,uld <Esc>yyp:s/./-/g<CR>               " Underline with '-' signs
nmap ,date a<CR>=strftime("%c")<CR><Esc>     " Append date after cursor

" Insert a centered (according to tw) '[ snip ]' surrounded by '-'
nmap ,snip a#<Esc>x10p<Esc>:ce<CR>:s/ /-/g<CR>:s/\(-*\).*/\1 [ snip ] \1/<CR>

" Snip quoted text with '[...]'
vmap <buffer> ,snip c> [...]<Esc>

" ------------------------------------------------------------------------------
" Coding templates:
" ~~~~~~~~~~~~~~~~~

" VCS plugin
if has("gui_mac")
  " Set path explicitely for Macvim + Mac OS X
  let $PATH = "~/bin:/opt/local/bin:/opt/local/sbin:/opt/local/apache2/bin:/opt/local/lib/mysql5/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin"
  let VCSCommandSVNExec = "/opt/local/bin/svn"
endif

" Surround plugin (don't override default s/S key in visual mode)
vmap <Leader>s <Plug>Vsurround
vmap <Leader>S <Plug>VSurround

" Blockdenting
map! ^O {^M}^[O^T

" Syntax highlighting available ?
if has("syntax")
    syntax on
endif

" Better matching for % (match if/else and XML start/end tags)
runtime macros/matchit.vim

" Auto-command settings:
" ~~~~~~~~~~~~~~~~~~~~~~
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
                    \ exe "normal g'\"" | endif
au FileType c    set  cindent tw=80 ts=4 sw=4 sts=2 makeprg=make
au FileType c    call CFile_Comments()
au FileType java call CFile_Comments()
au FileType sh   call Sharp_Comments()
au FileType perl call PerlFileType()
au FileType ruby call RubyFileType()
au FileType php  set  tw=0 ts=4 sw=4 sts=2 makeprg=php\ -l\ %
au FileType html set  tw=0 ts=4 sw=4 sts=2
au FileType tex  call Tex_Macros()
au Filetype html,xml,xsl,tpl,eruby call LoadCloseTags()

" Auto-save on focus lost
autocmd FocusLost *.css :up

" Auto-commands applied to coding:
aug coding
    au! 

    " Create file based on templates in ~/.vim/skel
    au BufNewFile ?akefile* call CMakefile_New()
    au BufNewFile *.c       call CFile_New()
    au BufNewFile *.h       call CHeader_New()
    au BufNewFile *.java    call JavaFile_New()
    au BufNewFile *.p[ml]   call PerlFile_New()
    au BufNewFile *.php     call PHPFile_New()
    au BufNewFile *.rb      call RubyFile_New()
    au BufNewFile *.sh      call ShellFile_New()

    " Update date in file header when saving
    au BufWritePre *.java   call CUpdate_Headers(1, 8)
    au BufWritePre *.[ch]   call CUpdate_Headers(1, 8)
aug END

" ------------------------------------------------------------------------------
" Vim-foo:
" ~~~~~~~~
" XXX Quite outdated. :x

" new Shell file
function ShellFile_New()
    0r ~/.vim/skel/sh.tpl
    call Sharp_Comments()
    normal G
endfun

" new Perl file
function PerlFile_New()
    0r ~/.vim/skel/perl.tpl
    normal G
    call Sharp_Comments()
    call ReplaceFields('', '', '')       " ## is bad :)
    compiler perl
    normal A
endfun

" new PHP file
function PHPFile_New()
    0r ~/.vim/skel/php.tpl
    compiler php
    normal Gddkko<CR>
endfun

" new Ruby file
function RubyFile_New()
    0r ~/.vim/skel/ruby.tpl
    normal G
    call Sharp_Comments()
    compiler ruby
endfun

" new Java file
function JavaFile_New()
    0r ~/.vim/skel/java.tpl
    call ReplaceFields('/*', ' *', ' */')       " ** is bad :)
    normal G
    call CFile_Indent()
    " common java func.
    iabbr sysout System.out.print
    iabbr syserr System.err.print
endfun

" new C file
function CFile_New()
    0r ~/.vim/skel/c.tpl
    call ReplaceFields('/*', ' *', ' */')       " ** is bad :)
    normal G
    call CFile_Indent()
endfun

" new C header
function CHeader_New()
    0r ~/.vim/skel/h.tpl
    call ReplaceFields('/*', ' *', ' */')       " ** is bad :)
    normal G
    call CFile_Indent()
endfu

" new Makefile
function CMakefile_New()
    0r ~/.vim/skel/c.tpl
    call ReplaceFields('#', '#', '#')       " ## is bad :)
    normal Gdh
    r ~/.vim/skel/makefile.tpl
endfun

" update date/time line for C-ish files
function CUpdate_Headers(us, ue)
    normal mx
    execute a:us . "," . a:ue . "s,\\(Last update \\).*,\\1" . strftime("%c") . " " . g:mename . ",e"
    normal `x
    normal zz
    call CFile_Indent()
    call CFile_Comments()
endfun

" C indentation
function CGlobalIndent()
    ormal i
endfun

" Replace fields in file templates...
function ReplaceFields(cs, cm, ce)
    execute "% s,@CS@," . a:cs . ",ge"
    execute "% s,@CM@," . a:cm . ",ge"
    execute "% s,@CE@," . a:ce . ",ge"
    execute "% s,@FILE-NAME@," . expand('%:t') . ",ge"
    execute "% s,@USER-LOGIN@," . $USER . ",ge"
    execute "% s,@USER-NAME@," . g:mename . ",ge"
    execute "% s/@DATE-STAMP@/" . strftime("%c") . "/ge"
    let headerfilename = expand('%:t')
    let l:dbli = substitute(l:headerfilename, '\.', '_', 'g')
    let l:dbli = '_' . toupper(l:dbli)
    execute "% s,@DBL_INCL@," . l:dbli . ",ge"
endfun

" auto-indent
function CFile_Indent()
    nmap <F5> <Esc>:10,$ call CGlobalIndent()<CR>
    vmap <F5> <Esc>:call CGlobalIndent()<CR>
endfun

" auto-comment/uncomment for '/* */' style comments
function CFile_Comments()
    nmap <F7> I/*<Space><Esc>A<Space>*/<Esc>j
    nmap <F8> ^3x$2hDj
endfun

" auto-comment/uncomment for '#' style comments
function Sharp_Comments()
    nmap <F7> I#<Space><Esc>j
    nmap <F8> ^2xj

    " Create a comment block with '#'
    vmap <buffer> ,com :s/^/#/g<CR>
    vmap <buffer> ,uncom :s/^#//g<CR>
endfun

" Perl config
function PerlFileType()
    set cindent
    set tw=0
    set keywordprg=perldocf
    set makeprg=perl\ -c\ %
    call Sharp_Comments()
endfun

" Ruby config
function RubyFileType()
    set cindent
    set tw=0
    set ts=2
    set sw=2
    set sts=2
    set makeprg=ruby\ -c\ % 
    call Sharp_Comments()
endfun

" abbreviations upon insertion (just getting life easer)
function TextHelper()
    iab Ca Ça
    iab etre être
    iab meme même
    iab << «
    iab >> »
    iab myname g:mename
    iab mymail $USER."@cyprio.net"
endfun

" A few LaTeX macros
function Tex_Macros()
    imap ,it \textit{}<Left>
    imap ,bf \textbf{}<Left>
    imap ,verb \verb++<Left>
    imap ,mize \begin{itemize}<CR>\end{itemize}<Esc>O<Tab>\item 
endfun

" Load closetag vim sript
fun LoadCloseTags()
    " Don't complete HTML tags like <img /> or <link /> etc.
    let g:closetag_html_style=1
    source ~/.vim/scripts/closetag.vim 
endfun

