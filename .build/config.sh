#### If you want a custom description to be put in _server.pbl, override this method
description() {
	lua .build/generate_server_description.lua
}

versions=(12 13)
declare -A titles=(
	[12]="Creep Wars New"
	[13]="Creep Wars"
)

upload() {
	for ver in "${versions[@]}"; do
		wesnoth_addon_manager --port "1.$ver.x" \
			--pbl-key "version" "$(version)" \
			--pbl-key "description" "$(description)" \
			--pbl-key "passphrase" "$(passphrase)" \
			--pbl-key "title" "${titles[$ver]}" \
			--upload .
	done
}
