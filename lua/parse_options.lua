-- << config_user

local wesnoth = wesnoth
local creepwars = creepwars


-- ugly hack to support wesnoth-1.12
-- (it cannot work with multiple scenarios defining same option id-s)
local scenario_suffix = wesnoth.game_config.mp_settings.mp_scenario


local mirror_style = wesnoth.get_variable("creepwars_mirror_style" .. scenario_suffix) or "manual"


local hide_leaders
if mirror_style == "mirror" then
	hide_leaders = false
else
	hide_leaders = wesnoth.get_variable("creepwars_hide_leaders" .. scenario_suffix) or false
end


creepwars.hide_leaders = hide_leaders
creepwars.mirror_style = mirror_style


-- >>
