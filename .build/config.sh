#### If you want a custom description to be put in _server.pbl, override this method
description() {
	lua .build/docs_to_txt.lua
}

upload_to_wesnoth_versions=(1.12 1.13)
