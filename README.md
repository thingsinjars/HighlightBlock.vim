Highlight Blocks
----------------
This is an attempt at emulating the theme behaviour of TextMate and a few other editors which allow highlighting certain blocks of embedded code (CSS, JS or PHP within HTML, for example) with a full screen-width colour.

This plugin will add the highlight class 'HighlightedBlock' to any lines that it identifies as having the cssStyle, javaScript or javaScriptComment highlight class. It then uses the 'signs' functionality to allow the highlight to apply full width.

This does have the downside of completely messing with any existing signs. Sorry about that. If you use them, you might not want to use this. The plugin acts on the 'InsertLeave' event so it won't highlight on initial load but will after you first leave insert mode. It also bases the style for the line on the active highlighting at the first character so it won't highlight a block that starts and finishes within the same line.
