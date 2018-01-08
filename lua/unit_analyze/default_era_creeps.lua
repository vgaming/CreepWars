-- << default_era_creeps

creepwars.default_era_creeps = {
	"Peasant", "Woodsman", "Ruffian", "Goblin Spearman", "Dwarvish Ulfserker", -- only creeps
	"Vampire Bat", -- costy lvl0, can be leader
	"Drake Burner", "Drake Clasher", "Drake Fighter", "Drake Glider", "Saurian Augur", "Saurian Skirmisher", -- lvl1 drakes
	"Dwarvish Fighter", "Dwarvish Guardsman", "Dwarvish Thunderer", "Gryphon Rider", "Footpad", "Poacher", "Thief", -- lvl1 knalgan
	"Bowman", "Cavalryman", "Fencer", "Heavy Infantryman", "Horseman", "Mage", "Merman Fighter", "Spearman", -- lvl1 loyal
	"Naga Fighter", "Orcish Archer", "Orcish Assassin", "Orcish Grunt", "Troll Whelp", "Wolf Rider", -- lvl1 orc
	"Elvish Archer", "Elvish Fighter", "Elvish Scout", "Elvish Shaman", "Mage", "Merman Hunter", "Wose", -- lvl1 rebels
	"Dark Adept", "Ghost", "Ghoul", "Skeleton Archer", "Skeleton", -- lvl1 undead
	"Sergeant",
	-- auto-generated (all advances):
	"Thug", "Goblin Impaler", "Goblin Rouser", "Dwarvish Berserker", "Blood Bat", "Fire Drake", "Drake Flare", "Drake Thrasher", "Drake Arbiter", "Drake Warrior", "Sky Drake", "Saurian Oracle", "Saurian Soothsayer", "Saurian Ambusher", "Dwarvish Steelclad", "Dwarvish Stalwart", "Dwarvish Thunderguard", "Gryphon Master", "Outlaw", "Trapper", "Rogue", "Longbowman", "Dragoon", "Duelist", "Shock Trooper", "Knight", "Lancer", "White Mage", "Red Mage", "Merman Warrior", "Swordsman", "Pikeman", "Javelineer", "Naga Warrior", "Orcish Crossbowman", "Orcish Slayer", "Orcish Warrior", "Troll", "Troll Rocklobber", "Goblin Knight", "Goblin Pillager", "Elvish Ranger", "Elvish Marksman", "Elvish Captain", "Elvish Hero", "Elvish Rider", "Elvish Druid", "Elvish Sorceress", "Merman Spearman", "Merman Netcaster", "Elder Wose", "Dark Sorcerer", "Wraith", "Shadow", "Necrophage", "Bone Shooter", "Revenant", "Deathblade", "Bandit", "Dread Bat", "Inferno Drake", "Drake Flameheart", "Drake Enforcer", "Drake Warden", "Drake Blademaster", "Hurricane Drake", "Saurian Flanker", "Dwarvish Lord", "Dwarvish Sentinel", "Dwarvish Dragonguard", "Fugitive", "Huntsman", "Ranger", "Assassin", "Master Bowman", "Cavalier", "Master at Arms", "Iron Mauler", "Paladin", "Grand Knight", "Mage of Light", "Arch Mage", "Silver Mage", "Merman Triton", "Merman Hoplite", "Royal Guard", "Halberdier", "Naga Myrmidon", "Orcish Slurbow", "Orcish Warlord", "Troll Warrior", "Direwolf Rider", "Elvish Avenger", "Elvish Sharpshooter", "Elvish Marshal", "Elvish Champion", "Elvish Outrider", "Elvish Shyde", "Elvish Enchantress", "Merman Javelineer", "Merman Entangler", "Ancient Wose", "Lich", "Necromancer", "Spectre", "Nightgaunt", "Ghast", "Banebow", "Draug", "Highwayman"
}


--local function add_advances(arr, set, filter)
--	set = set or array_to_set(arr)
--	filter = filter or function(adv) return true end
--	for _, unit in ipairs(arr) do
--		for _, adv in ipairs(creepwars.split_comma(wesnoth.unit_types[unit].__cfg.advances_to)) do
--			if set[adv] == nil and wesnoth.unit_types[adv] and filter(adv) then
--				set[adv] = true
--				arr[#arr + 1] = adv
--			end
--		end
--	end
--end


-- >>
