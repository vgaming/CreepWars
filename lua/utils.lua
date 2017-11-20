-- << utils

local function split_comma(str)
	local result = {}
	local n = 1
	for s in string.gmatch(str, "[^,]+") do
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


creepwars_split_comma = split_comma
creepwars_set_concat = set_concat

-- >>
