//
// file: rhi2_event_sweep.gsc
// description: "clean sweep" event script for rhineland2
// scripter: slayback
//

#include maps\_utility;
#include common_scripts\utility;
#include maps\rhi2;
#include maps\rhi2_util;

// --- STARTS ---
// normal map start
event_sweep_start()
{
	warp_players( "struct_sweep_start", "targetname" );
	warp_friendlies( "struct_sweep_start_friends", "targetname" );
	
	// play the intro cinematic
	level waittill( "finished final intro screen fadein" );
	wait( 3 );
	play_intro_igc();

	level thread event_sweep_setup();
}

event_sweep_start_barricade1()
{
	SetDvar( "introscreen", "0" );
	
	warp_players( "struct_barricade1_start", "targetname" );
	warp_friendlies( "struct_barricade1_start_friends", "targetname" );
	
	level thread event_sweep_setup( "barricade1" );
}

event_sweep_start_sweep2()
{
	SetDvar( "introscreen", "0" );
	
	warp_players( "struct_sweep2_start", "targetname" );
	warp_friendlies( "struct_sweep2_start_friends", "targetname" );
	
	level thread event_sweep_setup( "sweep2" );
}
// --- END STARTS ---

play_intro_igc()
{
	level waittill( "controls_active" );
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] FreezeControls( true );
	}
	
	iprintlnbold( "**a tank gets owned, chaos ensues**" );
	wait( 7 );
	iprintlnbold( "ok, we can't move up any further til it's clear!" );
	wait( 4 );
	iprintlnbold( "infantry, clear the area..." );
	wait( 2 );
	iprintlnbold( "then radio back and we'll move up." );
	wait( 2 );
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] FreezeControls( false );
	}
}

event_sweep_setup( startSpot )
{
	maps\_status::show_task( "sweep" );
		
	flag_clear( "convoy_move1" );
	flag_clear( "convoy_move2" );
	flag_clear( "convoy_move3" );
	flag_clear( "convoy_barricade1_flametank_go" );
	flag_clear( "convoy_barricade1_flametank_done" );
	flag_clear( "barricade1_cavedoor_fc_hit" );
	flag_clear( "convoy_past_barricade2" );
	
	convoy_setup();
	ei_setup();
	radioman_setup();
	
	// raise the flood_spawner trigger at barricade1 til we want it active
	GetEnt( "trig_spawner_barricade1guys", "script_noteworthy" ) trigger_off();
	
	if( !IsDefined( startSpot ) )
	{
		thread event_sweep_action1();
	}
	else if( startSpot == "barricade1" )
	{
		objectives_skip( 1 );
		thread convoy_movement_barricade1( true );
		thread event_sweep_action2();
	}
	else if( startSpot == "sweep2" )
	{
		objectives_skip( 3 );
		set_friendlychain( "node_sweep_fc25" );
		thread convoy_movement_sweep2( true );
		thread event_sweep_action3();
	}
}

// manages level action for the first house clearing area
event_sweep_action1()
{
	/*
	if( GetDvarInt( "introscreen" ) != 0 )
	{
		level waittill( "finished final intro screen fadein" );
	}
	*/
	
	set_objective( 1 );
	
	set_friendlychain( "node_sweep_fc1" );
	
	thread convoy_movement_sweep1();
	thread rocketmen_init( "trig_spawner_sweep_rocketgroup1", "rocketman_sweep1", "convoy_move2", "sbmodel_rocketgroup1_nosight" );
	thread runners_group_cleanup( "trig_sweep_runnersgroup1", "aigroup_sweep_runnersgroup1" );
	
	// move 1
	wait( 2 );
	flag_set( "convoy_move1" );
	
	// stop 1
	level waittill( "convoy_stopped" );	
	thread radioman_think();
	thread objective_follow_ent( 1, level.radioman );
	// TODO need VO
	//iprintlnbold( "clear out those houses" );
	
	// wait for radioman use
	level waittill( "radioman_used" );
	level notify( "stop_radioman_think" );
	level notify( "objective_stop_following_ent" );
	
	// move 2
	flag_set( "convoy_move2" );
	iprintlnbold( "roger, convoy moving up" );
	
	level thread event_sweep_action2();
}

// manages level action for the first barricade area
event_sweep_action2()
{	
	// clear old chain triggers and set friendlychain next to barricade
	trigs = GetEntArray( "trigs_sweep_area1_house_fctrigs", "script_noteworthy" );
	ASSERTEX( IsDefined( trigs ) && trigs.size > 0, "Triggers with script_noteworthy of trigs_sweep_area1_house_fctrigs could not be found" );
	for( i = 0; i < trigs.size; i++ )
	{
		trigs[i] trigger_off();
	}
	
	// set barricade1 flood_spawner trigger back on
	GetEnt( "trig_spawner_barricade1guys", "script_noteworthy" ) trigger_on();
	
	wait( 0.1 );
	set_friendlychain( "node_sweep_fc5" );
	
	// update objective state
	objective_state( 1, "done" );
	
	trigger_wait( "trig_sweep_atBarricade1", "targetname" );
	
	// DEPRECATED
	//set_friendlychain( "node_sweep_fc21" );
	
	// DEPRECATED
	// wait for any player to pass barricade
	/*
	playerCrossed = false;
	while( !playerCrossed )
	{
		players = get_players();
		
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			if( player.origin[1] > -1400 )
			{
				playerCrossed = true;
				break;
			}
		}
		
		if( playerCrossed )
		{
			break;
		}
		else
		{
			wait( 0.1 );
		}
	}
	*/
	
	// then wait a few beats to destroy the barricade and call in the flame tank
	wait( 15 );
	
	// TODO radioman VO
	iprintlnbold( "get em boys!" );
	
	flag_set( "convoy_barricade1_flametank_go" );
	
	flag_wait( "sweep_barricade1_cleared" );
	
	wait( 3 );
	
	// DEPRECATED
	// friendlies move past barricade
	//set_friendlychain( "node_sweep_fc21" );
	
	// DEPRECATED
	//thread event_sweep_barricade1_fc_failsafe();
	
	// wait for the flame tank to get to the flame node
	GetEnt( "vehicle_convoy_tank2", "targetname" ) waittill( "stopped_at_node" );
	
	set_friendlychain( "node_sweep_fc25" );
	
	// DEPRECATED
	/*
	// friendlies move to cave entrance (if necessary)
	if( !flag( "barricade1_cavedoor_fc_hit" ) )
	{
		set_friendlychain( "node_sweep_fc23" );
	}
	*/
	
	// wait for the flame tank to be done
	flag_wait( "convoy_barricade1_flametank_done" );
	
	// DEPRECATED
	// update objective
	//set_objective( 2 );
	// wait for player to get through the cave/bunker
	//trigger_wait( "trig_sweep_barricade1_caveclear", "targetname" );
	
	set_objective( 3 );
	
	trigger_wait( "trig_barricade1_roadRegroupSpot", "targetname" );
	level thread event_sweep_action3();
}
	

// manages level action for the second house clearing area
event_sweep_action3()
{
	thread rocketmen_init( "trig_spawner_sweep2_rocketgroup1", "rocketman_sweep2", "convoy_move3" );
	
	iprintlnbold( "you guys clear the road up ahead..." );
	wait( 2 );
	iprintlnbold( "you know the drill, radio back when it's clear." );
	
	set_objective( 4 );
	set_friendlychain( "node_sweep_fc27" );
	
	// radioman ready for use again
	thread radioman_think();
	thread objective_follow_ent( 4, level.radioman );
	
	// wait for radioman use
	level waittill( "radioman_used" );
	
	objective_state( 4, "done" );
	
	flag_set( "convoy_move3" );
	iprintlnbold( "roger, convoy moving up" );
	level notify( "stop_radioman_think" );
	level notify( "objective_stop_following_ent" );
	
	// new friendlychain & clean up trigger-based ones
	trigs = GetEntArray( "trigs_sweep_area2_house_fctrigs", "script_noteworthy" );
	for( i = 0; i < trigs.size; i++ )
	{
		trigs[i] trigger_off();
	}
	
	set_friendlychain( "node_sweep_fc38" );
	
	// wait for convoy to get past the second barricade and stop
	flag_wait( "convoy_past_barricade2" );
	
	// TODO start walk with convoy
	level thread maps\rhi2_event_convoywalk::event_convoywalk_setup();
}

// DEPRECATED
/*
event_sweep_barricade1_fc_failsafe()
{
	GetEnt( "trig_sweep_fc25", "targetname" ) waittill( "trigger" );
	flag_set( "barricade1_cavedoor_fc_hit" );
}
*/


// --- CONVOY ---
// sets up level.convoy_array
convoy_setup()
{
	if( IsDefined( level.convoyWasSetup ) && level.convoyWasSetup )
	{
		return;
	}
	else
	{
		level.convoyWasSetup = true;
	}
	
	level.convoy_array = [];
	
	// TODO figure out a more automated way of getting convoy vehicles
	level.tank1 = GetEnt( "vehicle_convoy_tank1", "targetname" );
	level.tank2 = GetEnt( "vehicle_convoy_tank2", "targetname" );
	level.tank1.health = 2000;  // TEMP hack until script_startinghealth works, or we change rocket damage, or we change sherman health value
	level.tank2.health = 2000;
	level.convoy_array = array_add( level.convoy_array, level.tank1 );
	level.convoy_array = array_add( level.convoy_array, level.tank2 );
	
	ASSERTEX( level.convoy_array.size > 0, "convoy setup failed because the convoy array is empty." );
	
	for( i = 0; i < level.convoy_array.size; i++ )
	{
		ASSERTEX( IsDefined( level.convoy_array[i] ), "one of the vehicles in the convoy array is undefined!" );
	}
	
	thread convoy_monitor_health();
}

convoy_monitor_health()
{
	level endon( "stop_monitoring_convoy_health" );
	
	level.convoy_healthAtStart = convoy_get_total_health();
	
	while( 1 )
	{
		string = "convoy health: " + convoy_get_total_health() + " / " + level.convoy_healthAtStart;
		Print3D( level.convoy_array[0].origin + ( 0, 0, 70 ), string, ( 1, 1, 1 ), 1, 0.75 );
		
		if( convoy_get_total_health() < ( level.convoy_healthAtStart / 2 ) )
		{
			convoy_mission_failed();
			break;
		}
		
		wait( 0.05 );
	}
}

convoy_mission_failed()
{
	level notify( "mission failed" );
	setDvar( "ui_deadquote", &"RHI2_MISSION_FAILED_CONVOYDEATH" );
	maps\_utility::missionFailedWrapper();
}

// gets the combined health of all vehicles in level.convoy_array
convoy_get_total_health()
{
	totalhealth = undefined;
	
	if( IsDefined( level.convoy_array ) && level.convoy_array.size > 0 )
	{
		for( i = 0; i < level.convoy_array.size; i++ )
		{
			vehicle = level.convoy_array[i];
			
			if( IsDefined( vehicle ) )
			{
				if( !IsDefined( totalhealth ) )
				{
					totalhealth = 0;
				}
				
				totalhealth += vehicle.health;
			}
		}
	}
	else
	{
		totalhealth = 0;
	}
	
	return totalhealth;
}

// handles the convoy movement throughout the event
convoy_movement_sweep1()
{
	flag_wait( "convoy_move1" );

	GetEnt( "trig_convoy_move1", "targetname" ) notify( "trigger" );
	
	GetVehicleNode( "vnode_convoy_tank1_stop1", "targetname" ) waittill( "trigger" );
	
	if( !flag( "convoy_move2" ) )
	{
		//iprintlnbold( "stopping convoy" );
		thread convoy_setspeed( 0, 30 );
		level notify( "convoy_stopped" );	
	}
	
	flag_wait( "convoy_move2" );
	thread convoy_resumespeed( 10 );
	
	level thread convoy_movement_barricade1();
}

convoy_movement_barricade1( skippedTo )
{
	// skip the convoy forward if we're using a start
	if( IsDefined( skippedTo ) && skippedTo )
	{
		GetEnt( "trig_convoy_move1", "targetname" ) notify( "trigger" );
		
		flag_set( "convoy_move1" );
		flag_set( "convoy_move2" );
		
		thread convoy_setspeed( 100, 1000 );
	}
	
	// stop at the barricade
	GetVehicleNode( "vnode_convoy_tank1_barricade1", "targetname" ) waittill( "trigger" );
	
	// stop them faster if they're skipping forward
	if( IsDefined( skippedTo ) && skippedTo )
	{
		thread convoy_setspeed( 0, 1000 );
	}
	else
	{
		thread convoy_setspeed( 0, 30 );
	}
	
	level notify( "convoy_stopped" );
	
	flag_wait( "convoy_barricade1_flametank_go" );
	
	// open the barricade and send up the flame tank
	thread convoy_open_barricade1();
	thread convoy_barricade1_flamecave();
	
	flag_wait( "convoy_barricade1_flametank_done" );
	
	level thread convoy_movement_sweep2();
}

convoy_movement_sweep2( skippedTo )
{
	// skip the convoy forward if we're using a start
	if( IsDefined( skippedTo ) && skippedTo )
	{
		GetEnt( "trig_convoy_move1", "targetname" ) notify( "trigger" );
		
		flag_set( "convoy_move1" );
		flag_set( "convoy_move2" );
		flag_set( "convoy_barricade1_flametank_go" );
		flag_set( "convoy_barricade1_flametank_done" );
		
		thread convoy_setspeed( 100, 1000 );
	}
	
	flag_wait( "convoy_move3" );
	
	// move convoy
	tank1 = GetEnt( "vehicle_convoy_tank1", "targetname" );
	tank2 = GetEnt( "vehicle_convoy_tank2", "targetname" );
	node1 = GetVehicleNode( "vnode_convoy_tank1_sweep2_pathStart", "targetname" );
	node2 = GetVehicleNode( "vnode_convoy_tank2_sweep2_pathStart", "targetname" );
	
	tank1 AttachPath( node1 );
	tank1 SetSpeed( 10, 10 );
	tank1 thread maps\_vehicle::vehicle_paths( node1 );
	tank2 AttachPath( node2 );
	tank2 SetSpeed( 10, 10 );
	tank2 thread maps\_vehicle::vehicle_paths( node2 );
		
	// barbed wire rollover
	thread convoy_sweep2_barbedwire_rollover();
	
	// push sdk out of the way
	thread convoy_push_sdk();
	
	waittill_multiple_ents( tank1, "reached_end_node", tank2, "reached_end_node" );
	
	flag_set( "convoy_past_barricade2" );
}

convoy_sweep2_barbedwire_rollover()
{
	wait( 0.05 );
	GetVehicleNode( "vnode_convoy_tank1_sweep2_midBarricade", "targetname" ) waittill( "trigger" );
	
	spool = GetEnt( "sbmodel_barricade2_barbedwire1", "targetname" );
	
	spool ConnectPaths();
	spool MoveTo( spool.origin + ( 0, 0, -44 ), 1, 0.25, 0.75 );
}

convoy_push_sdk( skippedTo )
{
	if( !IsDefined( skippedTo ) || !skippedTo )
	{
		wait( 0.05 );
		GetVehicleNode( "vnode_convoy_tank1_barricade2", "targetname" ) waittill( "trigger" );
	}
	/*
	else
	{
		// trigger the sdk to roll up
		GetEnt( "trig_barricade2_sdk", "targetname" ) notify( "trigger" );
		wait( 0.1 );
		sdk = GetEnt( "vehicle_barricade2_sdk", "targetname" );
		sdk SetSpeed( 100, 1000 );
		sdk waittill( "reached_path_end" );
	}
	*/
	
	sdk = GetEnt( "vehicle_barricade2_sdk", "targetname" );
	pushPathStart = GetStruct( "struct_sdk_push_pathStart", "targetname" );
	
	// swap the vehicle for a script_model
	sdk DoDamage( sdk.health + 200, ( 0, 0, 0 ) );
	fake_sdk = Spawn( "script_model", sdk.origin );
	fake_sdk Hide();
	fake_sdk SetModel( "vehicle_german_armored_car" );
	fake_sdk.angles = sdk.angles;
	sdk Hide();
	fake_sdk Show();
	
	org = Spawn( "script_origin", sdk.origin );
	org.angles = sdk.angles;
	
	// TODO we probably want to animate the SDK getting pushed out of the way
	fake_sdk LinkTo( org );
	
	pathpoint = pushPathStart;
	defaultMoveTime = 2;
	
	while( IsDefined( pathpoint ) )
	{
		if( IsDefined( pathpoint.script_float ) )
		{
			movetime = pathpoint.script_float;
		}
		else
		{
			movetime = defaultMoveTime;
		}
		
		org MoveTo( pathpoint.origin, movetime );
		org waittill( "movedone" );
		
		// get next pathpoint
		if( IsDefined( pathpoint.target ) )
		{
			pathpoint = GetStruct( pathpoint.target, "targetname" );
		}
		else
		{
			pathpoint = undefined;
		}
	}
	
	fake_sdk Unlink();
	
	wait( 0.1 );
	org Delete();
	
	
	// DEPRECATED
	/*
	wall_left = GetEnt( "sbmodel_sweep_barricade2_left", "targetname" );
	wall_right = GetEnt( "sbmodel_sweep_barricade2_right", "targetname" );
	
	wall_left ConnectPaths();
	wall_right ConnectPaths();
	
	//flag_set( "barricade2_doors_connected" );
	
	wall_left RotateTo( ( 0, 120, 0 ), 2 );
	wall_right RotateTo( ( 0, -120, 0 ), 2 );
	
	wall_right waittill( "rotatedone" );
	
	wall_left DisconnectPaths();
	wall_right DisconnectPaths();
	*/
	
	flag_set( "sweep_barricade2_cleared" );
}

convoy_barricade1_flamecave()
{
	// kill the spawners
	GetEnt( "trig_script_killspawner_1", "targetname" ) notify( "trigger" );
	
	// get the AIs and send them into the cave
	ais = get_ai_group_ai( "sweep_cavespawners" );
	for( i = 0; i < ais.size; i++ )
	{
		if( is_active_ai( ais[i] ) )
		{
			ais[i].ignoreall = true;
			ais[i].goalradius = 512;
			ais[i] SetGoalPos( ( 180, 428, -685.9 ) );
		}
	}
	
	// move lead tank
	leadtank = GetEnt( "vehicle_convoy_tank1", "targetname" );
	leadtank SetSpeed( 10, 10 );
	leadtank thread vehicle_stop_at_node( "vnode_convoy_tank1_barricade1a" );
	
	// wait for the lead tank to move out the way
	wait( 3 );
	
	// move flametank
	flametank = GetEnt( "vehicle_convoy_tank2", "targetname" );
	flametank SetSpeed( 10, 10 );
	flametank thread convoy_barricade1_flamecave_crush_barbedwire();
	flametank vehicle_stop_at_node( "vnode_convoy_tank2_barricade1_flamespot" );
	
	// flame the door
	cavedoor_org = GetEnt( "org_barricade1_cavedoor", "targetname" );
	flametank SetTurretTargetEnt( cavedoor_org );
	flametank waittill( "turret_on_target" );
	wait( 1.3 );
	flametank thread convoy_barricade1_flamecave_faketankflame();
	
	// kill off the cave AIs
	ais = get_ai_group_ai( "sweep_cavespawners" );
	for( i = 0; i < ais.size; i++ )
	{
		if( is_active_ai( ais[i] ) )
		{
			ais[i] bloody_death( true, 0 );
		}
	}
	
	cavedoor_org Delete();
	
	flag_set( "convoy_barricade1_flametank_done" );
	
	// DEPRECATED
	// wait til the player clears the cave then move forward again
	//GetEnt( "trig_sweep_barricade1_caveclear", "targetname" ) waittill( "trigger" );
	
	// wait for players to move beyond cave area
	trigger_wait( "trig_barricade1_roadRegroupSpot", "targetname" );
	
	flametank SetSpeed( 5, 5 );
}

// self = the flametank
convoy_barricade1_flamecave_crush_barbedwire()
{
	GetVehicleNode( "vnode_convoy_flametank_barbedwire", "targetname" ) waittill( "trigger" );
	
	spool = GetEnt( "sbmodel_barricade1_barbedwire1", "targetname" );
	
	spool ConnectPaths();
	spool MoveTo( spool.origin + ( 0, 0, -44 ), 1, 0.25, 0.75 );
}

// self = the flametank
convoy_barricade1_flamecave_faketankflame()
{	
	flametime = 4;
	timer = GetTime();
	
	barrelOrigin = self GetTagOrigin( "tag_flash" );
	barrelAngles = self GetTagAngles( "tag_flash" );
	
	while( flametime * 1000 > GetTime() - timer )
	{
		PlayFX( level._effect["flamethrower_fire"], barrelOrigin, barrelAngles );
		wait( RandomFloatRange( 0.3, 0.7 ) );
	}
}

// opens the first barricade
// TODO make it fancy
convoy_open_barricade1( string )
{
	wall_left = GetEnt( "sbmodel_sweep_barricade1_left", "targetname" );
	wall_right = GetEnt( "sbmodel_sweep_barricade1_right", "targetname" );
	
	wall_left ConnectPaths();
	wall_right ConnectPaths();
	
	//flag_set( "barricade1_doors_connected" );
	
	wall_left RotateTo( ( 0, 120, 0 ), 2 );
	wall_right RotateTo( ( 0, -120, 0 ), 2 );
	
	wall_right waittill( "rotatedone" );
	
	wall_left DisconnectPaths();
	wall_right DisconnectPaths();
	
	flag_set( "sweep_barricade1_cleared" );
}

// does SetSpeed on all the vehicles in level.convoy_array
convoy_setspeed( speed, accel, decel )
{
	ASSERTEX( IsDefined( level.convoy_array ), "can't set convoy speed because level.convoy_array is undefined." );
	
	if( IsDefined( level.convoy_array ) && level.convoy_array.size > 0 )
	{
		for( i = 0; i < level.convoy_array.size; i++ )
		{
			if( IsDefined( decel ) )
			{
				level.convoy_array[i] SetSpeed( speed, accel, decel );
			}
			else
			{
				level.convoy_array[i] SetSpeed( speed, accel );
			}
		}
	}
}

// does ResumeSpeed on all the vehicles in level.convoy_array
convoy_resumespeed( accel )
{
	ASSERTEX( IsDefined( level.convoy_array ), "can't resume convoy speed because level.convoy_array is undefined." );
	
	if( IsDefined( level.convoy_array ) && level.convoy_array.size > 0 )
	{
		for( i = 0; i < level.convoy_array.size; i++ )
		{
			level.convoy_array[i] ResumeSpeed( accel );
		}
	}
}

// self = the vehicle
// - stopNodeTN = the targetname of the vehiclenode where the vehicle should stop
vehicle_stop_at_node( stopNodeTN )
{
	GetVehicleNode( stopNodeTN, "targetname" ) waittill( "trigger" );
	self SetSpeed( 0, 30 );
	self notify( "stopped_at_node" );
}
// --- END CONVOY ---


// --- RADIOMAN ---
radioman_setup()
{
	if( !IsDefined( level.radiomanWasSetup ) || !level.radiomanWasSetup )
	{
		level.radiomanWasSetup = true;
	}
	else
	{
		return;
	}
	
	level.radioman = GetEnt( "radioman", "script_noteworthy" );
	
	ASSERT( is_active_ai( level.radioman ), "Can't find the radioman!" );
	
	level.radioman magic_bullet_shield();
}

// makes the radioman a usable guy who calls up the convoy
//  can be stopped and started as convoy moves and stops
radioman_think()
{
	level endon( "stop_radioman_think" );
	
	trig = GetEnt( "trig_radioman", "targetname" );
	
	timer = -1;
	buttonHoldTime = 3;
	buttonBeingHeld = false;
	
	while( 1 )
	{
		players = get_players();
		triggered = false;
		
		while( !triggered )
		{
			// move trigger origin to radioman if necessary
			if( trig.origin != level.radioman.origin )
			{
				trig.origin = level.radioman.origin;
			}
			
			printed = false;
			
			// check all players
			for( i = 0; i < players.size; i++ )
			{
				player = players[i];
				
				// if inside the trigger...
				if( player IsTouching( trig ) )
				{
					// make sure we're not already printing from another player being in the trigger
					if( !printed )
					{
						// if not holding button...
						if( !buttonBeingHeld )
						{
							string = "hold X to call tanks forward";
						}
						// if holding button, give a message for the player
						else
						{
							string = "keep holding to verify";
						}
						
						Print3D( level.radioman GetEye() + ( 0, 0, 7 ), string, ( 1, 1, 1 ), 1, 0.25 );
						printed = true;
					}
					
					// if this player is pressing the use button...
					if( player useButtonPressed() )
					{
						// toggle if necessary
						if( !buttonBeingHeld )
						{
							buttonBeingHeld = true;
						}
						
						// start timer if necessary
						if( timer == -1 )
						{
							timer = GetTime();
						}
						// otherwise see if timer has reached the desired value
						else
						{
							if( ( GetTime() - timer ) >= ( buttonHoldTime * 1000 ) )
							{
								triggered = true;
							}
						}
					}
					// if not pressing use button...
					else
					{
						// toggle if necessary
						if( buttonBeingHeld )
						{
							buttonBeingHeld = false;
						}
						if( timer != -1 )
						{
							timer = -1;
						}
					}
				}
			}
			
			// wait if we didn't trigger yet
			if( !triggered )
			{
				wait( 0.05 );
			}
		}
		
		level notify( "radioman_used" );
		wait( 1 );
	}
}
// --- END RADIOMAN ---


// --- PATHRUNNERS ---
// grabs a specified aigroup after their trigger (also specified) is hit, waits for
//  them to hit their last chained goalnode, and kills them off
runners_group_cleanup( triggerTN, aiGroupName )
{
	trig = GetEnt( triggerTN, "targetname" );
	
	if( !IsDefined( trig ) )
	{
		ASSERTMSG( "Can't find trigger with targetname " + triggerTN );
		return;
	}
	
	trig waittill( "trigger" );
	wait( 1 );
	
	ais = get_ai_group_ai( aiGroupName );
	
	if( !IsDefined( ais ) || ais.size < 0 )
	{
		ASSERTMSG( "Couldn't find any runners with aiGroupName of " + aiGroupName + ", aborting" );
		return;
	}
	
	for( i = 0; i < ais.size; i++ )
	{
		ais[i] thread runner_kill_at_path_end();
	}
}

// self = the ai
runner_kill_at_path_end()
{
	self endon( "death" );
	self waittill( "reached_path_end" );
	self bloody_death( true, 2 );
}
// --- END PATHRUNNERS ---


// --- ROCKETMEN ---
// sets up a group of rocketmen, specified with rocketmenSN
//  rocketmen_spawnTrig = the trigger that will spawn the rocketmen
//  convoy_moveFlag = the flag the rocketmen will wait for before showing themselves
//  sightblockerTN = the targetname of the sbmodels that block the vision of
//   the rocketmen before they show themselves
rocketmen_init( rocketmen_spawnTrig, rocketmenSN, convoy_moveFlag, sightBlockerTN )
{
	// debug steez
	/#
	if( GetDvarInt( "rocketmen_skip" ) > 0 )
	{
		iprintlnbold( "skipping rocketmen setup since dvar rocketmen_skip is > 0" );
		return;
	}
	#/
	
	trigger_wait( rocketmen_spawnTrig, "targetname" );
	
	wait( 1 );  // wait for these guys to spawn
	
	guys = get_ais( rocketmenSN, "script_noteworthy" );
	
	if( IsDefined( guys ) && guys.size > 0 )
	{
		for( i = 0; i < guys.size; i++ )
		{
			guy = guys[i];
			if( is_active_ai( guy ) )
			{
				guy thread rocketman_target_tank( convoy_moveFlag );
				guy thread rocketman_death_save();
				
				// TEMP for testing
				//level thread drawline_from_player( guy );
			}
		}
	}
	
	if( IsDefined( sightBlockerTN ) )
	{
		thread rocketman_remove_sightblockers( convoy_moveFlag, sightBlockerTN );
	}			
}

// TEMP for testing
drawline_from_player( ent1 )
{
	self endon( "kill_lines" );
	ent1 endon( "death" );

	color = ( 0, 255, 0 );

	while( 1 )
	{
		if( IsDefined( ent1 ) )
		{
			player = get_players()[0];
			line( player.origin, ent1.origin, color );
			wait( 0.05 );
		}
		else
		{
			break;
		}
	}
}

// removes sightblocker(s) in front of a rocketman when it's time for him to shoot
rocketman_remove_sightblockers( convoy_moveFlag, sightBlockerTN )
{
	blockers = GetEntArray( sightBlockerTN, "targetname" );
		
	if( IsDefined( blockers ) && blockers.size > 0 )
	{
		flag_wait( convoy_moveFlag );
		
		array_thread( blockers, ::trigger_off );  // TODO maybe just delete?
	}
}

// sets some pre-ambush AI params, then waits for the flag that moves the convoy up,
//  then sets new AI params and does an ambush (open shutters, target tank, etc.)
// self = the rocketman
rocketman_target_tank( convoy_moveFlag )
{
	self endon( "death" );
	
	// TODO special behavior before ambush?
	self.pacifist = 1;
	self.ignoreme = 1;
	
	flag_wait( convoy_moveFlag );
	
	// post-ambush behavior
	
	// open shutters
	self rocketman_open_shutters();
	
	self.pacifist = 0;
	self.suppressionwait = 0;
	
	self thread print_when_firing();
	
	// while the rocket is equipped...
	while( self animscripts\utility::usingRocketLauncher() )
	{
		// try to target each vehicle in the convoy in turn
		for( i = 0; i < level.convoy_array.size; i++ )
		{
			while( IsDefined( level.convoy_array[i] ) && level.convoy_array[i].health > 0 )
			{
				self SetEntityTarget( level.convoy_array[i] );
				wait( 3 );
			}
		}
		
		if( convoy_get_total_health() > 0 )
		{
			wait( 0.05 );
		}
		else
		{
			break;
		}
	}
	
	self ClearEnemy();
}

// self = the rocketman
rocketman_death_save()
{
	self endon( "stop_rocketman_deathsave" );
	
	self waittill( "death" );
	
	autosave_by_name( "rocketman_killed" );
}

// self = the rocketman
// TEMP til we get some sound fx
print_when_firing()
{
	self endon( "death" );
	
	timelimit = 20;
	startTime = GetTime();
	
	while( ( timelimit * 1000 ) > ( GetTime() - startTime ) )
	{
		self waittill( "fire" );
		Print3D( self.origin + ( 0, 0, 64 ), "FIRE!", ( 1, 1, 1 ), 1, 0.75, 300 );
	}
}

// opens the shutters (or other visible sight blockers) that are
//  targeted from the rocketman himself
// self = the rocketman
rocketman_open_shutters()
{
	self endon( "death" );
	
	shutter_left = undefined;
	shutter_right = undefined;
	
	shutters = GetEntArray( self.target, "targetname" );
	
	if( IsDefined( shutters ) && shutters.size > 0 )
	{
		for( i = 0; i < shutters.size; i++ )
		{
			shutter = shutters[i];
			
			if( IsDefined( shutter.script_noteworthy ) )
			{
				if( shutter.script_noteworthy == "shutter_left" )
				{
					shutter_left = shutter;
				}
				else if( shutter.script_noteworthy == "shutter_right" )
				{
					shutter_right = shutter;
				}
			}
		}
	}
	
	if( !IsDefined( shutter_left ) || !IsDefined( shutter_right ) )
	{
		ASSERTMSG( "shutters with targetname " + self.target + " couldn't be found." );
		return;
	}
	
	openAngle = 120;
	openAngle_opp = -120;
	
	shutter_left RotateTo( ( 0, openAngle, 0 ), RandomFloatRange( 0.4, 0.8 ) );
	Print3D( shutter_left.origin, "BANG!", ( 1, 1, 1 ), 1, 0.75, 150 );
	wait( RandomFloat( 1 ) );
	shutter_right RotateTo( ( 0, openAngle_opp, 0 ), RandomFloatRange( 0.4, 0.8 ) );
	Print3D( shutter_right.origin, "BANG!", ( 1, 1, 1 ), 1, 0.75, 150 );
	
	shutter_right waittill( "rotatedone" );
	
	// note: notify is on the rocketman
	self notify( "shutters_opened" );	
}
// --- END ROCKETMEN ---


// --- ENVIRONMENT INTERACTIONS ---
// sets up the environment interactions: kickable doors, bashable windows, etc.
ei_setup()
{
	// set up doors
	doorTrigTN = "usetrig_sweep_kickable_door";
	doorTrigs = GetEntArray( doorTrigTN, "targetname" );
	
	if( IsDefined( doorTrigs ) && doorTrigs.size > 0 )
	{
		for( i = 0; i < doorTrigs.size; i++ )
		{
			trig = doorTrigs[i];
			
			// error check
			if( trig.classname == "trigger_use" )
			{
				level thread ei_door_think( trig );
			}
			else
			{
				ASSERTMSG( "Oops, when setting up EI triggers, we found an entity of class " + trig.classname + " (origin " + 
				trig.origin + " ), but we're expecting it to be of class trigger_use." );
			}
		}
	}
	// if we didn't find any, there's something wrong
	else
	{
		ASSERTMSG( "Couldn't find any door kick triggers with targetname " + doorTrigTN );
	}
	
	// TODO do the same for windows, etc.
}

// trig = the use trigger that will kick off the environmental interaction
ei_door_think( trig )
{
	// try to get the doors early, so debugging broken ones will be much easier
	ASSERTEX( IsDefined( trig.target ), "The door kick trigger at origin " + trig.origin + " has no target specified." );	
	doors = GetEntArray( trig.target, "targetname" );
	ASSERTEX( IsDefined( doors ) && doors.size > 0, "Can't find any door entities with targetname " + trig.target + " for the door kick trigger at origin " + trig.origin + "." );	
	
	// now wait for the player to use the trigger
	// TODO localize, possibly move to the map file
	trig SetHintString( "Press [USE] to breach the door." );
	trig waittill( "trigger" );
	
	// see if we want to spawn anyone inside the house
	if( IsDefined( trig.script_noteworthy ) )
	{
		spawnTrig = GetEnt( trig.script_noteworthy, "targetname" );
		if( IsDefined( spawnTrig ) )
		{
			if( !IsDefined( spawnTrig.wasTriggered ) || !spawnTrig.wasTriggered )
			{
				spawnTrig.wasTriggered = true;
				spawnTrig notify( "trigger" );
			}
		}
	}
	
	// TODO play a door kicking anim or something
	
	doorLeft = undefined;
	doorRight = undefined;
	
	// open the door(s)
	for( i = 0; i < doors.size; i++ )
	{
		door = doors[i];
		
		ASSERT( IsDefined( door ), "Oops, one of the doors with targetname " + trig.target + " is not defined." );
		ASSERT( IsDefined( door.script_noteworthy ), "One of the doors with targetname " + trig.target + " does not have a script_noteworthy telling us what kind of door it is!" );
		
		if( door.script_noteworthy == "door_left" )
		{
			// open to the left
			door thread ei_door_open( "left" );
			doorLeft = door;
		}
		else if( door.script_noteworthy == "door_right" )
		{
			// open to the right
			door thread ei_door_open( "right" );
			doorRight = door;
		}
		else
		{
			ASSERTMSG( "Oops, one of the doors with targetname " + trig.target + " has a script_noteworthy of " + door.script_noteworthy + ", which doesn't match any of the types we're looking for. Is there a typo?" );
		}
	}
	
	if( IsDefined( doorLeft ) && IsDefined( doorRight ) )
	{
		level waittill_multiple( "ei_door_opened_left", "ei_door_opened_right" );
	}
	else if( IsDefined( doorLeft ) )
	{
		level waittill( "ei_door_opened_left" );
	}
	else if( IsDefined( doorRight ) )
	{
		level waittill( "ei_door_opened_right" );
	}
	
	level notify( "ei_door_open_finished" );
	trig Delete();
}

// self = the door that's opening
// TODO add sounds and particles
ei_door_open( direction )
{
	ASSERTEX( direction == "left" || direction == "right", "The direction you specified, '" + direction + "', is not valid. Typo?" );
	
	openTimeMin = 0.2;
	openTimeMax = 0.45;
	openAngle = 0;
	
	if( direction == "left" )
	{
		if( IsDefined( self.script_int ) )
		{
			openAngle = self.script_int;
		}
		else
		{
			openAngle = 120;
		}
	}
	else if( direction == "right" )
	{
		if( IsDefined( self.script_int ) )
		{
			// make sure this'll work with negative numbers for those times when I'm actually thinking
			if( self.script_int < 0 )
			{
				openAngle = self.script_int;
			}
			else
			{
				openAngle = self.script_int * -1;
			}
		}
		else
		{
			openAngle = -120;
		}
	}
	else
	{
		// should never happen so make it look weird
		openAngle = 45;
	}
	
	self ConnectPaths();
	self RotateTo( ( 0, openAngle, 0 ), RandomFloatRange( openTimeMin, openTimeMax ) );
	self waittill( "rotatedone" );
	self DisconnectPaths();
	
	notifyString = "ei_door_opened_" + direction;
	level notify( notifyString );
}
// --- END ENVIRONMENT INTERACTIONS ---
