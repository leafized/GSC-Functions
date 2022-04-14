#include maps\_utility; 
#include common_scripts\utility;
#using_animtree( "generic_human" ); 
main()
{
	// Don't give the player the default loadout, we want to specify it for our custom made map
	level.dodgeloadout = true;
	// Sets up all of the FX in the level
	maps\barebones_fx::main(); 
	// _load, sets up all of the basic entity behaviors
	maps\_load::main();
	// Sets the player's weapon loadout... This line should be right after _load::main(), and no waits/delays before it.
	set_loadout();
	// Sets up ambient sounds
	maps\barebones_amb::main(); 
	// Sets up "canned" animations
	maps\barebones_anim::main();
}
// Sets the custom weapon loadout
set_loadout()
{
	// Precache's / sets the list of weapons to give to the player when he spawns in
	maps\_loadout::add_weapon( "colt");
	maps\_loadout::add_weapon( "m1garand" );	
	maps\_loadout::add_weapon( "fraggrenade" );
	maps\_loadout::add_weapon( "m8_white_smoke" );
	// Sets the player's offhand throw weapon (aka smoke/flash)
	maps\_loadout::set_secondary_offhand( "smoke" );
	// Sets the player's default (if he does not have a pistol) laststand pistol.
	maps\_loadout::set_laststand_pistol( "colt" );
	
	// Sets the player's viewarms
	maps\_loadout::set_player_viewmodel( "viewmodel_usa_marine_arms");
	// Sets the player's viewarms when attacked by an enemy in a melee sequence or if a canned animation calls for them 
	maps\_loadout::set_player_interactive_hands( "viewmodel_usa_marine_player" );
	// Switches the player's weapon once he spawns in
	maps\_loadout::set_switch_weapon( "m1garand_bayonet" );
	// Sets the campaign, which is used for battlechatter and other various scripts
	level.campaign = "american";	 
	// Precaches the 3rd person model (for when playing coop)
	mptype\player_usa_marine::precache();
}
