#!/usr/bin/env lua

function Div(el)
	if el.classes[1] and el.classes[1]:match("^col%-(%d+)$") then
		local num_cols = el.classes[1]:match("^col%-(%d+)$")

		-- Create a new Pandoc.RawBlock for the beginning of multicols
		local start_multicols = pandoc.RawBlock('latex', '\\begin{multicols}{' .. num_cols .. '}')

		-- Create a new Pandoc.RawBlock for the end of multicols
		local end_multicols = pandoc.RawBlock('latex', '\\end{multicols}')

		-- Return the new structure: start, content, end
		return {start_multicols, el, end_multicols}
	end
	return el
end
