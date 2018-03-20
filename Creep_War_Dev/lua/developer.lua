-- << developer

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs
local string = string
local tostring = tostring

--- Allows configuring game from command-line

local cli_string = tostring(wesnoth.sides[1].user_team_name)
for _, assignment in ipairs(creepwars.split_comma(cli_string)) do
	local left, right = string.match(assignment, "(.-)=(.*)")
	if left and right then
		wesnoth.set_variable(left, right)
	end
end
wesnoth.sides[1].user_team_name = wesnoth.sides[1].team_name


-- >>
