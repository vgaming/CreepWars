#### If you want a custom description to be put in _server.pbl, override this method
description() {
	lua .build/generate_server_description.lua
}

upload_to_wesnoth_versions=(1.12 1.13)
