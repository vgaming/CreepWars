#!/bin/bash -eu
set -o pipefail
{

build/.build.sh

wesnoth_addon_manager --port 1.13.x --upload ~/.local/share/wesnoth/1.13/data/add-ons/Creep_War_Dev
wesnoth_addon_manager --port 1.12.x --upload ~/.local/share/wesnoth/1.12/data/add-ons/Creep_War_Dev

}; exit 0