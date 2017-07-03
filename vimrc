" vim: fdm=marker foldmarker={{{,}}} foldlevel=1

" Settings {{{
    " general {{{
        set nocompatible
        set ff=unix
        set autoread

        " better window/*nix compatibility
        set viewoptions=folds,options,cursor,unix,slash

        " Backspace for dummies
        set backspace=indent,eol,start

        " Faster terminal updates
        set ttyfast

        " Allow buffer switching without saving
        set hidden

        set sessionoptions-=help

        set modeline
        set modelines=5

        " lower mode switching delay
        set ttimeoutlen=50

        " Let Vim use utf-8 internally, because many scripts require this
        set encoding=utf-8
        " add gbk to display Chinese gbk
        set fileencodings=utf-8,gbk

        " always use system clipboard
        set clipboard=unnamed,unnamedplus,autoselect
    " }}}
    " nobackups {{{
        set nobackup
        set nowritebackup
        set noswapfile
    " }}}
    " indent {{{
        set autoindent
        set shiftwidth=2
        set softtabstop=2
        set expandtab
        " fixes html indenting in vim 7.4
        let g:html_indent_inctags = "html,body,head,tbody"
    " }}}
    " search {{{
        set incsearch
        set hlsearch
        set ignorecase
        set smartcase
    " }}}
    " wildignore {{{
        set wildignore=*.o,*.pyc,*~,*.class
        set wildignore+=*.jpg,*.png,*.gif,*.pdf,*.tar,*.zip,*.tgz
        set wildignore+=*.tmp
        set wildignore+=.git,.atom,.idea,.settings,.travis
        set wildignore+=node_modules,bower_components,target,dist
        set wildignore+=.DS_Store
    " }}}
    " UI {{{
        syntax on           " Syntax highlighting

        set shortmess+=I    " disable startup text
        set mouse=a         " Automatically enable mouse usage
        set mousehide       " hide mouse when typing
        set laststatus=2    " always display status line
        set nu              " show number
        set nocursorline    " do not highlight current line
        set linespace=3     " line spacing in pixel
        set tabpagemax=15   " Only show 15 tabs
        set showmode        " Display the current mode
        set showcmd         " display incomplete commands
        set ruler           " turn on status ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showmatch       " show matching parenthesis
        set virtualedit=onemore " Allow for cursor beyond last character

        set nowrap          " don't wrap text for performance reason

        set scrolljump=5    " Lines to scroll when cursor leaves screen
        set scrolloff=3     " Minimum lines to keep above and below cursor

        set splitbelow      " open split panes to bottom and
        set splitright      " right

        set wildmenu                    " Show list instead of just completing
        set wildmode=list:longest,full  " <Tab> completion, list matches, then longest common part, then all.

        set display+=lastline " no more @'s even when line doesn't fit screen

        set guitablabel=%t    " only display file name on tab title

        set foldnestmax=3

        let g:netrw_liststyle=3 " file tree layout

        set linebreak         " word wrapping
        set showbreak=\ \ "   " add 2 more spaces for indented wrapped lines

        if v:version >= 704
            set breakindent   " keep indent for wrapped lines
        endif

        " set t_Co=256 " use 256 colors
        if has("termguicolors")
            set termguicolors
        endif
    " }}}
    " gvim {{{
        if has("gui_running")
            set guioptions-=m " remove menu bar
            set guioptions-=T " remove toolbar
            set guioptions-=r " remove right scrollbar
            set guioptions-=L " remove left  scrollbar
            set guioptions+=e " use native tab display
        endif
    " }}}
    " paste automatically with paste mode on {{{
        if exists('$TMUX')
            function! WrapForTmux(s)
                let tmux_start = "\<Esc>Ptmux;"
                let tmux_end = "\<Esc>\\"
                return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
            endfunction

            let &t_SI .= WrapForTmux("\<Esc>[?2004h")
            let &t_EI .= WrapForTmux("\<Esc>[?2004l")
        endif

        function! XTermPasteBegin()
            set pastetoggle=<Esc>[201~
            set paste
            return ""
        endfunction

        inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
    " }}}
    " Arrow Key Fix {{{
        " https://github.com/spf13/spf13-vim/issues/780
        if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif
    " }}}
" }}}

" Key Mapping {{{
    " New Bindings {{{
        let g:mapleader = " "

        " Edit/Reload vimrc
        nmap <silent> <leader>ev :e $MYVIMRC<cr>
        nmap <silent> <leader>sv :so $MYVIMRC<cr>

        " highlight same words under cursor when double click on it
        nmap <2-LeftMouse> *

        " replace word under cursor
        nmap <leader>r :%s/\<<C-r><C-w>\>/
        " display all lines with keyword under cursor and ask which one to jump to
        nmap gr [I:let nr = input("Which one: ")<bar>exe "normal " . nr ."[\t"<cr>

        nmap <silent> <leader>/ :nohlsearch<cr>

        nmap <leader>f0 :set foldlevel=0<CR>
        nmap <leader>f1 :set foldlevel=1<CR>
        nmap <leader>f2 :set foldlevel=2<CR>

        map <F2> :tabprevious<cr>
        map <F3> :tabnext<cr>

        map <F5> :let &background = (&background == "dark" ? "light" : "dark")<cr>

        noremap <leader>y "*y
        noremap <leader>p "*p

        set pastetoggle=<F12>
    " }}}
    " Command abbrev {{{
        " For when you forget to sudo.. Really Write the file.
        cmap w!! w !sudo tee % >/dev/null
        " change to current working directory
        cmap cwd lcd %:p:h
        cmap pwdf echo @%
    " }}}
    " Default Replacements/Extension/Overwrite {{{

        " Yank from the cursor to the end of the line, to be consistent with C and D.
        nnoremap Y y$

        " save my pinky
        nnoremap fa zA
        nnoremap F za

        " fix stupid SHIFTs
        command! -bang -nargs=* -complete=file E e<bang> <args>
        command! -bang -nargs=* -complete=file W w<bang> <args>
        command! -bang -nargs=* -complete=file Wq wq<bang> <args>
        command! -bang -nargs=* -complete=file WQ wq<bang> <args>
        command! -bang Wa wa<bang>
        command! -bang WA wa<bang>
        command! -bang Q q<bang>
        command! -bang QA qa<bang>
        command! -bang Qa qa<bang>

        nmap J j
        vmap J j
        nmap K k
        vmap K k
        nmap L l
        vmap L l
        nmap H h
        vmap H h

        " Swaps
        nnoremap k gk
        nnoremap j gj
        nnoremap gk k
        nnoremap gj j

        " Disabled
        nnoremap Q    q
        nnoremap q    <NOP>
        nnoremap q:   <NOP>
        " help page
        nnoremap <F1> <NOP>
        inoremap <F1> <NOP>

        " Start/End
        inoremap <C-e> <End>
        inoremap <C-a> <Home>
    " }}}
" }}}

" Utils {{{
    " Indentation {{{
        command! Indent2 :set ts=2 sts=2 sw=2
        command! Indent4 :set ts=4 sts=4 sw=4
        command! Indent2to4 :set ts=2 sts=2 sw=2 noet | retab! | set ts=4 sts=4 sw=4 et | retab
        command! Indent4to2 :set ts=4 sts=4 sw=4 noet | retab! | set ts=2 sts=2 sw=2 et | retab
    " }}}
    " Resize Window {{{
        command! QuarterScreen :set lines=25 | set columns=85  " quarter screen
        command! HalfScreen    :set lines=50 | set columns=85  " half screen
        command! FullScreen    :set lines=50 | set columns=180 " full screen
        command! TinyScreen    :set lines=20 | set columns=45  " tiny screen
    " }}}
    " Trailing Spaces {{{
        command! Trim :%s:\s\+$::g
    " }}}
    " Wipe Buffer {{{
        function! DeleteInactiveBufs()
            "From tabpagebuflist() help, get a list of all buffers in all tabs
            let tablist = []
            for i in range(tabpagenr('$'))
                call extend(tablist, tabpagebuflist(i + 1))
            endfor

            let nWipeouts = 0
            for i in range(1, bufnr('$'))
                if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
                    "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
                    silent exec 'bwipeout' i
                    let nWipeouts = nWipeouts + 1
                endif
            endfor
            echomsg nWipeouts . ' buffer(s) wiped out'
        endfunction
        command! WipeBuffer call DeleteInactiveBufs()
    " }}}
    " Focus Mode {{{
        function! FocusModeToggle()
            " this doesn't work on large screen, but why if you get a big
            " enough screen to code
            if winheight(0) > 35 && winwidth(0) > 150
                :winc=
            else
                :999winc+ | 999winc>
            endif
        endfunction
        command! Focus call FocusModeToggle()
        nnoremap ƒ :call FocusModeToggle()<cr>
    " }}}
    " 80 Columns {{{
        set colorcolumn=0
        let s:color_column_old = 80
        function! s:ToggleColorColumn()
            if s:color_column_old == 0
                let s:color_column_old = &colorcolumn
                windo let &colorcolumn = 0
            else
                windo let &colorcolumn=s:color_column_old
                let s:color_column_old = 0
            endif
        endfunction
        nnoremap <silent>,8 :call <SID>ToggleColorColumn()<cr>
    " }}}
    " Abbreviations {{{
        silent iabbrev vimmarker vim: foldmethod=marker foldmarker={,}
    " }}}
    " Autocomplete from ajh17/VimCompletesMe {{{
        function! s:vim_completes_me(shift_tab)
            let dirs = ["\<c-p>", "\<c-n>"]
            let dir = 1

            if pumvisible()
                return a:shift_tab ? dirs[!dir] : dirs[dir]
            endif

            " Figure out whether we should indent/de-indent.
            let pos = getpos('.')
            let substr = matchstr(strpart(getline(pos[1]), 0, pos[2]-1), "[^ \t]*$")
            if empty(substr)
                let s_tab_deindent = pos[2] > 1 ? "\<C-h>" : ""
                return l:s_tab_deindent
            endif

            if a:shift_tab && exists('g:vcm_s_tab_mapping')
                return g:vcm_s_tab_mapping
            endif

            let omni_pattern = '\k\+\(\.\|->\|::\)\k*$'
            let is_omni_pattern = match(substr, omni_pattern) != -1
            let file_pattern = (has('win32') || has('win64')) ? '\\\|\/' : '\/'
            let is_file_pattern = match(substr, file_pattern) != -1

            if is_omni_pattern && (!empty(&omnifunc))
                " Check position so that we can fallback if at the same pos.
                if get(b:, 'tab_complete_pos', []) == pos && b:completion_tried
                    let exp = "\<C-x>" . dirs[!dir]
                else
                    echo "Looking for members..."
                    let exp = "\<C-x>\<C-o>"
                    let b:completion_tried = 1
                endif
                let b:tab_complete_pos = pos
                return exp
            elseif is_file_pattern
                return "\<C-x>\<C-f>"
            endif

            " First fallback to keyword completion if special completion was already tried.
            if exists('b:completion_tried') && b:completion_tried
                let b:completion_tried = 0
                return "\<C-e>" . dirs[!dir]
            endif

            " Fallback
            let b:completion_tried = 1
            return dirs[!dir]
        endfunction

        inoremap <expr> <plug>vim_completes_me_forward  <sid>vim_completes_me(0)
        inoremap <expr> <plug>vim_completes_me_backward <sid>vim_completes_me(1)

        " Maps
        imap <Tab>   <plug>vim_completes_me_forward
        imap <S-Tab> <plug>vim_completes_me_backward

        " Autocmds
        augroup VCM
            autocmd!
            autocmd InsertEnter * let b:completion_tried = 0
            if v:version > 703 || v:version == 703 && has('patch598')
                autocmd CompleteDone * let b:completion_tried = 0
            endif
        augroup END
    " }}}
" }}}

" Autocmd {{{
    augroup filetype_change " {{{
        au!
        au BufNewFile,BufRead *.markdown,*.md setlocal filetype=markdown
        au BufNewFile,BufRead *.html setlocal filetype=htmlm4 " show js syntax on html
    augroup end " }}}
" }}}

" Custom config {{{
    syntax enable
    set background=dark " default bg should be dark
    color desert
" }}}
