-- << advertisement

local wesnoth = wesnoth
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
local my_version = wesnoth.have_file(filename) and wesnoth.read_file(filename) or "0.0.0"

local highest_ver_key = "addon_" .. addon_dir .. "_highest"
wml.variables[highest_ver_key] = "0.0.0"

on_event("side turn 1", function()
	local side_version = wesnoth.synchronize_choice(function() return { v = my_version } end).v
	if rawget(_G, "print_as_json") then _G.print_as_json("addon", addon_name, wesnoth.current.side, side_version) end

	if wesnoth.compare_versions(side_version, ">", wml.variables[highest_ver_key]) then
		wml.variables[highest_ver_key] = side_version
	end
end)

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

on_event("turn 2", function()
	if my_version == wml.variables[highest_ver_key] then
		return
	end

	local advertisement = "🠉🠉🠉 Please upgrade your " .. addon_name .. " add-on 🠉🠉🠉"
		.. "\n"
		.. my_version .. " -> " .. wml.variables[highest_ver_key]
		.. "  (you may do that after the game)\n\n"
	show_message(advertisement)
end)


-- >>
