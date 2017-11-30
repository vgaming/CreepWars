-- << utils

local function split_comma(str)
	local result = {}
	local n = 1
	for s in string.gmatch(str, "%s*[^,]+%s*") do
		if s ~= "" and s ~= "null" then
			result[n] = s
			n = n + 1
		end
	end
	return result
end


local function set_concat(set, separator)
	separator = separator or ","
	local s = ""
	for k, _ in pairs(set) do
		s = s .. "," .. k
	end
	return string.sub(s, 2, string.len(s))
end


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


function creepwars_copy_table(orig)
	local result = {}
	for k, v in pairs(orig) do
		result[k] = v
	end
	return result
end


creepwars_split_comma = split_comma
creepwars_set_concat = set_concat

-- >>
