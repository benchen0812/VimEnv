" Plugins
" "--------------
call plug#begin('~/.vim/plugged')
  " for general purpose development
  Plug 'scrooloose/nerdtree'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'Yggdroot/indentLine'
  Plug 'tpope/vim-surround'
  Plug 'jiangmiao/auto-pairs'
  Plug 'scrooloose/nerdcommenter'
  Plug 'MarcWeber/vim-addon-mw-utils'
  Plug 'tomtom/tlib_vim'
  Plug 'majutsushi/tagbar'

  " git development
  Plug 'tpope/vim-fugitive'
  Plug 'ruanyl/vim-gh-line'
  " Plug 'airblade/vim-gitgutter'

  " style
  Plug 'KabbAmine/yowish.vim'
  Plug 'itchyny/lightline.vim'

  " tmunx
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'edkolev/tmuxline.vim'

  " snippet and complete
  Plug 'SirVer/ultisnips'
  Plug 'ervandew/supertab'
  Plug 'Valloric/YouCompleteMe'
  Plug 'honza/vim-snippets'

  " searching
  "Plug '/usr/local/opt/fzf'
  Plug '~/.fzf'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  "Powerline
  Plug 'powerline/powerline'

  " for ruby/rails development
  Plug 'vim-ruby/vim-ruby'
  Plug 'tpope/vim-rails'
  Plug 'thoughtbot/vim-rspec'
  Plug 'w0rp/ale'
  Plug 'ngmy/vim-rubocop'

  " for react/js development
  Plug 'mattn/emmet-vim'
  Plug 'pangloss/vim-javascript'
  Plug 'MaxMEllon/vim-jsx-pretty'
  Plug 'Valloric/MatchTagAlways'
  Plug 'alvan/vim-closetag'

  " For python syntax Checking and Highlighting
  Plug 'vim-syntastic/syntastic'
  Plug 'nvie/vim-flake8'
  Plug 'sheerun/vim-polyglot'

call plug#end()

"--------------
" Settings
"--------------
" set shell=zsh
" set shellcmdflag=-ic
set nocompatible
set clipboard=unnamed
set noswapfile
set hidden
set nobomb
set noswapfile

"vim-syntastic/syntastic, syntax checking plugin
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" git gutter
set updatetime=100
set signcolumn=yes

set smartindent
set smarttab
set backspace=indent,eol,start

" search
set hlsearch
set ignorecase
set smartcase
set incsearch

" copy paste
set clipboard+=unnamed  " use the clipboards of vim and win
set pastetoggle=<F10>
set go+=a               " Visual selection automatically copied to the clipboard

"Fold option enable
set foldmethod=indent
set foldlevelstart=20

"--------------
"Filetype and Encoding
"--------------

filetype on
filetype indent on
filetype plugin on

" file encoding
set encoding=utf-8
scriptencoding utf-8

"--------------
" Mouse Click on vim support enable
"--------------
"set mouse=a

"--------------
" key mapping
"--------------
" .vim/plugin/keymappings.vim

"--------------
" other settings
"--------------

" comment add space
let NERDSpaceDelims=1

"tmux
let g:airline#extensions#tmuxline#enabled = 1
let g:tmuxline_powerline_separators = 0

" close tag settings
let g:closetag_filetypes = 'html,xhtml,phtml,javascript.jsx,eruby'

"indent line
let g:indentLine_color_term = 239

"jumping window on
autocmd VimEnter * wincmd w

" git hi
hi GitGutterAdd guibg=red guifg=green

" Python make the code looks pretty
let python_highlight_all=1
syntax on

"--------------
" note
"--------------
"
" note
" "*P
" :read !pbpaste
" bash$ pbpaste | vim -

" Enable pathogen.vim
"execute pathogen#infect()


vnoremap <Leader>hh :call Pphashv()<cr>
noremap <Leader>hh :call Pphash()<cr>

function! Pphash()
  execute "set filetype=ruby"
  " split {} []
  execute ":%s/[{[]/&\r/g"
  execute ":%s/[]}]/\r&/g"

  execute ":%s/=>/: /g"
  " split new line on , and remove blank line
  execute ":%s/,/,\r/g"
  execute "g/^$/d"
  execute ":normal! gg=G"
endfunction

function! Pphashv()
  execute "set filetype=ruby"
  " split {} []
  execute ":s/[{[]/&\r/g"
  execute ":s/[]}]/\r&/g"

  execute ":s/=>/: /g"
  " split new line on , and remove blank line
  execute ":s/,/,\r/g"
  execute "g/^$/d"
endfunction

"Full Stack Setting
"For js, html, css file standard
au BufNewFile,BufRead *.js, *.html, *.css
    \ tabstop=2
    \ softtabstop=2
    \ shiftwidth=2

"Python setting
" PEP8 standard
au Filetype python set
    \ tabstop=4
    \ softtabstop=4
    \ shiftwidth=4
    \ textwidth=79
    \ expandtab
    \ autoindent
    \ fileformat=unix


"python with virtualenv support
"py << EOF
"import os
"import sys
"if 'VIRTUAL_ENV' in os.environ:
"  project_base_dir = os.environ['VIRTUAL_ENV']
"  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"  execfile(activate_this, dict(__file__=activate_this))
"EOF

" Google pylint setting
" Copyright 2019 Google LLC
"
" Licensed under the Apache License, Version 2.0 (the "License");
" you may not use this file except in compliance with the License.
" You may obtain a copy of the License at
"
"    https://www.apache.org/licenses/LICENSE-2.0
"
" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS,
" WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
" See the License for the specific language governing permissions and
" limitations under the License.

" Indent Python in the Google way.
"


"" Set Python Path
setlocal indentexpr=GetGooglePythonIndent(v:lnum)

let s:maxoff = 50 " maximum number of lines to look backwards.

function GetGooglePythonIndent(lnum)

  " Indent inside parens.
  " Align with the open paren unless it is at the end of the line.
  " E.g.
  "   open_paren_not_at_EOL(100,
  "                         (200,
  "                          300),
  "                         400)
  "   open_paren_at_EOL(
  "       100, 200, 300, 400)
  call cursor(a:lnum, 1)
  let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
        \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
        \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
        \ . " =~ '\\(Comment\\|String\\)$'")
  if par_line > 0
    call cursor(par_line, 1)
    if par_col != col("$") - 1
      return par_col
    endif
  endif

  " Delegate the rest to the original function.
  return GetPythonIndent(a:lnum)

endfunction

let pyindent_nested_paren="&sw*2"
let pyindent_open_paren="&sw*2"

" Setting for Syntastic
 let g:syntastic_python_python_exec = 'python3'
 let g:syntastic_python_pylint_exec = '/usr/bin/pylint3'
 let g:syntastic_python_checkers = ['pylint', 'pylint3']
