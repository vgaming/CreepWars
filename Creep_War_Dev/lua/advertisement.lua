-- << advertisement

local wesnoth = wesnoth
local ipairs = ipairs
local string = string
local tostring = tostring
local wml = wml
local on_event = wesnoth.require("lua/on_event.lua")

local addon_name = tostring((...).name)
local addon_dir = tostring((...).dir)
local addon_about = tostring((...).about)
local addon_icon = tostring((...).icon)

local function show_message(text)
	wesnoth.wml_actions.message {
		caption = addon_name,
		message = text,
		image = string.gsub(addon_icon, "\n", "") .. "~SCALE_INTO(144,144)",
	}
end

local filename = "~add-ons/" .. addon_dir .. "/target/version.txt"
local function version_func()
	return { v = wesnoth.have_file(filename) and wesnoth.read_file(filename) or "0.0.0" }
end

local my_version = version_func().v

if my_version == "0.0.0" then
	local text = "This game uses " .. addon_name .. " add-on. "
		.. "\n"
		.. "If you'll like it, feel free to install it from add-ons server."
		.. "\n\n"
		.. "======================\n\n"
		.. addon_about
	show_message(text)
	return
end

on_event("side turn 1", function()
	wml.variables["addon_ver_" .. addon_dir .. "_" .. wesnoth.current.side] = wesnoth.synchronize_choice(version_func).v
end)

on_event("turn 2", function()
	local highest_version = "0.0.0"
	local log = {}
	for _, side in ipairs(wesnoth.sides) do
		local side_version = wml.variables["addon_ver_" .. addon_dir .. "_" .. side.side]
		log[side.side] = side_version
		if wesnoth.compare_versions(side_version, ">", highest_version) then
			highest_version = side_version
		end
	end
	if rawget(_G, "print_as_json") then _G.print_as_json("addon versions", addon_name, log) end

	if my_version == highest_version then
		return
	end

	local advertisement = "🠉🠉🠉 Please upgrade your " .. addon_name .. " add-on 🠉🠉🠉"
		.. "\n"
		.. my_version .. " -> " .. highest_version
		.. "  (you may do that after the game)\n\n"
	show_message(advertisement)
end)


-- >>
