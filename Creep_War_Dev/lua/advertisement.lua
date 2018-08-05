-- << creepwars_advertisement

local wesnoth = wesnoth
local tostring = tostring

local script_arguments = ...
local remote_version = tostring(script_arguments.remote_version)
local filename = "~add-ons/Creep_War_Dev/target/version.txt"

if not wesnoth.have_file(filename) then
	wesnoth.message("", 'This is "Creep Wars" map, Leaders must fight creeps and each other to gain gold and upgrades')
	wesnoth.message("", 'If you(\'ll) like the map, feel free to download it. ("Creep Wars" add-on).')
else
	local local_version = wesnoth.read_file(filename)
	if wesnoth.compare_versions(remote_version, ">", local_version) then
		wesnoth.wml_actions.message {
			caption = "Creep Wars",
			message = "🠉🠉🠉 Please upgrade your Creep Wars add-on 🠉🠉🠉"
				.. "\n\n"
				.. local_version .. " -> " .. remote_version
				.. "\n(You can do that after the game)",
			image = "misc/blank-hex.png~BLIT(units/goblins/spearman-attack-n1.png~CROP(26,25,23,33)~SCALE(12,20)~FL(), 16, 52)~BLIT(units/drakes/burner-takeoff-4.png~CROP(2,10,55,55), 0, 0)~BLIT(units/undead/soulless-dwarf-attack-n.png~CROP(25,21,26,35)~SCALE(13,23),0,40)~BLIT(units/human-peasants/woodsman-bow-attack-2.png~FL()~CROP(13,19,38,40)~SCALE(25,25), 47, 47)",
		}
	end
end

-- >>
