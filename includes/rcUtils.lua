
local M = {}


M.contains = function (list, x)
	for _, v in pairs(list) do
		if v == x then return true end
	end
	return false
end

M.starts_with = function(str, start)
	return str:sub(1, #start) == start
end

M.ends_with = function(str, suffix)
    return str:sub(-#suffix) == suffix
end

M.file_exists = function(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
end

M.safeLatex = function(str)
	return str
		:gsub('\\','\\textbackslash ')
		:gsub('{SNIP}','\\codeSnip')
		:gsub('{REDACTED}','\\codeRedacted')
		:gsub('%%','\\%%')
		:gsub('{','\\{')
		:gsub('}','\\}')
		:gsub('<','\\textless{}')
		:gsub('>','\\textgreater{}')
		:gsub('\\codeSnip','\\codeSnip{}')
		:gsub('\\codeRedacted','\\codeRedacted{}')
		:gsub('%$','\\$')
		:gsub('#','\\#')
		:gsub('_','\\_')
		:gsub('%^','\\^{}')
		:gsub('&','{\\&}')
end

M.codeAdditions = function(text, lstlisting)
	lstlisting = lstlisting or false

	local colours={"yellow","red","orange","blue","green"}
	local risks={"info","informational","low","medium","high","critical"}


	if lstlisting then

		for _,colour in ipairs(colours) do
			local uppercase=colour:upper()
			text = text:gsub('{'.. uppercase ..'}(.-){/'.. uppercase ..'}', function(middle)
				return '#(\\sethlcolor{'..colour..'}\\hl{' .. M.safeLatex(middle) .. '}#)'
			end);
		end

		for _,risk in ipairs(risks) do
			local uppercase=risk:upper()
			text = text:gsub('{'.. uppercase ..'}(.-){/'.. uppercase ..'}', function(middle)
				return '#(\\sethlcolor{RC'..risk..'}\\hl{' .. M.safeLatex(middle) .. '}#)'
			end);
		end

		for _,risk in ipairs(risks) do
			local uppercase=risk:upper()
			--line = line:gsub('{'..uppercase..':(.-)}','',1)
			text = text:gsub('{'.. uppercase ..':(.-)}(.-){/'.. uppercase ..'}', function(title,middle)
				local padding = ""
				if #title > #middle then
					padding = string.rep('\\ ', #title - #middle + 1)
				end
				return string.format('#(\\tcbox[on line, leftrule=3mm,top=0pt,left=0pt,right=0pt,bottom=0pt,colframe=RC%s,title=%s]{%s}#)',risk,title,M.safeLatex(middle) .. padding)
			end);
		end

		text = text:gsub('\r?\n?{CODECOMMENT:(.-)}(.-){/CODECOMMENT}',function(title,middle)
				return string.format('#(\\begin{codecomment}{%s}%s\\end{codecomment}#)',title,pandoc.write( pandoc.read( middle,"markdown" ),"latex"))
		end);

		text = text:gsub('{SNIP}','#(\\codeSnip#)')
		text = text:gsub('{REDACTED}','#(\\codeRedacted#)')
		text = text:gsub('{LINEBREAK}','\\newline{}')

	else

		text=M.safeLatex(text)

		for _,colour in ipairs(colours) do
			local uppercase=colour:upper()
			text = text:gsub('\\{'.. uppercase ..'\\}(.-)\\{/'.. uppercase ..'\\}', function(middle)
				return '\\colorbox{'..colour..'}{' .. middle .. '}'
			end);
		end

		for _,risk in ipairs(risks) do
			local uppercase=risk:upper()
			text = text:gsub('\\{'.. uppercase ..'\\}(.-)\\{/'.. uppercase ..'\\}', function(middle)
				return '\\colorbox{RC'..risk..'}{' .. middle .. '}'
			end);
		end

		text = text:gsub('\\{SNIP\\}','\\codeSnip')
		text = text:gsub('\\{REDACTED\\}','\\codeRedacted')
		text = text:gsub('\\{LINEBREAK\\}','\\newline{}')
	end

	return text
end


M.urldecode = function(url)
  return (url:gsub("%%(%x%x)", function(x)
    return string.char(tonumber(x, 16))
    end))
end

return M
