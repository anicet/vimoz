" Vim changelog plugin file
"
" $Id: gnuchlog.vim 19642 2006-08-22 19:25:14Z lpc $
"
" Maintainer:  Luis P Caamano <lcaamano@gmail.com>
" Last Change: $Date: 2006-08-22 15:25:14 -0400 (Tue, 22 Aug 2006) $
" Credits:     Based on the changelog.vim filetype plugin written by
"              Nikolai Weibull <now@bitwi.se>
"
" License:     Vim License  (see vim's :help license)  because this is
"              based in the original changelog.vim ftplugin distributed
"              with vim under the Vim License.
"
" Description: Sets a global mapping that opens and adds an entry in the
"              appropriate ChangeLog file.
"
"              The ChangeLog file is only edited if it already exists, which
"              is searched upwards starting in the directory where the
"              edited file is located.  If the corresponding ChangeLog
"              file is already opened, the script either splits the window
"              to edit the buffer or switches to the window where the
"              buffer is already opened.
"
"              This behavior is identical to how emacs handles ChangeLog
"              files with the change-log-mode provided by C-x 4 a.
"
" See also:
"
" http://gnudist.gnu.org/software/emacs/manual/html_node/Change-Log.html
" http://www.gnu.org/prep/standards/html_node/Change-Log-Concepts.html
"
" Maps:
"   nmap <unique> <Leader>o <Plug>GnuchlogOpen
"   nmap <silent> <Plug>GnuchlogOpen :call <SID>Open()<CR>
"
" Variables:
"   g:changelog_dateformat -
"       description: the format sent to strftime() to generate a date string.
"       default: "%Y-%m-%d".
"   g:changelog_username -
"       description: the username to use in ChangeLog entries
"       default: try to deduce it from environment variables (EMAIL)
"       and system files.
"   g:changelog_relativepath
"       description: controls how to build the path name of the edited file
"       that is included in the title of the ChangeLog entry.  If true,
"       the path name is built relative to the directory where the ChangeLog
"       file is.  Otherwise, only the edited file's basename is used.
"       Patch provided by Donald Curtis <donald-curtis@uiowa.edu>
"       default: 1
"   b:changelog_tagfinder -
"       a reference to a function that returns a string that represents
"       the class, method or function where the cursor was when the user
"       invoked the s:Open() function.  This variable is set by filetype
"       plugins so we can use different tag finder mechanisms for
"       different languages, e.g., pythonhelper.vim for python, a ctags
"       based tag finder for C and C++, another for Java and so on.  See
"       the included and optional ftplugin/python_gnuchlog.vim script for
"       an example.
"
" Notes: mousefocus doesn't work too well because one gets to the changelog
"        entry, starts typing and the focus goes away to window we were
"        before because the pointer is still there.
"
" Install:
"
"To install and use this plugin:
"
" - Set the EMAIL environment to your email address, e.g., 
"   export EMAIL="John Doe <jdoe@foo.com>".  This is the user name
"   that will be included in the changelog entry.
"
" - Copy plugin/gnuchlog.vim to your ~/.vim/plugin dir.
"
" - Copy ftplugin/changelog.vim to your ~/.vim/ftplugin dir.  This
"   overrides the changelog.vim included by default in vim.
"
" - Make sure you have "filetype plugin on" in your .vimrc
"
"If you want to auto-include class/method/function name in the
"ChangeLog entry using the pythonhelper.py plugin:
"   
" - Copy plugin/pythonhelper.vim to your ~/.vim/plugin dir if you don't
"   have it already, which will give you this info in the status
"   line all by itself.
"   
" - Copy the ftplugin/python_gnuchlog.vim script to your ~/.vim/ftplugin
"   dir to make the gnuchlog.vim plugin use the pythonhelper.vim info
"   to get the class/method/name.
"
" - You can override the statusline setting to your liking by adding a
"   'set stl' command to ~/.vim/after/plugin/pythonhelper.vim.  See
"   ':help statusline' for info on how to configure the status line.
"   For example:
"
"   set stl=%-f%r\ %2*%m%*%h%w\ %1*%{TagInStatusLine()}%*%=%l,%c%V



" cannot run in compatible mode
if &cp
    if &verbose
        echo "GNU Changelog is not vi-compatible; not loaded (you need to set nocp)"
    endif
    finish
endif

if exists("loaded_GnuChangeLog")
    finish
endif
let g:loaded_GnuChangeLog= "v10"

let s:keepfo  = &fo
let s:keepcpo = &cpo
set cpo&vim

" Set up the format used for dates.
if !exists('g:changelog_dateformat')
    let g:changelog_dateformat = "%Y-%m-%d"
endif

" Set up including relative path.
if !exists('g:changelog_relativepath')
    let g:changelog_relativepath = 1
endif

" Try to figure out a reasonable username of the form:
"   Full Name <user@host>.
if !exists('g:changelog_username')
    if exists('$EMAIL') && $EMAIL != ''
        let g:changelog_username = $EMAIL
    elseif exists('$EMAIL_ADDRESS') && $EMAIL_ADDRESS != ''
        " This is some Debian junk if I remember correctly.
        let g:changelog_username = $EMAIL_ADDRESS
    else
        " Get the users login name.
        let login = system('whoami')
        if v:shell_error
            let login = 'unknown'
        else
            let newline = stridx(login, "\n")
            if newline != -1
                let login = strpart(login, 0, newline)
            endif
        endif

        " Try to get the full name from gecos field in /etc/passwd.
        if filereadable('/etc/passwd')
            for line in readfile('/etc/passwd')
                if line =~ '^' . login
                    let name = substitute(line,'^\%([^:]*:\)\{4}\([^:]*\):.*$','\1','')
                    " Only keep stuff before the first comma.
                    let comma = stridx(name, ',')
                    if comma != -1
                        let name = strpart(name, 0, comma)
                    endif
                    " And substitute & in the real name with the login of our user.
                    let amp = stridx(name, '&')
                    if amp != -1
                        let name = strpart(name, 0, amp) . toupper(login[0]) .
                                    \ strpart(login, 1) . strpart(name, amp + 1)
                    endif
                endif
            endfor
        endif

        " If we haven't found a name, try to gather it from other places.
        if !exists('name')
            " Maybe the environment has something of interest.
            if exists("$NAME")
                let name = $NAME
            else
                " No? well, use the login name and capitalize first
                " character.
                let name = toupper(login[0]) . strpart(login, 1)
            endif
        endif

        " Get our hostname.
        let hostname = system('hostname')
        if v:shell_error
            let hostname = 'localhost'
        else
            let newline = stridx(hostname, "\n")
            if newline != -1
                let hostname = strpart(hostname, 0, newline)
            endif
        endif

        " And finally set the username.
        let g:changelog_username = name . '  <' . login . '@' . hostname . '>'
    endif
endif

" External interface to create a new entry in the ChangeLog
" so that the filetype plugin (ftplugin/changelog.vim) can
" access the internal s:new_gnu_changelog_entry() function.
function! AddNewChangeLogEntry()
    call s:new_gnu_changelog_entry('', '')
endfunction

" Internal function to create a new entry in the ChangeLog.
function! s:new_gnu_changelog_entry(filename, funcname)
    " Deal with 'paste' option.
    let save_paste = &paste
    let &paste = 1
    call cursor(1, 1)

    " get today's date in the appropriate format
    let date = strftime(g:changelog_dateformat)

    " create the entry title
    if len(a:filename)
        if len(a:funcname)
            let etitle = printf("\t* %s (%s): {cursor}", a:filename,a:funcname)
        else
            let etitle = printf("\t* %s: {cursor}", a:filename)
        endif
    else
        let etitle = "\t* {cursor}"
    endif

    let search = printf('^\s*%s\_s*%s', date, g:changelog_username)
    if search(search) > 0
        " Found a section for today's date, now look
        " for the end of the date section and add an entry.
        call cursor(nextnonblank(line('.') + 1), 1)
        if search('^\s*$', 'W') > 0
            let p = line('.') - 1
        else
            let p = line('.')
        endif
        call append(p, split(etitle, '\n'))
        call cursor(p + 1, 1)
    else
        " Flag for removing empty lines at end of new ChangeLogs.
        let remove_empty = line('$') == 1
        " No entry today, so create a date-user header and insert an entry.
        let fmt = "%s  %s\n\n\%s\n\n"
        let todays_entry = printf(fmt, date, g:changelog_username, etitle)
        call append(0, split(todays_entry, '\n'))
        " Remove empty lines at end of file.
        if remove_empty
            $-/^\s*$/-1,$delete
        endif
        " Reposition cursor once we're done.
        call cursor(1, 1)
    endif

    " move the cursor and switch to insert mode
    if search('{cursor}') > 0
        let lnum = line('.')
        let line = getline(lnum)
        let cursor = stridx(line, '{cursor}')
        call setline(lnum, substitute(line, '{cursor}', '', ''))
    endif
    startinsert!

    " And reset 'paste' option
    let &paste = save_paste
endfunction

function! s:getFuncName()
    " b:changelog_tagfinder is a reference to a function that returns
    " a string that represents the class, method or function where the
    " cursor was when the user invoked the s:Open() function.  This
    " variable is set by filetype plugins.  We check this on every
    " s:Open() call so we can use different tag finder mechanisms for
    " different languages, e.g., pythonhelper.vim for python, a ctags
    " based tag finder for C and C++, another for Java and so on.
    if exists('b:changelog_tagfinder')
        return b:changelog_tagfinder()
    else
        return ''
    endif
endfunction

function! s:Open()
    " gather info about the file we're editing
    let funcname = s:getFuncName()

    " Search for the ChangeLog file to edit starting up
    " from the directory where the current file is
    let s:changelog = findfile("ChangeLog", expand("%:p:h") . ';')

    " don't do anything if we can't find the file
    if !filereadable(s:changelog)
        return
    endif

    " compare the ChangeLog directory and get the difference
    " ie. include the filenames path relative to ChangeLog
    if g:changelog_relativepath == 1
        let fname = expand("%:p")
        let changelogdir = fnamemodify(s:changelog, ":p:h")
        let m = matchend(fname, changelogdir) + 1
        let fname = fname[(m):]
    else
        let fname = expand("%:t")
    endif

    " see if we already opened the changelog file
    let bnum = bufnr(s:changelog)
    if bnum != -1
        " we already got a buffer for it
        let window_nr = bufwinnr(bnum)
        if window_nr != -1
            " we got the buffer in a window somewhere
            execute window_nr . 'wincmd w'
        else
            execute 'sbuffer ' bnum
        endif
    else
        " we haven't opened the changelog file in this session yet
        " split the current window and edit the changelog file there
        execute 'split ' . s:changelog
    endif

    " add the new entry now that we have the cursor in the window
    " with the buffer for the appropriate ChangeLog file 
    call s:new_gnu_changelog_entry(fname, funcname)
endfunction

" Add the Changelog global opening mapping
"nmap <silent> <Leader>o :call <SID>Open()<CR>

" Maps:
if !hasmapto('<Plug>GnuchlogOpen')
    nmap <unique> <Leader>o <Plug>GnuchlogOpen
endif
nmap <silent> <Plug>GnuchlogOpen :call <SID>Open()<CR>


" Restore Options
let &fo = s:keepfo
let &cpo= s:keepcpo


