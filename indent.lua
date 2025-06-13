#!/usr/bin/env lua
local utils = require('includes/rcUtils')

function Div(el)
	if utils.contains(el.attr.classes, "indent") then
		return {
			pandoc.RawBlock('latex','\\begin{adjustwidth}{2em}{0em}\\addtolength{\\LTleft}{2em}'),
			el,
			pandoc.RawBlock('latex','\\end{adjustwidth}')
		}
	end
	return el
end
