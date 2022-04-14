#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\hol3_callbacks;
#include maps\pel2_util;

#using_animtree ("generic_human");
main()
{
	
	maps\_sherman::main( "vehicle_usa_tracked_shermanm4a3_camo" );
	maps\_wc51::main( "vehicle_usa_wheeled_wc51" );
	maps\_truck::main( "vehicle_usa_wheeled_gmc_truck_winter", "gmc" );
	maps\_jeep::main( "vehicle_ger_wheeled_horch1a", "horch" );
	maps\_wasp::main( "vehicle_brt_tracked_wasp" );
	maps\_sdk::main( "vehicle_ger_wheeled_sdk222_winter" );
	
	PrecacheModel( "static_holland_gm_ammobox2" );
	PrecacheModel( "viewmodel_usa_bbetty_mine" );
	PrecacheModel( "viewmodel_usa_satchel_charge" );
	PrecacheModel( "tag_origin_animate" );
	PrecacheItem( "bouncing_betty" );
	
	add_start( "street", ::start_street, &"STARTS_HOL3_STREET" );
	add_start( "satchel", ::start_satchel, &"STARTS_HOL3_SATCHEL" );
	add_start( "furn", ::start_furniture, &"STARTS_HOL3_FURNITURE" );
	add_start( "defend", ::start_defend, &"STARTS_HOL3_DEFEND" );
	add_start( "yard", ::start_yard, &"STARTS_HOL3_YARD" );
	add_start( "square", ::start_square, &"STARTS_HOL3_SQUARE" );
	default_start( ::intro_rail );
	
	flag_init( "enable_weapons" );
	flag_init( "on_rail" );
	
	maps\hol3_fx::main();
	maps\createart\hol3_art::main();
	
	init_callbacks();
	
	// init drones
	maps\_drones::init();		

    set_environment("cold");
	
	maps\_load::main();

	level thread maps\hol3_amb::main();
	maps\hol3_anim::main();
	
	// setup drone characters
	character\char_ger_wrmcht_mp40::precache();
	character\char_brt_infwint_r_enfield::precache();
	// These are called everytime a drone is spawned in to set up the character.
	level.drone_spawnFunction["axis"] = character\char_ger_wrmcht_mp40::main;
	level.drone_spawnFunction["allies"] = character\char_brt_infwint_r_enfield::main; 		
	
}



///////////////////
//
// Entry point for the level action
//
///////////////////////////////

intro_rail()
{
	
	setup_level();
	
	flag_set( "on_rail" );
	
	// spawn player vehicles
	trig = getent( "trig_spawn_intro_jeeps", "targetname" );
	trig notify( "trigger" );
	
	wait( 0.05 );
	
	trig = getent( "trig_move_intro_jeeps", "targetname" );
	trig notify( "trigger" );

	level thread jeeps_unload();

	setup_friendlies();

	// spawn ambient friendly ai
	simple_spawn( "intro_fork_spawners" );
	simple_spawn( "intro_fork_smokers", ::intro_fork_smokers );
	
	simple_spawn( "intro_hq_spawners" );
	simple_spawn( "intro_hq_barrel_spawners", ::intro_hq_barrel_spawners_strat );
	
	truck_2 = getent( "intro_truck_2", "targetname" );
	truck_3 = getent( "intro_truck_3", "targetname" );	
	truck_4 = getent( "intro_truck_4", "targetname" );	
	
	truck_2.health = 100000000; 	
	truck_3.health = 100000000;
	truck_4.health = 100000000;
	
	level thread kill_convoy_guys();
	level thread populate_extra_trucks();
	level thread weary_walkers();
	level thread camp_sitters();
	level thread camp_unloaders();
	level thread near_camp();

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		level thread put_player_on_rail( players[i] );
	}	
	
	
	flag_wait( "jeeps_all_unloaded" );
	
	// TODO still need this? currently using deleteme on last node
	//level thread cleanup_rail();
	level thread backtrack_fail();
	
	kill_aigroup( "intro_fork_ai" );
	
	set_color_chain( "chain_pre_street" );

	maps\hol3_street::main();

}



put_player_on_rail( player )
{
	
	level.jeep_1 = getent( "intro_jeep_1", "targetname" );
	level.jeep_2 = getent( "intro_jeep_2", "targetname" );

	player_jeep = undefined;
	link_orig = undefined;
	link_angles = undefined;
	link_tag = undefined;

	if( !flag( "rail_seat_taken_1" ) )
	{
		player_jeep = level.jeep_2;

		link_tag = "tag_passenger2";
		link_orig = player_jeep gettagOrigin( link_tag );
		link_angles = player_jeep gettagangles( link_tag );
		
		flag_set( "rail_seat_taken_1" );
		player.current_seat = 1;
		
	}
	else if( !flag( "rail_seat_taken_2" ) )
	{
		player_jeep = level.jeep_2;
		link_tag = "tag_passenger4";		
		link_orig = player_jeep gettagorigin( link_tag );
		link_angles = player_jeep gettagangles( link_tag );
		
		flag_set( "rail_seat_taken_2" );
		player.current_seat = 2;
	}
	else if( !flag( "rail_seat_taken_3" ) )
	{
		player_jeep = level.jeep_1;
		link_tag = "tag_passenger2";		
		link_orig = player_jeep gettagorigin( link_tag );
		link_angles = player_jeep gettagangles( link_tag );
		
		flag_set( "rail_seat_taken_3" );
		player.current_seat = 3;
	}
	else if( !flag( "rail_seat_taken_4" ) )
	{
		player_jeep = level.jeep_1;
		link_tag = "tag_passenger4";		
		link_orig = player_jeep gettagorigin( link_tag );
		link_angles = player_jeep gettagangles( link_tag );
		
		flag_set( "rail_seat_taken_4" );
		player.current_seat = 4;
	}
	else
	{
		assertmsg( "something wrong with the jeep setup script" );
	}


	// set the players to the tag origins and angles
	player setorigin( link_orig );
	player setplayerangles( link_angles );

	player.jeep_linkspot = spawn( "script_origin", link_orig ) ;
	player.jeep_linkspot linkto( player_jeep, link_tag, (0,0,-30), (0,0,0) );
	player playerlinktodelta( player.jeep_linkspot, undefined, 1.0 );

	player setstance( "crouch" );
	
}



remove_player_from_rail( player )
{
	
	if( player.current_seat == 1 )
	{
		flag_clear( "rail_seat_taken_1" );
	}
	else if( player.current_seat == 2 )
	{
		flag_clear( "rail_seat_taken_2" );
	}
	else if( player.current_seat == 3 )
	{
		flag_clear( "rail_seat_taken_3" );
	}
	else if( player.current_seat == 4 )
	{
		flag_clear( "rail_seat_taken_4" );
	}
	
	player unlink();
	
}





/////////////////////
////
//// Link player(s) to jeeps
////
/////////////////////////////////
//
//players_in_jeeps()
//{
//
//	// link players to jeeps
//	players = get_players();
//
//	jeep_1 = getent( "intro_jeep_1", "targetname" );
//	jeep_2 = getent( "intro_jeep_2", "targetname" );
//
//	link_tag = undefined;
//	link_orig = undefined;
//	player_jeep = undefined;
//
//	for( i = 0; i < players.size; i++ )
//	{
//
//		// link the player in place
//		if( i == 0 )
//		{
//			player_jeep = jeep_2;
//			link_orig = player_jeep gettagorigin( "tag_passenger2" );
//			link_tag = "tag_passenger2";
//		}
//		else if( i == 1 )
//		{
//			player_jeep = jeep_2;
//			link_orig = player_jeep gettagorigin( "tag_passenger4" );
//			link_tag = "tag_passenger4";
//		}
//		else if( i == 2 )
//		{
//			player_jeep = jeep_1;
//			link_orig = player_jeep gettagorigin( "tag_passenger2" );
//			link_tag = "tag_passenger2";
//		}
//		else if( i == 3 )
//		{
//			player_jeep = jeep_1;
//			link_orig = player_jeep gettagorigin( "tag_passenger4" );
//			link_tag = "tag_passenger4";
//		}
//		
//		
//		players[i].jeep_linkspot = spawn( "script_origin", link_orig ) ;
//		players[i].jeep_linkspot linkto( player_jeep, link_tag, (0,0,-30), (0,0,0) );
//		players[i] playerlinktodelta( players[i].jeep_linkspot, undefined, 1.0 );
//		players[i] setplayerangles( ( 0, -10, 0 ) );
//				
//	}
//
//	
//}




camp_unloaders()
{

	
	orig = getent( "orig_box_unload", "targetname" );
	
	guys = simple_spawn( "intro_box_guys" );

	for( i  = 0; i < guys.size; i++ )
	{
		guys[i].animname = "truck_unload_" + i;
		guys[i] animscripts\shared::placeWeaponOn( guys[i].primaryweapon, "none");		
	}

	level thread anim_loop( guys, "truck_unload", undefined, "blah", orig );
	
}



intro_fork_smokers()
{

	self endon( "death" );
	
	self.animname = "rail_smokers";

	goalnode = getnode( self.target, "targetname" );
	
	level thread anim_loop_solo( self, self.script_noteworthy, undefined, undefined, goalnode );			
	
}



///////////////////
//
// Use script_models for guys in main convoy trucks
//
///////////////////////////////

populate_extra_trucks()
{
	
	
	
//	for( j  = 0; j < level.trucks[i].attachedguys.size; j++ )
//	{
//		animpos = maps\_vehicle_aianim::anim_pos( level.trucks[i], level.trucks[i].attachedguys[j].pos );
//		level.trucks[i].attachedguys[j].vehicle_idle_override = animpos.death_shot;
//	}		
	
	
	truck = getent( "intro_truck_2", "targetname" );
	
	for( i  = 0; i < 10; i++ )
	{
	
		passenger[i] = Spawn( "script_model", truck.origin );
		passenger[i] character\char_brt_infwint_r_enfield::main();
		passenger[i] UseAnimTree( #animtree );
		passenger[i].animname = "truck";
		passenger[i].drone_delete_on_unload = true;
		
		animpos = maps\_vehicle_aianim::anim_pos( truck, i );
		passenger[i].vehicle_idle_override = animpos.drive_idle;
		
		truck thread maps\_vehicle_aianim::guy_enter( passenger[i], truck );	
		
	}
	

	truck = getent( "intro_truck_3", "targetname" );

	for( i  = 0; i < 10; i++ )
	{
	
		passenger[i] = Spawn( "script_model", truck.origin );
		passenger[i] character\char_brt_infwint_r_enfield::main();
		passenger[i] UseAnimTree( #animtree );
		passenger[i].animname = "truck";
		passenger[i].drone_delete_on_unload = true;
		
		animpos = maps\_vehicle_aianim::anim_pos( truck, i );
		passenger[i].vehicle_idle_override = animpos.drive_idle;		
		
		truck thread maps\_vehicle_aianim::guy_enter( passenger[i], truck );	
		
	}
	
	truck = getent( "intro_truck_4", "targetname" );

	for( i  = 0; i < 2; i++ )
	{
	
		passenger[i] = Spawn( "script_model", truck.origin );
		passenger[i] character\char_brt_infwint_r_enfield::main();
		passenger[i] UseAnimTree( #animtree );
		passenger[i].animname = "truck";
		passenger[i].drone_delete_on_unload = true;
		
		animpos = maps\_vehicle_aianim::anim_pos( truck, i );
		passenger[i].vehicle_idle_override = animpos.drive_idle;		
		
		truck thread maps\_vehicle_aianim::guy_enter( passenger[i], truck );	
		
	}	
	
	truck = getent( "convoy_pass_truck", "targetname" );
	
	for( i  = 0; i < 10; i++ )
	{
	
		passenger[i] = Spawn( "script_model", truck.origin );
		passenger[i] character\char_brt_infwint_r_enfield::main();
		passenger[i] UseAnimTree( #animtree );
		passenger[i].animname = "truck";
		passenger[i].drone_delete_on_unload = true;
		
		animpos = maps\_vehicle_aianim::anim_pos( truck, i );
		passenger[i].vehicle_idle_override = animpos.drive_idle;		
		
		truck thread maps\_vehicle_aianim::guy_enter( passenger[i], truck );	
		
	}	
	
}



jeeps_unload()
{

	jeep_1 = getent( "intro_jeep_1", "targetname" );
	jeep_2 = getent( "intro_jeep_2", "targetname" );

	// TODO make invinc
	jeep_1.health = 100000000; 
	jeep_2.health = 100000000; 	

	jeep_1.unload_group = "passengers";
	jeep_2.unload_group = "passengers";

	level thread unload_jeep_1( jeep_1 );
	level thread unload_jeep_2( jeep_2 );

}



unload_jeep_1( jeep )
{
	
	end_node = getvehiclenode( "unload_jeep_1", "script_noteworthy" );
	end_node waittill( "trigger" );
	
	jeep setspeed( 0, 50, 50 );
	
	jeep notify( "unload" );
	
	wait( 10.25 );	
	
	jeep resumespeed( 5 );
	
}



unload_jeep_2( jeep )
{
	
	end_node = getvehiclenode( "unload_jeep_2", "script_noteworthy" );
	end_node waittill( "trigger" );
	
	unload_jeep_players();
	enable_player_weapons();
	flag_set( "enable_weapons" );
	
	jeep setspeed( 0, 50, 50 );
	
	jeep notify( "unload" );
	wait( 0.05 );
	flag_set( "jeeps_all_unloaded" );
	
	wait( 3 );	
	
	jeep resumespeed( 5 );	

	wait( 20 );
	
	kill_aigroup( "intro_jeep_drivers" );
	
}



unload_jeep_players()
{
	
	flag_clear( "on_rail" );
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( players[i].current_seat == 1 )
		{
			players[i] thread move_to_struct_pos( "rail_player1_off" );
		}
		else if( players[i].current_seat == 2 )
		{
			players[i] thread move_to_struct_pos( "rail_player2_off" );
		}
		else if( players[i].current_seat == 3 )
		{
			players[i] thread move_to_struct_pos( "rail_player3_off" );
		}
		else if( players[i].current_seat == 4 )
		{
			players[i] thread move_to_struct_pos( "rail_player4_off" );
		}
	}
	
}



move_to_struct_pos( struct_name )
{
	
	dest = getstruct( struct_name, "targetname" );
	
	move_org = spawn( "script_origin", dest.origin );
	self unlink();
	self linkto( move_org );
	move_org moveto( dest.origin, 1, 0.5, 0.3 );
	wait( 1 );
	self unlink();
	move_org delete();
	
}




backtrack_fail()
{
	
	// TODO add proper endon here
	//level endon( TODO );
	
	trig_warn = getent( "trig_backtrack_warn", "targetname" );
	trig_fail= getent( "trig_backtrack_fail", "targetname" );
	
	while( 1 )
	{
	
		if( any_player_istouching( trig_warn ) )
		{
		
			iprintlnbold( "Warning! Return to your squad!" );
			
			if( any_player_istouching( trig_fail ) )
			{			
				// TODO add correct string here
				//setdvar( "ui_deadquote", &"MAK_FAILED_TO_ESCAPE" ); // you failed to escape in time
				maps\_utility::missionFailedWrapper();
				return;
			}
			
		}
	
		wait( 1 );
		
	}
	
}


near_camp()
{

	trigger_wait( "trig_near_camp", "targetname" );

	// move the convoy
	trig = getent( "trig_move_intro_convoy", "targetname" );
	trig notify( "trigger" );

	wait( 0.05 );
	
	trigger_wait( "trig_at_camp", "targetname" );
	
	firepoint = getstruct( "orig_rail_barrel_fire", "targetname" );
	playfx( level._effect["barrel_fire"], firepoint.origin );
	
	trig = getent( "trig_move_last_trucks", "targetname" );
	trig notify( "trigger" );
	
	near_fork();
	
}



weary_walkers()
{

	level.weary_walks = [];
	level.weary_walks[0] = "weary_walk1";
	level.weary_walks[1] = "weary_walk2";
	level.weary_walks[2] = "weary_walk3";
	level.weary_walks[3] = "weary_walk4";
	
	level.weary_walks = array_randomize( level.weary_walks );

	wait( 5 );

	simple_spawn( "weary_walkers", ::weary_walkers_strat );

}



weary_walkers_strat()
{

	self endon ("death");
	self.ignoreall = true;
	
	self.animname = "road_walkers";
	self.goalradius = 64;
	
	self thread set_run_anim( level.weary_walks[int(self.script_noteworthy)] );
	
	self waittill ("goal");
	self delete();
	
}



camp_sitters()
{

	guys = simple_spawn( "intro_hq_sitters" );
	
	anims = [];
	anims[0] = "sit_cold_1";
	anims[1] = "sit_cold_2";

	for( i  = 0; i < guys.size; i++ )
	{
		guys[i].animname = "rail";
		anim_orig = getent( guys[i].target, "targetname" );
		level thread anim_loop_solo( guys[i], anims[i], undefined, undefined, anim_orig );
	}

}



near_fork()
{

	trigger_wait( "trig_near_fork", "targetname" );
	event_text( "near_fork" );

	level thread stuck_jeep();
	level thread rail_fork();
	
}

///////////////////
//
// Guys standing around barrel fire
//
///////////////////////////////

intro_hq_barrel_spawners_strat()
{

	
	self endon( "death" );
	
	self.animname = "rail";
	
	goalnode = getnode( self.target, "targetname" );
	
	level thread anim_loop_solo( self, self.script_noteworthy, undefined, "stop_barrel_loop", goalnode );		
	
}



///////////////////
//
// Anims near the fork in the road
//
///////////////////////////////

rail_fork()
{

	wait( 1 );
	
	guy = get_specific_single_ai( "intro_fork_waver" );
	guy.animname = "rail";
	
	// take away his weapon
	guy animscripts\shared::placeWeaponOn( guy.primaryweapon, "none");
	
	goal_node = getnode( "node_rail_waver", "targetname" );
	
	//level thread anim_loop_solo( guy, "motioning_a", undefined, "stop_fork_waving", goal_node );
	level thread anim_loop_solo( guy, "traffic", undefined, "stop_fork_waving", goal_node );		
	
}



///////////////////
//
// Cleanup early rail ai
//
///////////////////////////////

kill_convoy_guys()
{
	
	trigger_wait( "trig_near_stuck_jeep", "targetname" );

	level notify( "stop_barrel_loop" );

	wait( 0.05 );

	kill_aigroup( "intro_hq_ai" );

	vnode = getvehiclenode( "auto2290", "targetname" );
	vnode waittill( "trigger" );
	
	kill_aigroup( "intro_jeep_stuck_ai" );
	
}


/////////////////////
////
//// Cleanup rail vehicles
////
/////////////////////////////////
//
//cleanup_rail()
//{
//	
//	vehicles_to_delete = getentarray( "script_vehicle", "classname" );
//	script_vehiclespawngroup
//	
//}



stuck_jeep()
{
	
	simple_spawn( "intro_jeep_stuck_spawners", ::intro_jeep_stuck_spawners_strat );
	driver = simple_spawn_single( "intro_jeep_stuck_driver" );
	waiter = simple_spawn_single( "intro_jeep_stuck_waiter" );
	
	// take away their weapons
	driver animscripts\shared::placeWeaponOn( driver.primaryweapon, "none");
	waiter animscripts\shared::placeWeaponOn( waiter.primaryweapon, "none");
	
	wait( 0.05 );
	
	// jeep stuff
	jeep = getent( "intro_jeep_stuck", "targetname" );

	driver.animname = "rail";
	waiter.animname = "rail";
	level thread anim_loop_solo( driver, "stuck_driver", undefined, "dont_end", jeep );
	level thread anim_loop_solo( waiter, "fire_d", undefined, "dont_end", undefined );
	
	level thread stuck_jeep_fx();
	level thread stuck_jeep_anim( jeep );
	///////////////
	
}



stuck_jeep_fx()
{

	orig_fx = getstruct( "orig_jeep_tread", "targetname" );

	orig_fx.looper = playLoopedFx( level._effect["stuck_jeep_tread"], 1, orig_fx.origin, 0, orig_fx.angles );
	
	wait( 25 );
	
	orig_fx.looper delete();

}



intro_jeep_stuck_spawners_strat()
{

	self.animname = "rail";
	
	// take away his weapon
	self animscripts\shared::placeWeaponOn( self.primaryweapon, "none");
	
	if( self.script_noteworthy == "jeep_stuck_left" )
	{
		stuck_anim = "stuck_pusher_left";	
	}
	else
	{
		stuck_anim = "stuck_pusher_right";
	}
	
	jeep = getent( "intro_jeep_stuck", "targetname" );

	level thread anim_loop_solo( self, stuck_anim, undefined, "never_end", jeep );
	
}



//////
///////////////////
//
// STARTS
//
///////////////////////////////
//////

start_street()
{

	enable_player_weapons();

	setup_level();

	simple_spawn( "friendly_squad_extras" );
	
	setup_friendlies();
	
	start_teleport_players( "orig_start_street" );

	maps\hol3_street::main();	
	
}

start_satchel()
{
	
	enable_player_weapons();
	
	setup_level();

	setup_friendlies();
	
	maps\hol3_street::hide_wall_chunks();
	
	start_trick_teleport_player();
	start_teleport_ai( "orig_start_satchel" );	
	start_teleport_players( "orig_start_satchel" );

	set_color_chain( "chain_satchel" );
	
	maps\hol3_street::satchel_charge();
	
}
// only for debug!
start_furniture()
{
	
	enable_player_weapons();
	
	setup_level();

	setup_friendlies();
	
	level.extra_pow = simple_spawn_single( "pow_extra", maps\hol3_defend::pow_misc_strat );
	level.maddock = simple_spawn_single( "pow_maddock", maps\hol3_defend::pow_maddock_strat );
	  
	// hax for teleport
	level.extra_pow.script_noteworthy = "friendly_squad_ai";
	
	start_trick_teleport_player();
	start_teleport_ai( "orig_start_furniture" );	
	start_teleport_players( "orig_start_defend" );

 	// undo hax after the teleport
  	level.extra_pow.script_noteworthy = "";

	maps\hol3_defend::furniture_clear_vignette();
	
}

start_defend()
{

	enable_player_weapons();

	setup_level();

	setup_friendlies();
	
	// POWs hax for the teleport
	level.extra_pow = simple_spawn_single( "pow_extra", maps\hol3_defend::pow_misc_strat );
	level.maddock = simple_spawn_single( "pow_maddock", maps\hol3_defend::pow_maddock_strat );
	level.maddock.name = "TEMP Maddock";
	level.heroes[2] = level.maddock;
	level.extra_pow thread replace_on_death();
	level.extra_pow set_force_color( "y" );
	level.maddock set_force_color( "g" );

	//spawn extra friendlies for color reinforcements
	yellow_guys = simple_spawn( "mansion_extras" );
	yellow_guys[0].script_noteworthy = "friendly_squad_ai";
	yellow_guys[1].script_noteworthy = "friendly_squad_ai";
	trig = getent( "trig_mansion_friendlies", "script_noteworthy" );
	trig notify( "trigger" );
	
  	// hax for teleport
  	level.extra_pow.script_noteworthy = "friendly_squad_ai";

	// sTUFF TO DELETE
	/////////////////////
	// delete spawn trig inside mansion
	getent( "door_mansion_kick", "targetname" ) delete();
	getent( "trig_inside_mansion", "script_noteworthy" ) delete();
	// delete furniture
	delete_noteworthy_ents( "mansion_furniture" );
	// delete front door
	door = getent( "door_furniture_kick", "targetname" );	
	door connectpaths();
	wait( 0.05 );
	door delete();
	trig = getent( "chain_mansion_3", "targetname" );
	trig delete();
	
	maps\hol3_defend::turn_off_yard_triggers();
	/////////////////////
		
	level thread maps\hol3_defend::advance_fail();
	level thread maps\hol3_defend::spawn_sdk();
	
	start_trick_teleport_player();
	start_teleport_ai( "orig_start_defend" );	
	start_teleport_players( "orig_start_defend" );

 	// undo hax after the teleport
  	level.extra_pow.script_noteworthy = "";
	yellow_guys[0].script_noteworthy = "mansion_extra_ai";
	yellow_guys[1].script_noteworthy = "mansion_extra_ai";

	maps\hol3_defend::mine_plant_in_yard();
	
}



start_yard()
{

	enable_player_weapons();

	setup_level();

	setup_friendlies();

	// remove blocker
	brush = getent( "defend_gate_1", "targetname" );
	brush connectpaths();
	brush delete();

	//spawn extra friendlies for color reinforcements
	yellow_guys = simple_spawn( "mansion_extras" );
	// hax for teleport
	yellow_guys[0].script_noteworthy = "friendly_squad_ai";
	yellow_guys[1].script_noteworthy = "friendly_squad_ai";

	// POWs hax for the teleport
	level.maddock = simple_spawn_single( "pow_maddock", maps\hol3_defend::pow_maddock_strat );
	level.maddock.name = "TEMP Maddock";
	level.maddock set_force_color( "g" );
	level.heroes[2] = level.maddock;
  	level.extra_pow = simple_spawn_single( "pow_extra", maps\hol3_defend::pow_misc_strat );
  	level.extra_pow.script_noteworthy = "friendly_squad_ai";
	level.extra_pow set_force_color( "y" );
	level.extra_pow stop_magic_bullet_shield();
	level.extra_pow thread replace_on_death();


	maps\hol3_defend::wasp_spawn_1();
	maps\hol3_defend::wasp_spawn_2();
	
	// hax (only used in start, so no biggie)
	vnode = getvehiclenode( "auto2796", "targetname" );
	level.wasp_1 attachpath( vnode );
	level.wasp_1 thread maps\_vehicle::vehicle_paths( vnode );
	
	vnode = getvehiclenode( "auto2790", "targetname" );
	level.wasp_2 attachpath( vnode );	
	level.wasp_2 thread maps\_vehicle::vehicle_paths( vnode );
	//////////////////
	
	
	start_trick_teleport_player();
	start_teleport_ai( "orig_start_defend" );	
	start_teleport_players( "orig_start_yard" );
	
 	// undo hax after the teleport
  	level.extra_pow.script_noteworthy = "";
	yellow_guys[0].script_noteworthy = "mansion_extra_ai";
	yellow_guys[1].script_noteworthy = "mansion_extra_ai";	
	
	maps\hol3_yard::main();
	
}



start_square()
{

	enable_player_weapons();

	setup_level();


	maps\hol3_defend::wasp_spawn_1();
	maps\hol3_defend::wasp_spawn_2();
	
	// hax (only used in start, so no biggie)
	vnode = getvehiclenode( "auto2956", "targetname" );
	level.wasp_1 attachpath( vnode );
	level.wasp_1 thread maps\_vehicle::vehicle_paths( vnode );
	
	vnode = getvehiclenode( "auto3001", "targetname" );
	level.wasp_2 attachpath( vnode );	
	level.wasp_2 thread maps\_vehicle::vehicle_paths( vnode );
	//////////////////

	level thread maps\hol3_end::wasp_1_square_strat();
	level thread maps\hol3_end::wasp_2_square_strat();

	start_trick_teleport_player();
	start_teleport_ai( "orig_start_square" );	
	start_teleport_players( "orig_start_square" );

	maps\hol3_end::main();
	
}



///////////////////
//
// Handles basic level initializing
//
///////////////////////////////

setup_level()
{
	
	setup_guzzo_hud();

	setexpfog( 8000, 10000, 0.71875, 0.742188, 0.742188, 5 );
	
	// street flags
	flag_init( "jeeps_all_unloaded" );
	flag_init( "rail_seat_taken_1" );
	flag_init( "rail_seat_taken_2" );
	flag_init( "rail_seat_taken_3" );
	flag_init( "rail_seat_taken_4" );
	flag_init( "grenade_throw_time" );
	flag_init( "grenade_throw_release" );
	flag_init( "mid_street" );
	flag_init( "blowup_main_fakefire" );
	flag_init( "near_town_axis_alert" );
	flag_init( "everyone_in_place" );
	flag_init( "grenade_throw_done" );
	flag_init( "near_barricade" );
	flag_init( "building_flank" );
	flag_init( "building_flank_damage" );
	flag_init( "mansion_secured" );
	flag_init( "pows_saved" );
	// defend flags
	flag_init( "mansion_door_kick" );
	flag_init( "furniture_clear_done" );
	flag_init( "mine_planting" );
	flag_init( "ai_mine_plant_1_done" );
	flag_init( "ai_mine_plant_2_done" );
	flag_init( "in_defensive_pos_early" );
	flag_init( "defend_1_done" );
	flag_init( "defend_2_done" );
	flag_init( "rush_the_house" );
	flag_init( "wasp_rescue" );
	flag_init( "mine_countdown_over" );
	flag_init( "retreat_house_open" );
	flag_init( "outside_retreat_house" );
	flag_init( "wasps_own_infantry" );
	flag_init( "sdk_retaliate" );
	flag_init( "flamed_sdk" );
	flag_init( "wasp_1_saved_day" );
	flag_init( "wasp_2_saved_day" );
	// yard flags	
	flag_init( "chain_backyard_1" );
	flag_init( "chain_backyard_2" );
	flag_init( "yard_mghouse_active" );
	flag_init( "house_4_flamed" );
	flag_init( "house_7_burned" );
	
	flag_init( "wasp_2_house_1" );
	flag_init( "wasp_2_house_3" );
	flag_init( "wasp_2_house_6" );
	flag_init( "wasp_2_house_10" );
	flag_init( "wasp_2_house_11" );
	
	flag_init( "wasp_1_house_2" );
	flag_init( "wasp_1_house_4" );
	flag_init( "wasp_1_house_5" );
	flag_init( "wasp_1_house_6" );
	flag_init( "wasp_1_house_8" );
	// square
	flag_init( "wasps_move_into_square" );
	flag_init( "wasps_flame_fountain" );
	flag_init( "wasp_counterattack" );
	flag_init( "wasp_2_dead" );
	flag_init( "sdk_1_dead" );
	flag_init( "sdk_2_dead" );
	
	
	level.barricade_mg_l_occupied = 0;
	level.barricade_mg_r_occupied = 0;

	level.defend_axis_killed = 0;

	// threatbias group setups
	createthreatbiasgroup( "heroes" );
	createthreatbiasgroup( "street_mg_guys" );
	createthreatbiasgroup( "intro_redshirt_ai" );	
	createthreatbiasgroup( "mid_street_reinforcers" );
	createthreatbiasgroup( "main_street_friendlies" );
	createthreatbiasgroup( "mainstreet_car_spawners" );
	
	// setup objectives
	level thread setup_objectives();
	
	// do objective skip if using a start
	if( GetDvar( "start" ) != "" )
	{
		setup_objectives_skip();
	}
	
	maps\hol3_defend::turn_off_yard_triggers();

	/#
	level thread debug_ai();
	level thread draw_goal_radius();
	level debug_ai_health();
	#/	
	
}



///////////////////
//
// Sets up objectives
//
///////////////////////////////

setup_objectives()
{
	
	// if not using a start, need to wait till player is out of jeep to give first objective
	if( GetDvar( "start" ) == "" )
	{
		flag_wait( "jeeps_all_unloaded" );
	}

	obj_num = 1;
	
	objective_add( obj_num, "active", &"HOL3_SNEAK_TO_TOWN", ( -168, -136, -56.4 ) ); 
	objective_current ( obj_num ); 
	
	level waittill( "obj_assault_complete" );
	
	objective_state ( obj_num, "done" );
	obj_num++;



	objective_add( obj_num, "active", &"HOL3_BLOW_HOLE_IN_MANSION", ( 211, 4513, 239 ) ); 
	objective_current ( obj_num ); 
	
	level waittill( "obj_satchel_complete" );
	
	objective_state ( obj_num, "done" );
	obj_num++;



	objective_add( obj_num, "active", &"HOL3_SAVE_POWS", ( -71, 5466, -25 ) ); 
	objective_current ( obj_num ); 
	
	level waittill( "obj_pows_complete" );
	
	objective_state ( obj_num, "done" );
	obj_num++;



	objective_add( obj_num, "active", &"HOL3_CLEAR_THE_MANSION", ( 100, 5342, 109 ) ); 
	objective_current ( obj_num ); 
	
	level waittill( "obj_clear_mansion_complete" );
	
	objective_state ( obj_num, "done" );
	obj_num++;


	objective_add( obj_num, "active", &"HOL3_REGROUP", (204, 5420, 103.5) ); 
	objective_current ( obj_num ); 
	
	level waittill( "obj_plant_betties" );
	
	objective_state ( obj_num, "done" );
	obj_num++;



	objective_add( obj_num, "active", &"HOL3_DEFENSIVE_POS", ( 100, 5342, 109 ) ); 
	objective_current ( obj_num ); 
	
	level waittill( "obj_defensive_pos" );
	
	objective_state ( obj_num, "done" );
	obj_num++;



	objective_add( obj_num, "active", &"HOL3_DEFEND_THE_MANSION", ( 100, 5342, 109 ) ); 
	objective_current ( obj_num ); 
	
	level waittill( "obj_defend_complete" );
	
	objective_state ( obj_num, "done" );
	obj_num++;



	objective_add( obj_num, "active", &"HOL3_MAKE_WAY_TOWARDS_TOWN", ( 4546, 6129, 240 ) ); 
	objective_current ( obj_num ); 
	
	level waittill( "obj_yard_complete" );
	
	objective_state ( obj_num, "done" );	
	obj_num++;



	objective_add( obj_num, "active", &"HOL3_ASSAULT_TOWN_SQUARE", ( 5192, 4859.9, 287.7 ) ); 
	objective_current ( obj_num ); 
	
	level waittill( "obj_town_assault_complete" );
	
	objective_state ( obj_num, "done" );	
	obj_num++;
	
	
	
//	objective_add( obj_num, "active", &"HOL3_HOLD_TOWN_SQUARE", ( 4546, 6129, 240 ) ); 
//	objective_current ( obj_num ); 
//	
//	level waittill( "obj_town_hold_complete" );
//	
//	objective_state ( obj_num, "done" );	
//	obj_num++;	
	
}



///////////////////
//
// Sets up objectives when used with starts
//
///////////////////////////////

setup_objectives_skip()
{
	
	//wait ( 0.01 );
	
	obj_complete = 0;
	
	start_string = GetDvar( "start" );
	
	// determine how far to skip
	switch( start_string )
	{

		case "satchel":
			
			obj_complete = 1;
			break;	
				
		case "defend":
			
			obj_complete = 4;
			break;
			
		case "yard":
		
			obj_complete = 7;
			break;

		case "square":
		
			obj_complete = 9;
			break;
			
		default:
			return;
					
	}	
	
	obj_index = 1;
	
	
	// actually send out notifies that the setup_objectives() thread will receive so it can skip objectives
	while( obj_index <= obj_complete )
	{

		if( obj_index == 1 )
		{
			level notify( "obj_assault_complete" );
		}
		else if( obj_index == 2 )
		{
			level notify( "obj_satchel_complete" );
		}		
		else if( obj_index == 3 )
		{
			level notify( "obj_pows_complete" );
		}					
		else if( obj_index == 4 )
		{
			level notify( "obj_clear_mansion_complete" );
		}
		else if( obj_index == 5 )
		{
			level notify( "obj_plant_betties" );
		}
		else if( obj_index == 6 )
		{
			level notify( "obj_defensive_pos" );
		}				
		else if( obj_index == 7 )
		{
			level notify( "obj_defend_complete" );
		}						
		else if( obj_index == 8 )
		{
			level notify( "obj_yard_complete" );
		}	
		
		obj_index++;
		maps\_spawner::waitframe(); 
		
	}
	
	
}



///////////////////
//
//  Sets up general friendly squad settings 
//
///////////////////////////////

setup_friendlies()
{

	level.heroes = [];
	
	// POLISH fix these up
	level.goddard = get_specific_single_ai( "goddard" );
	level.goddard.name = "TEMP goddard";
	
	level.extra_hero = get_specific_single_ai( "extra_hero" );
	level.extra_hero.name = "TEMP extra";

	level.heroes[0] = level.goddard;
	level.heroes[1] = level.extra_hero;
	
	array_thread( level.heroes, ::friendly_setup_thread );

}



///////////////////
//
// Sets up specific friendly squad settings 
//
///////////////////////////////

friendly_setup_thread()
{

	self thread magic_bullet_shield();
	self.goalradius = 400;
	self.old_grenadeammo = self.grenadeammo;
	self.grenadeammo = 0;
	self setthreatbiasgroup( "heroes" );
	self.script_noteworthy = "friendly_squad_ai";
	self.targetname = "friendly_squad";
	
}



// handles coop players connecting/disconnecting as well as spawned/killed.
init_callbacks()
{
	level thread onFirstPlayerConnect();
	level thread onPlayerConnect();
	level thread onPlayerDisconnect();
	level thread onPlayerSpawned();
	level thread onPlayerKilled();
}



enable_player_weapons()
{
	flag_set( "enable_weapons" );
		
	players = get_players();
	
	for ( i = 0; i < players.size; i++ )
	{
		players[i] enableweapons();
	}
}



#using_animtree ("hol3_stuck_jeep");
stuck_jeep_anim( jeep )
{

	// TODO make sure this stops it
	level endon( "jeeps_all_unloaded" );

	jeep UseAnimTree(#animtree);

	while( 1 )
	{
		jeep animscripted( "jeep_stuck_done", jeep.origin, jeep.angles, %v_willys_holland3_jeep_stuck );
		jeep waittill( "jeep_stuck_done" );
	}
	
}



/// TEMPPPPPP!!!!!!!!
hol3_temp_kill_axis()
{
	/#
	level endon( "stop_hol3_temp_kill_axis" );
	
	while( 1 )
	{
	
		ai = getaiarray( "axis" );
		
		for( i  = 0; i < ai.size; i++ )
		{
			ai[i] dodamage( 70, (0,0,0) );
		}
		
		wait( 2 );
		
	}
	#/
}


