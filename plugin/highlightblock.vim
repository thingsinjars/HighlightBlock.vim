"------------------------------------------------------------------------------
" Exit when your app has already been loaded (or "compatible" mode set)
if exists("g:loaded_HighlightBlock") || &cp
  finish
endif
let g:loaded_HighlightBlock= 1 " your version number
let s:keepcpo           = &cpo
set cpo&vim

" Public Interface:
" HighlightCodeBlocks: is a function you expect your users to call
" HB: some sequence of characters that will run your AppFunction
" Repeat these three lines as needed for multiple functions which will
" be used to provide an interface for the user
if !exists('g:highlightblock_map_keys')
    let g:highlightblock_map_keys = 1
endif

if g:highlightblock_map_keys
    nnoremap <leader>i :call <sid>HighlightCodeBlocks()<CR>
endif

autocmd InsertLeave *.*  call <sid>HighlightCodeBlocks()

fun! s:HighlightCodeBlocks()
  sign define wholeline linehl=HighlightedBlock
  let linenr = 0
  let lastBlock = 'cssStyle'
  sign unplace *
  while linenr < line("$")
    let linenr += 1	" The += construction requires vim 7.0 . 
    " Need to detect 'is this line active for 'htmlJavaScript' highlight or
    " 'cssStyle' highlight?'
    let currentBlock = synIDattr(synID(linenr, 1, 1), "name")
    if currentBlock == 'cssStyle' || currentBlock == 'javaScript' || currentBlock == 'javaScriptLineComment' || currentBlock == '' && lastBlock == 'cssStyle' || currentBlock == '' && lastBlock == 'javaScript' || currentBlock == '' && lastBlock == 'javaScriptLineComment'
      exe ":sign place 1 name=wholeline line=" . linenr . " file=" . expand("%:p")
      if &numberwidth == 6
        set numberwidth=4
      endif
    endif
    if currentBlock != ''
      let lastBlock = currentBlock
   endif
  endwhile 
endfun

" ------------------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo

