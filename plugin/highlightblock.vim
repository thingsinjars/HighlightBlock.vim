" HighlightBlocksPlugin: Uses signs to apply highlighting to a full-width line
" (not just until the last character)
" Author:   Simon Madine (@thingsinjars)
" Date:     6 October 2011
" Usage:    Runs automatically on new bufferwindow and exiting insert mode
"
" Theming:  This applies the styles from the 'HighlightedBlock' tag to each
"           matched line
"
" NOTE:     Doesn't play nice with other signs-based plugins
"           Currently only recognises CSS & JS for highlighting
"           Currently only applied to html, php, vm and rb files
"------------------------------------------------------------------------------
" Exit if this module has already been loaded (or "compatible" mode set)
if exists("g:loaded_HighlightBlock") || &cp || !has("signs")
  finish
endif
let g:loaded_HighlightBlock= 1 " version number
let s:keepcpo           = &cpo
set cpo&vim

let s:SyntaxToHighlight = ['cssStyle', 'cssComment', 'javaScript', 'javaScriptComment', 'javaScriptLineComment']
sign define highlightline linehl=HighlightedBlock
 
" There's no public interface or keybinding required here
" as we only fire on an event
autocmd InsertLeave,BufWinEnter *.html,*.php,*.vm,*.rb  call <sid>HighlightCodeBlocks()

fun! s:HighlightCodeBlocks()
  " Start at the top of the file each time
  let linenr = 0
  let lastBlock = 'cssStyle'

  " Clear all current signs (sorry about that)
  sign unplace *

  " This is so we know how wide our Line Numbers column needs to be
  let atleastonesignset = 0

  while linenr < line("$")
    let linenr += 1
    
    " Get the Syntax Highlight tag assigned to the first character in this
    " line to figure out what the line should be doing
    let currentBlock = synIDattr(synID(linenr, 1, 1), "name")

    " Check to see if that is in our list of Syntax Tags to highlight
    " or if it is undefined and directly follows a highlightable tag
    if (index(s:SyntaxToHighlight, currentBlock) >= 0) || currentBlock == '' && (index(s:SyntaxToHighlight, lastBlock) >= 0)
      let atleastonesignset = 1
      exe ":sign place " . linenr . " name=highlightline line=" . linenr . " file=" . expand("%:p")
      if &numberwidth == 6
        set numberwidth=4
      endif
    endif

    if currentBlock != ''
      let lastBlock = currentBlock
    endif
  endwhile 

  " There are no highlight blocks left so we increase the size of the line
  " number column again.
  if atleastonesignset == 0
    set numberwidth=6
  endif
endfun

" ------------------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo
