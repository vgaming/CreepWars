not_pushed_ignore=true

#### If you want a custom description to be put in _server.pbl, override this method
description() {
	cd Creep_War_Dev
	lua ../.build/generate_server_description.lua | tee target/about.txt
	cd ..
}

upload_to_wesnoth_versions=("1.14")

declare -A titles=(
	["1.14"]="Creep Wars"
)

upload() {
	for ver in "${upload_to_wesnoth_versions[@]}"; do
		wesnoth_addon_manager --port "$ver.x" \
			--pbl-key "version" "$(version)" \
			--pbl-key "description" "$(description)" \
			--pbl-key "passphrase" "$(passphrase)" \
			--pbl-key "title" "${titles[$ver]}" \
			--upload Creep_War_Dev
	done
}
