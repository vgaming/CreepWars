-- << dialog

local wesnoth = wesnoth
local ipairs = ipairs
local T = wesnoth and wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}
local translate = wesnoth and wesnoth.textdomain "wesnoth"
local creepwars = creepwars
local is_ai_array = creepwars.is_ai_array
local sync_choice = creepwars.sync_choice


local human_side
for k,v in ipairs(is_ai_array) do
	if not v then
		human_side = k
		break
	end
end


local function pango_escape(str)
	if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13") then
		return str
	else
		str = string.gsub(str, "<[^>]+>", "") -- html tags
		str = string.gsub(str, "&lt;", "<")
		str = string.gsub(str, "&gt;", ">")
		return str
	end
end

--- shows a wesnoth "list" dialog and returns the result.
-- Example:
--   item = {text = "", image = ""}
--   show_dialog { label = "Choose from this list", options = {item, item, item} }
local function show_dialog_unsynchronized(settings)
	local label = settings.label
	local spacer = settings.spacer or "\n"
	local options = settings.options
	local show_images = options[1].image and true or false

	local description_row = T.row {
		T.column { T.label { use_markup = true, label = spacer .. pango_escape(label) .. spacer } },
	}

	local list_sub_row
	if show_images then
		list_sub_row = T.row {
			T.column { T.image { id = "the_icon" } },
			T.column { grow_factor = 0, T.label { use_markup = true, id = "the_label" } },
			T.column { grow_factor = 1, T.spacer {} },
		}
	else
		list_sub_row = T.row {
			T.column { horizontal_alignment = "left", T.label { id = "the_label" } }
		}
	end

	local toggle_panel = T.toggle_panel { return_value = -1, T.grid { list_sub_row } }

	local list_definition = T.list_definition { T.row { T.column { horizontal_grow = true, toggle_panel } } }

	local listbox = T.listbox { id = "the_list", list_definition }

	local ok_cancel_buttons = T.grid {
		T.row {
			T.column { T.button { id = "cancel", return_value = -2, label = "\n" .. translate "Cancel" .. "\n"} },
			T.column { T.button { id = "ok", return_value = -1, label = "\n" .. translate "OK" .. "\n" } },
		}
	}

	local dialog = {
		T.tooltip { id = "tooltip_large" },
		T.helptip { id = "tooltip_large" },
		T.grid {
			T.row { T.column { T.spacer { width = 250 } } },
			description_row ,
			T.row { T.column { horizontal_grow = true, listbox } },
			T.row { T.column { ok_cancel_buttons } }
		}
	}

	local function preshow()

		for i, v in ipairs(options) do
			wesnoth.set_dialog_value(spacer .. pango_escape(v.text) .. spacer, "the_list", i, "the_label")
			if show_images then
				local img = v.image
				if type(img) == "function" then img = img() end
				wesnoth.set_dialog_value(img or "misc/blank-hex.png", "the_list", i, "the_icon")
			end
		end
		wesnoth.set_dialog_value(1, "the_list")

		if show_images then
			local function select()
				local i = wesnoth.get_dialog_value "the_list"
				local img = options[i].image
				if type(img) == "function" then img = img() end
				wesnoth.set_dialog_value(img or "misc/blank-hex.png", "the_list", i, "the_icon")
			end
			wesnoth.set_dialog_callback(select, "the_list")
		end
	end

	local item_result
	local function postshow()
		item_result = wesnoth.get_dialog_value "the_list"
	end

	local dialog_exit_code = wesnoth.show_dialog(dialog, preshow, postshow)
	local is_ok = dialog_exit_code == -1
	print(string.format("Button %s pressed. Item %s selected.", dialog_exit_code, item_result))
	return {is_ok = is_ok, index = item_result}
end


local function show_dialog(settings)
	local func = function() return show_dialog_unsynchronized(settings) end
	return wesnoth.synchronize_choice(func)
end


local function show_dialog_early(settings)
	local func = function() return show_dialog_unsynchronized(settings) end
	return sync_choice(func, nil, { human_side }, settings.id)[human_side]
end


creepwars.show_dialog = show_dialog
creepwars.show_dialog_early = show_dialog_early

-- >>
