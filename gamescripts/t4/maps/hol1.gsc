#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\hol1_util;	
#include maps\hol1_rail;
#include maps\hol1_stealth;					
#include maps\_stealth_logic;	



#using_animtree( "generic_human" );


////////////////////////// Holland 1 //////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

main()
{
	// setup skiptos
	// to run, try: +set start charge
	add_start( "event1", ::start_event1 );		// rail intro through German checkpoint
	add_start( "event2", ::start_event2 );		// rail escape
	add_start( "event2b", ::start_event2b );	
	add_start( "event2c", ::start_event2c );
	add_start( "event2d", ::start_event2d );
	add_start( "event2e", ::start_event2e );
	add_start( "event3", ::start_event3 );		
	add_start( "event4", ::start_event4 );
	add_start( "event5", ::start_event5 );
	default_start( ::opening );

	// player detection
	level thread onPlayerConnect();
	level thread onFirstPlayerConnect();
	
	// setup vehicles
	maps\_jeep::main( "vehicle_ger_wheeled_horch1a_backseat", "jeep" );
	maps\_truck::main( "vehicle_ger_wheeled_opel_blitz_winter", "opel" );
	maps\_panther::main( "vehicle_ger_tracked_panther", "panther" );	

	// other setups
	level.maxfriendlies = 4;
	level.ev2_rail_start_section = "a";		// used to identify which portion of rail to start with

	level.rail_sequence = false;	// true if rail section is being played
	level.rail_seat_taken_1 = false;
	level.rail_seat_taken_2 = false;
	level.rail_seat_taken_3 = false;
	level.rail_seat_taken_4 = false;

	// load anything that needs loaded
	precache_items();

	// init functions
	maps\hol1_fx::main();	// must be before _load::main
	maps\_load::main();		// must be before the other stuff here
	maps\hol1_anim::main();
	maps\hol1_amb::main();
	maps\hol1_status::main();

	stealth_init(); 					  
  	maps\_stealth_behavior::main();

	// misc
	set_environment ("cold");	

	level.goddard = getent( "goddard", "targetname" );
	level.friend1 = getent( "friend1", "targetname" );
	level.friend2 = getent( "friend2", "targetname" );
}


precache_items()
{
	// just objectives for now
	level.obj1_string = &"HOL1_OBJECTIVE_0"; 	// Pose as Germans to sneak pass the checkpoint
	level.obj2_string = &"HOL1_OBJECTIVE_1"; 	// Escape
	level.obj3_string = &"HOL1_OBJECTIVE_2";	// Locate document
	level.obj4A_string = &"HOL1_OBJECTIVE_3A";	// Snipers 1
	level.obj4B_string = &"HOL1_OBJECTIVE_3B";	// Snipers 2
	level.obj5A_string = &"HOL1_OBJECTIVE_4A";	// Explosives 1
	level.obj5B_string = &"HOL1_OBJECTIVE_4B";	// Explosives 2
	level.obj5C_string = &"HOL1_OBJECTIVE_4C";	// Explosives 3
	level.obj6_string = &"HOL1_OBJECTIVE_5";	// Regroup
	level.obj7_string = &"HOL1_OBJECTIVE_6";	// Get document
	level.obj8_string = &"HOL1_OBJECTIVE_7";	// Get on truck
}



/////////////////////// Start functions ////////////////////////
////////////////////////////////////////////////////////////////

start_event1()
{

}


start_event2()
{
	level.rail_sequence = true;

	// delete this trigger (player starts inside, and we don't want it triggered)
	trigger = getent( "ev1_move_truck_trigger", "targetname" );
	trigger delete();

	rail_standard_vehicle_setup( "ev1_end_jeep1", "ev1_end_jeep2" );

	wait( 4 );

	level.jeep1 startpath();
	level.jeep2 startpath();
	level.jeep1 setspeed( 0, 999, 999 );
	level.jeep2 setspeed( 0, 999, 999 );

	level.ev2_rail_start_section = "a";

	level thread event2();
}

start_event2b()
{
	level.rail_sequence = true;

	rail_standard_vehicle_setup( "ev2_lake_stop1", "ev2_lake_stop2" );

	wait( 5 );

	level.jeep1 startpath();
	level.jeep2 startpath();
	level.jeep1 setspeed( 0, 999, 999 );
	level.jeep2 setspeed( 0, 999, 999 );

	level.ev2_rail_start_section = "b";

	level thread event2();
}

start_event2c()
{
	level.rail_sequence = true;

	rail_standard_vehicle_setup( "ev2_convoy_ends_1", "ev2_convoy_ends_2" );

	wait( 5 );

	level.jeep1 startpath();
	level.jeep2 startpath();
	level.jeep1 setspeed( 0, 999, 999 );
	level.jeep2 setspeed( 0, 999, 999 );

	level.ev2_rail_start_section = "c";

	level thread event2();
}

start_event2d()
{
	level.rail_sequence = true;

	rail_standard_vehicle_setup( "ev2_forest_end_1", "ev2_forest_end_2" );

	wait( 10 );

	level.jeep1 startpath();
	level.jeep2 startpath();
	level.jeep1 setspeed( 0, 999, 999 );
	level.jeep2 setspeed( 0, 999, 999 );

	level.ev2_rail_start_section = "d";

	level thread event2();
}

start_event2e()
{
	level.rail_sequence = true;

	rail_standard_vehicle_setup( "ev2_lake_enter1", "ev2_lake_enter2" );

	wait( 4 );

	level.jeep1 startpath();
	level.jeep2 startpath();
	level.jeep1 setspeed( 0, 999, 999 );
	level.jeep2 setspeed( 0, 999, 999 );


	level.ev2_rail_start_section = "e";

	level thread event2();
}

start_event3()
{
	level.rail_sequence = false;

	//friendlies_force_teleport( "event3" );
	teleport_players( "event3_start" );

	level thread event3();
}

start_event4()
{
}

start_event5()
{
}


/////////////////////// Opening functions //////////////////////
////////////////////////////////////////////////////////////////

// TODO: Any opening IGC scripting
// This is separated from Event 1 so I can debug without keep watching the IGCs
opening()
{

	//level waittill ("introscreen_complete");

	// IGC
	level.rail_sequence = true;

	level thread event1();
}


/////////////////////// Event1 functions ///////////////////////
////////////////////////////////////////////////////////////////



// Event 1: Rail Sequence. Ends just after escaping from checkpoint
event1()
{
	// typical event threads
	maps\_status::show_task( "Event1" );
	level thread maps\hol1_amb::event1();
	level thread event1_objectives();

	level.rail_sequence = true;

	//////////////////////////// MISC SETUPS /////////////////////////////////

	// spawn functions on the camp enemies, so they animate correctly once spawned
	ev1_spawners_init();
	
	// prepare the jeeps
	rail_standard_vehicle_setup( "ev1_jeep1_start", "ev1_jeep2_start" );

	// initialize the nodes along the rail. Once hit, these nodes will send specific notifies to the AIs
	// NOTE: Since each reaction node will run a thread, we will limit this function with a starting and ending node
	//       so it can be used for pieces of the rail
	jeep1_start = getvehiclenode( "ev1_jeep1_start", "script_noteworthy" );
	jeep2_start = getvehiclenode( "ev1_jeep2_start", "script_noteworthy" );
	jeep1_end = getvehiclenode( "ev1_end_jeep1", "script_noteworthy" );
	jeep2_end = getvehiclenode( "ev1_end_jeep2", "script_noteworthy" );
	level.jeep1 thread ev1_rail_reactions_init( jeep1_start, jeep1_end );
	level.jeep2 thread ev1_rail_reactions_init( jeep2_start, jeep2_end );

	//level.maddock animscripts\shared::placeWeaponOn( level.maddock.primaryweapon, "none");
	level.maddock.ignorall = 1;
	level.maddock.pacifist = 1;

	// misc other setups

	// play headlight effect at specific places
	level thread maps\hol1_fx::attach_headlights_to_struct( "ev1_fake_headlights" );

	// a truck is at the checkpoint. It moves after the player gets there
	level thread ev1_spawn_checkpoint_truck();

	// a few trucks drive by in the background at the checkpoint
	level thread ev1_spawn_checkpoint_trucks_ambient();

	// get rid of players' weapons
	get_players()[0] disableWeapons();

	// temp text on the screen
	level thread ev1_temp_text();

	level thread ev1_cleanup();



	//////////////////////////// MAIN EVENT //////////////////////////////////////

	// start the rail
	level.jeep1 startpath();
	level.jeep2 startpath();

	
	// Stop at the checkpoint. A truck is in the way, so the crew waits
	// is notify is sent by the vehivle when a node is reached
	level waittill( "stop_at_checkpoint" );
	
		// TODO: Play anim of guard checking paper of a truck
		wait( 3 );

	level notify( "gate_opens" );
	//iprintlnbold( "Gate opens" );
	wait( 2 ); // wait for the gate to fully open
	
	level notify( "move_opel" ); // the truck in front of the player should move
	wait( 2 );

		// TODO: Play anim of guard waving at player
	level notify( "gate_closes" );
	//iprintlnbold( "Gate closes" );

	level notify( "move_forward" ); // player's cars move forward

	level waittill( "stop_at_checkpoint2" );	// player's car reached stop point
	wait( 1 );

	level thread maps\hol1_anim::maddock_capture_anims( level.maddock );	// special thing for maddock

	level waittill( "maddock_captured" );
	wait( 1 );
	level notify( "checkpoint_break_through" );
	
	get_players()[0] enableWeapons();

	trigger1 = getent( "ev1_sccessful_escape", "targetname" );
	trigger1 waittill( "trigger" );
	
	// do something about the maddock moving

	trigger2 = getent( "ev1_oversees_camp", "targetname" );
	trigger2 waittill( "trigger" );
	level notify( "oversees_camp" );
	
	level thread ev1_enemies_run_chasing();

	level waittill( "stop_jeep_at_overlook" );

	wait( 1 );
	level.jeep1 notify( "stop_reactions" );
	level.jeep2 notify( "stop_reactions" );

	// end of event 1
	level notify( "event1_ends" );
	wait( 0.05 );

	level thread event2();
}


event1_objectives()
{
	// snwak through checkpoint
	level waittill( "see_checkpoint" );
	objective_add( 1, "current", level.obj1_string, ( 2368, -912, 60.3 ) );

	// escape
	level waittill( "checkpoint_break_through" );
	objective_state( 1, "done" );
	objective_add( 2, "current", level.obj2_string );
}

event1_objectives_finish()
{
	objective_add( 1, "done", level.obj1_string );
	objective_add( 2, "current", level.obj2_string );
}

ev1_spawners_init()
{
	// enemies from train (some run and die, while others fight normally)
	maps\hol1_anim::ev1_spawners_anims_init();
}

ev1_cleanup()
{
	trigger = getent( "ev1_cleanup", "targetname" );
	trigger waittill( "trigger" );

	// all enemies run to chase the player
	enemies = getaiarray( "axis" );

	for( i = 0; i < enemies.size; i++ )
	{
		if( isalive( enemies[i] ) )
		{
			enemies[i] dodamage( enemies[i].health + 100, ( 0, 0, 0 ) );
		}
	}

}

ev1_temp_text()
{
	level waittill ("introscreen_complete");

	wait( 1 );

	iprintlnbold( "Goddard: You think these German Uniforms will fool them?" );
	wait( 3 );
	iprintlnbold( "AI: Don't worry. Our Sgt found fake papers." );
	wait( 3 );
	iprintlnbold( "AI: The Germans will think we have some captured prisoners." );
	wait( 4 );
	iprintlnbold( "Maddock: Be quiet. We are still behind enemy lines." );
	wait( 15 );

	level notify( "see_checkpoint" );

	iprintlnbold( "Maddock: A checkpoint. Stay quiet and let me handle it." );

	level waittill( "stop_at_checkpoint2" );
	iprintlnbold( "Maddock presents paper to guard" );

	level waittill ("maddock_out");
	iprintlnbold( "Fake paper identified by guard" );
	wait( 2 );

	iprintlnbold( "Maddock: Our cover is blown! RUN! Get out of here!" );
	level notify("sound_alarm");
	
	level waittill( "stop_jeep_at_overlook" );
	iprintlnbold( "Goddard: There's our Sgt. He's still alive!" );
	wait( 2 );

	iprintlnbold( "AI: We'll have to rescue him later. Let's get out of here." );

}

ev1_spawn_checkpoint_truck()
{
	trigger = getent( "ev1_spawn_checkpoint", "targetname" );
	start_node = getvehiclenode( "checkpoint_truck", "script_noteworthy" );
	
	opel = spawnvehicle( 	"vehicle_ger_wheeled_opel_blitz_winter", 
							"truck", 
							"opel", 
							start_node.origin, 
							start_node.angles );
			
	opel attachPath( start_node );

	wait( 2 );
	playfxontag( level._effect["headlight"], opel, "tag_headlight_left" );
	playfxontag( level._effect["headlight"], opel, "tag_headlight_right" );
	//playfxontag( level._effect["brakelight"], opel, "tag_brakelight_left" );

	level waittill( "move_opel" );

	opel startpath();

	level thread ev1_truck_delete_at_end( opel );
}

ev1_spawn_checkpoint_trucks_ambient()
{
	level waittill( "stop_at_checkpoint" );

	wait( 2 );

	start_nodes = [];
	start_nodes[0] = getvehiclenode( "checkpoint_truck_1", "script_noteworthy" );
	start_nodes[1] = getvehiclenode( "checkpoint_truck_2", "script_noteworthy" );
	start_nodes[2] = getvehiclenode( "checkpoint_truck_3", "script_noteworthy" );
		
	for( i = 0; i < start_nodes.size; i++ )
	{
		opel = spawnvehicle( 	"vehicle_ger_wheeled_opel_blitz_winter", 
								"truck", 
								"opel", 
								start_nodes[i].origin, 
								start_nodes[i].angles );

		opel attachPath( start_nodes[i] );

		level thread put_fx_on_truck_wait( opel );
			
		opel startpath();

		level thread ev1_truck_delete_at_end( opel );
	}
}

put_fx_on_truck_wait( opel )
{
	wait( 0.5 );
	playfxontag( level._effect["headlight"], opel, "tag_headlight_left" );
	playfxontag( level._effect["headlight"], opel, "tag_headlight_right" );		
	//playfxontag( level._effect["brakelight"], opel, "tag_brakelight_left" );
}

ev1_truck_delete_at_end( truck )
{
	end_node = getvehiclenode( "checkpoint_truck_delete", "script_noteworthy" );
	truck setwaitnode( end_node );
	truck waittill( "reached_wait_node" );
	truck delete();
}


ev1_enemies_run_chasing()
{
	// all enemies run to chase the player
	enemies = getaiarray( "axis" );
	goal_node = getnode( "ev1_goal", "targetname" );

	for( i = 0; i < enemies.size; i++ )
	{
		if( isalive( enemies[i] ) && i <= 10)
		{
			enemies[i].goalradius = 4;
			enemies[i] setgoalpos( goal_node.origin );
		}
	}
	wait( 0.5 );
	trucks = getentarray( "ev1_truck", "targetname" );
	for( i = 0; i < trucks.size; i++ )
	{
		playfxontag( level._effect["headlight"], trucks[i], "tag_headlight_left" );
		playfxontag( level._effect["headlight"], trucks[i], "tag_headlight_right" );
		//playfxontag( level._effect["brakelight"], trucks[i], "tag_brakelight_left" );

		level thread ev1_truck_delete_at_end( trucks[i] );
	}
}









/////////////////////// Event2 functions ///////////////////////
////////////////////////////////////////////////////////////////

event2()
{	
	//iprintlnbold( "EVENT2" );
	maps\_status::show_task( "Event2" );
	level thread maps\hol1_amb::event2();
	level thread event2_objectives();
	level thread ev2_spawners_init();
	level thread ev2_cleanup();


	if( level.ev2_rail_start_section == "a" )
	{
		jeep1_start = getvehiclenode( "ev1_end_jeep1", "script_noteworthy" );
		jeep2_start = getvehiclenode( "ev1_end_jeep2", "script_noteworthy" );
		jeep1_end = getvehiclenode( "ev2_lake_stop1", "script_noteworthy" );
		jeep2_end = getvehiclenode( "ev2_lake_stop2", "script_noteworthy" );
		level.jeep1 thread ev2_rail_reactions_init_a( jeep1_start, jeep1_end );
		level.jeep2 thread ev2_rail_reactions_init_a( jeep2_start, jeep2_end );
	
		// jeep 2 backs a bit, then go forward, ahead of jeep 1
		level.jeep2 setspeed( 15, 7, 7 );
		level waittill( "jeep2_starts" );
		level.jeep1 setspeed( 20, 7, 7 );

		maps\hol1_amb::set_fog_culling( 0, 600, 0, 3000 );

		level waittill( "rail_section_a_ends" );
		level.jeep1 notify( "stop_reactions" );
		level.jeep2 notify( "stop_reactions" );
		wait( 0.05 );

		level.ev2_rail_start_section = "b";
	}

	if( level.ev2_rail_start_section == "b" )
	{
		jeep1_start = getvehiclenode( "ev2_lake_stop1", "script_noteworthy" );
		jeep2_start = getvehiclenode( "ev2_lake_stop2", "script_noteworthy" );
		jeep1_end = getvehiclenode( "ev2_convoy_ends_1", "script_noteworthy" );
		jeep2_end = getvehiclenode( "ev2_convoy_ends_2", "script_noteworthy" );
		level.jeep1 thread ev2_rail_reactions_init_b( jeep1_start, jeep1_end );
		level.jeep2 thread ev2_rail_reactions_init_b( jeep2_start, jeep2_end );
	
		maps\hol1_amb::set_fog_culling( 0, 200, 300, 2000 );

		wait( 3 );

		level.jeep1 setspeed( 20, 7, 7 );
		level.jeep2 setspeed( 20, 7, 7 );

		level thread maps\hol1_anim::ev2_truck_crash_anim();


		level waittill( "rail_section_b_ends" );
		level.jeep1 notify( "stop_reactions" );
		level.jeep2 notify( "stop_reactions" );
		wait( 0.05 );
		
		level.ev2_rail_start_section = "c";
	}

	if( level.ev2_rail_start_section == "c")
	{
		jeep1_start = getvehiclenode( "ev2_convoy_ends_1", "script_noteworthy" );
		jeep2_start = getvehiclenode( "ev2_convoy_ends_2", "script_noteworthy" );
		jeep1_end = getvehiclenode( "ev2_forest_end_1", "script_noteworthy" );
		jeep2_end = getvehiclenode( "ev2_forest_end_2", "script_noteworthy" );
		level.jeep1 thread ev2_rail_reactions_init_c( jeep1_start, jeep1_end );
		level.jeep2 thread ev2_rail_reactions_init_c( jeep2_start, jeep2_end );
	
		level.jeep2 setspeed( 25, 99, 99 );
		wait( 1 );	
		level.jeep1 setspeed( 30, 99, 99 );

		wait( 1 );
		maps\hol1_amb::set_fog_culling( 0, 200, 370, 2000 );

		level waittill( "raise fog" );
		maps\hol1_amb::set_fog_culling( 0, 400, 25, 3000 );

		level waittill( "rail_section_c_ends" );
		level.jeep1 notify( "stop_reactions" );
		level.jeep2 notify( "stop_reactions" );
		wait( 0.05 );
	
		level.ev2_rail_start_section = "d";
	}

	if( level.ev2_rail_start_section == "d")
	{
		jeep1_start = getvehiclenode( "ev2_forest_end_1", "script_noteworthy" );
		jeep2_start = getvehiclenode( "ev2_forest_end_2", "script_noteworthy" );
		jeep1_end = getvehiclenode( "ev2_lake_enter1", "script_noteworthy" );
		jeep2_end = getvehiclenode( "ev2_lake_enter2", "script_noteworthy" );
		level.jeep1 thread ev2_rail_reactions_init_d( jeep1_start, jeep1_end );
		level.jeep2 thread ev2_rail_reactions_init_d( jeep2_start, jeep2_end );
	

		trigger = getent( "ev2_tank_guard_trigger", "targetname" );
		trigger notify( "trigger" );

		maps\hol1_amb::set_fog_culling( 0, 500, 25, 3000 );

		// tells jeep 1 to check out the cabin
		wait( 1 );
		iprintlnbold( "Go clear the cabin. We'll hold them here" );
		wait( 1 );
		level.jeep1 setspeed( 15, 10, 10 );

		level waittill( "ready_to_spawn_panther" );
		level thread ev2_panther();
		wait( 2 );
		iprintlnbold( "Panther ahead" );

		wait( 4 );
		level.jeep2 setspeed( 15, 15, 15 );
		iprintlnbold( "Back up! Back up!" );


		level waittill( "rail_section_d_ends" );
		level.jeep1 notify( "stop_reactions" );
		level.jeep2 notify( "stop_reactions" );
		wait( 0.05 );
			
		level.ev2_rail_start_section = "e";
	}
	
	if( level.ev2_rail_start_section == "e")
	{
		jeep1_start = getvehiclenode( "ev2_lake_enter1", "script_noteworthy" );
		jeep2_start = getvehiclenode( "ev2_lake_enter2", "script_noteworthy" );
		jeep1_end = getvehiclenode( "ev2_stop_rail_1", "script_noteworthy" );
		jeep2_end = getvehiclenode( "ev2_stop_rail_2", "script_noteworthy" );
		level.jeep1 thread ev2_rail_reactions_init_e( jeep1_start, jeep1_end );
		level.jeep2 thread ev2_rail_reactions_init_e( jeep2_start, jeep2_end );
	
		level.jeep1 resumespeed( 10 );	
		level.jeep2 resumespeed( 10 );	

		level waittill( "rail_section_e_ends" );
		level.jeep1 notify( "stop_reactions" );
		level.jeep2 notify( "stop_reactions" );
	}
	
	wait( 3 );
	// dismount


	//level.goddard thread move_to_struct_pos( "ev2_goddard_off" );
	//level.friend1 thread move_to_struct_pos( "ev2_friend1_off" );
	//level.friend2 thread move_to_struct_pos( "ev2_friend2_off" );

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( players[i].current_seat == 1 )
		{
			players[i] thread move_to_struct_pos( "ev2_player1_off" );
		}
		else if( players[i].current_seat == 2 )
		{
			players[i] thread move_to_struct_pos( "ev2_player2_off" );
		}
		else if( players[i].current_seat == 3 )
		{
			players[i] thread move_to_struct_pos( "ev2_player3_off" );
		}
		else if( players[i].current_seat == 4 )
		{
			players[i] thread move_to_struct_pos( "ev2_player4_off" );
		}
	}

	level.rail_sequence = false;
	level notify( "end_rail" );

	teleport_players( "event3_start" );

	//iprintlnbold( "Event 3 starts" );
	level thread event3();
}



event2_objectives()
{ 

}

ev2_spawners_init()
{
	// enemies from train (some run and die, while others fight normally)
	maps\hol1_anim::ev2_spawners_anims_init();
}

ev2_panther()
{
	start_node = getvehiclenode( "ev2_panther_start", "script_noteworthy" );

	tank = spawnvehicle( 	"vehicle_ger_tracked_panther", 
							"panther", 
							"panther", 
							start_node.origin, 
							start_node.angles );

	tank attachPath( start_node );
	tank.health = 10000000;

	wait( 0.5 );
	playfxontag( level._effect["headlight"], tank, "tag_headlight_left" );
			
	tank startpath();

	node = getvehiclenode( "splash_entry", "script_noteworthy" );
	maps\hol1_rail::wait_till_reach_vehicle_node( node, tank );

	pos = getstruct( "splash_entry_pos", "targetname" );
	playfx( level._effect["snow_splash_large"], pos.origin );
	playfx( level._effect["snow_tree_falling"], pos.origin + (0,0,80) );

	node = getvehiclenode( "fire_at_player_1", "script_noteworthy" );
	maps\hol1_rail::wait_till_reach_vehicle_node( node, tank );

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] EnableInvulnerability();
	}


	level thread ev2_panther_fire_at_jeep2( tank );

	node = getvehiclenode( "fire_at_player_2", "script_noteworthy" );
	maps\hol1_rail::wait_till_reach_vehicle_node( node, tank );

	level thread ev2_panther_fire_at_jeep2( tank );

	node = getvehiclenode( "tank_at_edge", "script_noteworthy" );
	maps\hol1_rail::wait_till_reach_vehicle_node( node, tank );
	level notify( "tank_at_edge" );

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] DisableInvulnerability();
	}
}

ev2_panther_fire_at_jeep2( tank )
{
	target_ent = spawn( "script_origin", level.jeep2.origin );

	tank setturrettargetent( target_ent );
	tank waittill( "turret_on_target" );
	tank fireWeapon();
	//iprintlnbold( "fire" );
	target_ent delete();
	tank setturrettargetent( level.jeep2 );
}

ev2_cleanup()
{
	trigger = getent( "ev2_cleanup", "targetname" );
	trigger waittill( "trigger" );

	// all enemies run to chase the player
	enemies = getaiarray( "axis" );

	for( i = 0; i < enemies.size; i++ )
	{
		if( isalive( enemies[i] ) )
		{
			enemies[i] dodamage( enemies[i].health + 100, ( 0, 0, 0 ) );
		}
	}

	trucks = getentarray( "opel", "targetname" );
	for( i = 0; i < trucks.size; i++ )
	{
		trucks[i] notify( "death" );
	}

	//iprintlnbold( "clean up" );
}


////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

event3()
{
	level thread event3_objectives();

	custom_stealth_detection_range_setup( 5, 256, 50, 512, 128, 1024, false );

	// temp: remove this once friendlies dismount correctly
	level thread event3_temp_replace_friendlies();

	level thread event3_section_1();
	level waittill( "event3_section_1_complete" );

	level thread event3_execution();
	level waittill( "event3_section_2_complete" );

	custom_stealth_detection_range_setup( 5, 50, 50, 512, 128, 1024, true );

	level.goddard thread avoid_combat();
	level.friend1 thread avoid_combat();
	level.friend2 thread avoid_combat();

	level thread custom_stealth_react_to_gun_fire( "ev3_area_1" );
	level thread custom_stealth_react_to_gun_fire( "ev3_area_2" );

	level thread reinforcements_monitor( "ev3_reinforcement_trigger", "ev3_area_1" ); 
	level thread reinforcements_monitor( "ev3_reinforcement_trigger_2", "ev3_area_2" ); 

	enemies1 = getentarray( "ev3_enemies_area1", "targetname" );	
	array_thread( enemies1, ::add_spawn_function, ::ev3_spawners_1_custom_init );

	enemies2 = getentarray( "ev3_enemies_area2", "targetname" );	
	array_thread( enemies2, ::add_spawn_function, ::ev3_spawners_2_custom_init );

	event3_ambient_anims();


	level thread event3_stealth_run();
	level thread event3_stealth_attack();


	level waittill( "event3_done" );
	level thread event4();
}

event3_temp_replace_friendlies()
{	
	if( isdefined( level.goddard ) )
	{	
		level.goddard thread stop_magic_bullet_shield();
	}
	if( isdefined( level.maddock ) )
	{	
		level.maddock thread stop_magic_bullet_shield();
	}
	if( isdefined( level.friend1 ) )
	{	
		level.friend1 thread stop_magic_bullet_shield();
	}
	if( isdefined( level.friend2 ) )
	{	
		level.friend2 thread stop_magic_bullet_shield();
	}

	new_friends = getentarray( "ev3_temp_friendlies", "targetname" );	
	array_thread( new_friends, ::add_spawn_function, ::ev3_temp_friends_init );
}

ev3_temp_friends_init()
{
	wait( 1 );
	if( self.script_noteworthy == "temp1" )
	{
		level.goddard = self;
		level notify( "goddard_re_spawned" );
		//iprintlnbold( "Goddard In" );
	}
	else if( self.script_noteworthy == "temp2" )
	{
		level.friend1 = self;
		level notify( "friend1_re_spawned" );
		//iprintlnbold( "Guy 1 In" );
	}
	else if( self.script_noteworthy == "temp3" )
	{
		level.friend2 = self;
		level notify( "friend2_re_spawned" );
		//iprintlnbold( "Guy 2 In" );
	}

	self thread magic_bullet_shield();
	self avoid_combat();
}

event3_stealth_run()
{
	level endon( "break_stealth" );

	dont_attack_trigger = getent( "ev3_friends_dont_attack", "targetname" );
	dont_attack_trigger waittill( "trigger" );

	level.goddard avoid_combat();
	level.friend1 avoid_combat();
	level.friend2 avoid_combat();

	stealth_start_trigger = getent( "ev3_friends_start_stealth", "targetname" );
	stealth_start_trigger waittill( "trigger" );

	level.goddard disable_ai_color();
	level.friend1 disable_ai_color();
	level.friend2 disable_ai_color();

	nodes = getnodearray( "ev3_stealth_start_covers", "targetname" );

	level.goddard thread go_to_node_with_notify( nodes[0], "1_in_position" );
	level.friend1 thread go_to_node_with_notify( nodes[1], "2_in_position" );
	level.friend2 thread go_to_node_with_notify( nodes[2], "3_in_position" );

	level waittill_multiple( "1_in_position", "2_in_position", "3_in_position" );
	level notify( "all_in_position" );

	////////////////////////////////////

	iprintlnbold( "Some of us are still in German uniform" );
	wait( 2 );
	iprintlnbold( "We can sneak through, posing as captor and prisoners" );
	wait( 2 );
	iprintlnbold( "Follow me closely and don't alert the Germans" );
	wait( 2 );
	iprintlnbold( "Let's go" );

	////////////////////////////////////

	level.goddard.animname = "captor";
	level.friend1.animname = "prisonerL";
	level.friend2.animname = "prisonerR";

	//level.friend1 animscripts\shared::placeWeaponOn( level.friend1.primaryweapon, "none");
	//level.friend2 animscripts\shared::placeWeaponOn( level.friend2.primaryweapon, "none");

	// 1. Get them to reach the start positions

	maps\hol1_anim::formation_anim();

	maps\hol1_anim::everyone_single_solo( "capture_walk_in" );

	// 2. start walking loop
	maps\hol1_anim::set_capture_walk_anims();

	everyone_walk_to_trigger( "walk_captor_turn", "walk_prisonerL_turn", "walk_prisonerR_turn", "walk_right_trigger" );

	// now the trigger is hit, make then reach for there and do idle
	maps\hol1_anim::turn_anim_with_idle();

	everyone_walk_to_trigger( "walk_captor_stop", "walk_prisonerL_stop", "walk_prisonerR_stop", "walk_stop_trigger" );

	maps\hol1_anim::everyone_single_solo( "capture_walk_out" );

	maps\hol1_anim::reset_capture_walk_anims();

	go_to_cover_nodes( "walk_captor_cover", "walk_prisonerL_cover", "walk_prisonerR_cover" );
	iprintlnbold( "Take out that guard in the road" );
}

event3_stealth_attack()
{
	level waittill_any( "ev3_area_1", "ev3_area_2", "ev4_inside", "ev4_outside" );
	level notify( "break_stealth" );

	level.goddard resume_combat();
	level.friend1 resume_combat();
	level.friend2 resume_combat();

	level.goddard enable_ai_color();
	level.friend1 enable_ai_color();
	level.friend2 enable_ai_color();
}

everyone_walk_to_trigger( node_name_captor, node_name_prisonerL, node_name_prisonerR, trigger_name )
{
	goal_captor = getnode( node_name_captor, "targetname" );
	goal_prisonerL = getnode( node_name_prisonerL, "targetname" );
	goal_prisonerR = getnode( node_name_prisonerR, "targetname" );

	level.goddard setgoalnode( goal_captor );
	level.friend1 setgoalnode( goal_prisonerL );
	level.friend2 setgoalnode( goal_prisonerR );

	// wait until the trigger is touched. The prisoners will hit the trigger first
	turn_trigger = getent( trigger_name, "targetname" );
	while( level.friend1 istouching( turn_trigger ) == false )
	{
		wait( 0.1 );
	}
	level notify( "everyone_in_position" );
}

go_to_cover_nodes( node_name_captor, node_name_prisonerL, node_name_prisonerR )
{
	goal_captor = getnode( node_name_captor, "targetname" );
	goal_prisonerL = getnode( node_name_prisonerL, "targetname" );
	goal_prisonerR = getnode( node_name_prisonerR, "targetname" );

	level.goddard setgoalnode( goal_captor );
	level.friend1 setgoalnode( goal_prisonerL );
	level.friend2 setgoalnode( goal_prisonerR );

	level.goddard.goalradius = 512;
	level.friend1.goalradius = 512;
	level.friend2.goalradius = 512;
}

event3_ambient_anims()
{
	enemies1 = getentarray( "ev3_digger", "script_noteworthy" );
	array_thread( enemies1, ::add_spawn_function, ::ev3_digger_init );

	enemies2 = getentarray( "ev3_barrel", "script_noteworthy" );
	array_thread( enemies2, ::add_spawn_function, ::ev3_barrels_init );

	enemies3 = getentarray( "ev3_weapons_check_1", "script_noteworthy" );
	array_thread( enemies3, ::add_spawn_function, ::ev3_weapons_check_1_init );

	enemies4 = getentarray( "ev3_weapons_check_2", "script_noteworthy" );
	array_thread( enemies4, ::add_spawn_function, ::ev3_weapons_check_2_init );

	enemies5 = getentarray( "ev3_weapons_check_3", "script_noteworthy" );
	array_thread( enemies5, ::add_spawn_function, ::ev3_weapons_check_3_init );

	enemies6 = getentarray( "ev3_weapons_check_4", "script_noteworthy" );
	array_thread( enemies6, ::add_spawn_function, ::ev3_weapons_check_4_init );
}

ev3_digger_init()
{
	self thread maps\hol1_anim::digger_anim();
}

ev3_barrels_init()
{
	self thread maps\hol1_anim::barrel_anim();
}

ev3_weapons_check_1_init()
{
	self thread maps\hol1_anim::weapon_check_1_anim();
}

ev3_weapons_check_2_init()
{
	self thread maps\hol1_anim::weapon_check_2_anim();
}

ev3_weapons_check_3_init()
{
	self thread maps\hol1_anim::weapon_check_3_anim();
}

ev3_weapons_check_4_init()
{
	self thread maps\hol1_anim::weapon_check_4_anim();
}

event3_objectives()
{
	// update objective to point to camp
	objective_position( 2, ( 21741, -1587, 7.1 ) );

	trigger = getent( "ev3_spawn_enemies", "targetname" );
	trigger waittill( "trigger" );
	objective_state( 2, "done" );
	objective_add( 3, "current", level.obj3_string, ( 28680.8, -1513.5, 90 ) );

	trigger = getent( "ev4_start_trigger", "targetname" );
	trigger waittill( "trigger" );
	objective_state( 3, "done" );
	objective_add( 4, "current", level.obj4A_string, ( 27460.6, -1865, 280 ) );
	objective_add( 5, "current", level.obj4B_string, ( 27833.6, -3021.25, 280 ) );
	objective_add( 6, "current", level.obj5A_string, ( 26597.8, -3551.75, 33.298 ) );
	objective_add( 7, "current", level.obj5B_string, ( 27055.3, -3549.25, 33.298 ) );
	objective_add( 8, "current", level.obj5C_string, ( 27344.1, -3709.25, 25.9966 ) );

	level notify( "event3_done" );
}

ev3_spawners_1_custom_init()
{
	self thread custom_stealth_ai( "ev3_area_1" );
}

ev3_spawners_2_custom_init()
{
	self thread custom_stealth_ai( "ev3_area_2" );
}



temp_level_end()
{
	trigger = getent( "temp_end_level", "targetname" );
	trigger waittill( "trigger" );

	//iprintlnbold( "END OF SCRIPTING" );
	missionsuccess( "hol3", false );
}


reinforcements_monitor( trigger_name, notify_name )
{
	triggers = getentarray( trigger_name, "targetname" );
	
	// initially disable them
	for( i = 0; i < triggers.size; i++ )
	{
		triggers[i] trigger_off();
	}
		
	level waittill( notify_name );
	
	for( i = 0; i < triggers.size; i++ )
	{
		triggers[i] trigger_on();
	}
}

event3_section_1()
{
	level.ev3_section1_stealth_broken = false;
	level thread ev3_section1_check_stealth_level();
	level thread ev3_section1_failsafe();
	level thread ev3_force_end_section_1();

	// Step 1: prepare the spawners in the enemy area
	knife_kill_enemy = getentarray( "ev3_first_blood", "script_noteworthy" );
	array_thread( knife_kill_enemy, ::add_spawn_function, ::ev3_knife_kill_enemy_ai );
	player_kill_enemy = getentarray( "ev3_camp1_guy1", "script_noteworthy" );
	array_thread( player_kill_enemy, ::add_spawn_function, ::ev3_player_kill_enemy_ai );
	weapon_check_enemy = getentarray( "ev3_camp1_guy2", "script_noteworthy" );
	array_thread( weapon_check_enemy, ::add_spawn_function, ::ev3_weapon_check_enemy_ai );

	level waittill_multiple( "goddard_re_spawned", "friend1_re_spawned", "friend2_re_spawned" );
	//iprintlnbold( "Move Guys" );

	level thread custom_stealth_react_to_gun_fire( "ev3_first_blood" );
	level thread custom_stealth_react_to_gun_fire( "ev3_camp1_patrol" );
	level thread custom_stealth_react_to_gun_fire( "ev3_camp1_weapon" );

	// Step 2: tell AIs to run to first set of covers
	level.goddard.goalradius = 16;
	level.goddard setgoalnode( getnode( "goddard_cover_0", "targetname" ) );
	level.friend1.goalradius = 16;
	level.friend1 setgoalnode( getnode( "friend1_cover_0", "targetname" ) );
	level.friend2.goalradius = 16;
	level.friend2 setgoalnode( getnode( "friend2_cover_0", "targetname" ) );

	iprintlnbold( "Stay hidden. Don't make any noise" );

	
	// Step 3: When player approaches, play the kill anim
	trigger = getent( "ev3_section_1_approach", "targetname" );
	trigger waittill( "trigger" );
	level notify( "player_approaches" );

	level.goddard.goalradius = 16;
	level.goddard setgoalnode( getnode( "goddard_cover_1", "targetname" ) );
	level.friend1.goalradius = 16;
	level.friend1 setgoalnode( getnode( "friend1_cover_1", "targetname" ) );
	level.friend2.goalradius = 16;
	level.friend2 setgoalnode( getnode( "friend2_cover_1", "targetname" ) );

	level thread ev3_section1_anim();
	level waittill_either( "anim_kill_complete", "stealth_broken" );

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] enableWeapons();
	}

	// Step 2: tell AIs to run to first set of covers
	level.goddard.goalradius = 16;
	level.goddard setgoalnode( getnode( "goddard_cover_2", "targetname" ) );
	level.friend1.goalradius = 16;
	level.friend1 setgoalnode( getnode( "friend1_cover_2", "targetname" ) );
	level.friend2.goalradius = 16;
	level.friend2 setgoalnode( getnode( "friend2_cover_2", "targetname" ) );
	wait( 0.5 );

	if( level.ev3_section1_stealth_broken == false )
	{
		iprintlnbold( "STEALTH OK" );
		level.goddard thread gesture_closer( "Melee this guy down. Wait till his back is turned" );
		
		level waittill_either( "entering_combat", "move_on" );
	}
	else
	{
		iprintlnbold( "STEALTH BROKEN. Wait for kills" );
		// wait till all enemies have died
		wait( 2 );
	
		guys1 = get_ai_group_ai( "ev3_first_blood" );
		guys2 = get_ai_group_ai( "ev3_camp1_patrol" );
		guys3 = get_ai_group_ai( "ev3_camp1_weapon" );
		for( i = 0; i < guys1.size; i++ )
		{
			guys1[i] DoDamage( guys1[i].health + 5, (0,0,0) );
		}
		for( i = 0; i < guys2.size; i++ )
		{
			guys2[i] DoDamage( guys2[i].health + 5, (0,0,0) );
		}
		for( i = 0; i < guys3.size; i++ )
		{
			guys3[i] DoDamage( guys3[i].health + 5, (0,0,0) );
		}
	}

	iprintlnbold( "move" );

	level.goddard thread avoid_combat();
	level.friend1 thread avoid_combat();
	level.friend2 thread avoid_combat();


	// Step 2: tell AIs to run to next nodes
	level.goddard.goalradius = 16;
	level.goddard setgoalnode( getnode( "goddard_cover_3", "targetname" ) );
	level.friend1.goalradius = 16;
	level.friend1 setgoalnode( getnode( "friend1_cover_3", "targetname" ) );
	level.friend2.goalradius = 16;
	level.friend2 setgoalnode( getnode( "friend2_cover_3", "targetname" ) );

	//level.goddard waittill( "goal" );
	//level.goddard thread gesture_stop( "Wait here. Don't alert them" );

	level notify( "event3_section_1_complete" );
}

ev3_section1_anim()
{

	if( level.ev3_section1_stealth_broken == false )
	{
		iprintlnbold( "Wait here. I'll take that guard out" );

		level.goddard waittill( "goal" );

		// Step 4: now play it
		node = getstruct("knife_node", "targetname");
		
		level.goddard.animname = "sneaky_goddard";
	
		if( isalive( level.knife_enemy ) )
		{
			//iprintlnbold( "Enemy defined" );
	
			nazi = level.knife_enemy;
			nazi.animname = "nazi_knifed";
	
			vignette_dudes = [];
			vignette_dudes = array_add( vignette_dudes, level.goddard );
			vignette_dudes = array_add( vignette_dudes, nazi );
	
			level.goddard.goalradius = 4;
			//node anim_reach_solo( level.goddard, "goddard_sneak");
	
			if( level.ev3_section1_stealth_broken == false && isalive( level.knife_enemy ) )
			{
				node anim_single_solo( level.goddard, "goddard_sneak");
			}

			if( level.ev3_section1_stealth_broken == false && isalive( level.knife_enemy ) )
			{
				node anim_single( vignette_dudes, "goddard_knife" );
			}

			if( level.ev3_section1_stealth_broken == false && isalive( level.knife_enemy ) )
			{
				nazi.deathanim = level.scr_anim["nazi_knifed"]["nazi_death"];
				nazi dodamage( nazi.health * 10, ( nazi.origin ) );
				node anim_single_solo(level.goddard, "goddard_kill");
			}

			if( level.ev3_section1_stealth_broken == false )
			{
				wait( 4 );
	
				level.goddard thread gesture_closer( "Follow me" );
			}
			wait( 2 );
		}
	}
	level notify( "anim_kill_complete" );
}


ev3_section1_check_stealth_level()
{
	level endon( "event3_section_1_complete" );

	level waittill_either( "entering_combat", "attack_button_pressed" );
	level notify( "stealth_broken" );
	//iprintlnbold( "stealth broken" );
	level.ev3_section1_stealth_broken = true;

	level.goddard stopanimscripted();
		
	level.goddard thread resume_combat();
	level.friend1 thread resume_combat();
	level.friend2 thread resume_combat();

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] enableWeapons();
	}

	guys1 = get_ai_group_ai( "ev3_first_blood" );
	guys2 = get_ai_group_ai( "ev3_camp1_patrol" );
	guys3 = get_ai_group_ai( "ev3_camp1_weapon" );
	if( isalive( guys1[0] ) )
	{
		guys1[0] notify( "enemy_in_sight" );
	}
	if( isalive( guys2[0] ) )
	{
		guys2[0] notify( "enemy_in_sight" );
	}
	if( isalive( guys3[0] ) )
	{
		guys3[0] notify( "enemy_in_sight" );
	}
}

ev3_section1_failsafe()
{
/*
	level waittill( "player_approaches" );

	// wait till all enemies have died
	while( 1 )
	{
		guys1 = get_ai_group_ai( "ev3_first_blood" );
		guys2 = get_ai_group_ai( "ev3_camp1_patrol" );
		guys3 = get_ai_group_ai( "ev3_camp1_weapon" );
		if( guys1.size + guys2.size + guys3.size != 0 )
		{
			wait( 0.05 );
		}
		else
		{
			break;
		}
	}

	iprintlnbold( "FAILSAFE" );

	// Step 2: tell AIs to run to next nodes
	level.goddard.goalradius = 16;
	level.goddard setgoalnode( getnode( "goddard_cover_3", "targetname" ) );
	level.friend1.goalradius = 16;
	level.friend1 setgoalnode( getnode( "friend1_cover_3", "targetname" ) );
	level.friend2.goalradius = 16;
	level.friend2 setgoalnode( getnode( "friend2_cover_3", "targetname" ) );

	level.goddard thread gesture_stop( "Wait here. Don't alert them" );

	level notify( "event3_section_1_complete" );
*/
}

ev3_section2_check_stealth_level()
{
	level endon( "event3_section_2_complete" );

	level waittill_either( "entering_combat", "attack_button_pressed" );
	//iprintlnbold( "stealth 2 broken" );
	level.ev3_section2_stealth_broken = true;
	level.goddard stopanimscripted();
		
	level.goddard thread resume_combat();
	level.friend1 thread resume_combat();
	level.friend2 thread resume_combat();

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] enableWeapons();
	}

	guys = get_ai_group_ai( "ev3_execution" );
	for( i = 0; i < guys.size; i++ )
	{
		guys[i] notify( "enemy_in_sight" );
	}
}

gesture_closer( msg )
{
	self.animname = "gesture";
	self waittill( "goal" );
	self anim_single_solo( self, "gesture_closer" );
	if( isdefined( msg ) )
	{
		iprintlnbold( msg );
	}
}

gesture_stop( msg )
{
	self.animname = "gesture";
	self waittill( "goal" );
	self anim_single_solo( self, "gesture_stop" );
	if( isdefined( msg ) )
	{
		iprintlnbold( msg );
	}
}

ev3_knife_kill_enemy_ai()
{
	level.knife_enemy = self;
	self.ignoreall = 1;
	self.pacifist = 1;
	//self thread custom_stealth_ai( "ev3_first_blood" );
}

ev3_player_kill_enemy_ai()
{
	self thread custom_stealth_ai( "ev3_camp1_patrol" );
	level thread wait_for_player_to_kill_him( self );
}

wait_for_player_to_kill_him( guy )
{
	guy waittill( "death" );
	level notify( "move_on" );
}

ev3_force_end_section_1()
{
	level endon( "event3_section_1_complete" );
	trig = GetEnt( "ev3_intro_camp_2", "targetname" );
	trig waittill ("trigger");

	iprintlnbold( "move" );

	guys1 = get_ai_group_ai( "ev3_first_blood" );
	guys2 = get_ai_group_ai( "ev3_camp1_patrol" );
	guys3 = get_ai_group_ai( "ev3_camp1_weapon" );
	for( i = 0; i < guys1.size; i++ )
	{
		guys1[i] DoDamage( guys1[i].health + 5, (0,0,0) );
	}
	for( i = 0; i < guys2.size; i++ )
	{
		guys2[i] DoDamage( guys2[i].health + 5, (0,0,0) );
	}
	for( i = 0; i < guys3.size; i++ )
	{
		guys3[i] DoDamage( guys3[i].health + 5, (0,0,0) );
	}

	level.goddard thread avoid_combat();
	level.friend1 thread avoid_combat();
	level.friend2 thread avoid_combat();

	// Step 2: tell AIs to run to next nodes
	level.goddard.goalradius = 16;
	level.goddard setgoalnode( getnode( "goddard_cover_3", "targetname" ) );
	level.friend1.goalradius = 16;
	level.friend1 setgoalnode( getnode( "friend1_cover_3", "targetname" ) );
	level.friend2.goalradius = 16;
	level.friend2 setgoalnode( getnode( "friend2_cover_3", "targetname" ) );

	//level.goddard waittill( "goal" );
	//level.goddard thread gesture_stop( "Wait here. Don't alert them" );

	level notify( "event3_section_1_complete" );
}

ev3_weapon_check_enemy_ai()
{
	self thread custom_stealth_ai( "ev3_camp1_weapon" );

	self thread maps\hol1_anim::weapon_check_1_anim();
}

event3_execution()
{	
	level.goddard thread avoid_combat();
	level.friend1 thread avoid_combat();
	level.friend2 thread avoid_combat();

	level.ev3_section2_stealth_broken = false;

	trig = GetEnt( "ev3_intro_camp_2", "targetname" );

	animSpot = GetStruct( trig.target, "targetname" );

	trig waittill ("trigger");
	level thread ev3_section2_check_stealth_level();
	trig Delete();

	if( level.ev3_section2_stealth_broken == true )
	{
		iprintlnbold( "broken" );
	}

	// setup watchers
	execution_enemy = getentarray( "execution_watcher", "script_noteworthy" );
	array_thread( execution_enemy, ::add_spawn_function, ::ev3_execution_enemy_ai );

	executioner = getentarray( "execution_watcher", "script_noteworthy" );
	array_thread( executioner, ::add_spawn_function, ::ev3_executioner_ai );

	// spawn the guys
	victim_spawner = GetEnt( "execution_friendly_spawner", "targetname" );
	executioner_spawner = GetEnt( "execution_enemy_spawner", "targetname" );
	
	// spawn victim
	victim = victim_spawner spawn_ai();
	if ( spawn_failed( victim ) )
	{
		ASSERTMSG( "Key friendly failed to spawn." );
		return;
	}

	victim.ignoreme = true;
	victim.anim_disableLongDeath = true;
	victim.og_pathenemyfightdist = victim.pathenemyfightdist;
	victim.og_pathenemylookahead = victim.pathenemylookahead;
	victim.og_goalheight = victim.goalheight;
	victim.og_goalradius = victim.goalradius;
	victim.og_animname = victim.animname;
	victim.pathenemyfightdist = 0;
	victim.pathenemylookahead = 0;
	victim.goalheight = 64;
	victim.goalradius = 32;
	victim.animname = "knees_execution_victim";
	victim.targetname = "knees_execution_guys";
	
	victim.ignoreall = 1;
	victim.pacifist = 1;

	// TODO take weapons from victim
	
	// spawn executioner
	executioner = executioner_spawner spawn_ai();
	if ( spawn_failed( executioner ) )
	{
		ASSERTMSG( "Key enemy failed to spawn." );
		return;
	}
	executioner.ignoreme = true;
	executioner.goalradius = 32;
	executioner.animname = "knees_execution_executioner";
	executioner.targetname = "knees_execution_guys";
	executioner.victim = victim;
	executioner.allowdeath = true;
	// TODO give rifle to executioner
	
	victim.executioner = executioner;

	executioner.ignoreall = 1;
	executioner.pacifist = 1;
	
	// kick off the victim/executioner anims
	level thread maps\hol1_anim::event3_execution_2man_anims( victim, executioner, animSpot );

	if( level.ev3_section2_stealth_broken == false )
	{
		level waittill( "execution_done" );
	}
	if( isalive( executioner ) )
	{
		executioner.health = 1;	
	}

	if( isalive( victim ) )
	{
		victim DoDamage( victim.health + 5, (0,0,0) );
	}

	if( level.ev3_section2_stealth_broken == false )
	{
		level notify( "run_back" );
	}

	/*
	if( level.ev3_section2_stealth_broken == false )
	{
		wait( 7 );
	}
	else
	{
		// wait till all enemies have died
		count = 0;
		while( count < 20 * 15 ) // 15 seconds
		{
			guys1 = get_ai_group_ai( "ev3_execution" );
			guys2 = get_ai_group_ai( "ev3_executioner" );
			if( guys1.size + guys2.size != 0 )
			{
				wait( 0.05 );
				count++;
			}
			else
			{
				break;
			}
		}
	}
	*/
	wait( 7 );

	level notify( "time_to_move_on" );
	iprintlnbold( "Time to move" );

	level.goddard.goalradius = 16;
	level.goddard setgoalnode( getnode( "goddard_cover_4", "targetname" ) );
	level.friend1.goalradius = 16;
	level.friend1 setgoalnode( getnode( "friend1_cover_4", "targetname" ) );
	level.friend2.goalradius = 16;
	level.friend2 setgoalnode( getnode( "friend2_cover_4", "targetname" ) );

	level notify( "event3_section_2_complete" );
}

ev3_execution_enemy_ai()
{
	self thread custom_stealth_ai( "ev3_execution" );
	
	escape_node = getnode( "ev3_escape", "targetname" );
	level waittill( "run_back" );
	self.goalradius = 64;
	self setgoalnode( escape_node );
	self waittill( "goal" );
	self delete();
}

ev3_executioner_ai()
{
	self.health = 100000;
	self.ignoreall = true;
	level waittill( "execution_done" );
	self.health = 1;
	//self thread custom_stealth_ai( "ev3_executioner" );
	//if( level.ev3_section2_stealth_broken == true )
	//{
	//	self notify( "enemy_in_sight" );
	//}
}


///////////////////////////////////////////////////////////////////////

event4()
{
	level thread event4_objective();

	//iprintlnbold( "event 4 starts" );

	custom_stealth_detection_range_setup( 5, 512, 25, 512, 128, 1024, false );

	level thread custom_stealth_react_to_gun_fire( "ev4_outside" );
	level thread custom_stealth_react_to_gun_fire( "ev4_inside" );

	enemies1 = getentarray( "ev4_outside", "targetname" );	
	array_thread( enemies1, ::add_spawn_function, ::ev4_spawners_custom_1_init );

	enemies2 = getentarray( "ev4_inside", "targetname" );	
	array_thread( enemies2, ::add_spawn_function, ::ev4_spawners_custom_2_init );

	snipers1 = getentarray( "sniper1", "script_noteworthy" );
	array_thread( snipers1, ::add_spawn_function, ::snipers1_ai );
	
	snipers2 = getentarray( "sniper2", "script_noteworthy" );
	array_thread( snipers2, ::add_spawn_function, ::snipers2_ai );

	//overwrite_detect_ranges_2();

	level thread bombs_set();

	level thread snipers_kill();

	level thread prepare_escape_truck();

	iprintlnbold( "Radio: Intruders alert!" );
	wait( 2 );
	iprintlnbold( "Don't get close to the enemies and stay in cover" );

	wait( 2 );
	iprintlnbold( "Kill snipers on the roof" );
	wait( 2 );
	iprintlnbold( "and set explosive underneath the trucks" );

	level waittill( "regrouped" );
	inspection_node = getnode( "inspection_node", "targetname" );

	insiders = get_ai_group_ai( "ev4_inside" );
	for( i = 0; i < insiders.size; i++ )
	{
		insiders[i] thread avoid_combat();
		insiders[i].goalradius = 64;
		insiders[i] setgoalnode( inspection_node );
	}

	level thread temp_level_end();
}

event4_objective()
{
	level waittill_multiple( "all_bombs_set", "all_snipers_killed" );		

	objective_add( 9, "current", level.obj6_string, ( 28315.6, -3264.6, 53.4 ) );

	regroup_trigger = getent( "regroup_trigger", "targetname" );
	regroup_trigger waittill( "trigger" );

	iprintlnbold( "Bombs go off. Germans inside running out" );
	level notify( "regrouped" );
	objective_state( 9, "done" );

	objective_add( 10, "current", level.obj7_string, ( 28296.3, -2222.4, 88 ) );
	document_trigger = getent( "document_trigger", "targetname" );
	document_trigger waittill( "trigger" );
	iprintlnbold( "Found documents on desk. Exit through the back door" );
	objective_state( 10, "done" );

	objective_add( 11, "current", level.obj8_string, ( 28811, -2374, 70.1552 ) );
	level thread get_players_into_truck();

	level waittill( "all_players_in_position" );
	objective_state( 11, "done" );

}

get_players_into_truck()
{
	get_on_trigger = getent( "get_on_truck", "targetname" );
	get_on_trigger waittill( "trigger" );

	level notify( "all_players_in_position" );

	players = get_players();
	if( isdefined( players[0] ) )
	{
		players[0] playerlinktodelta( level.escape_opel, "tag_passenger3", 1.0, 180, 180, 180, 180);
	}
	if( isdefined( players[1] ) )
	{
		players[1] playerlinktodelta( level.escape_opel, "tag_passenger4", 1.0, 180, 180, 180, 180);
	}
	if( isdefined( players[2] ) )
	{
		players[2] playerlinktodelta( level.escape_opel, "tag_passenger5", 1.0, 180, 180, 180, 180);
	}
	if( isdefined( players[3] ) )
	{
		players[3] playerlinktodelta( level.escape_opel, "tag_passenger6", 1.0, 180, 180, 180, 180);
	}

	level.friend1 linkto( level.escape_opel, "tag_passenger7" );
	level.friend2 linkto( level.escape_opel, "tag_passenger8" );
	level.goddard linkto( level.escape_opel, "tag_driver" );

	germans = getaiarray("axis");
	for( i = 0; i < germans.size; i++ )
	{
		germans[i].accuracy = 0;
	}
}

overwrite_detect_ranges_2()
{
	//these values represent the BASE huristic for max visible distance base meaning 
	//when the character is completely still and not turning or moving
	//HIDDEN is self explanatory
	hidden = [];
	hidden[ "prone" ]	= 32;
	hidden[ "crouch" ]	= 64;
	hidden[ "stand" ]	= 256;
	
	//ALERT levels are when the same AI has sighted the same enemy twice OR found a body	
	alert = [];
	alert[ "prone" ]	= 256;
	alert[ "crouch" ]	= 512;
	alert[ "stand" ]	= 2000;

	//SPOTTED is when they are completely aware and go into NORMAL COD AI mode...however, the
	//distance they can see you is still limited by these numbers because of the assumption that
	//you're wearing a ghillie suit in woodsy areas
	spotted = [];
	spotted[ "prone" ]	= 512;
	spotted[ "crouch" ]	= 5000;
	spotted[ "stand" ]	= 8000;
	
	system_set_detect_ranges( hidden, alert, spotted );
}

prepare_escape_truck()
{
	start_node = getvehiclenode( "escape_truck_start", "targetname" );

	opel = spawnvehicle( 	"vehicle_ger_wheeled_opel_blitz_winter", 
							"truck", 
							"opel", 
							start_node.origin, 
							start_node.angles );

	level.escape_opel = opel;

	wait( 1 );
			
	playfxontag( level._effect["headlight"], opel, "tag_headlight_left" );
	playfxontag( level._effect["headlight"], opel, "tag_headlight_right" );
	//playfxontag( level._effect["brakelight"], opel, "tag_brakelight_left" );

	opel attachPath( start_node );
	
	level waittill( "all_players_in_position" );

	opel startpath();
}

bombs_set()
{
	bomb1 = getent( "bomb1", "targetname" );
	bomb2 = getent( "bomb2", "targetname" );
	bomb3 = getent( "bomb3", "targetname" );

	bomb1 hide();
	bomb2 hide();
	bomb3 hide();
	
	use_trigger1 = getent( "bomb_trigger1", "targetname" );
	use_trigger2 = getent( "bomb_trigger2", "targetname" );
	use_trigger3 = getent( "bomb_trigger3", "targetname" );

	level thread bomb_set_single( bomb1, use_trigger1, 6, "bomb1_set" );
	level thread bomb_set_single( bomb2, use_trigger2, 7, "bomb2_set" );
	level thread bomb_set_single( bomb3, use_trigger3, 8, "bomb3_set" );

	level waittill_multiple( "bomb1_set", "bomb2_set", "bomb3_set" );		
	level notify( "all_bombs_set" );
}

bomb_set_single( bomb, trigger, obj_num, msg )
{
	trigger waittill( "trigger" );
	trigger delete();
	
	bomb show();
	objective_state( obj_num, "done" );
	level notify( msg );
}

snipers_kill()
{
	level thread sniper_1_kill();
	level thread sniper_2_kill();

	level waittill_multiple( "sniper1_killed", "sniper2_killed" );		
	level notify( "all_snipers_killed" );
}

snipers1_ai()
{
	level.sniper1 = self;
	level notify( "sniper1_spawned" );
}

snipers2_ai()
{
	level.sniper2 = self;
	level notify( "sniper2_spawned" );
}

sniper_1_kill()
{
	level waittill( "sniper1_spawned" );
	level.sniper1 waittill( "death" );
	
	objective_state( 4, "done" );
	level notify( "sniper1_killed" );
}

sniper_2_kill()
{
	level waittill( "sniper2_spawned" );
	level.sniper2 waittill( "death" );
	
	objective_state( 5, "done" );
	level notify( "sniper2_killed" );
}

ev4_spawners_custom_1_init()
{
	self thread custom_stealth_ai( "ev4_outside" );
}

ev4_spawners_custom_2_init()
{
	self thread custom_stealth_ai( "ev4_inside" );
}