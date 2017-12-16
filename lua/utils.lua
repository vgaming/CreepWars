-- << utils

local ipairs = ipairs
local next = next
local string = string
local table = table
local tostring = tostring
local type = type

local function split_comma(str)
	local result = {}
	local n = 1
	for s in string.gmatch(str or "", "%s*[^,]+%s*") do
		if s ~= "" and s ~= "null" then
			result[n] = s
			n = n + 1
		end
	end
	return result
end


local function _format_any_value(obj, buffer)
	if type(obj) == "table" then
		buffer[#buffer + 1] = '{'
		buffer[#buffer + 1] = '"' -- needs to be separate for empty tables {}
		for key, value in next, obj, nil do
			buffer[#buffer + 1] = tostring(key) .. '":'
			_format_any_value(value, buffer)
			buffer[#buffer + 1] = ',"'
		end
		buffer[#buffer] = "}" -- note the overwrite
	elseif type(obj) == "string" or type(obj) == "number" or type(obj) == "boolean" then
		buffer[#buffer + 1] = '"' .. tostring(obj) .. '"'
	else
		buffer[#buffer + 1] = '"???' .. type(obj) .. '???"'
	end
end

function creepwars_format(obj)
	local buffer = {}
	_format_any_value(obj or "nil", buffer)
	return table.concat(buffer)
end

function creepwars_print(obj) print(creepwars_format(obj)) end


function creepwars_array_filter(arr, func)
	local result = {}
	for _, elem in ipairs(arr) do
		if func(elem) then result[#result + 1] = elem end
	end
	return result
end


function creepwars_array_to_set(arr)
	local result = {}
	for _, v in ipairs(arr) do
		result[v] = true
	end
	return result
end


function creepwars_copy_array(orig)
	local result = {}
	for k, v in ipairs(orig) do
		result[k] = v
	end
	return result
end


function creepwars_array_merge(first, second)
	local i = 1
	local result = {}
	for _, v in ipairs(first) do result[i] = v; i = i + 1 end
	for _, v in ipairs(second) do result[i] = v; i = i + 1 end
	return result
end


creepwars = {}
creepwars.split_comma = split_comma

creepwars_split_comma = split_comma

-- >>
