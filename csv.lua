local csv = require("csv")
local utils = require('includes/rcUtils')
local rcTables = require('includes/rcTables')

local function rawLatex(filename, tableOptions, caption)
	local latex=""
	local file=""
	if pandoc.path.is_relative(filename) then
		for _,path in ipairs(PANDOC_STATE.resource_path) do
			file = string.format("%s/%s",path,filename)
			if utils.file_exists( file ) then
				break
			end
			file=utils.urldecode(file)
			if utils.file_exists( file ) then
				break
			end
		end
	else
		file=filename
	end

	if utils.file_exists(file) then
		local f = csv.open(file)
		local header=true
		local firstCol=true
		local cols=0

		for fields in f:lines() do
			firstCol=true
			if header then
				header=false
				cols=#fields;
				latex = latex .. rcTables.begin("\\textwidth",tableOptions.align,cols)
				if caption ~= nil then
					latex = latex .. string.format("\\caption{ %s }\\\\\n",caption)
				end

				if tableOptions.grid then
					latex = latex .. '\\hline \n'
				end

				latex = latex .. rcTables.headerrow(fields,tableOptions)

				if tableOptions.grid then
					latex = latex .. '\\hline \n'
				end
			else
				latex = latex .. rcTables.row(fields,cols)

				if tableOptions.grid then
					latex = latex .. '\\hline \n'
				end
			end
		end
		latex = latex .. "\\end{tabularx}"
	else
		-- We would get here if the file isn't found in any of the paths
		latex=string.format("\\colorbox{red}{The file \\texttt{%s} was not found}",filename:gsub('_','\\_'))
	end

	return pandoc.RawBlock('latex',latex)
end

function Para(el)
	if #el.content == 1 and el.content[1].tag == "Image" then
		-- This is an "image" without a caption
		local image = el.content[1]
		local tableOptions = rcTables.tableOptions(image.attr.attributes, image.attr.classes)
		if utils.ends_with(image.src,'.csv') or utils.ends_with(image.src,'.tsv') then
			return rawLatex(image.src,tableOptions)
		end
	end
	return el
end

function Figure(el)
	-- Pandoc puts images inside a plain block inside the figure
	--
	-- (#) Figure {
	--   attr: Attr {
	--    ...
	--   }
	--   caption: {
	--    ...
	--   }
	--   content: Blocks[1] {
	--     [1] Plain {
	--       content: Inlines[1] {
	--         [1] Image {
	--           ..
	--         }
	--       }
	--     }
	--   }
	-- }
	if #el.content == 1 and #el.content[1].content == 1 and el.content[1].content[1].tag == "Image" then
		local caption=pandoc.utils.stringify(el.caption.long[1].content)


		local image = el.content[1].content[1]
		local tableOptions = rcTables.tableOptions(image.attr.attributes, image.attr.classes)
		if utils.ends_with(image.src,'.csv') or utils.ends_with(image.src,'.tsv') then
			return rawLatex(image.src, tableOptions, caption)
		end
	end
	return el
end
