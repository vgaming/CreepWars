-- << sync_choice

-- code taken from the "PYR_No_Preperation_Turn" addon
-- highly recommend to study this addon-s code for examples of real quality code

local wesnoth = wesnoth
local math = math
local os = os
local pairs = pairs
local tostring = tostring

local function get_global_variable(namespace, name, side)
	wesnoth.wml_actions.get_global_variable {
		namespace = namespace,
		from_global = name,
		to_local = "creepwars_global_variable",
		side = side,
		immediate = true,
	}
	local r = wesnoth.get_variable("creepwars_global_variable")
	wesnoth.set_variable("creepwars_global_variable", nil)
	return r
end

local function set_global_variable(namespace, name, side, value)
	wesnoth.set_variable("creepwars_global_variable", value)
	wesnoth.wml_actions.set_global_variable {
		namespace = namespace,
		to_global = name,
		from_local = "creepwars_global_variable",
		side = side,
		immediate = true,
	}
	wesnoth.set_variable("creepwars_global_variable", nil)
end

local function clear_global_variable(namespace, name, side)
	wesnoth.wml_actions.set_global_variable {
		namespace = namespace,
		global = name,
		side = side,
		immediate = true,
	}
end

local function sync_version1_11_13(func_human, func_ai, sides, id)
	local r = {}
	local local_sides = {}
	for _, v in pairs(sides) do
		local ir = tostring(math.random(1000000000)) .. "_" .. tostring(os.time()) .. "_" .. tostring(os.clock()) .. "_" .. tostring(wesnoth.get_time_stamp())
		set_global_variable("creepwars_1_12", "side_local_test" .. tostring(v), v, ir)
		local ircheck = get_global_variable("creepwars_1_12", "side_local_test" .. tostring(v), v)
		if ir == tostring(ircheck) then
			local_sides[v] = true
		end
	end
	for v, _ in pairs(local_sides) do
		local r_side
		if wesnoth.sides[v].controller == "human" or func_ai == nil then
			r_side = func_human(v)
		else
			r_side = func_ai(v)
		end
		set_global_variable("creepwars_1_12", id .. tostring(v), v, r_side)
	end
	for _, v in pairs(sides) do
		if not local_sides[v] then
			print("Creep Wars", "Waiting for input from side " .. tostring(v))
		end
		r[v] = get_global_variable("creepwars_1_12", id .. tostring(v), v)
		if not local_sides[v] then
			print("Creep Wars", "Received input from side " .. tostring(v))
		end
	end
	return r
end


local function sync_choice(func_human, func_ai, sides, id)
	if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.14") then
		return wesnoth.synchronize_choice(func_human, func_ai, sides)
	else
		return sync_version1_11_13(func_human, func_ai, sides, id)
	end
end


creepwars.sync_choice = sync_choice

-- >>
