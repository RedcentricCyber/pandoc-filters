local ordered_table = require('ordered_table')
local utils = require('includes/rcUtils')
local rctables = require('includes/rcTables')


local function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

-- Function to parse YAML array of objects into a Lua table
local function yamlToTable(yamlArray)
	local luaTable = ordered_table.new()
	local currentItem = ordered_table.new()
	local multilineKey = nil

	for line in yamlArray:gmatch("[^\r\n]+") do
		if utils.starts_with( line, "- " ) then
			if tablelength(currentItem) > 0 then
				table.insert(luaTable, tablelength(luaTable) + 1 , currentItem)
				currentItem = {}
			end
			local key, value = line:match("^%s*-%s*([^:]+)%s*:%s*(.*)$")
			if key and value then
				if currentItem[key] then
					table.insert(luaTable, currentItem)
					currentItem = {}
				end

				currentItem[key] = tostring(value) or value
			end

		else
			local key, value = line:match("^%s*([^:]+)%s*:%s*(.*)$")
			if key and value then
				if currentItem[key] then
					table.insert(luaTable, currentItem)
					currentItem = {}
				end

				if multilineKey ~= nil then
				end
				currentItem[key] = tostring(value) or value
			end
		end
	end

	if next(currentItem) then
		table.insert(luaTable, currentItem)
	end

	return luaTable
end


function CodeBlock(el)
	if utils.contains(el.attr.classes, "table") then
		local passedTable=yamlToTable(el.text)


		local latex = rctables.tableToLatex(passedTable, rctables.tableOptions(el.attr.attributes, el.attr.classes))


		return pandoc.RawBlock('latex', latex)
	end
	return el
end

