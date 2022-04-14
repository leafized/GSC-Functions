#include maps\_utility;
#include maps\_anim;
#include maps\rhi3_utility;

#using_animtree("generic_human");

main()
{
	// setup skiptos
	// to run, try: +set start event1
	add_start( "event1", ::start_event1 );
	add_start( "event2", ::start_event2 );
	add_start( "event3", ::start_event3 );
	add_start( "event4", ::start_event4 );
	default_start( ::opening );
	
	level.maxfriendlies = 6;
	level.default_goalradius = 512; 
	
	//create threatbias groups for entire map
	createthreatbiasgroup("players");
	createthreatbiasgroup("allies");
	createthreatbiasgroup("enemies");
	createthreatbiasgroup("actors");
	createthreatbiasgroup("redshirts");
	
	precache_items();
	
	//load vehicle models
	//maps\_aircraft::main("vehicle_stuka_flying", "stuka");
		maps\_stuka::main( "vehicle_stuka_flying" );

	maps\rhi3_fx::main();
	
	maps\_load::main();
	
	maps\rhi3_anim::main();
	maps\rhi3_amb::main();
	maps\rhi3_status::main();
	
	//wait_for_first_player();
	
	//callback setup
	init_callbacks();
	init_heroes();
	init_threatbiasgroups();
	
}


precache_items()
{
	level.obj1_string = &"RHI3_OBJECTIVE1"; 	// Enter Dock
	level.obj2_string = &"RHI3_OBJECTIVE2"; 	// secure dock
	level.obj3_string = &"RHI3_OBJECTIVE3";		// Enter Sub Pen
	level.obj4_string = &"RHI3_OBJECTIVE4";		// Secure Sub Pen
	level.obj5_string = &"RHI3_OBJECTIVE5";		// Blow Up Sub
	level.obj6_string = &"RHI3_OBJECTIVE6";		// Go To Flak
	
	level.obj7A_string = &"RHI3_OBJECTIVE7A";	// Set charges 3/3 left
	level.obj7B_string = &"RHI3_OBJECTIVE7B"; // 2/3 left
	level.obj7C_string = &"RHI3_OBJECTIVE7C"; // 1/3 left
	level.obj7D_string = &"RHI3_OBJECTIVE7D"; // done
	level.obj8_string  = &"RHI3_OBJECTIVE8";	// use Elevator
	level.obj9_string  = &"RHI3_OBJECTIVE9";  // Set last charge
	level.obj10_string = &"RHI3_OBJECTIVE10"; // escape
	
	precacheModel("tag_origin"); // to lock player in elevator (not currently used)
}

init_callbacks()
{
	level thread onPlayerConnect();
}

init_heroes()
{
	//-- currently the only guys in magic bulletshield are targetname: sgt / hero_a
	
	level.sgt = getent("sgt", "targetname");
	level.sgt.name = "sgt";
	level.wilkins = getent("hero_a", "targetname");
	level.wilkins.name = "wilkins";
	
	level.heroes = [];
	level.heroes[0] = level.sgt;
	level.heroes[1] = level.wilkins;
	
	for(i=0; i<level.heroes.size; i++)
	{
		level.heroes[i] thread magic_bullet_shield();
	}
}

init_threatbiasgroups()
{
	players = get_players();
	
	//setup threatbias groups
	for(i=0; i<players.size; i++)
	{
		players[i] setthreatbiasgroup("players");
	}
	
	setignoremegroup("actors", "players");
	setignoremegroup("actors", "allies");
	setignoremegroup("actors", "enemies");
	setignoremegroup("actors", "redshirts");
	
	setignoremegroup("players", "actors");
	setignoremegroup("allies", "actors");
	setignoremegroup("redshirts", "actors");	
}

/////////////////////// Start functions ////////////////////////
////////////////////////////////////////////////////////////////
start_event1()
{
	// Grab the starting point, could be a ent, node, vector, whatever.
	starts = getentarray( "event1_start","targetname" );
	
	// grab all players
	players = get_players();

	// set up each player, make sure there are four points to start from
	for( i = 0; i < players.size; i++ )
	{
		// Set the players' origin to each start point
		players[i] setOrigin( starts[i].origin );
	
		// Set the players' angles to face the right way.
		players[i] setPlayerAngles( starts[i].angles );
	}
	
	// start event1
	level thread event1();
}


start_event2()
{
	// Grab the starting point, could be a ent, node, vector, whatever.
	starts = getentarray( "event2_start","targetname" );
	
	// grab all players
	players = get_players();

	// set up each player, make sure there are four points to start from
	for( i = 0; i < players.size; i++ )
	{
		// Set the players' origin to each start point
		players[i] setOrigin( starts[i].origin );
	
		// Set the players' angles to face the right way.
		players[i] setPlayerAngles( starts[i].angles );
	}
	
	finish_event1_objectives();
	
	// start event2
	level thread event2();
}


start_event3()
{
	// Grab the starting point, could be a ent, node, vector, whatever.
	starts = getentarray( "event3_start","targetname" );
	
	// grab all players
	players = get_players();

	// set up each player, make sure there are four points to start from
	for( i = 0; i < players.size; i++ )
	{
		// Set the players' origin to each start point
		players[i] setOrigin( starts[i].origin );
	
		// Set the players' angles to face the right way.
		players[i] setPlayerAngles( starts[i].angles );
	}
	
	finish_event1_objectives();
	finish_event2_objectives();
	
	init_friendlychain();
	
	level thread event3_teleport_friendlies();

	// start event3
	level thread event3();
}


start_event4()
{
	// Grab the starting point, could be a ent, node, vector, whatever.
	starts = getentarray( "event4_start","targetname" );
	
	// grab all players
	players = get_players();

	// set up each player, make sure there are four points to start from
	for( i = 0; i < players.size; i++ )
	{
		// Set the players' origin to each start point
		players[i] setOrigin( starts[i].origin );
	
		// Set the players' angles to face the right way.
		players[i] setPlayerAngles( starts[i].angles );
	}
	
	finish_event1_objectives();
	finish_event2_objectives();
	finish_event3_objectives();
	
	init_friendlychain();

	// start event3
	level thread event4();
}

event3_teleport_friendlies()
{
	wait( 3 );
	
	// teleport friendlies first
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] setOrigin( players[i].origin + ( 0, 0, -597 ) );
	}
	
	wait( 1 );
	pos = getentarray( "event3_teleport", "targetname" );
	friendlies = getaiarray( "allies" );
	
	for( i = 0; i < friendlies.size; i++ )
	{
		if( i < pos.size )
		{
			friendlies[i] teleport( pos[i].origin, pos[i].angles );
		}
	}
	
	for( i = 0; i < players.size; i++ )
	{
		players[i] setOrigin( players[i].origin + ( 0, 0, 597 ) );
	}
}

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

opening()
{
	// Setup some ambient fx
	level thread flak_tracers();
	
	// TODO: Set up level to start from default player_start
	
	// Opening scripting:
	level waittill ("introscreen_complete");
	
	// TODO: Need to put in the actual cutscene
	maps\_camsys::playback_scene("intro");
	
	// Other Setup
	init_friendlychain();
			
	level thread event1();
}

flak_tracers()
{
	tracer_origins = getentarray( "flak_tracer", "targetname" );
	
	assertex( tracer_origins.size > 0, "There are this many tracer origins: " + tracer_origins.size);
	
	for( i = 0; i < tracer_origins.size; i++ )
	{
		tracer_origins[i] thread aa_tracer_loop();
	}
}

aa_tracer_loop()
{
	level endon( "aa_fireloop_end" );

	interval_min = 9;
	interval_max = 10;

	fxOrigin = self.origin;

	while( 1 )
	{
		//playfx ( level.flak_tracer, fxOrigin + ( 100, 0, 0 ), anglestoforward( self.angles ), anglestoup( self.angles ) );
		//playfx ( level.flak_tracer, fxOrigin + ( 100, 100, 0 ), anglestoforward( self.angles ), anglestoup( self.angles ) );
		//playfx ( level.flak_tracer, fxOrigin + ( 0, 100, 0 ), anglestoforward( self.angles ), anglestoup( self.angles ) );
		playfx ( level.flak_tracer, fxOrigin + ( 0, 0, 0 ), anglestoforward( self.angles ), anglestoup( self.angles ) );
		wait( RandomFloatRange( interval_min, interval_max ) );
	}
}


////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

event1()
{
	level thread event1_objectives();
	
	
	//-- INITIALIZE PATROLLERS
	level thread event1_init_patrollers();
	//-- Germans watching bombers event
	level thread event1_setup_germans_watching_bombers();
	//-- Setup the crane
	level thread event1_drop_crane_load();
	
	
	//movement through event 1 through AI dying, not friendly chains triggers
	
	// -- temporarily disabled
	// level thread event1_manage_friendlies();
	
	//level thread switch_to_colors();
	
	level thread event1_regroup_before_pacing();
	
	level waittill( "event1_ends" );
	level thread event2();
}

event1_init_patrollers()
{
	level.ev1_patrollers = [];
 	level.ev1_patrollers[0] = getent("patroller00", "targetname");
	level.ev1_patrollers[1] = getent("patroller01", "targetname");
	level.ev1_patrollers[2] = getent("patroller02", "targetname");
	
	for(i=0; i<level.ev1_patrollers.size; i++)
	{
		level.ev1_patrollers[i] thread interrupt_patroller_go_to_node();
	}
	
	level thread event1_end_patrols();
}

event1_end_patrols()
{
	level endon("actor_damaged");
	
	getent("patrol_trig", "targetname") waittill("trigger");
	
	//level waittill("patrol_alert");
	
	println("PATROLLERS ALERTED!");
	
	for(i=0; i<level.ev1_patrollers.size; i++)
	{
		level.ev1_patrollers[i] notify("enemy");
	}
	
	level notify("actor_damaged");
}

event1_setup_germans_watching_bombers()
{
	level thread event1_response_group();
	
	t_spawn = getent("spawn_bomb_watcher", "targetname");
	//t_spawn notify("trigger");
	t_spawn waittill("trigger");
	
	wait 1;
	
	bomb_watcher1 = getent("bombwatcher1", "targetname");
	bomb_watcher2 = getent("bombwatcher2", "targetname");
	bomb_watcher3 = getent("bombwatcher3", "targetname");
	bomb_watcher4 = getent("bombwatcher4", "targetname");
	bomb_watcher5 = getent("bombwatcher5", "targetname");
	
	watcher_array = [];
	
	watcher_array[0] = bomb_watcher1;
	watcher_array[1] = bomb_watcher2;
	watcher_array[2] = bomb_watcher3;
	watcher_array[3] = bomb_watcher4;
	watcher_array[4] = bomb_watcher5;
	
	watcher_array[0].animname = "bombwatcher1";
	watcher_array[1].animname = "bombwatcher2";
	watcher_array[2].animname = "bombwatcher3";
	watcher_array[3].animname = "bombwatcher4";
	watcher_array[4].animname = "bombwatcher5";
	
	for(i=0; i<watcher_array.size; i++)
	{
		watcher_array[i].ignoreme = true;
	}
	
	getent("bombwatcher_trig", "targetname") waittill("trigger");
	
	for(i=0; i<watcher_array.size; i++)
	{
		watcher_array[i] thread waittill_actor_damage();
		watcher_array[i] thread reset_my_group();
		watcher_array[i] thread maps\rhi3_anim::rhi_dialog_and_anim(0);
	}
}

waittill_actor_damage()
{
	//THIS ALSO WILL NOTIFY PATROLLING SOLDIERS TO RESPOND
	level endon("actor_damaged");
	
	self waittill("damage", dmg);
	
	for(i=0; i<level.ev1_patrollers.size; i++)
	{
		level.ev1_patrollers[i] notify("enemy");
	}
	
	level notify("actor_damaged");
}

reset_my_group()
{
	level waittill("actor_damaged");
	self setthreatbiasgroup("enemies");
	self clearanim(%door_kick_in, 0);
}

event1_drop_crane_load()
{
	//-- If the crane latch gets damaged, then it will drop it's package down onto the boat or into the harbor
	// depending on whether or not the boat had already been sunk
	
	crane_trigger = getent("crane_latch_trig", "targetname");
	crane_package = getent("crane_package", "targetname");
	
	crane_trigger waittill("trigger");
	
	//crane_package moveZ(-357.5, 5, 4, 0.1);
	crane_package physicslaunch(crane_package.origin, (0,0,-1));
	
}


event1_response_group()
{
	response_trigger = getent("ev1_attack_response_trig", "targetname");
	
	response_trigger endon("trigger");
	level waittill("actor_damaged");
	
	//wait a few seconds for shouts and then trigger the next spawn
	wait 3;
	response_trigger notify("trigger");
}

event1_objectives()
{
	// enter harbor
	triggered_objective_wait( 1, level.obj1_string, "ev1_obj_harbor", "harbor_reached" );

	// secure harbor
	triggered_objective_wait( 2, level.obj2_string, "ev1_obj_secure", "harbor_secured" );

	level notify( "event1_ends" );
}

event1_manage_friendlies()
{
	first_trig = getent("ev1_attack_response_trig", "targetname");
	first_trig waittill("trigger");
	
	level thread event1_manage_friendlies_01();
		
	wait(2); 
	on_clear_squad_advance_fc("event1_axis_spawn00", "event1_axis_spawn00_fc", "event1_axis_spawn01_trig", "fc01_start");
	
	println("FINISHED FIRST GROUP OF ENEMIES, TRIGGERED NEXT WAVE");
}

event1_manage_friendlies_01()
{
	my_trig = getent("event1_axis_spawn01_trig", "script_noteworthy");
	my_trig waittill("trigger");
	
	wait(2);
	on_clear_squad_advance_fc("event1_axis_spawn01", "event1_axis_spawn01_fc", "event1_axis_spawn02_trig", "fc02_start");
}

event1_regroup_before_pacing()
{
	//-- This watches for the last of the axis to be killed before regrouping
	// the squad before the pacing event, where they walk the curved section
	// of the docks right before the U-Boat Pen.
	
	last_battle_trigger = getent("ev1_last_battle_trig", "targetname");
	last_battle_trigger waittill("trigger");
	
	wait 2;
		
	all_axis = [];
	all_axis = GetAIArray("axis");
	
	players = get_players();
	for(i=0; i < all_axis.size; i++)
	{
		//-- Delete all of the axis that are farther than 1500 units away from the player
		if(distance(players[0].origin, all_axis[i].origin) > 1500)
		{
			all_axis[i] DoDamage(all_axis[i].health + 100, (0,0,0));
		}
	}
	
	all_axis = array_removeDead(all_axis);
	
	if(all_axis.size > 0)
	{
		waittill_dead(all_axis);
	}
	
	//-- All of the axis are now dead, so regroup and lets start walking
	
	new_pos = [];
	new_pos = getentarray("pacingstart_pos", "targetname");
	
	all_ally = [];
	all_ally = getAIArray("allies");
	
	assertex( new_pos.size >= all_ally.size, "There are not enough spots for the guys!!");
	
	for(i=0; i<all_ally.size; i++)
	{
		all_ally[i] SetGoalPos(new_pos[i].origin);
	}
	
}

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

event2()
{	
	level thread event2_objectives();
	
	level waittill( "sub_blows_up" );
	sub_explosion_fx();
	
	/*
	// open sub door to outside
	door = getent( "subpen_exit_door", "targetname" );
	door hide();
	door notsolid();
	door connectpaths();
	*/
	level waittill( "reached_flak" );
	level notify( "event2_ends" );
	level thread event3();
}

event2_objectives()
{
	// enter sub pen
	triggered_objective_wait( 3, level.obj3_string, "ev2_obj_enter", "subpen_entered" );

	// secure sub pen
	triggered_objective_wait( 4, level.obj4_string, "ev2_obj_secure", "subpen_secured" );

	// blow up sub
	triggered_objective_wait( 5, level.obj5_string, "ev2_obj_bomb", "trigger_sub" );
	
	// delete the explosive charge model
	explosive = getent( "sub_bomb", "targetname" );
	explosive hide();
	explosive delete();
	
	level notify( "sub_blows_up" );
	
	iprintlnbold( "End of scripting" );
	
	wait( 5 );
	
	missionsuccess( "rhi3", false );
	
	//triggered_objective_wait( 6, level.obj6_string, "ev2_obj_to_flak", "trigger_flak_entrance" );
	//level notify( "reached_flak" );
}

sub_explosion_fx()
{
	targets = getentarray( "sub_explosion", "targetname" );
	for( i = 0; i < targets.size; i++ )
	{
		playfx ( level.fx_sub_explosion, targets[i].origin );
		radiusdamage( targets[i].origin, 100, 500, 1 );
		wait( randomfloat( 1.0 ) );
	}
	
	for( i = 0; i < targets.size; i++ )
	{
		playfx ( level.fx_sub_explosion, targets[i].origin );
		radiusdamage( targets[i].origin, 100, 500, 1 );
		wait( randomfloat( 1.0 ) );
	}
}

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

event3()
{
	level.explosive_charges_left = 3;
	
	level thread event3_objectives();
	level thread event3_charge_set( "bomb1", "trigger_bomb1", 8 );
	level thread event3_charge_set( "bomb2", "trigger_bomb2", 9 );
	level thread event3_charge_set( "bomb3", "trigger_bomb3", 10 );
	
	level thread event3_elevator();

	level waittill( "last_charge_set" );
	level notify( "event3_ends" );
	level thread event4();
}


event3_objectives()
{
	objective_add( 7, "current", level.obj7A_string ); // 3 of 3 left
	// add the 3 sub objectives (hidden)
	bomb1_pos = getent( "ev3_obj_bomb1", "targetname" );
	objective_add( 8, "active", "", bomb1_pos.origin );
	objective_additionalcurrent( 8 );
	bomb2_pos = getent( "ev3_obj_bomb2", "targetname" );
	objective_add( 9, "active", "", bomb2_pos.origin );
	objective_additionalcurrent( 9 );
	bomb3_pos = getent( "ev3_obj_bomb3", "targetname" );
	objective_add( 10, "active", "", bomb3_pos.origin );
	objective_additionalcurrent( 10 );
	
	previous_charges = level.explosive_charges_left;
	
	while( level.explosive_charges_left > 0 )
	{
		wait( 0.5 );
		
		if( previous_charges != level.explosive_charges_left )
		{
			if( level.explosive_charges_left == 2 )
			{
				objective_string( 7, level.obj7B_string );
			}
			else if( level.explosive_charges_left == 1 )
			{
				objective_string( 7, level.obj7C_string );
			}
			previous_charges = level.explosive_charges_left;
		}
	}
	objective_string( 7, level.obj7D_string );
	objective_state( 7, "done" );
	level notify( "all_explosives_set" );
	
	level notify( "aa_fireloop_end" );
	
	elevator_pos = getent( "ev3_obj_elevator", "targetname" );
	objective_add( 8, "active", level.obj8_string, elevator_pos.origin );
	
	// at top of evevator, set another charge
	level waittill( "elevator_finished" );
	objective_state( 8, "done" );
	
	ammo_charge = getent( "bomb4", "targetname" );
	ammo_pos = getent( "ev3_obj_bomb4", "targetname" );
	ammo_charge_trigger = getent( "trigger_bomb4", "targetname" );
	objective_add( 9, "active", level.obj9_string, ( 16358, 20345.5, 1407.5 ) );
	ammo_charge_trigger waittill( "trigger" );
	ammo_charge hide();
	ammo_charge delete();
	ammo_charge_trigger delete();
	
	level notify( "last_charge_set" );
	objective_state( 9, "done" );
}

event3_charge_set( bomb_string, trigger_string, num )
{
	bomb = getent( bomb_string, "targetname" );
	trigger = getent( trigger_string, "targetname" );
		
	trigger waittill( "trigger" );
	level.explosive_charges_left--;
	bomb hide();
	bomb delete();
	trigger delete();
	
	iprintlnbold( "Charge Set" );
	
	objective_delete( num );
}

event3_elevator()
{
	level waittill( "all_explosives_set" );
	
	// open elevator door
	first_door = getent( "door_down", "targetname" );
	first_door hide();
	first_door notsolid();
	first_door connectpaths();
	
	// wait till all players are inside elevator
	enter_trigger = getent( "elevator_inside", "targetname" );
	while( 1 )
	{
		players = get_players();
		players_in_position = 0;
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] istouching( enter_trigger ) )
			{
				players_in_position++;
			}
		}
		if( players_in_position == players.size )
		{
			break; // all players are inside
		}
		wait( 0.1 );
	}
	
	// now kill existing friendlies 
	allies = getaiarray( "allies" );
	for( i = 0; i < allies.size; i++ )
	{
		allies[i] delete();
	}
	
	// spawn new friendlies
	new_spawner = getent( "new_friends_spawn", "targetname" );
	new_spawner notify( "trigger" );
	wait( 0.1 );
	
	// now have sarge go to his control node and wait there
	sarge = getentarray( "new_sarge", "script_noteworthy" );
	level.sarge2 = 0;
	for( i = 0; i < sarge.size; i++ )
	{
		if( isalive( sarge[i] ) )
		{
			sarge[i] thread magic_bullet_shield();
			sarge[i].maxsightdistsqrd = 4;
			sarge[i] clearenemy();
			sarge[i].goalradius = 4;
			sarge_node = getnode( "sarge_door", "targetname" );
			sarge[i] setgoalnode( sarge_node );
			level.sarge2 = sarge[i];
		}
	}
	
	// have all other friendlies go to their perspective nodes
	others = getentarray( "new_friends", "script_noteworthy" );
	other_nodes = getnodearray( "others_elevator", "targetname" );
	total_others = 0;
	for( i = 0; i < others.size; i++ )
	{
		if( isalive( others[i] ) )
		{
			total_others++;
			if( total_others <= 3 )
			{
				 
				others[i].maxsightdistsqrd = 4;
				others[i] clearenemy();
				others[i].goalradius = 4;
				others[i].script_ignoreall = 1;
				
				if( total_others == 1 )
				{
					node_to_go = getnode( "others_elevator1", "targetname" );
					others[i] setgoalnode( node_to_go );
					level.other_guy1 = others[i];
				}
				else if( total_others == 2 )
				{
					node_to_go = getnode( "others_elevator2", "targetname" );
					others[i] setgoalnode( node_to_go );
					level.other_guy2 = others[i];
				}
				else
				{
					node_to_go = getnode( "others_elevator3", "targetname" );
					others[i] setgoalnode( node_to_go );
					level.other_guy3 = others[i];
				}
			}
		}
	}
	
	// wait till all others are inside elevator
	while( 1 )
	{
		in_position = 0;
		for( i = 0; i < others.size; i++ )
		{
			if( others[i] istouching( enter_trigger ) )
			{
				in_position++;
			}
		}
		if( in_position == total_others )
		{
			break; // all AIs are inside elevator
		}
		wait( 0.1 );
	}
	
	// now have the sarge enter as well
	sarge_node2 = getnode( "sarge_elevator", "targetname" );
	level.sarge2 setgoalnode( sarge_node2 );
	level.sarge2 waittill( "goal" );
	
	// setup the elevator
	second_door = getent( "door_up", "targetname" );
	elevator = getent( "elevator", "targetname" );
	displacement = 1125;
	time = 15.0;
	
	//level thread elevator_operation( others, enter_trigger, elevator, first_door, second_door, displacement, time );
}


////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

event4()
{
	level thread event4_objectives();
	
	event4_explosions();
	
	event4_elevator1();
	
	event4_elevator2();
	
	exit = getent( "flak_tower_exit", "targetname" );
	exit waittill( "trigger" );
	
	level notify( "event4_ends" );
	
	missionsuccess( "rhi3", false );
}

event4_explosions()
{
	// whenever player hits these triggers, create one or more explosions at it's target
	
	triggers = getentarray( "ev4_explosion_trigger", "targetname" );
	for( i = 0; i < triggers.size; i++ )
	{
		level thread event4_single_explosion( triggers[i] );
	}
}

event4_single_explosion( trigger )
{
	trigger waittill( "trigger" );
	
	destination_name = trigger.target;
	destinations = getentarray( destination_name, "targetname" );
	
	for( i = 0; i < destinations.size; i++ )
	{
		playfx( level.fx_sub_explosion, destinations[i].origin );
		wait( 0.5 );
		playfx( level.fx_sub_explosion, destinations[i].origin );
		wait( 1 );
	}
}

// all friendlies go back to the elevator
event4_elevator1()
{
	inside_trigger = getent( "elevator_inside_4f", "targetname" );
	/*
	level.new_guys = getentarray( "goddard2", "targetname" );
	array_removeDead( level.new_guys );
	
	// tell AIs to go inside
	target_nodes = getnodearray( "elevator_nodes2", "targetname" );
	for( i = 0; i < target_nodes.size; i++ )
	{
		level.new_guys[i] setgoalnode( target_nodes[i] );
	}

	// wait till all friendlies are inside
	while( 1 )
	{
		in_position = 0;
		for( i = 0; i < level.new_guys.size; i++ )
		{
			if( level.new_guys[i] istouching( inside_trigger ) )
			{
					in_position++;
			}
		}
		if( in_position == level.new_guys )
		{
			break; // all AIs are inside elevator
		}
		wait( 0.1 );
	}
	*/
	
	// now wait for all players
	while( 1 )
	{
		players = get_players();
		players_in_position = 0;
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] istouching( inside_trigger ) )
			{
				players_in_position++;
			}
		}
		if( players_in_position == players.size )
		{
			break; // all players are inside
		}
		wait( 0.1 );
	}
	
	// now close door
	door_start = getent( "door_up", "targetname" );
	door_start solid();
	door_start show();
	
	// move elevator and people inside, normal speed
	displacement = -150;
	time = 4;
	elevator = getent( "elevator", "targetname" );
	elevator moveTo( elevator.origin + ( 0, 0, displacement ), time, .05, .05); 
	wait( time );
	level notify( "move_friendlies" );
	
	// now explosion above
	origin_explosion = getent( "elevator_explosion", "targetname" );
	playfx ( level.fx_sub_explosion, origin_explosion.origin );
	
	// elevator drops rapidly
	displacement = -465;
	time = 1.5;
	
	elevator moveTo( elevator.origin + ( 0, 0, displacement ), time, .05, .05); 
	wait( time );
	level notify( "move_friendlies" );
	
	// delete all friendlies
	old_friendlies = getaiarray( "allies" );
	array_Delete( old_friendlies );
	
	// open next door
	door_3f = getent( "elevator_door_3f", "targetname" );
	door_3f notsolid();
	door_3f hide();
	door_3f connectpaths();
	
	spawn_trigger = getent( "3f_spawn", "targetname" );
	spawn_trigger waittill( "trigger" );
	wait( 1 );
	
	new_friends = getentarray( "goddard3", "script_noteworthy" );
	for( i = 0; i < new_friends.size; i++ )
	{
		if( isalive( new_friends[i] ) )
		{
			new_friends[i] setgoalentity ( get_players()[0] );
		}
	}
}

event4_elevator2()
{
	elevator2 = getent( "elevator2", "targetname" );
	elevator2_door = getent( "elevator2_door", "targetname" );
	elevator2_door_bottom = getent( "elevator2_door2", "targetname" );
	elevator2_inside = getent( "elevator2_inside", "targetname" );
	
	// open top door
	elevator2_door hide();
	elevator2_door notsolid();
	elevator2_door connectpaths();
	
	// wait for all players to enter
	while( 1 )
	{
		players = get_players();
		players_in_position = 0;
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] istouching( elevator2_inside ) )
			{
				players_in_position++;
			}
		}
		if( players_in_position == players.size )
		{
			break; // all players are inside
		}
		wait( 0.1 );
	}
	
	// close top door
	elevator2_door show();
	elevator2_door solid();
	elevator2_door disconnectpaths();
	
	// kill all allies
	old_friendlies = getaiarray( "allies" );
	array_Delete( old_friendlies );
	
	// delete friendly wave
	fw = getent( "1f_fx", "targetname" );
	fw delete();
	
	// delete existing chains
	fcs = getentarray( "event3_1f_fc", "targetname" );
	array_Delete( fcs );
	
	// move elevator down
	displacement = -915;
	time = 4;
	elevator2 moveTo( elevator2.origin + ( 0, 0, displacement ), time, .05, .05); 
	wait( time );
	
	// open bottom door
	elevator2_door_bottom hide();
	elevator2_door_bottom notsolid();
	elevator2_door_bottom connectpaths();
	
	//link new friendlies to player
	new_friends = getentarray( "goddard4", "script_noteworthy" );
	for( i = 0; i < new_friends.size; i++ )
	{
		if( isalive( new_friends[i] ) )
		{
			new_friends[i] setgoalentity ( get_players()[0] );
		}
	}
}

event4_objectives()
{
	elevator_target = getent( "ev4_obj1", "targetname" );
	objective_add( 10, "current", level.obj10_string, elevator_target.origin ); // escape
	elevator_trigger = getent( "elevator_inside_4f", "targetname" );
	elevator_trigger waittill( "trigger" );
	
	event4_update_escape_objective( "ev4_obj2", "ev4_obj2_trigger" );
	event4_update_escape_objective( "ev4_obj3", "ev4_obj3_trigger" );
	event4_update_escape_objective( "ev4_obj4", "ev4_obj4_trigger" );
	event4_update_escape_objective( "ev4_obj5", "ev4_obj5_trigger" );
	event4_update_escape_objective( "ev4_obj6", "ev4_obj6_trigger" );
	event4_update_escape_objective( "ev4_obj7", "ev4_obj7_trigger" );
	
	target_pos = getent( "ev4_obj8", "targetname" );
	objective_position( 10, target_pos.origin );
	
	level waittill( "event4_ends" );
	objective_state( 10, "done" );
}

event4_update_escape_objective( next_position, next_trigger )
{
	target_pos = getent( "ev4_obj1", "targetname" );
	objective_position( 10, target_pos.origin );
	target_trigger = getent( next_trigger, "targetname" );
	target_trigger waittill( "trigger" );
}

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

init_friendlychain()
{
	// first node on the friendlychain
	node = getnode("fc_start", "targetname" );

	// set the friendlychain on the player
	get_players()[0] setfriendlychain( node );
	
	//put guys on the squad
	guys = getentarray( "friendly_guy", "script_noteworthy" );	
	for( i = 0; i < guys.size; i++ )
	{
		guys[i] setgoalentity ( get_players()[0] );
	}
}

// add an objective, using given script_origin for positioning
// when specified trigger is hit, the objective is completed
triggered_objective_wait( num, obj_string, origin_name, trigger_name )
{
	obj_target = getent( origin_name, "targetname" );
	obj_trigger = getent( trigger_name, "targetname" );
	
	objective_add( num, "current", obj_string, obj_target.origin );
	obj_trigger waittill( "trigger" );
	objective_state( num, "done" );
	
	level notify( "objective_complete" );
}

finish_event1_objectives()
{
	
}

finish_event2_objectives()
{
	
}

finish_event3_objectives()
{
	
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onPlayerDisconnect();
		player thread onPlayerSpawned();
		player thread onPlayerKilled();
	
		// put any calls here that you want to happen when the player connects to the game
		println("Player connected to game.");
		
		//player setthreatbiasgroup("players");
	}
}

onPlayerDisconnect()
{
	self waittill("disconnect");
	
	// put any calls here that you want to happen when the player disconnects from the game
	// this is a good place to do any clean up you need to do
	println("Player disconnected from the game.");
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		
		// put any calls here that you want to happen when the player spawns
		// this will happen every time the player spawns
		println("Player spawned in to game at " + self.origin);
	}
}

onPlayerKilled()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("killed_player");

		// put any calls here that you want to happen when the player gets killed
		println("Player killed at " + self.origin);
		
	}
}	