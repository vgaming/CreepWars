-- << creepwars/advertisement

local wesnoth = wesnoth
local ipairs = ipairs
local tostring = tostring

local addon_name = tostring((...).name)
local addon_dir = tostring((...).dir)
local addon_about = tostring((...).about)
local addon_icon = tostring((...).icon)

local filename = "~add-ons/" .. addon_dir .. "/target/version.txt"
local function human_ver()
	if wesnoth.have_file(filename) then
		return { v = wesnoth.read_file(filename) }
	else
		return { v = "0.0.0" }
	end
end

local function ai_ver()
	return { v = "0.0.0" }
end


local human_sides = {}
for _, side in ipairs(wesnoth.sides) do
	if side.__cfg.allow_player then human_sides[#human_sides + 1] = side.side end
end

local sync_choices = wesnoth.synchronize_choices(human_ver, ai_ver, human_sides)

local highest_version = "0.0.0"
for _, side_version in pairs(sync_choices) do
	if wesnoth.compare_versions(side_version.v, ">", highest_version) then
		highest_version = side_version.v
	end
end

local my_version = human_ver().v

if my_version == highest_version then
	return
end

local advertisement
if my_version == "0.0.0" then
	advertisement = "This game uses " .. addon_name .. " add-on. "
		.. "\n"
		.. "If you'll like it, feel free to install it from add-ons server."
		.. "\n\n"
		.. "======================\n\n"
		.. addon_about
else
	advertisement = "🠉🠉🠉 Please upgrade your " .. addon_name .. " add-on 🠉🠉🠉"
		.. "\n"
		.. my_version .. " -> " .. highest_version
		.. "  (you may do that after the game)\n\n"
end

wesnoth.wml_actions.message {
	caption = addon_name,
	message = advertisement,
	image = string.gsub(addon_icon, "\n", "") .. "~SCALE_INTO(144,144)",
}


-- >>
