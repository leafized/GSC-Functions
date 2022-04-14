//
// DEPRECATED, ah well...
//
// file: ber3b_fireteams.gsc
// description: fireteams script for berlin3b
// scripter: slayback
//

#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

// --- SETUP EXAMPLES ---
/*
// set these up in your level's ::main function
//level.fireteams_init_func = ::ber3b_fireteams_init;
//level.fireteams_reset_ais_customfunc = ::ber3b_fireteam_reset_ais_customfunc;
//maps\ber3b_fireteams::fireteams_init();

// init function example
ber3b_fireteams_init()
{	
	//
	// --- FIRETEAM CONTROL ARRAY NOTES ---
	//
	// -- GENERAL REFERENCE --
	// - teamname = the reference name for this team, used for string concatenation for dialogue, etc.
	// - level.current_battle is set up to match the area the player is in at the moment (ex. "foyer", "parliament", etc)
	// - warpSpots are where the guys will start from (generally inside a door, etc.)
	// - doors are opened when the fireteam shows up, open type depends on "openDirection"
	// - nodes are where guys run to when they spawn, can be chained per entrance index by targeting another set
	// - aimSpots are where guys will fire at, these are used differently per fireteam
	//    since they all have different firing behavior
	// - geoPrefixes (optional) are the prefix strings for destructible string concatenation
	// - killzones (optional) are our failsafes: we can DoDamage to guys in those areas to
	//    make sure that the teams kills 'em dead
	// - killspawners (optional) can be triggered so that a team's impact is permanent to that area
	//
	// -- OTHER --
	// - only need one set of spawners per fireteam, since we're warping guys just outside of the battle areas
	// - most of these groups (warpSpots, nodes, doors, etc.) are all connected by their array indices,
	//    so if I want a team to enter from entrance index 0, it can potentially go to different nodes,
	//    use different aimSpots, etc. than if it enters from entrance index 1.
	// - each fireteam type has unique behavior, and we could add to them as well - sniper team, mortar team, etc.
	//
	// - main fireteam behavior function note! unlike in almost every other function,
	//    fireteamControlArray is only used to copy any values we added to the array
	//    during the input loop over into the copy of the array that's stored in the level variable
	//    (for example, level.fireteam_bazooka)
	//
	// - direct questions/bugs to sean slayback
	//
	
	// -- bazooka fireteam control array --	
	level.fireteam_bazooka["teamname"] = "bazooka";
	level.fireteam_bazooka["displayname"] = "bazooka";  // TODO localize
	level.fireteam_bazooka["maxUses"] = 1;
	level.fireteam_bazooka["masterControlFunc"] = maps\ber3b_fireteams::fireteam_bazooka;
	//level.fireteam_bazooka["pickEntranceFunc"] = maps\ber3b_fireteams::fireteams_pickentrance;
	
	level.fireteam_bazooka["spawner_primary"] = getent_safe( "spawner_fireteam_bazooka", "targetname" );
	level.fireteam_bazooka["spawner_secondary"] = getent_safe( "spawner_fireteam_bazooka_helper", "targetname" );
	
	level.fireteam_bazooka["foyer"]["warpSpots_primary"][0] = getstruct_safe( "struct_fireteam_foyer_warpSpot_primary_rightDoor", "targetname" );
	level.fireteam_bazooka["foyer"]["warpSpots_secondary"][0] = getstruct_safe( "struct_fireteam_foyer_warpSpot_secondary_rightDoor", "targetname" );
	level.fireteam_bazooka["foyer"]["warpSpots_primary"][1] = getstruct_safe( "struct_fireteam_foyer_warpSpot_primary_leftDoor", "targetname" );
	level.fireteam_bazooka["foyer"]["warpSpots_secondary"][1] = getstruct_safe( "struct_fireteam_foyer_warpSpot_secondary_leftDoor", "targetname" );
	
	level.fireteam_bazooka["foyer"]["doors"][0] = getent_safe( "sbmodel_fireteam_door_foyer_1", "targetname" );
	level.fireteam_bazooka["foyer"]["doors"]["openDirection"][0] = "right";
	level.fireteam_bazooka["foyer"]["doors"][1] = getent_safe( "sbmodel_fireteam_door_foyer_2", "targetname" );
	level.fireteam_bazooka["foyer"]["doors"]["openDirection"][1] = "left";
	
	level.fireteam_bazooka["foyer"]["nodes_primary"][0] = getnode_safe( "node_fireteam_foyer_bazooka_1", "targetname" );
	level.fireteam_bazooka["foyer"]["nodes_secondary"][0] = getnode_safe( "node_fireteam_foyer_bazooka_helper_1", "targetname" );
	// for now, second set of runto nodes are the same as primary ones
	level.fireteam_bazooka["foyer"]["nodes_primary"][1] = getnode_safe( "node_fireteam_foyer_bazooka_1", "targetname" );
	level.fireteam_bazooka["foyer"]["nodes_secondary"][1] = getnode_safe( "node_fireteam_foyer_bazooka_helper_1", "targetname" );
	
	// TODO allow for multiple sets of aimSpots per level.current_battle
	level.fireteam_bazooka["foyer"]["aimSpots"][0] = getent_safe( "org_fireteam_foyer_bazooka_aimSpot1", "targetname" );
	level.fireteam_bazooka["foyer"]["aimSpots"][1] = getent_safe( "org_fireteam_foyer_bazooka_aimSpot2", "targetname" );
	level.fireteam_bazooka["foyer"]["aimSpots"][2] = getent_safe( "org_fireteam_foyer_bazooka_aimSpot3", "targetname" );
	
	// set up the geometry name prefixes for destruction later
	// NOTE these must match the aimSpot reference indices above
	// TODO rework these to use _exploder
	level.fireteam_bazooka["foyer"]["geoPrefixes"][0] = "sbmodel_foyer_strongpoint_1";  // left side
	level.fireteam_bazooka["foyer"]["geoPrefixes"][1] = "sbmodel_foyer_strongpoint_2";  // center
	level.fireteam_bazooka["foyer"]["geoPrefixes"][2] = "sbmodel_foyer_strongpoint_3";  // right
	
	// -- flamethrower fireteam control array --
	level.fireteam_flamethrower["teamname"] = "flamethrower";
	level.fireteam_flamethrower["displayname"] = "flamethrower";  // TODO localize
	level.fireteam_flamethrower["maxUses"] = 1;
	level.fireteam_flamethrower["masterControlFunc"] = maps\ber3b_fireteams::fireteam_flamethrower;
	level.fireteam_flamethrower["pickEntranceFunc"] = maps\ber3b_fireteams::fireteam_flamethrower_pickentrance;
	
	level.fireteam_flamethrower["spawner_primary"] = getent_safe( "spawner_fireteam_flamethrower", "targetname" );
	level.fireteam_flamethrower["spawner_secondary"] = getent_safe( "spawner_fireteam_flamethrower_helper", "targetname" );
	
	level.fireteam_flamethrower["foyer"]["warpSpots_primary"][0] = getstruct_safe( "struct_fireteam_foyer_warpSpot_primary_leftDoor", "targetname" );
	level.fireteam_flamethrower["foyer"]["warpSpots_secondary"][0] = getstruct_safe( "struct_fireteam_foyer_warpSpot_secondary_leftDoor", "targetname" );
	level.fireteam_flamethrower["foyer"]["warpSpots_primary"][1] = getstruct_safe( "struct_fireteam_foyer_warpSpot_primary_rightDoor", "targetname" );
	level.fireteam_flamethrower["foyer"]["warpSpots_secondary"][1] = getstruct_safe( "struct_fireteam_foyer_warpSpot_secondary_rightDoor", "targetname" );
	
	level.fireteam_flamethrower["foyer"]["doors"][0] = getent_safe( "sbmodel_fireteam_door_foyer_2", "targetname" );
	level.fireteam_flamethrower["foyer"]["doors"]["openDirection"][0] = "left";
	level.fireteam_flamethrower["foyer"]["doors"][1] = getent_safe( "sbmodel_fireteam_door_foyer_1", "targetname" );
	level.fireteam_flamethrower["foyer"]["doors"]["openDirection"][1] = "right";
	
	level.fireteam_flamethrower["foyer"]["nodes_primary"][0] = getnode_safe( "node_fireteam_foyer_flamethrower_right_1", "targetname" );
	level.fireteam_flamethrower["foyer"]["nodes_secondary"][0] = getnode_safe( "node_fireteam_foyer_flamethrower_helper_right_1", "targetname" );
	level.fireteam_flamethrower["foyer"]["nodes_primary"][1] = getnode_safe( "node_fireteam_foyer_flamethrower_1", "targetname" );
	level.fireteam_flamethrower["foyer"]["nodes_secondary"][1] = getnode_safe( "node_fireteam_foyer_flamethrower_helper_1", "targetname" );
	
	// NOTE: for flamer to sweep from one node to another, any spot grabbed here should target at least one more
	// entrance index 0, fire on this spot first
	level.fireteam_flamethrower["foyer"]["aimSpots"][0][0] = getent_safe( "org_fireteam_foyer_flamethrower_right_aimSpot1a", "targetname" );
	// then move and fire on this spot second
	level.fireteam_flamethrower["foyer"]["aimSpots"][0][1] = getent_safe( "org_fireteam_foyer_flamethrower_right_aimSpot2a", "targetname" );
	
	// entrance index 1
	level.fireteam_flamethrower["foyer"]["aimSpots"][1][0] = getent_safe( "org_fireteam_foyer_flamethrower_aimSpot1a", "targetname" );
	level.fireteam_flamethrower["foyer"]["aimSpots"][1][1] = getent_safe( "org_fireteam_foyer_flamethrower_aimSpot2a", "targetname" );
	
	// killzones & killspawners should match the aimSpot sets
	level.fireteam_flamethrower["foyer"]["killzones"][0][0] = getent_safe( "trig_fireteam_foyer_flamethrower_right_killzone_1", "targetname" );
	level.fireteam_flamethrower["foyer"]["killzones"][0][1] = getent_safe( "trig_fireteam_foyer_flamethrower_right_killzone_2", "targetname" );
	level.fireteam_flamethrower["foyer"]["killzones"][1][0] = getent_safe( "trig_fireteam_foyer_flamethrower_killzone_1", "targetname" );
	level.fireteam_flamethrower["foyer"]["killzones"][1][1] = getent_safe( "trig_fireteam_foyer_flamethrower_killzone_2", "targetname" );
	
	// TODO separate the separate groups of guys into different killspawners?
	level.fireteam_flamethrower["foyer"]["killspawners"][0][0] = getent_safe( "trig_script_killspawner_13", "targetname" );
	level.fireteam_flamethrower["foyer"]["killspawners"][0][1] = getent_safe( "trig_script_killspawner_14", "targetname" );
	level.fireteam_flamethrower["foyer"]["killspawners"][1][0] = getent_safe( "trig_script_killspawner_13", "targetname" );
	level.fireteam_flamethrower["foyer"]["killspawners"][1][1] = getent_safe( "trig_script_killspawner_14", "targetname" );
	
	// -- mg fireteam control array --
	level.fireteam_mg["teamname"] = "mg";
	level.fireteam_mg["displayname"] = "DP28 LMG";  // TODO localize
	level.fireteam_mg["maxUses"] = 1;
	level.fireteam_mg["masterControlFunc"] = maps\ber3b_fireteams::fireteam_mg;
	//level.fireteam_mg["pickEntranceFunc"] = maps\ber3b_fireteams::fireteams_pickentrance;
	
	level.fireteam_mg["spawner_primary"] = getent_safe( "spawner_fireteam_mg", "targetname" );
	level.fireteam_mg["spawner_secondary"] = getent_safe( "spawner_fireteam_mg_helper", "targetname" );
	
	level.fireteam_mg["foyer"]["warpSpots_primary"][0] = getstruct_safe( "struct_fireteam_foyer_warpSpot_primary_rightDoor", "targetname" );
	level.fireteam_mg["foyer"]["warpSpots_secondary"][0] = getstruct_safe( "struct_fireteam_foyer_warpSpot_secondary_rightDoor", "targetname" );
	level.fireteam_mg["foyer"]["warpSpots_primary"][1] = getstruct_safe( "struct_fireteam_foyer_warpSpot_primary_leftDoor", "targetname" );
	level.fireteam_mg["foyer"]["warpSpots_secondary"][1] = getstruct_safe( "struct_fireteam_foyer_warpSpot_secondary_leftDoor", "targetname" );
	
	level.fireteam_mg["foyer"]["doors"][0] = getent_safe( "sbmodel_fireteam_door_foyer_1", "targetname" );
	level.fireteam_mg["foyer"]["doors"]["openDirection"][0] = "right";
	level.fireteam_mg["foyer"]["doors"][1] = getent_safe( "sbmodel_fireteam_door_foyer_2", "targetname" );
	level.fireteam_mg["foyer"]["doors"]["openDirection"][1] = "left";
	
	level.fireteam_mg["foyer"]["nodes_primary"][0] = getnode_safe( "node_fireteam_foyer_mg_1", "targetname" );
	level.fireteam_mg["foyer"]["nodes_secondary"][0] = getnode_safe( "node_fireteam_foyer_mg_helper_1", "targetname" );
	// for now, second set of runto nodes are the same as primary ones
	level.fireteam_mg["foyer"]["nodes_primary"][1] = getnode_safe( "node_fireteam_foyer_mg_1", "targetname" );
	level.fireteam_mg["foyer"]["nodes_secondary"][1] = getnode_safe( "node_fireteam_foyer_mg_helper_1", "targetname" );
	
	level.fireteam_mg["foyer"]["aimSpots"][0] = getent_safe( "org_fireteam_foyer_mg_aimSpot1a", "targetname" );
	level.fireteam_mg["foyer"]["aimSpots"][1] = getent_safe( "org_fireteam_foyer_mg_aimSpot1b", "targetname" );
	
	// -- global fireteam settings --	
	level.fireteams_action_slot = 4;  // to which action slot do we want to assign the fireteams?
	level.fireteams_dpad_button = "DPAD_RIGHT";  // HACK this needs to be keybinding- and platform-safe
	level.fireteam_request_wait_min = 3;  // min seconds that the fireteam will take to show up
	level.fireteam_request_wait_max = 5;  // max seconds that the fireteam will take to show up
	level.fireteam_dialogue_deny_wait = 8;  // seconds to wait between playing fireteam deny dialogues
	level.fireteam_cooldown_time = 60;  // seconds we have to wait between fireteams
	level.fireteam_hud_fade_time = 0.1;  // seconds over which fireteam hudelements will fade in/out
	level.fireteam_input_pause_time = 2;  // seconds to pause the input loop after calling in a fireteam
}

// self = an AI
ber3b_fireteam_reset_ais_customfunc()
{
	// add to color chain
	friend_add( self );
	self thread friend_remove_on_death();
	self set_force_color( "b" );
}

// --- level_anim setup example ---
// -- fireteam anims --
level.scr_sound["fireteam_bazooka_primary"]["bazooka_reload"] = "print: Bazooka loading anim";
level.scr_sound["fireteam_bazooka_secondary"]["bazooka_reload"] = "print: Bazooka loading anim";

// -- fireteam dialogue --
// generic to all fireteams
level.scr_sound["fireteam_generic"]["fireteams_unavailable"] = "print:Fireteams no longer available, we'll let you know when that changes.";
level.scr_sound["fireteam_generic"]["fireteams_unavailable_reminder"] = "print:Fireteams are still unavailable.";
level.scr_sound["fireteam_generic"]["fireteams_unavailable_already_active"] = "print:There's already a fireteam with us!";
level.scr_sound["fireteam_generic"]["fireteams_available"] = "print:Fireteams are ready to be called!";

// request
level.scr_sound["fireteam_requester"]["fireteam_request_bazooka"] = "print:We need a bazooka team up here, NOW!";
level.scr_sound["fireteam_requester"]["fireteam_request_flamethrower"] = "print:Flamethrowers, get up here!";
level.scr_sound["fireteam_requester"]["fireteam_request_mg"] = "print:We need a machine gun on the front line!";

// arrival
level.scr_sound["fireteam_bazooka_primary"]["fireteam_arrival_bazooka"] = "print:Bazooka team here, ready to rock!";
level.scr_sound["fireteam_flamethrower_primary"]["fireteam_arrival_flamethrower"] = "print:Flamethrower team on the line!  Cover us!";
level.scr_sound["fireteam_mg_primary"]["fireteam_arrival_mg"] = "print:Machine gun team setting up now!  Move up when we suppress the enemy!";

// finished
level.scr_sound["fireteam_bazooka_primary"]["fireteam_finished_bazooka"] = "print:Bazooka shells expended, but we still have our rifles.";
level.scr_sound["fireteam_flamethrower_primary"]["fireteam_finished_flamethrower"] = "print:Flamethrower team is out of gas, but we'll keep fighting with you.";
level.scr_sound["fireteam_mg_primary"]["fireteam_finished_mg"] = "print:We're out of MG drums!";
// -- end fireteam dialogue --

*/
// --- END SETUP EXAMPLES ---

fireteams_init()
{
	// setup flags
	flag_init( "fireteams_setup" );  // have we initialized all the arrays?
	flag_init( "fireteams_ability_given" );  // did we give players the ability to call in fireteams yet?
	flag_init( "fireteams_available" );  // are we in a place where the fireteams can enter the battle?
	flag_init( "fireteam_active" );  // is there currently a fireteam doing its thing?
	flag_init( "fireteam_hud_clearing" );  // are we clearing the fireteam hud element?	
	
	fireteams_setup_hud();
	
	level.fireteam_entrance_index = 0;  // default to 0 to eliminate script asserts
	
	ASSERTEX( IsDefined( level.fireteams_init_func ), "Scripter needs to set up the level's fireteam_init_func." );
	[[level.fireteams_init_func]]();
	
	// hide the destroyed states
	fireteams_hide_destroyed_states();
	
	// populate level.fireteams with our control arrays
	fireteams_populate_leveldotfireteams();
	
	flag_set( "fireteams_setup" );
}

fireteams_populate_leveldotfireteams()
{
	level.fireteams[0] = level.fireteam_bazooka;
	level.fireteams[1] = level.fireteam_flamethrower;
	level.fireteams[2] = level.fireteam_mg;
}

fireteams_hide_destroyed_states()
{
	prefixes = level.fireteam_bazooka["foyer"]["geoPrefixes"];
	// TODO array_add more here as we update the script
	
	for( i = 0; i < prefixes.size; i++ )
	{
		prefix = prefixes[i];
		fullname = prefix + "_destroyed";
		destruction = GetEntArray( fullname, "targetname" );
		ASSERTEX( IsDefined( destruction ) && destruction.size > 0, "Couldn't find any destruction to hide with targetname of '" + fullname + "'." );
		
		// each destruction group can have both models and sbmodels
		for( k = 0; k < destruction.size; k++ )
		{
			destruction[k] Hide();
		}
	}
}

fireteams_give_ability_allplayers( setAvailable )
{
	players = get_players();
	
	for( i = 0; i < players.size; i++ )
	{
		players[i] fireteams_give_ability();
	}
	
	flag_set( "fireteams_ability_given" );
	
	if( !IsDefined( setAvailable ) )
	{
		setAvailable = true;
	}
	
	if( setAvailable )
	{
		fireteams_set_available();
	}
	
	// kick off the callbacks
	level thread fireteams_onPlayerConnect();
}

// self = a player
fireteams_give_ability()
{
	self GiveWeapon( "rocket_barrage" );
	self SetActionSlot( level.fireteams_action_slot, "weapon", "rocket_barrage" );
	
	self thread fireteams_catch_input();
}

// players can now call in fireteams
fireteams_set_available()
{
	if( !flag( "fireteams_available" ) )
	{
		flag_set( "fireteams_available" );
		thread fireteam_dialogue( "fireteams_available" );
	}
}

// players can no longer call in fireteams
fireteams_set_unavailable( sayDialogue )
{
	if( flag( "fireteams_available" ) )
	{		
		flag_clear( "fireteams_available" );
		
		if( !IsDefined( sayDialogue ) )
		{
			sayDialogue = false;
		}		
		
		if( sayDialogue )
		{
			thread fireteam_dialogue( "fireteams_unavailable" );
		}
	}
}

fireteams_firsthint()
{
	level.fireteam_hint_hud setText( "Press Right D-Pad to call in a fireteam." );	 // TODO localize
	level.fireteam_hint_hud FadeOverTime( level.fireteam_hud_fade_time );
	level.fireteam_hint_hud.alpha = 1;
	
	while( 1 )
	{
		players = get_players();
		
		foundOne = false;
		for( i = 0; i < players.size; i++ )
		{
			if( IsDefined( players[i].is_calling_fireteam ) && players[i].is_calling_fireteam )
			{
				foundOne = true;
				break;
			}
		}
		
		if( foundOne )
		{
			break;
		}
		else
		{
			wait( 0.05 );
		}
	}
	
	level.fireteam_hint_hud FadeOverTime( level.fireteam_hud_fade_time );
	level.fireteam_hint_hud.alpha = 0;
}

// self = a player
fireteams_catch_input()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	while( 1 )
	{
		// wait for player to switch to the item
		while( self GetCurrentWeapon() != "rocket_barrage" )
		{
			wait( 0.05 );
		}
		
		ASSERTEX( IsDefined( level.current_battle ), "No current battle defined, so we can't call in a fireteam." );
		
		// init self.is_calling_fireteam if necessary
		if( !IsDefined( self.is_calling_fireteam ) )
		{
			self.is_calling_fireteam = false;
		}
		
		// if we're not already in the middle of calling in a fireteam...
		if( !self.is_calling_fireteam )
		{
			ASSERTEX( flag( "fireteams_setup" ), "fireteams need to be set up first." );
	
			// if fireteams aren't currently available, we can't call it in
			if( !flag( "fireteams_available" ) )
			{
				sayDialogue = false;
				
				// how much time has elapsed since we last denied service?
				if( !IsDefined( level.fireteam_dialogue_last_deny ) )
				{
					level.fireteam_dialogue_last_deny = GetTime();
				}
				
				// if too little time has elapsed...
				if( GetTime() - level.fireteam_dialogue_last_deny < ( level.fireteam_dialogue_deny_wait * 1000 ) )
				{
					// TODO maybe pulse the fireteam icon or something?
				}
				// otherwise...
				else
				{
					// is it because a fireteam is doing its thing at the moment?
					if( flag( "fireteam_active" ) )
					{
						thread fireteam_dialogue( "fireteams_unavailable_already_active" );
					}
					// or some other reason?
					else
					{
						thread fireteam_dialogue( "fireteams_unavailable_reminder" );
					}
				}
				
				// wait for weapon switch OR for fireteams to become available again before continuing
				while( self GetCurrentWeapon() == "rocket_barrage" && !flag( "fireteams_available" ) )
				{
					wait( 0.1 );
				}
			}
			// otherwise we're ok to call in a fireteam
			else
			{
				self.is_calling_fireteam = true;
				
				while( self GetCurrentWeapon() == "rocket_barrage" && flag( "fireteams_available" ) )
				{
					for( i = 0; i < level.fireteams.size; i++ )
					{
						// make sure we're still legit in case this isn't the first iteration of the loop
						if( self GetCurrentWeapon() != "rocket_barrage" || !flag( "fireteams_available" ) )
						{
							break;
						}
						
						fireteamControlArray = level.fireteams[i];
						
						// set up the "timesUsed" element of the control array, if necessary
						if( !IsDefined( fireteamControlArray["timesUsed"] ) )
						{
							fireteamControlArray["timesUsed"] = 0;
						}
						
						// skip this fireteam if we've used them more than we're allowed to
						if( fireteamControlArray["timesUsed"] >= fireteamControlArray["maxUses"] )
						{
							continue;
						}
						
						// TODO localize
						printstring = "Press Fire to call in the " + fireteamControlArray["displayname"] + " team, press Use to select a different one.";
						fireteams_hud_print( printstring );
						
						input = undefined;
						
						// wait for input: player can press one of two buttons here
						while( self GetCurrentWeapon() == "rocket_barrage" && flag( "fireteams_available" ) )
						{
							if( self AttackButtonPressed() )
							{
								input = "attack";
								
								// wait for button to be unpressed before continuing
								while( self AttackButtonPressed() )
								{
									wait( 0.05 );
								}
								
								break;
							}
							// HACK this needs to be keybinding- and platform-safe
							//else if( self ButtonPressed( level.fireteams_dpad_button ) )
							else if( self UseButtonPressed() )
							{
								input = "switch";
								
								while( self UseButtonPressed() )
								{
									wait( 0.05 );
								}
								
								break;
							}
							
							wait( 0.05 );
						}
						
						thread fireteams_hud_clear();
						
						// weapon can switch here (out of ammo, player presses weapon swap button, etc),
						//  so make sure that input is defined and that we're still allowed to call in a team
						if( IsDefined( input ) && flag( "fireteams_available" ) && input == "attack" )
						{
							self fireteams_call_in_team( fireteamControlArray );
							// wait for player to be switched off of weapon, etc., before we wait for feedback again
							wait( level.fireteam_input_pause_time );
							break;
						}
						else
						{
							continue;
						}
					}
					
					//wait( 0.05 );  // shouldn't need this but might as well be safe
				}
				
				self.is_calling_fireteam = false;
			}
		}
		
		wait( 0.05 );
	}
}

// self = a player
fireteams_call_in_team( fireteamControlArray )
{
	level.fireteam_requester = self;
	
	fireteams_set_unavailable();
	
	flag_set( "fireteam_active" );
	
	fireteamControlArray["timesUsed"]++;
	
	level thread [[fireteamControlArray["masterControlFunc"]]]( fireteamControlArray );
}

fireteams_setup_hud()
{
	level.fireteam_hud = NewHudElem();
	level.fireteam_hud.alignX = "left";
	level.fireteam_hud.fontScale = 1.25;
	level.fireteam_hud.x = 90;
	level.fireteam_hud.y = 200;
	
	level.fireteam_hint_hud = NewHudElem();
	level.fireteam_hint_hud.alignX = "left";
	level.fireteam_hint_hud.fontScale = 1.5;
	level.fireteam_hint_hud.x = 210;
	level.fireteam_hint_hud.y = 200;
}

fireteams_hud_print( text, method )
{
	while( flag( "fireteam_hud_clearing" ) )
	{
		// TODO maybe waittillframeend?
		wait( 0.05 );
	}
	
	level.fireteam_hud setText( text );	
	level.fireteam_hud FadeOverTime( level.fireteam_hud_fade_time );
	level.fireteam_hud.alpha = 1;
}

fireteams_hud_clear()
{
	flag_set( "fireteam_hud_clearing" );
	
	level.fireteam_hud FadeOverTime( level.fireteam_hud_fade_time );
	level.fireteam_hud.alpha = 0;
	
	wait( level.fireteam_hud_fade_time );
	
	flag_clear( "fireteam_hud_clearing" );
}

// handles specific behavior for when a bazooka fireteam is called in
fireteam_bazooka( fireteamControlArray)
{
	// HACK? we've added some values to our working copy of the control array,
	//  so now we need to copy that over into the level variable
	level.fireteam_bazooka = fireteamControlArray;
	// same for the copies in this array
	fireteams_populate_leveldotfireteams();
	
	// TODO figure out which entrance we're using!  for now default to 0
	level.fireteam_entrance_index = 0;
	
	guys = fireteam_preshoot( level.fireteam_bazooka );
	guy_primary = guys[0];
	guy_secondary = guys[1];
	
	guy_primary.animname = "fireteam_bazooka_primary";
	guy_secondary.animname = "fireteam_bazooka_secondary";
	
	guy_primary SetCanDamage( false );
	
	// collect aimSpots
	aimSpots = level.fireteam_bazooka[level.current_battle]["aimSpots"];
	
	// TEMP remove after testing	
	for( i = 0; i < aimSpots.size; i++ )
	{
		thread draw_line_until_notify( guy_primary.origin, aimSpots[i].origin, 0, 255, 255, level, "fireteam_done_firing" );
	}
	
	explosionRadius = 215;
	
	// TODO allow for multiple sets of aimSpots per level.current_battle
	for( i = 0; i < aimSpots.size; i++ )
	{
		// guys reload bazooka
		guys fireteam_bazooka_reload();
		
		aimSpot = aimSpots[i];
		guy_primary AllowedStances( "stand" );
		wait( 0.5 );
		guy_primary.ignoreall = false;
		guy_primary SetEntityTarget( aimSpot );
		
		guy_primary waittillmatch( "fireAnim", "fire" ); // Fired off a shot
		
		// TODO wait for damage
		
		// do damage to the spot and kill the guys in the area
		// TODO possibly break this out into a separate function -
		//   see if other fireteams need the functionality
		prefix = level.fireteam_bazooka[level.current_battle]["geoPrefixes"][i];
		geoIntactArray = GetEntArray( prefix + "_intact", "targetname" );
		geoDestroyedArray = GetEntArray( prefix + "_destroyed", "targetname" );
		
		// TODO play a particle
		
		// kill the enemies in the area
		enemies = GetAIArray( "axis" );
		for( k = 0; k < enemies.size; k++ )
		{
			enemy = enemies[k];
			
			if( Distance( aimSpot.origin, enemy.origin ) <= explosionRadius )
			{
				enemy DoDamage( enemy.health + 50, ( 0, 0, 0 ) );
			}
		}
		
		// delete the intact geo
		for( k = 0; k < geoIntactArray.size; k++ )
		{
			geo = geoIntactArray[k];
			// TODO perhaps connectpaths on sbmodels			
			geo Delete();
		}
		
		// show the destroyed geo
		for( k = 0; k < geoDestroyedArray.size; k++ )
		{
			geo = geoDestroyedArray[k];
			// TODO perhaps disconnectpaths on sbmodels			
			geo Show();
		}
		
		wait( 0.05 );
		guy_primary ClearEntityTarget();
		
		guy_primary AllowedStances( "crouch" );
		
		// if it's not the last spot to shoot at...
		if( i < ( aimSpots.size - 1 ) )
		{
			wait( RandomFloatRange( 2, 5 ) );
		}
		else
		{
			// give him some time after shooting
			wait( 2 );
			
			// switch weapon
			guy_primary gun_switchto( guy_primary.secondaryweapon, "right" );
		}
	}
	
	// wait a few seconds
	wait( 3 );
	
	guys fireteam_postshoot( level.fireteam_bazooka );
}

// TODO put in anims when we get them
// self = the fireteam AI array
fireteam_bazooka_reload()
{
	anime = "bazooka_reload";
	
	level thread anim_single( self, anime );
	level waittill( anime );
}

// handles specific behavior for when a flamethrower fireteam is called in
fireteam_flamethrower( fireteamControlArray )
{
	// HACK? we've added some values to our working copy of the control array,
	//  so now we need to copy that over into the level variable
	level.fireteam_flamethrower = fireteamControlArray;
	// same for the copies in this array
	fireteams_populate_leveldotfireteams();
	
	// TODO figure out which entrance we're using!  for now default to 1
	level.fireteam_entrance_index = 1;
	
	guys = fireteam_preshoot( level.fireteam_flamethrower, false );
	guy_primary = guys[0];
	guy_secondary = guys[1];
	
	// we want these guys to do a couple firing sets
	guys thread fireteam_runto_nodes( level.fireteam_flamethrower, true );
	
	// get the "sets" of aimSpots for this entrance index.  this tells us how many stops the flamethrower team will make
	aimSpotSets = level.fireteam_flamethrower[level.current_battle]["aimSpots"][level.fireteam_entrance_index];
	
	// OPTIONAL - get the killspawners for this entrance index
	killspawners = level.fireteam_flamethrower[level.current_battle]["killspawners"][level.fireteam_entrance_index];
	
	// OPTIONAL - get the killzones for the entrance index
	killzones = level.fireteam_flamethrower[level.current_battle]["killzones"][level.fireteam_entrance_index];
	
	if( IsDefined( killspawners ) )
	{
		ASSERTEX( aimSpotSets.size == killspawners.size, "The size of the aimSpotSets and killspawners arrays should match!" );
	}
	
	if( IsDefined( killzones ) )
	{
		ASSERTEX( aimSpotSets.size == killzones.size, "The size of the aimSpotSets and killzones arrays should match!" );
	}
	
	for( i = 0; i < aimSpotSets.size; i++ )
	{
		level waittill( "fireteam_reached_nodes" );
		
		if( IsDefined( killspawners ) && IsDefined( killspawners[i] ) )
		{
			// turn off the killspawner
			killspawners[i] notify( "trigger" );
		}
		
		// find the first spot from the control array, and get the second one from the first one's target
		aimSpots[0] = aimSpotSets[i];
		aimSpots[1] = getent_safe( aimSpots[0].target, "targetname" );
		
		// TODO maybe do a flamethrower team setup anim before shooting
		
		// set up the flamethrower guy to shoot
		og_shootTime_min = guy_primary.a.flamethrowerShootTime_min;
		og_shootTime_max = guy_primary.a.flamethrowerShootTime_max;
	
		guy_primary.a.flamethrowerShootTime_min = 10000;
		guy_primary.a.flamethrowerShootTime_max = 15000;
	
		og_DelayTime_min = guy_primary.a.flamethrowerShootDelay_min;
		og_DelayTime_max = guy_primary.a.flamethrowerShootDelay_max;
	
		guy_primary.a.flamethrowerShootDelay_min = 0;
		guy_primary.a.flamethrowerShootDelay_max = 1;
		
		// derive spots close to the shooter so he's never blocked by cover
		//  the aimSpot origins in the map are, in this case, for visual convenience
		aimOrigins_close = [];
		for( k = 0; k < aimSpots.size; k++ )
		{
			eyeOrigin = guy_primary GetEye();
			
			forward = AnglesToForward( VectorToAngles( aimSpots[k].origin - eyeOrigin ) );
			aimOrigins_close[k] = eyeOrigin + vectorScale( forward, 64 );
		}
		
		// TEMP remove after testing	
		for( k = 0; k < aimOrigins_close.size; k++ )
		{
			eyeOrigin = guy_primary GetEye();
			thread draw_line_until_notify( eyeOrigin, aimOrigins_close[k], 0, 255, 255, level, "fireteam_runto_nextnode" );
		}
	
		// spawn the target origin that will do the actual moving
		org = Spawn( "script_origin", aimOrigins_close[0] );
		
		guy_primary.ignoreall = false;
		guy_secondary.ignoreall = false;
		guy_primary SetCanDamage( false );
		guy_primary SetEntityTarget( org );
		
		flameTimer = 10;
		flameStartTime = GetTime();
		flameSweepTime = 2;
		
		// move the target origin around
		while( ( GetTime() - flameStartTime ) < ( flameTimer * 1000 ) )
		{
			for( k = 0; k < aimOrigins_close.size; k++ )
			{
				org MoveTo( aimOrigins_close[k], flameSweepTime );
				org waittill( "movedone" );
			}
		}
		
		if( IsDefined( killzones ) && IsDefined( killzones[i] ) )
		{
			// kill guys off
			thread kill_axis_in_trigger( killzones[i], 1.25 );
		}
		
		// clean up target and spawned origin
		guy_primary ClearEntityTarget();
		org Delete();
		
		guy_primary.a.flamethrowerShootTime_min = og_shootTime_min;
		guy_primary.a.flamethrowerShootTime_max = og_shootTime_max;

		guy_primary.a.flamethrowerShootDelay_min = og_DelayTime_min;
		guy_primary.a.flamethrowerShootDelay_max = og_DelayTime_max;
		
		// send them to the next goalnodes
		level notify( "fireteam_runto_nextnode" );	
	}
	
	// flamer switch weapons
	guy_primary gun_switchto( guy_primary.secondaryweapon, "right" );
	
	guys fireteam_postshoot( level.fireteam_flamethrower );
}

// self = level
fireteam_flamethrower_pickentrance()
{
	switch( level.current_battle )
	{
		case "foyer":
			foyer_midpoint = 1140;
			
			if( get_players_avg_origin()[0] > 1140 )
			{
				// come in from the right side
				level.fireteam_entrance_index = 0;
			}
			else
			{
				// come in from the left side
				level.fireteam_entrance_index = 1;
			}
			
			break;
		
		default:
			ASSERTMSG( "current_battle string '" + level.current_battle + "' not recognized." );
	}
}

// handles specific behavior for when an MG fireteam is called in
fireteam_mg( fireteamControlArray )
{
	// HACK? we've added some values to our working copy of the control array,
	//  so now we need to copy that over into the level variable
	level.fireteam_mg = fireteamControlArray;
	// same for the copies in this array
	fireteams_populate_leveldotfireteams();
	
	// TODO figure out which entrance we're using!  for now default to 0
	level.fireteam_entrance_index = 0;
	
	guys = fireteam_preshoot( level.fireteam_mg );
	guy_primary = guys[0];
	guy_secondary = guys[1];
	
	// collect aimSpots
	aimSpots = level.fireteam_mg[level.current_battle]["aimSpots"];
	
	// TEMP remove after testing	
	for( i = 0; i < aimSpots.size; i++ )
	{
		thread draw_line_until_notify( guy_primary.origin, aimSpots[i].origin, 0, 255, 255, level, "fireteam_done_firing" );
	}
	
	// TODO set up and fire the MG!
	guy_primary.ignoreall = false;
	guy_primary SetCanDamage( false );
	
	// TEMP stuff here for now
	iprintlnbold( "firing mg" );
	wait( 15 );
	
	guy_primary gun_switchto( guy_primary.secondaryweapon, "right" );
	
	guys fireteam_postshoot( level.fireteam_mg );
}

// handles generic pre-shooting behavior for fireteams
// runToNodes = if true, this will tell guys to run to nodes for you; disable for custom behavior
fireteam_preshoot( fireteamControlArray, runToNodes )
{	
	level notify( "fireteam_starting" );
	
	if( !IsDefined( runToNodes ) )
	{
		runToNodes = true;
	}
	
	// call 'em in
	thread fireteam_request_dialogue( fireteamControlArray );
	
	level waittill( "fireteam_request_done" );
	
	wait( RandomFloatRange( level.fireteam_request_wait_min, level.fireteam_request_wait_max ) );
	
	// optionally, figure out which entrance index to use
	if( IsDefined( fireteamControlArray["pickEntranceFunc"] ) )
	{
		level thread [[fireteamControlArray["pickEntranceFunc"]]]();
	}
	
	// spawn, setup, warp the guys
	guys = fireteam_spawn_ais( fireteamControlArray );
	guys fireteam_setup_ais();
	//guys fireteam_warp_ais( fireteamControlArray );
	
	// open the door
	guys fireteam_entrance_action( fireteamControlArray );
	
	// entrance dialogue
	guys thread fireteam_dialogue( "entrance", fireteamControlArray );
	
	if( runToNodes )
	{
		// guys run to node
		guys fireteam_runto_nodes( fireteamControlArray );
	}
	
	return guys;
}

// handles the fireteam "request" when players activate it
fireteam_request_dialogue( fireteamControlArray )
{
	player = level.fireteam_requester;
	
	teamname = fireteamControlArray["teamname"];
	
	speaker = undefined;
	animname = "fireteam_requester";
	anime = "fireteam_request_" + teamname;
	
	// TODO echo this back, relay style - I bet we can get away with just playing the sound farther away
	
	// get the non-hero friendly closest to the player
	// TODO maybe we always want the sarge to do the dialogue?
	for( i = 0; i < level.friends.size; i++ )
	{
		guy = level.friends[i];
		
		// no heroes, since they have unique voices
		if( guy == level.sarge || guy == level.hero1 )
		{
			continue;
		}
		
		if( is_active_ai( guy ) )
		{
			// first guy becomes our test case
			if( !IsDefined( speaker ) )
			{
				speaker = guy;
			}
			else
			{
				// if the guy we're evaluating is closer...
				if( Distance( player.origin, guy.origin ) < Distance( player.origin, speaker.origin ) )
				{
					// we have a new winner
					speaker = guy;
				}
			}
		}
	}
	
	// maybe we only have heroes in the squad?  this is no bueno but we'll roll with it.
	if( !IsDefined( speaker ) )
	{
		speaker = level.sarge;
		println( "BER3B: fireteam_request_dialogue(): tried to find a non-hero AI to call the fireteam in with, but couldn't.  defaulting to sarge." );
	}
	
	speaker say_dialogue( animname, anime );
	
	level notify( "fireteam_request_done" );
}

// self = the array of AIs who are the fireteam
fireteam_spawn_ais( fireteamControlArray )
{
	// get warp spots and spawners
	warpspot_primary = fireteamControlArray[level.current_battle]["warpSpots_primary"][level.fireteam_entrance_index];
	warpspot_secondary = fireteamControlArray[level.current_battle]["warpSpots_secondary"][level.fireteam_entrance_index];
	
	spawner_primary = fireteamControlArray["spawner_primary"];
	spawner_secondary = fireteamControlArray["spawner_secondary"];
	
	// move the spawners to the warp spots before using them
	spawner_primary.origin = warpspot_primary.origin;
	spawner_secondary.origin = warpspot_secondary.origin;
	
	guys = [];
	
	guys[0] = spawn_guy( spawner_primary );  // primary guy
	guys[1] = spawn_guy( spawner_secondary );  // secondary guy
	
	return guys;
}

// self = the fireteam AI array
fireteam_entrance_action( fireteamControlArray )
{
	// TODO more action on door opening!
	
	door = fireteamControlArray[level.current_battle]["doors"][level.fireteam_entrance_index];
	openDirection = fireteamControlArray[level.current_battle]["doors"]["openDirection"][level.fireteam_entrance_index];
	door fireteam_door_open( openDirection );
}

// self = the door script_brushmodel
fireteam_door_open( openDirection )
{
	// if multiple teams are using the same door, don't keep rotating it
	if( IsDefined( self.fireteam_door_opened ) )
	{
		return;
	}
	else
	{
		self.fireteam_door_opened = true;
	}
	
	self ConnectPaths();
	
	if( openDirection == "right" )
	{
		self RotateYaw( -120, 1, 0, 0.5 );
	}
	else
	{
		self RotateYaw( 120, 1, 0, 0.5 );
	}
	
	self waittill( "rotatedone" );
	self DisconnectPaths();
}

// self = the fireteam AI array
// waitForNotifies = do we wait for a notify before moving to the next node set?
fireteam_runto_nodes( fireteamControlArray, waitForNotifies )
{
	if( !IsDefined( waitForNotifies ) )
	{
		waitForNotifies = false;
	}
	
	nodePrimary = fireteamControlArray[level.current_battle]["nodes_primary"][level.fireteam_entrance_index];
	nodeSecondary = fireteamControlArray[level.current_battle]["nodes_secondary"][level.fireteam_entrance_index];
	
	// can handle a node chain, if necessary
	while( 1 )
	{
		self[0] SetGoalNode( nodePrimary );
		self[1] SetGoalNode( nodeSecondary );
	
		array_thread( self, ::fireteam_member_reached_node, fireteamControlArray );
	
		numReached = 0;
		while( numReached < self.size )
		{
			level waittill( "fireteam_member_reached_goal" );
			numReached++;
		}
		
		level notify( "fireteam_reached_nodes" );
		
		// if there are more nodes in the chain...
		if( IsDefined( nodePrimary.target ) && IsDefined( nodeSecondary.target ) )
		{
			nodePrimary = getnode_safe( nodePrimary.target, "targetname" );
			nodeSecondary = getnode_safe( nodeSecondary.target, "targetname" );
			
			if( waitForNotifies )
			{
				level waittill( "fireteam_runto_nextnode" );
			}
		}
		else
		{
			break;
		}
	}
}

// self = an AI
fireteam_member_reached_node( fireteamControlArray )
{
	self endon( "death" );
	
	self waittill( "goal" );
	level notify( "fireteam_member_reached_goal" );
	
	// special behavior for bazooka guys when they reach their nodes
	if( fireteamControlArray["teamname"] == "bazooka" )
	{
		self AllowedStances( "crouch" );
	}
}

// self = the array of AIs who are the fireteam
fireteam_setup_ais()
{
	self[0].fireteam_role = "primary";
	self[1].fireteam_role = "secondary";
	
	for( i = 0; i < self.size; i++ )
	{
		guy = self[i];
		guy.og_goalradius = guy.goalradius;
		guy.goalradius = 12;
		guy.ignoreme = true;
		guy.ignoreall = true;
		guy.og_grenadeawareness = guy.grenadeawareness;
		guy.grenadeawareness = 0;
		guy PushPlayer( true );
		guy thread magic_bullet_shield();
	}
}

// handles generic post-shooting behavior for fireteams
// self = the fireteam AI array
fireteam_postshoot( fireteamControlArray )
{
	level notify( "fireteam_done_firing" );
	
	self thread fireteam_dialogue( "finished", fireteamControlArray );
	
	// when done, reset guys
	self fireteam_reset_ais();
	
	level notify( "fireteam_finished" );
	
	level thread fireteams_cooldown_timer();
}

// self should be the level
fireteams_cooldown_timer()
{
	// set as no longer active
	flag_clear( "fireteam_active" );
	
	fireteam_dialogue( "fireteams_unavailable" );
	
	// wait for the cooldown timer and reset the fireteams as available
	wait( level.fireteam_cooldown_time );
	
	fireteams_set_available();
}

// sets these guys back to be normal friendlies
// self = the array of AIs who are the fireteam
fireteam_reset_ais()
{
	for( i = 0; i < self.size; i++ )
	{
		guy = self[i];
		
		if( !is_active_ai( guy ) )
		{
			continue;
		}
		
		guy.goalradius = guy.og_goalradius;
		guy.ignoreme = false;
		guy.ignoreall = false;
		guy.grenadeawareness = guy.og_grenadeawareness;
		guy PushPlayer( false );
		guy SetCanDamage( true );
		
		guy AllowedStances( "stand", "crouch", "prone" );
		
		if( IsDefined( level.fireteam_reset_ais_customfunc ) )
		{
			guy [[level.fireteam_reset_ais_customfunc]]();
		}
		else
		{
			// TODO maybe add some default node-seeking functionality?
		}
		
		// thread this so players don't experience a long period of time between
		//  fireteam action and the start of the cooldown period
		guy thread fireteam_reset_ais_delayed_danger();
	}
}

// gives a fireteam member a fighting chance to get some cover after doing their fireteam duties
// self = an AI
fireteam_reset_ais_delayed_danger()
{
	self waittill_notify_or_timeout( "goal", 10 );
	self notify( "stop magic bullet shield" );
}

// self = the fireteam AI array
fireteam_dialogue( dialogueType, fireteamControlArray )
{
	speaker = undefined;
	animname = undefined;
	anime = undefined;
	
	if( IsDefined( fireteamControlArray ) )
	{
		teamname = fireteamControlArray["teamname"];
	}
	else
	{
		teamname = "generic";
	}
	
	switch( dialogueType )
	{
		case "entrance":
			speaker = self[0];
			animname = "fireteam_" + teamname + "_primary";
			anime = "fireteam_arrival_" + teamname;
			break;
			
		case "finished":
			speaker = self[0];
			animname = "fireteam_" + teamname + "_primary";
			anime = "fireteam_finished_" + teamname;
			break;
			
		case "fireteams_available":
			speaker = level.sarge;
			animname = "fireteam_generic";
			anime = "fireteams_available";
			break;
		
		case "fireteams_unavailable":
			speaker = level.sarge;
			animname = "fireteam_generic";
			anime = "fireteams_unavailable";
			break;
			
		case "fireteams_unavailable_reminder":
			speaker = level.sarge;
			animname = "fireteam_generic";
			anime = "fireteams_unavailable_reminder";
			break;
		
		case "fireteams_unavailable_already_active":
			speaker = level.sarge;
			animname = "fireteam_generic";
			anime = "fireteams_unavailable_already_active";
			break;
			
		default:
			ASSERTMSG( "Can't recognize fireteam dialogue type '" + dialogueType + "'." );
			return;
	}
	
	speaker say_dialogue( animname, anime );
}


// --- COOP FUNCTIONS ---
fireteams_onPlayerConnect()
{
	while( 1 )
	{
		// initial server connection
		level waittill( "connecting", player );
		
		player thread fireteams_onPlayerSpawned();
	}
}

// self = a player connected to the server
fireteams_onPlayerSpawned()
{
	// need to loop because potentially this can happen more than once per player, since
	//  last stand just respawns the downed player when they're rezzed.
	while( 1 )
	{
		// waittill the player spawns
		self waittill("spawned_player");
		
		// set up fireteam control if we've hit that part of the level
		if( flag( "fireteams_ability_given" ) )
		{
			self fireteams_give_ability();
		}
	}
}
// --- END COOP FUNCTIONS ---


// --- UTIL FUNCTIONS ---

// does GetEnt, error checks the result, and if bad, gives the scripter a useable error message
// returns the result of the GetEnt call
// debugName = an arbitrary string that the scripter can use to ID his issue
getent_safe( value, key, debugName )
{
	ent = GetEnt( value, key );
	
	if( IsDefined( debugName ) )
	{
		debugString = "Couldn't GetEnt for: " + debugName;
	}
	else
	{
		debugString = "Couldn't GetEnt with KVP " + key + " / " + value;
	}
	
	if( IsDefined( ent ) )
	{
		return ent;
	}
	else
	{
		ASSERTMSG( debugString );
	}
}

// same as above, but for GetNode
getnode_safe( value, key, debugName )
{
	node = GetNode( value, key );
	
	if( IsDefined( debugName ) )
	{
		debugString = "Couldn't GetNode for: " + debugName;
	}
	else
	{
		debugString = "Couldn't GetNode with KVP " + key + " / " + value;
	}
	
	if( IsDefined( node ) )
	{
		return node;
	}
	else
	{
		ASSERTMSG( debugString );
	}
}

// spawns a guy
// spawner = the spawner to spawn a guy from
spawn_guy( spawner )
{
	spawnedGuy = spawner StalingradSpawn();
	spawn_failed (spawnedGuy);
	ASSERT( IsDefined( spawnedGuy ) );

	return spawnedGuy;
}

// plays dialogue from a specific AI
// self = the AI to speak
say_dialogue( animname, theLine )
{
	ASSERTEX( is_active_ai( self ), "play_dialogue(): the entity that's supposed to be speaking is not an active AI." );
	
	self.og_animname = self.animname;
	self.animname = animname;
	
	// don't want to mess up previously scripted values
	if( !IsDefined( self.magic_bullet_shield ) || !self.magic_bullet_shield )
	{
		self thread magic_bullet_shield();
		self.say_dialogue_bullet_shield = true;
	}
	
	self anim_single_solo( self, theLine );
	self.animname = self.og_animname;
	
	if( IsDefined( self.say_dialogue_bullet_shield ) && self.say_dialogue_bullet_shield )
	{
		self notify( "stop magic bullet shield" );
	}
}

is_active_ai( suspect )
{
	if( IsDefined( suspect ) && IsSentient( suspect ) && IsAlive( suspect ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

// returns the "average" of all players' origins 
get_players_avg_origin()
{
	players = get_players();
	
	meanX = 0;
	meanY = 0;
	meanZ = 0;
	
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		meanX += player.origin[0];
		meanY += player.origin[1];
		meanZ += player.origin[2];
	}
	
	meanX /= players.size;
	meanY /= players.size;
	meanZ /= players.size;
	
	return ( meanX, meanY, meanZ );
}

// kill axis in a given trigger
kill_axis_in_trigger( trig, randomDelayFloat )
{
	ASSERTEX( IsDefined( trig ), "kill_axis_in_trigger(): trig is not defined" );
	
	enemies = GetAIArray( "axis" );
	for( k = 0; k < enemies.size; k++ )
	{
		enemy = enemies[k];
		
		if( enemy IsTouching( trig ) )
		{
			enemy bloody_death( true, randomDelayFloat );
		}
	}
}

// Fake death
// self = the guy getting worked
bloody_death( die, delay )
{
	self endon( "death" );

	if( !is_active_ai( self ) )
	{
		return;
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return;
	}

	self.bloody_death = true;

	if( IsDefined( delay ) )
	{
		wait( RandomFloat( delay ) );
	}

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";
	
	for( i = 0; i < 3 + RandomInt( 5 ); i++ )
	{
		random = RandomIntRange( 0, tags.size );
		//vec = self GetTagOrigin( tags[random] );
		self thread bloody_death_fx( tags[random], undefined );
		wait( RandomFloat( 0.1 ) );
	}

	if( die )
	{
		self DoDamage( self.health + 50, self.origin );
	}
}	

// self = the AI on which we're playing fx
bloody_death_fx( tag, fxName ) 
{ 
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["flesh_hit"];
	}

	PlayFxOnTag( fxName, self, tag );
}
