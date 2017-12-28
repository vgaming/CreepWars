-- << config_user

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs
local math = math
local helper = wesnoth.require "lua/helper.lua"
local array_forall = creepwars.array_forall
local is_ai_array = creepwars.is_ai_array
local recruitable_array = creepwars.recruitable_array
local show_dialog_early = creepwars.show_dialog_early
local generate_until = creepwars.generate_until


local offline_game = not wesnoth or array_forall(wesnoth.sides, function(side)
	return side.controller == "human" or side.controller == "ai" or side.controller == "null"
end)


local max_leader_level = -1
for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do
	if not is_ai_array[unit.side] then
		max_leader_level = math.max(max_leader_level, wesnoth.unit_types[unit.type].level)
	end
end


local function random_leader() return recruitable_array[math.random(#recruitable_array)] end

local mirror_image = function()
	local up = random_leader()
	local down = random_leader()
	up = wesnoth.unit_types[up].__cfg.image
	down = wesnoth.unit_types[down].__cfg.image
	up = up .. "~SCALE(36,36)"
	down = down .. "~SCALE(36,36)"
	return "misc/blank-hex.png~SCALE(72,92)"
			.. "~BLIT(" .. up .. ",0,0)"
			.. "~BLIT(" .. up .. "~FL(),36,0)"
			.. "~BLIT(" .. down .. ",0,36)"
			.. "~BLIT(" .. down .. "~FL(),36,36)"
end


local samecost_image = function()
	local upleft = random_leader()
	local upright = generate_until(random_leader, function(u)
		return wesnoth.unit_types[u].__cfg.cost == wesnoth.unit_types[upleft].__cfg.cost
	end)
	local downleft = random_leader()
	local downright = generate_until(random_leader, function(u)
		return wesnoth.unit_types[u].__cfg.cost == wesnoth.unit_types[downleft].__cfg.cost
	end)

	upleft = wesnoth.unit_types[upleft].__cfg.image .. "~SCALE(36,36)"
	upright = wesnoth.unit_types[upright].__cfg.image .. "~SCALE(36,36)"
	downleft = wesnoth.unit_types[downleft].__cfg.image .. "~SCALE(36,36)"
	downright = wesnoth.unit_types[downright].__cfg.image .. "~SCALE(36,36)"
	return "misc/blank-hex.png~SCALE(72,92)"
			.. "~BLIT(" .. upleft .. ",0,0)"
			.. "~BLIT(" .. upright .. "~FL(),36,0)"
			.. "~BLIT(" .. downleft .. ",0,36)"
			.. "~BLIT(" .. downright .. "~FL(),36,36)"
end


local function ask_mirror_style()
	local options = {
		{
			id = "mirror",
			text = "Same leaders. Works on any Era. \n&lt;--- example",
			image = mirror_image
		}, {
			id = "same_cost",
			text = "Same cost. May be unbalanced.\n&lt;--- example",
			image = samecost_image
		},
	}
	if max_leader_level > 1 then
		options[#options + 1] = {
			id = "manual",
			text = 'Random (but downgrade for this map). May be unbalanced.',
			image = "units/random-dice.png"
		}
	else
		options[#options + 1] = {
			id = "manual_no_downgrade",
			text = "Random. May be unbalanced.",
			image = "units/random-dice.png"
		}
	end
	if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") then
		options[#options + 1] = {
			id = "same_strength",
			text = "Same Strength -- Same team strength.\n"
					.. "May still be unbalanced (for example with custom unit abilities).",
		}
	end
	local result = show_dialog_early {
		id = "mirror_style",
		label = "Creep Wars: Leader mirroring\n",
		options = options
	}
	--creepwars.print(result)
	return options[result.index].id
end

local mirror_style = wesnoth.get_variable("creepwars_mirror_style")
	or ask_mirror_style()


local hide_leaders
if mirror_style == "mirror" then
	hide_leaders = false
elseif wesnoth.get_variable("creepwars_hide_leaders") ~= nil then
	hide_leaders = wesnoth.get_variable("creepwars_hide_leaders")
else
	hide_leaders = true
end


creepwars.hide_leaders = hide_leaders
creepwars.mirror_style = mirror_style


-- >>
