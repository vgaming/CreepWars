-- << info_menu

local wesnoth = wesnoth
local creepwars = creepwars
local tostring = tostring

local function show_game_config()
	local msg = "Game config:\n\n"
		.. "Mirror style : " .. creepwars.mirror_style .. "\n"
		.. "Reveal leaders : " .. tostring(creepwars.reveal_leaders) .. "\n"
--		.. "Gold multiplier : " .. creepwars.gold_multiplier_user_config .. "\n"
--		.. "Guard health increase : " .. creepwars.guard_health_user_config .. "\n"
	creepwars.wesnoth_message {
		speaker = "narrator",
		force_show = true,
		message = msg,
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
		local options = {
			{ text = "This game config", func = show_game_config },
			{ text = "About Creep Wars", func = show_about_cw },
			{ text = "Game Rules (details)", func = show_game_rules },
			{ text = "Changelog", func = show_changelog },
		}
		local result = creepwars.show_dialog_unsynchronized {
			label = "Creep Wars Info",
			has_minimum = false,
			options = options,
		}
		if result.is_ok then options[result.index].func() end
	until not result.is_ok
end


creepwars.info_menu = info_menu


-- >>
