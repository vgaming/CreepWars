-- << info_menu

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs
local string = string
local tostring = tostring

local function info_message()
	local msg = ""
		.. "Mirror style : " .. creepwars.mirror_style .. "\n"
		.. "Reveal leaders : " .. tostring(creepwars.reveal_leaders) .. "\n"
--		.. "Gold multiplier : " .. creepwars.gold_multiplier_user_config .. "\n"
		.. "Guard health increase : " .. creepwars.guard_health_percentage .. "%\n"

	for team, team_sides in ipairs(creepwars.team_array) do
		local creepkills = wesnoth.get_variable("creepwars_creepkills_" .. team)
		local leaderkills = wesnoth.get_variable("creepwars_leaderkills_" .. team)
		local gold = wesnoth.get_variable("creepwars_gold_" .. team)
		local score = string.format("%.2f", wesnoth.get_variable("creepwars_score_" .. team))
		local text = "\n" .. wesnoth.sides[team_sides[1]].user_team_name
			.. ": <span color='#FF8080'>" .. score .. " score</span>, "
			.. "<span color='#FFE680'>" .. gold .. " gold</span>"
			.. "<span color='#FFFFFF'>, " .. creepkills + leaderkills .. " total kills, "
			.. leaderkills .. " leader kills."
			.. "</span>\n"
		msg = msg .. text
	end
	return msg
end

local function show_game_config()
	creepwars.wesnoth_message {
		speaker = "narrator",
		force_show = true,
		message = info_message(),
	}
end


local function show_about_cw()
	creepwars.wesnoth_message {
		speaker = "narrator",
		force_show = true,
		message = wesnoth.get_variable("creepwars_about"),
	}
end


local function show_game_rules()
	creepwars.wesnoth_message {
		speaker = "narrator",
		force_show = true,
		message = wesnoth.get_variable("creepwars_game_rules"),
	}
end


local function show_changelog()
	creepwars.wesnoth_message {
		speaker = "narrator",
		force_show = true,
		message = wesnoth.get_variable("creepwars_changelog"),
	}
end


local function info_menu()
	repeat
		local options = {}
		if wesnoth.compare_versions(wesnoth.game_config.version, "<", "1.13.10") then
			options[#options + 1] = { text = "This game", func = show_game_config }
		end
		options[#options + 1] = { text = "About Creep Wars", func = show_about_cw }
		options[#options + 1] = { text = "Game Rules (details)", func = show_game_rules }
		options[#options + 1] = { text = "Changelog", func = show_changelog }
		local result = creepwars.show_dialog_unsynchronized {
			label = "<b>Creep Wars</b>\n\n" .. info_message(),
			has_minimum = false,
			options = options,
		}
		if result.is_ok then options[result.index].func() end
	until not result.is_ok
end


creepwars.info_menu = info_menu


-- >>
