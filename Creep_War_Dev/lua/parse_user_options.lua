-- << parse_user_options

local wesnoth = wesnoth
local creepwars = creepwars
local math = math
local string = string


local leader_type_mirror = wesnoth.get_variable("creepwars_leader_type") or "manual_normal"
local mirror_style, overpowered_string = string.match(leader_type_mirror, "^(.*)_(.-)$")
local allow_overpowered = overpowered_string == "overpowered"


local reveal_leaders
if mirror_style == "mirror" then
	reveal_leaders = true
else
	reveal_leaders = wesnoth.get_variable("creepwars_reveal_leaders") or true
end


local is_cli_game = wesnoth.get_variable("creepwars_guard_health") == nil


local guard_health_percentage = wesnoth.get_variable("creepwars_guard_health") or 100
local guard_health_level_add = guard_health_percentage / 25


local gold_multiplier_percent = wesnoth.get_variable("creepwars_gold_multiplier") or 100
local function gold_per_kill(kills)
	local default = creepwars.gold_per_kill_start + math.floor(kills / creepwars.gold_kills_to_increase)
	return math.floor((default * gold_multiplier_percent + 50) / 100)
end


creepwars.allow_overpowered = allow_overpowered
creepwars.gold_multiplier_percent = gold_multiplier_percent
creepwars.gold_per_kill = gold_per_kill
creepwars.guard_health_level_add = guard_health_level_add
creepwars.guard_health_percentage = guard_health_percentage
creepwars.is_cli_game = is_cli_game
creepwars.mirror_style = mirror_style
creepwars.reveal_leaders = reveal_leaders


-- >>
