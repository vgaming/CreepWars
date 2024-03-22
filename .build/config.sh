not_pushed_ignore=true

#### If you want a custom description to be put in _server.pbl, override this method
description() {
	cd Creep_War_Dev
	lua ../.build/generate_server_description.lua | tee target/about.txt
	cd ..
}

upload_to_wesnoth_versions=("1.18")
addon_manager_args=("--pbl-key" "icon" "$(cat src/doc/icon.txt)")
