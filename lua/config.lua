-- << config

local wesnoth = wesnoth
local math = math
local creepwars = creepwars
local array_forall = creepwars.array_forall
local show_dialog = creepwars.show_dialog

creepwars_lvl0_barrier = 12 -- creep score lower than this value will generate lvl0 creeps
creepwars_lvl3plus_barrier = 50
creepwars_creep_lvl_max = 3

creepwars_creep_count = 8

creepwars_default_era_creeps = wesnoth and wesnoth.get_variable("creepwars_default_era_creeps") or false

local offline_game = not wesnoth or array_forall(wesnoth.sides, function(side)
	return side.controller == "human" or side.controller == "ai" or side.controller == "null"
end)

local function ask_mirror_style()
	local options = {
		{ id = "mirror", text = "\nMirror -- Same leaders. Works on any Era.\n" },
		{ id = "manual", text = '\nRandom Downgrade -- Downgrade Leaders for this map. May be unbalanced.\n' },
		{ id = "manual_no_downgrade", text = "\nRandom -- Leave leaders as-is. May be unbalanced.\n" },
		{ id = "same_cost", text = "\nSame cost -- Random leaders of the same cost. May be unbalanced.\n" },
	}
	if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") then
		options[#options + 1] = {
			text = "\nSame Strength -- Same team strength.\n"
					.. "May still be unbalanced (for example with custom unit abilities).\n",
			id = "same_strength"
		}
	end
	local result = creepwars.show_dialog {
		label = "\nCreep Wars: Leaders style\n\n",
		options = options
	}
	return options[result].id
end

local mirror_style = wesnoth and wesnoth.get_variable("creepwars_mirror_style")
	or (wesnoth and ask_mirror_style() or "manual")

local hide_leaders
if mirror_style == "mirror" then
	hide_leaders = false
elseif wesnoth and wesnoth.get_variable("creepwars_hide_leaders") ~= nil then
	hide_leaders = wesnoth.get_variable("creepwars_hide_leaders")
else
	hide_leaders = true
end


creepwars_guard_hp_initial = 50
creepwars_guard_hp_for_kill = function(is_leader) return is_leader and 3 or 1 end


local creepwars_expected_total_kills = 80

local gold_per_kill_start = 3
local gold_kills_to_increase = 20
local function gold_per_kill(kills) return gold_per_kill_start + math.floor(kills / gold_kills_to_increase) end

local creepwars_score_scale = 3
creepwars_score_start = 9
-- derived values:
creepwars_score_per_kill_min = 2 * (creepwars_lvl3plus_barrier - creepwars_score_start)
	/ (creepwars_score_scale + 1)
	/ creepwars_expected_total_kills
creepwars_score_per_kill_increase = creepwars_score_per_kill_min * (creepwars_score_scale - 1) / creepwars_expected_total_kills
local function score_per_kill(kills) return creepwars_score_per_kill_min + creepwars_score_per_kill_increase * kills end


creepwars.gold_kills_to_increase = gold_kills_to_increase
creepwars.gold_per_kill = gold_per_kill
creepwars.gold_per_kill_start = gold_per_kill_start
creepwars.hide_leaders = hide_leaders
creepwars.mirror_style = mirror_style
creepwars.score_per_kill = score_per_kill


-- >>
