-- << sync_choice_alt


local wesnoth = wesnoth
local creepwars = creepwars
local debug = debug
local error = error
local ipairs = ipairs
local print = print
local string = string


local function sync_by_first_side(func, id)
	id = id or string.gsub(debug.traceback(), "[^a-zA-Z0-9]", "")
	local am_i_first
	local first_side
	for _, side in ipairs(wesnoth.sides) do
		if side.controller == "human" then
			first_side = side.side
			am_i_first = true
			break
		elseif side.controller == "network" then
			first_side = side.side
			am_i_first = false
			break
		end
	end
	print("first side", first_side) -- todo clean up
	print("I am first", am_i_first)
	if am_i_first == nil then
		error("No human sides found!")
	elseif am_i_first == true then
		local res = func()
		print("got local result from user", creepwars.format(res))
		wesnoth.set_variable("creepwars_global_variable", res)
		wesnoth.wml_actions.set_global_variable {
			namespace = "creepwars",
			to_global = "creepwars_sync_" .. id,
			from_local = "creepwars_global_variable",
			side = first_side,
			immediate = true,
		}
	end
	wesnoth.wml_actions.get_global_variable {
		namespace = "creepwars",
		from_global = "creepwars_sync_" .. id,
		to_local = "creepwars_global_variable",
		side = first_side,
		immediate = true,
	}
	local result = wesnoth.get_variable("creepwars_global_variable")
	print("sync result", creepwars.format(result))
	wesnoth.set_variable("creepwars_global_variable", nil)
	return result
end


creepwars.sync_by_first_side = sync_by_first_side


-- >>
