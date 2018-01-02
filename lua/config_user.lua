-- << config_user

local wesnoth = wesnoth
local creepwars = creepwars
local math = math
local recruitable_array = creepwars.recruitable_array
local show_dialog_early = creepwars.show_dialog_early
local generate_until = creepwars.generate_until


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
			text = "Mirror. \n&lt;--- example",
			image = mirror_image
		}
	}
	options[#options + 1] = {
		id = "same_cost",
		text = "Same cost. May be unbalanced.\n&lt;--- example",
		image = samecost_image
	}
	options[#options + 1] = {
			id = "manual",
			text = "Manual. May be unbalanced.",
	}

	local result = show_dialog_early {
		id = "mirror_style",
		label = "Creep Wars: Leader mirroring\n",
		options = options
	}
	--creepwars.print(result)
	return options[result.index].id
end

local mirror_style
do
	local conf = wesnoth.get_variable("creepwars_mirror_style")
	mirror_style = conf ~= nil and conf ~= "decide_later" and conf or ask_mirror_style()
end


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
