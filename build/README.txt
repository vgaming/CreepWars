on Linux and MacOS, this will launch CW scenario quickly:
	wesnoth --multiplayer --era=era_default --scenario="Creep Wars $(cat ~/.local/share/wesnoth/1.12/data/add-ons/Creep_War_Dev/target/version.txt) (narrow)" --controller 5:null --controller 7:null --controller 3:null --controller 6:null --debug

You may find using git "post-checkout" and "post-commit" hooks useful.
See /build/post-checkout script for details
