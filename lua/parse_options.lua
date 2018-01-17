-- << config_user

local wesnoth = wesnoth
local creepwars = creepwars


-- ugly hack to support wesnoth-1.12
-- (it cannot work with multiple scenarios defining same option id-s)
local scenario_suffix = wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.0")
	and ""
	or wesnoth.game_config.mp_settings.mp_scenario


local mirror_style = wesnoth.get_variable("creepwars_mirror_style" .. scenario_suffix) or "manual"


local forbid_berserkers = wesnoth.get_variable("creepwars_forbid_berserkers" .. scenario_suffix) or false


local reveal_leaders
if mirror_style == "mirror" then
	reveal_leaders = true
else
	reveal_leaders = wesnoth.get_variable("creepwars_reveal_leaders" .. scenario_suffix) or true
end


creepwars.reveal_leaders = reveal_leaders
creepwars.mirror_style = mirror_style
creepwars.forbid_berserkers = forbid_berserkers


-- >>
