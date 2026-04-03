-- << ai_menu_upgrades | Creep_War_Dev

local wesnoth = wesnoth
local addon = creepwars

local loop_limit = nil
local current_side = nil

local function ai_answer_dialog(settings)
    ilua._pretty_print("ai_answer_dialog", settings)
    local gold = wesnoth.sides[wesnoth.current.side].gold
    
    if current_side ~= wesnoth.current.side then
        loop_limit = 20
        current_side = wesnoth.current.side
    end
    loop_limit = loop_limit - 1
    
    if loop_limit < 0 then
        print("out of loop_limit")
        return { is_ok = false, index = 1 }
    end
    
    local function answer_main_dialog(options)
        if gold >= 50 then
            return { is_ok = true, index = 1 }
        end
    end
    
    local options = settings.options
    -- TODO 1.19 only starts_with
    if stringx.starts_with(settings.label, "Shop.") then
        -- main menu
        if gold >= 50 then
            return { is_ok = true, index = 1 }
        end
    end
    if stringx.starts_with(settings.label, "Hero Upgrade.") then
        -- regular upgrade menu
        if gold >= 50 then
            return { is_ok = true, index = 1 }
        end
    end
    
    return { is_ok = false, index = 1 }
end

addon.ai_answer_dialog = ai_answer_dialog
-- >>
