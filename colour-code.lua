local logging = require("includes/logging")
local utils = require('includes/sevenEutils')


function CodeBlock(el)
	el.text = utils.codeAdditions(el.text, true)
	return el
end

-- Inline code
function Code(el)
	return pandoc.RawInline('latex',string.format('\\inlinecode{%s}',utils.codeAdditions(el.text)))
end

