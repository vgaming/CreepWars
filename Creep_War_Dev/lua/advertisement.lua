-- << advertisement | Creep_War_Dev
if rawget(_G, "advertisement | Creep_War_Dev") then
	-- TODO: remove this code once https://github.com/wesnoth/wesnoth/issues/8157 is fixed
	return
else
	rawset(_G, "advertisement | Creep_War_Dev", true)
end

local wesnoth = wesnoth
local string = string
local tostring = tostring
local wml = wml
local on_event = wesnoth.require("lua/on_event.lua")
local T = wml.tag

local addon_name = tostring((...).name)
local addon_dir = tostring((...).dir)
local addon_about = tostring((...).about)
local addon_icon = tostring((...).icon)
local addon_host_version = tostring((...).version)
addon_icon = string.gsub(addon_icon, "\n", "") .. "~SCALE_INTO(144,144)"

wesnoth.wml_actions.set_menu_item {
	id = "about_" .. addon_dir,
	description = "About: " .. addon_name,
	synced = false,
	T.command {
		T.message {
			caption = addon_name .. " v" .. addon_host_version,
			message = addon_about,
			image = addon_icon
		}
	}
}

local function show_message(text)
	wesnoth.wml_actions.message {
		caption = addon_name,
		message = text,
		image = addon_icon,
	}
end

local filename = "~add-ons/" .. addon_dir .. "/target/version.txt"
local my_version = filesystem.have_file(filename) and filesystem.read_file(filename) or "0.0.0"

local highest_ver_key = "addon_" .. addon_dir .. "_highest"
wml.variables[highest_ver_key] = my_version

on_event("side turn 1", function()
	local side_version = wesnoth.sync.evaluate_single(function() return { v = my_version } end).v
	if rawget(_G, "print_as_json") then _G.print_as_json("addon", addon_name, wesnoth.current.side, side_version) end

	if wesnoth.version(side_version) > wesnoth.version(wml.variables[highest_ver_key]) then
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
