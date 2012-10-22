" Notes {
"   A subset of https://github.com/spf13/spf13-vim
" }

" Environment {
    " Basics {
        set nocompatible        " must be first line
        if has ("unix") && "Darwin" != system("echo -n \"$(uname)\"")
          " on Linux use + register for copy-paste
          set clipboard=unnamedplus
        else
          " one mac and windows, use * register for copy-paste
          set clipboard=unnamed
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if has('win32') || has('win64')
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }

    " Filetype Workarounds {
        " Temporary workaround to Better-CSS-Syntax-for-Vim
        " See https://github.com/ChrisYip/Better-CSS-Syntax-for-Vim/issues/9
        " for more information
        autocmd BufNewFile,BufRead *.scss set filetype=css
        autocmd BufNewFile,BufRead *.sass set filetype=css
    " }

    " Setup Bundle Support {
    " The next three lines ensure that the ~/.vim/bundle/ system works
        filetype on
        filetype off
        set rtp+=~/.vim/bundle/vundle
        call vundle#rc()
    " }

" }

" Bundles {
    " Use bundles config {
        if filereadable(expand("~/.vimrc.bundles"))
            source ~/.vimrc.bundles
        endif
    " }
" }

" General {
    set noautochdir

    " set background dark         " Assume a dark background
    if !has('gui')
        "set term=$TERM          " Make arrow and other keys work
    endif
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " syntax highlighting
    scriptencoding utf-8

    set shortmess+=filmnrxoOtT      " abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
    set virtualedit=onemore         " allow for cursor beyond last character
    set history=1000                " Store a ton of history (default is 20)
    set hidden                      " allow buffer switching without saving

    set undofile                "so is persistent undo ...
    set undolevels=1000         "maximum number of changes that can be undone
    set undoreload=10000        "maximum number lines to save for undo on a buffer reload

    " To disable views set
    " Could use * rather than *.*, but I prefer to leave .files unsaved
    au BufWinLeave *.* silent! mkview  "make vim save view (state) (folds, cursor, etc)
    au BufWinEnter *.* silent! loadview "make vim load view (state) (folds, cursor, etc)
    " }
" }

" Vim UI {
    if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
        let g:solarized_termcolors=256
        color solarized                 " load a colorscheme
    endif
    let g:solarized_termtrans=1
    let g:solarized_contrast="high"
    let g:solarized_visibility="high"
    colorscheme solarized

    set tabpagemax=15               " only show 15 tabs
    set showmode                    " display the current mode

    set cursorline                  " highlight current line

    if has('cmdline_info')
        set ruler                   " show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
        set showcmd                 " show partial commands in status line and
                                    " selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\    " Filename
        set statusline+=%w%h%m%r " Options
        set statusline+=\ [%{&ff}/%Y]            " filetype
        set statusline+=\ [%{getcwd()}]          " current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set nu                          " Line numbers on
    set showmatch                   " show matching brackets/parenthesis
    set incsearch                   " find as you type search
    set hlsearch                    " highlight search terms
    set winminheight=0              " windows can be 0 line high
    set ignorecase                  " case insensitive search
    set smartcase                   " case sensitive when uc present
    set wildmenu                    " show list instead of just completing
    set wildmode=list:longest,full  " command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " backspace and cursor keys wrap to
    set scrolljump=5                " lines to scroll when cursor leaves screen
    set scrolloff=8                 " minimum lines to keep above and below cursor
    set list
    set listchars=extends:# " Highlight problematic whitespace
" }

" Formatting {
    set nowrap                      " wrap long lines
    set autoindent                  " indent at the same level of the previous line
    set shiftwidth=4                " use indents of 4 spaces
    set expandtab                   " tabs are spaces, not tabs
    set tabstop=4                   " an indentation every four columns
    set softtabstop=4               " let backspace delete indent
    "set matchpairs+=<:>                " match, to be used with %
    set pastetoggle=<F3>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    autocmd FileType c,cpp,java,php,javascript,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
" }

" Key (re)Mappings {

    "The default leader is '\', but many people prefer ',' as it's in a standard
    let mapleader = ','

    " Easier moving in tabs and windows
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_

    " Wrapped lines goes down/up to next row, rather than next line in file.
    nnoremap j gj
    nnoremap k gk

    " remap the tab movement
    map <C-t> gT
    map <C-T> gt

    " Stupid shift key fixes
    if has("user_commands")
        command! -bang -nargs=* -complete=file E e<bang> <args>
        command! -bang -nargs=* -complete=file W w<bang> <args>
        command! -bang -nargs=* -complete=file Wq wq<bang> <args>
        command! -bang -nargs=* -complete=file WQ wq<bang> <args>
        command! -bang Wa wa<bang>
        command! -bang WA wa<bang>
        command! -bang Q q<bang>
        command! -bang QA qa<bang>
        command! -bang Qa qa<bang>
    endif

    cmap Tabe tabe

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    """ Code folding options
    set nofoldenable

    "clearing highlighted search
    "nmap <silent> <leader>/ :nohlsearch<CR>

    " ack
    nmap <leader>/ :Ack 

    " visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Fix home and end keybindings for screen, particularly on mac
    " - for some reason this fixes the arrow keys too. huh.
    map [F $
    imap [F $
    map [H g0
    imap [H g0

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

" }

" Plugins {

    " AutoClose {
        " Turn autoclose off for now - i dont like it most the time"
        let b:AutoCloseOn = 0
    " }

    " Python mode {
        " disable folding
        let g:pymode_folding = 0
    " }

    " Misc {
        let g:NERDShutUp=1
        let b:match_ignorecase = 1
    " }

    " OmniComplete {
        if has("autocmd") && exists("+omnifunc")
            autocmd Filetype *
                \if &omnifunc == "" |
                \setlocal omnifunc=syntaxcomplete#Complete |
                \endif
        endif

        hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
        hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
        hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

        " some convenient mappings
        " inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
        " inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
        " inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
        " inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
        " inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
        " inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

        " automatically open and close the popup menu / preview window
        " au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
        set completeopt=menu,preview,longest
    " }

    " Ctags {
        set tags=./tags;/,~/.vimtags
    " }

    " SnipMate {
        " Setting the author var
        " If forking, please overwrite in your .vimrc.local file
        let g:snips_author = 'Steve Francia <steve.francia@gmail.com>'
    " }

    " NerdTree {
        " "map <C-t> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
        map <leader>t :NERDTreeTabsToggle<CR>
        " "nmap <leader>nt :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        let g:nerdtree_tabs_open_on_gui_startup=0
    " }

     " Session List {
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        nmap <leader>sl :SessionList<CR>
        nmap <leader>ss :SessionSave<CR>
        let sessionman_save_on_exit=0
     " }

     " Buffer explorer {
        nmap <leader>b :BufExplorer<CR>
     " }

     " JSON {
        nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
     " }

     " PyMode {
        let g:pymode_lint_checker = "pyflakes"
        nmap } ]M
        nmap { [M
     " }

     " command-t {
        nnoremap <silent> <leader>f :CommandT<CR>
        let g:CommandTMaxFiles=4000
        let g:CommandTMaxDepth=10           
        set wildignore+=*.o,*.obj,.git,.svn 
     "}

     " TagBar {
        nnoremap <silent> <leader>c :TagbarToggle<CR>
     "}

     " PythonMode {
     " Disable if python support not present
        if !has('python')
           let g:pymode = 1
        endif
     " }

     " neocomplcache {
     "   let g:neocomplcache_enable_at_startup = 1
     "   let g:neocomplcache_enable_camel_case_completion = 1
     "   let g:neocomplcache_enable_smart_case = 1
     "   let g:neocomplcache_enable_underbar_completion = 1
     "   let g:neocomplcache_min_syntax_length = 100
     "   let g:neocomplcache_enable_auto_delimiter = 1
     "   let g:neocomplcache_max_list = 15
     "   let g:neocomplcache_auto_completion_start_length = 1000
     "   let g:neocomplcache_force_overwrite_completefunc = 1
     "   let g:neocomplcache_snippets_dir='~/.vim/bundle/snipmate-snippets/snippets'

     "   " AutoComplPop like behavior.
     "   let g:neocomplcache_enable_auto_select = 0

     "   " SuperTab like snippets behavior.
     "   imap  <silent><expr><tab>  neocomplcache#sources#snippets_complete#expandable() ? "\<plug>(neocomplcache_snippets_expand)" : (pumvisible() ? "\<c-e>" : "\<tab>")
     "   smap  <tab>  <right><plug>(neocomplcache_snippets_jump) 

     "   " Plugin key-mappings.
     "   " Ctrl-k expands snippet & moves to next position
     "   " <CR> chooses highlighted value
     "   imap <C-k>     <Plug>(neocomplcache_snippets_expand)
     "   smap <C-k>     <Plug>(neocomplcache_snippets_expand)
     "   inoremap <expr><C-g>   neocomplcache#undo_completion()
     "   inoremap <expr><C-l>   neocomplcache#complete_common_string()
     "   inoremap <expr><CR>    neocomplcache#complete_common_string()

     "   " <CR>: close popup
     "   " <s-CR>: close popup and save indent.
     "   inoremap <expr><s-CR> pumvisible() ? neocomplcache#close_popup()"\<CR>" : "\<CR>"
     "   inoremap <expr><CR>  pumvisible() ? neocomplcache#close_popup() : "\<CR>"

     "   " <TAB>: completion.
     "   inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
     "   inoremap <expr><s-TAB>  pumvisible() ? "\<C-p>" : "\<TAB>"

     "   " <C-h>, <BS>: close popup and delete backword char.
     "   inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
     "   inoremap <expr><C-y>  neocomplcache#close_popup()

     "   " Define keyword.
     "   if !exists('g:neocomplcache_keyword_patterns')
     "     let g:neocomplcache_keyword_patterns = {}
     "   endif
     "   let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

     "   " Enable omni completion.
     "   autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
     "   autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
     "   autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
     "   autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
     "   autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
     "   autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

     "   " Enable heavy omni completion.
     "   if !exists('g:neocomplcache_omni_patterns')
     "       let g:neocomplcache_omni_patterns = {}
     "   endif
     "   let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
     "   let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
     "   let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
     "   let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

     "   " For snippet_complete marker.
     "   if has('conceal')
     "       set conceallevel=2 concealcursor=i
     "   endif

     " }

        set ts=4 sw=4 et
     " }

" }

" Issues {
    set background=dark
    set noautochdir
" }

 " Functions {

function! InitializeDirectories()
    let separator = "."
    let parent = $HOME
    let prefix = '.vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    for [dirname, settingname] in items(dir_list)
        let directory = parent . '/' . prefix . dirname . "/"
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()

function! NERDTreeInitAsNeeded()
    redir => bufoutput
    buffers!
    redir END
    let idx = stridx(bufoutput, "NERD_tree")
    if idx > -1
        NERDTreeMirror
        NERDTreeFind
        wincmd l
    endif
endfunction
" }

