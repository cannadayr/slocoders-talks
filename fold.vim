" --- fold_bqn.vim ---
" Provides paragraph-based folding + partial BQN highlighting
" (for lines beginning with 3 spaces or #).

if exists("b:current_syntax")
  finish
endif

" ------------------------------------------------------------------------
" 1) Paragraph-based folding (blank lines separate folds)
function! MyFoldExpr() abort
  if getline(v:lnum) =~# '^$'
    " Blank line => fold level 0 => no fold
    return 0
  else
    " Non-blank => fold level 1 => inside a fold
    return 1
  endif
endfunction

" Use the paragraph’s first line as the fold’s "title" when folded
function! MyFoldText() abort
  return getline(v:foldstart)
endfunction

set foldmethod=expr
set foldexpr=MyFoldExpr()
set foldtext=MyFoldText()

" ------------------------------------------------------------------------
" 2) Load official BQN syntax + apply only to select lines
"    - ^\s\{3} = lines starting with 3 spaces
"    - ^#      = lines starting with #
"    We combine them with the alternation "\|"
syntax include @bqn syntax/bqn.vim

" Instead of using 'syn region', use 'syn match', so each line is matched
" independently. This eliminates any multiline "bleed."
syn match bqnInput '^#.*'               contains=@bqn
syn match bqnInput '^\s\{3}\(\S.*\)\?$' contains=@bqn

" ------------------------------------------------------------------------
" 3) Optional highlight for folded lines
highlight Folded ctermfg=Gray ctermbg=NONE

" ------------------------------------------------------------------------
" 4) Re-center the cursor after opening a fold with za
"
" nnoremap = "normal mode, non-recursive mapping"
" za       = open one fold
" After opening, we call zz to re-center.

nnoremap za zMzazz

" Remap down arrow to "zj" (next fold)
nnoremap <down> zj

function! GoPrevFoldTop() abort
  " 1) Move to the start of the previous fold
  normal! zk

  " 2) If the fold is open (foldclosed('.') == -1), re-jump
  if foldclosed('.') == -1
    normal! zk
  endif

  " 3) foldclosed('.') now returns the top line of the (closed) fold
  let lnum = foldclosed('.')
  if lnum > 0
    " 4) Position the cursor at that fold's top line
    call cursor(lnum, 1)
  endif
endfunction

nnoremap <silent> <Up> <Cmd>call GoPrevFoldTop()<CR>

let b:current_syntax = "fold_bqn"

