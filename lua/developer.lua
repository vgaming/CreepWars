-- << developer

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs
local string = string
local tostring = tostring

--- Allows configuring game from command-line, useful for AI tournaments (see build/ai_tournament.sh)

local cli_string = tostring(wesnoth.sides[1].user_team_name)
for _, assignment in ipairs(creepwars.split_comma(cli_string)) do
	local left = string.gsub(assignment, "=[^=]*", "")
	local right = string.gsub(assignment, "[^=]*=", "")
	wesnoth.set_variable(left, right)
end
wesnoth.sides[1].user_team_name = wesnoth.sides[1].team_name


-- >>
