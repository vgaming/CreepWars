Launch CW scenario quickly (Linux, MacOS):
	wesnoth --multiplayer --era=era_default --scenario="Creep Wars $(cat ~/.local/share/wesnoth/1.12/data/add-ons/Creep_War_Dev/target/version.txt) (narrow)" --controller=5:null --controller=7:null --controller=3:null --controller=6:null --debug

If you also want leader mirroring, add this:
	--parm=1:user_team_name:creepwars_mirror_style=mirror


You may find using git "post-checkout" and "post-commit" hooks useful.
To add them:
	ln -s ../../build/build.sh .git/hooks/post-commit
	ln -s ../../build/build.sh .git/hooks/post-checkout
