#!/usr/bin/env lua

-- This Lua Pandoc filter removes all elements except headings

function filterHeaders(el)
	--
  -- Check if the block is a header
  if el.t == "Header" then
	return el
  end

  --Don't emmediately remove divs, as they main contain headers
  if el.t == "Div" then
	return el:walk({
		Block = filterHeaders
	}).content

  end



  -- Return empty array to remove all other block elements
  return {}
end


return {
	Block = filterHeaders
}
