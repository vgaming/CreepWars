#!/bin/bash -eu
set -o pipefail
{

# remove heavy add-ons before using this script multiple times.

#	--controller 1:null --controller 2:null \
wesnoth --multiplayer --era=era_default \
	--scenario="Creep Wars narrow $(cat ~/.local/share/wesnoth/1.12/data/add-ons/Creep_Wars/target/version.txt)" \
	--controller 5:null --controller 7:null \
	--controller 3:null --controller 6:null \
	--parm 1:user_team_name:creepwars_mirror_style=mirror,creepwars_kill_limit=20 \
#	| grep -m 1 "CREEPWARS_WINNING_TEAM"


}; exit 0