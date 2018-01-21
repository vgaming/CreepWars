#!/bin/bash -eu
set -o pipefail
{

readarray -td '' all_lua_files < <(find -name '*.lua' -print0)
luacheck "${all_lua_files[@]}" --config build/.luacheckrc

test "$(git rev-parse HEAD)" = "$(git rev-parse '@{u}')" || (echo "git push first!"; exit 1)
test -z "$(git status --porcelain)" || (echo "You have local changes. Commit them."; exit -1)

git tag "$1"

build/build.sh

printf 'version="%s"\ndescription="%s"' \
	"$(cat target/version.txt)" \
	"$(cat target/about.txt)" >> _server.pbl

wesnoth_addon_manager --port 1.13.x --upload ~/.local/share/wesnoth/1.13/data/add-ons/Creep_War_Dev
wesnoth_addon_manager --port 1.12.x --upload ~/.local/share/wesnoth/1.12/data/add-ons/Creep_War_Dev

sed -i '/version=/,//d' _server.pbl

}; exit 0