-- << developer | Creep_War_Dev
if rawget(_G, "developer | Creep_War_Dev") then
	-- TODO: remove this code once https://github.com/wesnoth/wesnoth/issues/8157 is fixed
	return
else
	rawset(_G, "developer | Creep_War_Dev", true)
end

local wesnoth = wesnoth
local string = string
local tostring = tostring

--- Allows configuring game from command-line

local cli_string = tostring(wesnoth.sides[1].user_team_name)
for assignment in string.gmatch(cli_string, "[^,]+") do
	local left, right = string.match(assignment, "(.-)=(.*)")
	if left and right then
		wesnoth.set_variable(left, right)
	end
end
wesnoth.sides[1].user_team_name = wesnoth.sides[1].team_name


-- >>
