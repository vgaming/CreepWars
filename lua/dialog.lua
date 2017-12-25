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


--- shows a wesnoth "list" dialog and returns the result.
-- Example:
--   item = {text = "", image = ""}
--   show_dialog { label = "Choose from this list", options = {item, item, item} }
local function show_dialog_unsynchronized(settings)
	local label = settings.label
	local options = settings.options
	local show_images = options[1].image and true or false

	local description_row = T.row {
		T.column { T.label { label = label } },
	}

	local list_sub_row
	if show_images then
		list_sub_row = T.row {
			T.column { T.image { id = "the_icon" } },
			T.column { horizontal_alignment = "left", T.label { id = "the_label" } }
		}
	else
		list_sub_row = T.row {
			T.column { horizontal_alignment = "left", T.label { id = "the_label" } }
		}
	end

	local toggle_panel = T.toggle_panel { T.grid { list_sub_row } }

	local list_definition = T.list_definition { T.row { T.column { horizontal_grow = true, toggle_panel } } }

	local listbox = T.listbox { id = "the_list", list_definition }

	local ok_cancel_buttons = T.grid {
		T.row {
			T.column { T.button { id = "ok", label = "\n" .. translate "OK" .. "\n" } },
			T.column { T.button { id = "cancel", label = "\n" .. translate "Cancel" .. "\n"} }
		}
	}

	local dialog = {
		T.tooltip { id = "tooltip_large" },
		T.helptip { id = "tooltip_large" },
		T.grid {
			description_row ,
			T.row { T.column { horizontal_grow = true, listbox } },
			T.row { T.column { ok_cancel_buttons } }
		}
	}

	local function preshow()
		for i, v in ipairs(options) do
			wesnoth.set_dialog_value(v.text, "the_list", i, "the_label")
			if show_images then
				wesnoth.set_dialog_value(v.image or "misc/blank-hex.png", "the_list", i, "the_icon")
			end
		end
		wesnoth.set_dialog_value(1, "the_list")
	end

	local item_result
	local function postshow()
		item_result = wesnoth.get_dialog_value "the_list"
	end

	local dialog_exit_code = wesnoth.show_dialog(dialog, preshow, postshow)
	local is_ok = dialog_exit_code == -1
	-- wesnoth.message(string.format("Button %d pressed. Item %d selected.", dialog_exit_code, result_item))
	return {is_ok = is_ok, index = item_result}
end


local function show_dialog(settings)
	local func = function() return show_dialog_unsynchronized(settings) end
	return wesnoth.synchronize_choice(func)
end


local function show_dialog_early(settings)
	local func = function() return show_dialog_unsynchronized(settings) end
	return sync_choice(func, func, { human_side }, settings.id)[human_side]
end


--- shows a wesnoth "list" dialog and returns the result.
-- Example:
--   item = {text = "", image = "", description = "", big_image = ""}
--   settings = {label = "", show_description = true, options = {item, item, item}}
local function show_advanced_dialog(settings)
	local label = settings.label
	local options = settings.options

	local description_row = T.row {
		T.column { T.label { label = label } },
	}

	local list_sub_row = T.row {
		T.column { T.image { id = "the_icon" } },
		T.column { horizontal_alignment = "left", T.label { id = "the_label" } },
	}

	local toggle_panel = T.toggle_panel { T.grid { list_sub_row } }

	local list_definition = T.list_definition { T.row { T.column { horizontal_grow = true, toggle_panel } } }

	local listbox = T.listbox { id = "the_list", list_definition }

	local ok_cancel_buttons = T.grid {
		T.row {
			T.column { T.button { id = "ok", label = translate "OK" } },
			T.column { T.button { id = "cancel", label = translate "Cancel" } }
		}
	}

	local dialog = {
		T.tooltip { id = "tooltip_large" },
		T.helptip { id = "tooltip_large" },
		T.grid {
			description_row ,
			T.row { T.column { T.grid { T.row {
				T.column { T.grid {
					T.row { T.column { horizontal_grow = true, listbox } },
				} },
				T.column {
					T.grid {
						T.row { T.column { T.label { id = "item_description", label = "label test" } } },
						T.row { T.column { T.image { id = "item_big_image" } } },
					}
				}
			} } } },
			T.row { T.column { ok_cancel_buttons } }
		}
	}

	local function preshow()
		local function select()
			local i = wesnoth.get_dialog_value "the_list"
			-- local big_image = (options[i].big_image or "misc/empty.png") .. "~SCALE_INTO(640,480)"
			wesnoth.set_dialog_value(options[i].big_image or "misc/empty.png", "item_big_image")
			wesnoth.set_dialog_value(options[i].description or "", "item_description")
		end

		wesnoth.set_dialog_callback(select, "the_list")
		for i, v in ipairs(options) do
			-- local image = (v.image or "misc/blank-hex.png") .. "~SCALE_INTO(72,72)"
			wesnoth.set_dialog_value(v.text, "the_list", i, "the_label")
			wesnoth.set_dialog_value(v.image or "misc/blank-hex.png", "the_list", i, "the_icon")
		end
		wesnoth.set_dialog_value(1, "the_list")
		select()
	end

	local result_item
	local function postshow()
			result_item = wesnoth.get_dialog_value "the_list"
	end

	local dialog_exit_code = wesnoth.show_dialog(dialog, preshow, postshow)
	-- wesnoth.message(string.format("Button %d pressed. Item %d selected.", dialog_exit_code, result_item))
	return result_item, dialog_exit_code == -1
end


creepwars.show_dialog = show_dialog
creepwars.show_dialog_early = show_dialog_early

-- >>
