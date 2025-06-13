local utils = require('rcUtils')

local M = {}


local function get_keys(t)
	local keys={}
	for key,_ in pairs(t) do
		table.insert(keys, key)
	end
	return keys
end

local function splitAlign(input)
	local result = {}
	local i = 1
	local length = #input

	while i <= length do
		local char = input:sub(i, i)

		if char:match("%a") and input:sub(i + 1, i + 1) == "[" then
			-- If the character is a letter followed by a '[', find the closing bracket
			local start = i
			local closingBracket = input:find("]", start)
			if closingBracket then
				local insert, _ = input:sub(start,closingBracket):gsub("%[","{"):gsub("%]","}")
				-- Extract the letter and the content within the brackets
				table.insert(result, insert)
				i = closingBracket + 1 -- Move past the closing bracket
			else
				-- If no closing bracket is found, just add the character
				table.insert(result, char)
				i = i + 1
			end
		else
			-- If it's just a letter or any other character, add it to the result
			table.insert(result, char)
			i = i + 1
		end
	end

	return result
end

local function splitRotate(input)
	local result = {}
	if input and input ~= "" then
		for i = 1, #input do
			result[i] = (input:sub(i, i) == "r")
		end
	end
	return result
end

local function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

M.begin = function(width,alignStr,columnsCount,grid)
	width = width or '\\linewidth'
	grid = grid or true

	local align=splitAlign(alignStr)

	-- Latex doesn't like it if the alignment columns don't exactly equal the number of columns.
	-- So, we add an X for any missing

	while ( #align < columnsCount) do
		table.insert(align,"X")
	end
	-- Then remove any extras
	while ( #align > columnsCount) do
		table.remove(align,columnsCount+1)
	end

	if grid then
		alignStr = "|" .. table.concat(align,"|") .. "|"
	else
		alignStr = table.concat(align,"")
	end
	return string.format("\\begin{tabularx}{%s}{%s}\n",width,alignStr)
end

M.headerrow = function(tbl,tableOptions)
	local result = ""
	
	local rotate = splitRotate(tableOptions.rotateHeader)

	while ( #rotate < #tbl) do
		table.insert(rotate,tableOptions.rotateHeaderDefault)
	end

	local i = 1
	for _,value in ipairs(tbl) do
		if i > 1 then result = result .. ' & ' end
		if type(rotate) == "table" and rotate[i] then
			result = result .. string.format('\\tableheaderrotate{%s}',value)
		else
			result = result .. string.format('\\tableheader{%s}',value)
		end
		i = i + 1
	end
	result = result .. ' \\\\\n'
	result = result .. '\\endhead\n'
	return result
end

M.row = function(tbl,tableOptions, index)
	local result = ""
	
	local i = 1
	if index == nil then
		for _,value in ipairs(tbl) do
			if i > 1 then result = result .. ' & ' end
			result = result .. string.format('%s', pandoc.write(pandoc.read(value,"markdown"),"latex"))
			i = i + 1
		end
	else

		for _,key in ipairs(index) do
			if i > 1 then result = result .. ' & ' end
			local text = tbl[key]
			if text == nil then
				text=""
			end
			result = result .. string.format('%s', pandoc.write(pandoc.read(text,"markdown"),"latex"))
			i = i + 1
		end
	end
	result = result .. ' \\\\\n'
	return result
end


M.tableOptions = function(attributes, classes)
	local align = "X"
	if attributes.align ~= nil then
		align = attributes.align
	end
	local width = "\\linewidth"
	if attributes.width ~= nil then
		width = attributes.width
	end
	local rotateHeader = ""
	if attributes.rotateHeader ~= nil then
		rotateHeader = attributes.rotateHeader
	end


	return {
		["transpose"] = utils.contains(classes, "transpose"),
		["grid"] = not utils.contains(classes, "nogrid"),
		["rotateHeaderDefault"] = utils.contains(classes, "rotateHeader"),
		["align"] = align,
		["width"] = width,
		["rotateHeader"] = rotateHeader
	}
end

M.tableToLatex = function(tbl,tableOptions)


	local columnsCount = 0

	if tableOptions.transpose then
		columnsCount=tablelength(tbl) + 1
	else
		columnsCount = tablelength(tbl[1])
	end


	local latex=M.begin(tableOptions.width,tableOptions.align,columnsCount)

	if tableOptions.grid then
		latex = latex .. '\\hline \n'
	end

	if tableOptions.transpose then
		for colkey,_ in pairs(tbl[1]) do
			latex = latex .. string.format('\\tableheader{%s} ', colkey )
			for row,_ in ipairs(tbl) do
				latex = latex .. string.format('& {%s}', pandoc.write( pandoc.read( tbl[row][colkey],"markdown" ),"latex") )
			end
			latex = latex .. '\\\\\n'
			if tableOptions.grid then
				latex = latex .. '\\hline \n'
			end
		end
	else
		local i = 1

		latex = latex .. M.headerrow(get_keys(tbl[1]),tableOptions)

		if tableOptions.grid then
			latex = latex .. '\\hline \n'
		end

		for _,contents in pairs(tbl) do

			latex = latex .. M.row(contents,tableOptions,get_keys(tbl[1]))


			if tableOptions.grid then
				latex = latex .. '\\hline \n'
			end
		end
	end
	latex = latex .. [[
\end{tabularx} ]]
	return latex
end

return M
