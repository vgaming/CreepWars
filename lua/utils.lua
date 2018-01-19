-- << utils

local ipairs = ipairs
local next = next
local print = print
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
	elseif type(obj) == "string" then
		buffer[#buffer + 1] = '"' .. tostring(obj) .. '"'
	elseif type(obj) == "number" or type(obj) == "boolean" then
		buffer[#buffer + 1] = tostring(obj)
	elseif type(obj) == "function" then
		buffer[#buffer + 1] = '"???function???"'
	else
		buffer[#buffer + 1] = '"' .. tostring(obj) .. '"'
	end
end

local function format(obj)
	if obj == nil then return "null" else
		local buffer = {}
		_format_any_value(obj, buffer)
		return table.concat(buffer)
	end
end

local function _print(obj) print(format(obj)) end


local function array_filter(arr, func)
	local result = {}
	for _, elem in ipairs(arr) do
		if func(elem) then result[#result + 1] = elem end
	end
	return result
end


local function array_map(arr, func)
	local result = {}
	for index, elem in ipairs(arr) do
		result[#result + 1] = func(elem, index)
	end
	return result
end


local function array_copy(arr) return array_map(arr, function(e) return e end) end


local function array_to_set(arr)
	local result = {}
	for _, v in ipairs(arr) do
		result[v] = true
	end
	return result
end


local function array_merge(first, second)
	local i = 1
	local result = {}
	for _, v in ipairs(first) do result[i] = v; i = i + 1 end
	for _, v in ipairs(second) do result[i] = v; i = i + 1 end
	return result
end


local function array_forall(arr, func)
	for _, v in ipairs(arr) do
		if not func(v) then
			return false
		end
	end
	return true
end


local function generate_until(gen_func, until_func)
	local result
	repeat
		result = gen_func()
	until until_func(result)
	return result
end

local function wesnoth_message(message, image)
	local wesnoth = wesnoth
	wesnoth.synchronize_choice(function()
		if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") then
			local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}
			local ugly_index = image and 2 or 1
			wesnoth.show_dialog {
				T.tooltip { id = "tooltip_large" },
				T.helptip { id = "tooltip_large" },
				T.grid {
					[1] = T.row { T.column { T.image { label = image } } },
					[ugly_index] = T.row { T.column { T.label { label = message .. "\n" } } },
					[ugly_index + 1] = T.row { T.column { T.button { label = "\nOK\n", return_value = -1 } } },
				}
			}
		else
			wesnoth.wml_actions.message {
				message = message,
				image = image
			}
		end
		return {} -- strange obligatory "table" result
	end)
end


local creepwars = creepwars
creepwars.array_copy = array_copy
creepwars.array_filter = array_filter
creepwars.array_forall = array_forall
creepwars.array_map = array_map
creepwars.array_merge = array_merge
creepwars.array_to_set = array_to_set
creepwars.format = format
creepwars.generate_until = generate_until
creepwars.print = _print
creepwars.split_comma = split_comma
creepwars.wesnoth_message = wesnoth_message

-- >>
