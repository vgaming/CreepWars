#!/bin/bash -eu
set -o pipefail
{
trap "sed -i '/version=/,//d' _server.pbl" EXIT


readarray -td '' all_lua_files < <(find . -name '*.lua' -print0)
test "${#all_lua_files[@]}" -ne 0 && luacheck "${all_lua_files[@]}" --config .build/.luacheckrc

test -z "$(git status --porcelain)" || (echo "ERROR. You have local changes. Commit them."; exit -1)
test "$(git rev-parse HEAD)" = "$(git rev-parse '@{u}')" || (echo "ERROR. git push first!"; exit 1)

git tag "$1"

if test -x .build/build.sh; then
	.build/build.sh
else
	wesnoth_addon_build.sh
fi

printf 'version="%s"
description="%s"
passphrase="%s"' \
	"$(cat target/version.txt)" \
	"$(cat target/about.txt)" \
	"$(cat .build/.private-password)" >> _server.pbl

if test -x .build/upload.sh; then
	.build/upload.sh
else
	dir_name="$(basename "$(realpath .)")"
	wesnoth_addon_manager --port 1.13.x --upload ~/.local/share/wesnoth/1.13/data/add-ons/"$dir_name"
	wesnoth_addon_manager --port 1.12.x --upload ~/.local/share/wesnoth/1.12/data/add-ons/"$dir_name"
fi


}; exit 0