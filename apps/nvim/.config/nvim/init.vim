" vim:sw=4:

" Brian Hicks' vimrc, presented in pseudo-literate style. Starring VIM (well,
" nVIM but you get the gist)

" We begin our story by installing plugins with plug. I'm not completely sold
" on plug yet, but it does look nice. The options below (see vimproc) are
" quite nice, but we'll see how it does in long-term use. The plugins are
" listed in alphabetical order. (block-select and `!sort -f` to do this in the
" future.)

" https://github.com/junegunn/vim-plug
call plug#begin('~/.config/nvim/plugged')

""" Post-update hooks for plugs
function! BuildDeoplete(info)
    if a:info.status != 'unchanged' || a:info.force
        normal UpdateRemotePlugins
    endif
endfunction

Plug 'christoomey/vim-tmux-navigator'                            " navigate through vim and tmux windows with the same bindings
Plug 'critiqjo/unite-fasd.vim'                                   " integration with unite
Plug 'ddollar/nerdcommenter'                                     " (un)comment things
Plug 'easymotion/vim-easymotion'                                 " hop around with <leader><leader>
Plug 'godlygeek/tabular'                                         " line content up by regexes
Plug 'jiangmiao/auto-pairs'                                      " automatically insert pairs (like `(` and `'`)
Plug 'majutsushi/tagbar'                                         " navigate tags in the project. May replace with unit-tag or unite-outline?
Plug 'mattn/emmet-vim'                                           " expand emmet-like expressions in HTML/XML
Plug 'mattn/gist-vim'                                            " post gists
Plug 'mattn/webapi-vim'                                          " used mattn/gist-vim
Plug 'scrooloose/syntastic'                                      " syntax checks
Plug 'Shougo/deoplete.nvim', { 'do': function('BuildDeoplete') } " autocompletion
Plug 'Shougo/neosnippet.vim' | Plug 'Shougo/neosnippet-snippets' " snippet management
Plug 'Shougo/unite.vim'                                          " finding things and making menus
Plug 'Shougo/vimproc.vim', { 'do': 'make' }                      " asychronous stuff for vim, legacy req in neovim
Plug 'tmux-plugins/vim-tmux-focus-events'                        " add focus events in tmux
Plug 'tommcdo/vim-exchange'                                      " cx<motion> for swapping text
Plug 'tpope/vim-dispatch'                                        " split tmux or whatever for testing (or whatever)
Plug 'tpope/vim-eunuch'                                          " unix shell commands in vim, like :Remove and :Rename
Plug 'tpope/vim-fugitive'                                        " git wrapper
Plug 'tpope/vim-obsession'                                       " session management
Plug 'tpope/vim-repeat'                                          " repeat operators (such as those in vim-surround)
Plug 'tpope/vim-sensible'                                        " sensible defaults like incsearch
Plug 'tpope/vim-surround'                                        " surround text with parens, quotes, etc
Plug 'tpope/vim-unimpaired'                                      " pairs of mappings for navigation. I mostly use `[ ` and `] ` for inserting new lines
Plug 'tpope/vim-vinegar'                                         " better netrw - press `-` to navigate up
Plug 'vim-airline/vim-airline'                                   " fancy status line
Plug 'wellle/tmux-complete.vim'                                  " autocompletion from lines in tmux

" language-specific plugs
Plug 'ElmCast/elm-vim'
Plug 'fatih/vim-go' | Plug 'zchee/deoplete-go', { 'do': 'make' }
Plug 'tmux-plugins/vim-tmux'
Plug 'cespare/vim-toml'

" color schemes
Plug 'chriskempson/base16-vim'

" TODO: tsukkee/unite-tag and/or h1mesuke/unite-outline. Best in combination?

call plug#end()

"""""""""""""""""""""""""""
""" BASIC CONFIGURATION """
"""""""""""""""""""""""""""

" I'm coming back to VIM from Spacemacs, so a lot of the keybinding choices
" are taken from there. The basic philosophy: leader is spacebar, and does
" editor-level tasks (e.g. git or window management.) Comma is the leader for
" buffer or language-level tasks (e.g. running tests, linting) My personal
" addition/spin on this is that actions that change state (especially state on
" disk or potentially destructive actions) should always be uppercased (e.g.
" `<leader>gW` for `:Gwrite`.) This does not, however, mean that all
" capitzliaed shortcuts change state (e.g. `<leader>wS` below)

""" Simple defaults
filetype plugin indent on
syntax on
set number
set relativenumber
set autoread
set ignorecase

""" Color Scheme
colorscheme base16-default
set background=dark

""" leader
let mapleader = ' '
let maplocalleader = ','

""" use ; as :, but don't lose ;
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

""" navigation

" move up and down by visual line instead of real line, and move the real line
" behavior to the previous keys
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

" escape with fd instead of <esc>
inoremap fd <esc>

""" splitting and split navigation
" libterm (used by nvim) apparently reads <c-h> as backspace, which comes from
" terminfo.  Since I don't want to change terminfo on every box I use, it's
" easier to just remap <bs> to what I intend <c-h> to be. Of course, this
" means that the backspace key will jump the window right in normal mode, but
" that's OK since there are more effective navigation methods.
if has('nvim')
    " this used to be managed directly, now it's in vim-tmux-nvaigator
    " nnoremap <bs> <c-w>h
    nnoremap <bs> :TmuxNavigateLeft<cr>
endif

" the basic idea behind splitting: w for *w*indow, then lower case for splits
" and upper case for splits *and then moving to the split*.
nnoremap <leader>ws <c-w>s
nnoremap <leader>wS <c-w>s<c-w>j
nnoremap <leader>wv <c-w>v
nnoremap <leader>wV <c-w>v<c-w>l

""" Visual Mode

" bring repeat into visual mode
vnoremap . :normal .<cr>

""" Searching
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/#making-vim-more-useful
" uses full regexes instead of vimmy matching
nnoremap / /\v
vnoremap / /\v

""" Editing vimrc
" reload vimrc on save. very useful for experimenting, but it's quite the
" footgun if you have syntax errors.
augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

nnoremap <leader>ev :vsplit $MYVIMRC<CR>

""" Errors
nnoremap <leader>eN :cnfile<CR>
nnoremap <leader>eP :cpfile<CR>
nnoremap <leader>ec :cclose<CR>
nnoremap <leader>en :cnext<CR>
nnoremap <leader>eo :copen<CR>
nnoremap <leader>ep :cprevious<CR>

"""""""""""""""
""" PLUGINS """
"""""""""""""""

" Shortcut mnemonics:
"
" - *c*ommenting
" - *E*diting
" - *e*rrors
" - *f*inding
" - *g*it (with fugitive)
" - *P*lugins
" - *r*unning
" - *s*yntax
" - *t*oggles

""" Plug
nnoremap <leader>Pd :PlugDiff<CR>
nnoremap <leader>PI :PlugInstall<CR>
nnoremap <leader>Ps :PlugStatus<CR>
nnoremap <leader>PU :PlugUpdate<CR>

""" Unite
" TODO: use this configuration a while and then revisit from the "advanced
" configuration" in `:help unite`
call unite#filters#matcher_default#use(['matcher_fuzzy'])

nnoremap <silent> <leader>f/ :<c-u>Unite -ignorecase -start-insert grep:.<CR>
nnoremap <silent> <leader>fb :<c-u>Unite -ignorecase -start-insert buffer<CR>
nnoremap <silent> <leader>ff :<c-u>Unite -ignorecase -start-insert file_rec/git<CR>
nnoremap <silent> <leader>fr :<c-u>UniteResume<CR>

""" Unite-FASD

" update vim when reading a file, but don't double count `x` when invoking
" `nvim x`
au VimEnter * let g:unite_fasd#read_only = 0

let g:unite_fasd#fasd_path = '/usr/local/bin/fasd'

nnoremap <silent> <leader>fa :<c-u>Unite -ignorecase -start-insert fasd<CR>

" configuration for find by search, taken from `:help unite`
if executable('ag')
    " Use ag (the silver searcher)
    " https://github.com/ggreer/the_silver_searcher
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts =
      \ '-i --vimgrep --hidden --ignore ' .
      \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
    let g:unite_source_grep_recursive_opts = ''
endif

""" Fugitive
" remember in Gstatus that help can be displayed by `g?`
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gP :Gpush --force<CR>
nnoremap <leader>gf :Gfetch<CR>
nnoremap <leader>gF :Gpull<CR>
nnoremap <leader>gW :Gwrite<CR>
nnoremap <leader>gR :Gmove<CR>
nnoremap <leader>gD :Gremove<CR>
nnoremap <leader>go :Gbrowse<CR>

""" Tagbar
" TODO: add ctags to zish
nnoremap <leader>tt :TagbarToggle<CR>

""" Airline

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" I don't want to bother with patching fonts just for left and right arrows.
" Straight bars look nice too.
let g:airline_left_sep = ''
let g:airline_right_sep = ''

let g:airline_symbols.linenr = '␤'
let g:airline_symbols.branch = ''

""" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#omni#input_patterns = {}

""" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

nnoremap <leader>ts :SyntasticToggleMode<CR>
nnoremap <leader>ee :Errors<CR>
nnoremap <leader>si :SyntasticInfo<CR>
nnoremap <leader>ss :SyntasticCheck<CR>
nnoremap <leader>sr :SyntasticReset<CR>

let g:syntastic_mode_map = {
  \ "mode": "active",
  \ "passive_filetypes": ["go"] }

""" Tabularize
" *E*dit *a*lignment
nnoremap <leader>Ea" :Tabularize /"<CR>
nnoremap <leader>Ea, :Tabularize /,/l0r1<CR>
nnoremap <leader>Ea# :Tabularize /#<CR>
nnoremap <leader>Ea/ :Tabularize /\/\+<CR>

""" NerdCommenter
" We don't need any additional bindings because they're all well-organized
" under <leader> by default :)

""" Gist.vim
nnoremap <leader>ggg :Gist -p<CR>
nnoremap <leader>ggG :Gist -P<CR>

""" Dispatch

" remember: in languages you can set `b:dispatch` to the command to run with
" dispatch. Works great in autocommands: `autocmd FileType java let b:dispatch
" = 'javac %'`
nnoremap <leader>rr :Dispatch<CR>

"""""""""""""""""
""" LANGUAGES """
"""""""""""""""""

" languages keybindings are implemented with the following mnemonics:
"
" - *a*lternate
" - *c*ompile
" - *d*ocumentation
" - *g*o somewhere
" - *i*nspect (stuff like `go oracle`)
" - *r*un
" - *t*est
" - re*f*actor
" - *s*: repl. Mnemonic is *s*lime, but this could be improved.
"
" The primary action typically is the key repeated. So for example, `tt` could
" test the entire project, or `gg` would go to the definition under the point.

" before we do anything too crazy, let's set up some basic bindings to help
" with discoverability. These will be active in every language, but will
" display bindings for that language when triggered. If there are no bindings
" under a given prefix, this will show that.
nnoremap <localleader>a :map <localleader>a<cr>
nnoremap <localleader>c :map <localleader>c<cr>
nnoremap <localleader>d :map <localleader>d<cr>
nnoremap <localleader>f :map <localleader>f<cr>
nnoremap <localleader>g :map <localleader>g<cr>
nnoremap <localleader>i :map <localleader>i<cr>
nnoremap <localleader>r :map <localleader>r<cr>
nnoremap <localleader>s :map <localleader>s<cr>
nnoremap <localleader>t :map <localleader>t<cr>

""" Go (via `fatih/vim-go`)

" TODO: go#jobcontrol#StatusLine() in Airline

" just some reminders from the manual:
"
" - `af` and `if` as text objects for functions (and see
"   `go_textobj_include_fucntion_doc` below)
" - `]]` and `[[` as text motions around functions

let g:go_fmt_autosave=1
let g:go_fmt_command="goimports"
let g:go_textobj_include_function_doc=1

" Keybindings
augroup go
    autocmd!
    autocmd FileType go nmap <localleader>aa <Plug>(go-alternate-edit)
    autocmd FileType go nmap <localleader>cc <Plug>(go-build)
    autocmd FileType go nmap <localleader>cg <Plug>(go-generate)
    autocmd FileType go nmap <localleader>ci <Plug>(go-install)
    autocmd FileType go nmap <localleader>dd <Plug>(go-doc)
    autocmd FileType go nmap <localleader>fl <Plug>(go-metalinter)
    autocmd FileType go nmap <localleader>fr <Plug>(go-rename)
    autocmd FileType go nmap <localleader>gf <Plug>(go-files)
    autocmd FileType go nmap <localleader>gg <Plug>(go-def)
    autocmd FileType go nmap <localleader>i< <Plug>(go-callees)
    autocmd FileType go nmap <localleader>i> <Plug>(go-callers)
    autocmd FileType go nmap <localleader>ic <Plug>(go-channelpeers)
    autocmd FileType go nmap <localleader>id <Plug>(go-describe)
    autocmd FileType go nmap <localleader>if <Plug>(go-freevars)
    autocmd FileType go nmap <localleader>ii <Plug>(go-implements)
    autocmd FileType go nmap <localleader>ir <Plug>(go-referrers)
    autocmd FileType go nmap <localleader>is <Plug>(go-callstack)
    autocmd FileType go nmap <localleader>rr <Plug>(go-run)
    autocmd FileType go nmap <localleader>rs <Plug>(go-run-split)
    autocmd FileType go nmap <localleader>tc <Plug>(go-coverage)
    autocmd FileType go nmap <localleader>tf <Plug>(go-test-func)
    autocmd FileType go nmap <localleader>tt <Plug>(go-test)
    autocmd FileType go nmap <localleader>tv <Plug>(go-test-vet)
augroup END

""" Elm (via `ElmCast/elm-vim`)

" elm-vim provides some bindings by default, but I'm creating my own very
" specific language bindings, so... thanks but no thanks!
let g:elm_setup_keybindings = 0

let g:elm_format_autosave = 1
let g:elm_syntastic_show_warnings = 1

let g:deoplete#omni#input_patterns.elm = '\.'

" Keybindings
augroup elm
    autocmd!
    autocmd FileType elm set sw=2
    autocmd FileType elm nmap <localleader>cb <Plug>(elm-make)
    autocmd FileType elm nmap <localleader>cc <Plug>(elm-make-main)
    autocmd FileType elm nmap <localleader>tb <Plug>(elm-test)
    autocmd FileType elm nmap <localleader>tt :ElmTest<CR>
    autocmd FileType elm nmap <localleader>ss <Plug>(elm-repl)
    autocmd FileType elm nmap <leader>ed <Plug>(elm-error-detail)
    autocmd FileType elm nmap <localleader>dd <Plug>(elm-show-docs)
    autocmd FileType elm nmap <localleader>do <Plug>(elm-browse-docs)
augroup END
