
#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;

main()
{
	
	// for infantry retreating
	level thread tiger_retreat( "1" );
	level thread tiger_retreat( "2" );

	level thread truck_on_bridge();

	// set up the friendly T34s
	maps\see2::setup_later_tanks();

	// chains that the friendly tanks move on
	level thread basin_tank_chains();

	// make tiger have hud damage indicator
	tiger_tank = getent( "captured_tiger", "targetname" );
	tiger_tank thread maps\see2::vehicle_damage();	

	// TEMP keep tank alive 
	tiger_tank thread keep_tank_alive();

	// event 5
	level thread basin_battle();
	
}
		
				

///////////////////
//
// Trucks that are escaping over the bridge
//
///////////////////////////////

truck_on_bridge()
{

	trig = getent( "trig_guys_on_bridge", "targetname" );
	trig waittill( "trigger" );
	
	simple_spawn( "tiger_bridge_guy" );
	
}



///////////////////
//
// Beginning of the end tank battle
//
///////////////////////////////

basin_battle()
{


	trig = getent( "trig_basin_begin", "targetname"	);
	trig waittill( "trigger" );


	get_players_in_basin_tanks();


	//kill_magic_bullet_shield_town_friendlies();

	//wait( 0.05 );

	kill_all_ai();

	// turn off tank chain so friendlies dont advance too far
	trig = getent( "trig_tank_path_basin_c", "targetname" );
	trig trigger_off();

	quick_text(	"basin begin" );
	
	
	level thread wave_1_panthers();
	level thread wave_2_panthers();

	level.panther_tanks_1_dead = 0;
	level.panther_tanks_2_dead = 0;



	// waittill both waves are killed
	while( !level.panther_tanks_1_dead || !level.panther_tanks_2_dead )
	{
		wait( 0.7 );
	}
	
	quick_text( "all tanks dead!" );
	
	level notify( "obj_basin_2_complete" );
	
	wait( 3 );
	
	end_igc();
	
}



///////////////////
//
// Get players into their appropriate tanks for the end battle
//
///////////////////////////////

get_players_in_basin_tanks()
{
	
	
	players = get_players();
	entry_points = getstructarray( "orig_enter_basin_t34", "targetname" );
	
	tiger_tank = getent( "captured_tiger", "targetname" );
	tiger_owner = tiger_tank getvehicleowner();
	
	
	// if a player is in the tiger
	if( isdefined( tiger_owner ) )
	{
		// find which player is in the tiger
		for( i  = 0; i < players.size; i++ )
		{			
			
			if( tiger_owner == players[i] )
			{
				players = array_remove( players, players[i] );
			}
			
		}
		
	}

	
	// put other players into t34s... currently if no player is in the tiger at the time that get_players_in_basin_tanks() runs,
	// then he will NOT be placed into the tiger. this will need to be fixed. TODO
	for( i  = 0; i < players.size; i++ )
	{

		tank = getent( entry_points[i].target, "targetname" );
		
		// Set the players' origin to the entry point because useby() is based on distance
		players[i] setOrigin( entry_points[i].origin );
		
		tank makevehicleunusable();
		
		tank useby( players[i] );

		// TEMP put in so players don't die in tanks
		tank thread keep_tank_alive();
		
		tank thread maps\see2::vehicle_damage();	
		
	}
		
	
}



///////////////////
//
// Removes magic bullet shield so we dont get an assert
//
///////////////////////////////

kill_magic_bullet_shield_town_friendlies()
{

	allies = get_ai_group_ai( "town_friendly_ai" );
	
	for( i  = 0; i < allies.size; i++ )
	{
		allies[i] thread stop_magic_bullet_shield();	
	}
	
}



///////////////////
//
// Handles first wave of panthers
//
///////////////////////////////

wave_1_panthers()
{


	// wait till we're close enough to start the panthers
	trig = getent( "trig_move_panthers_1", "targetname"	);
	trig waittill( "trigger" );

	quick_text(	"moving	panthers 1!" );
	
	wait( 1 );	

	// keep track of how many panthers remain
	level thread monitor_panther_1_tanks();	

	
	// get array of all friendlies so panthers know who to target
	// (TODO this probably doesn't need to be called in both panther wave threads)
	group_basin_friendly_tanks();


	// enemy tank behavior
	enemy_tanks	= getentarray( "basin_panther_1",	"targetname" );
	
	for( i = 0;	i <	enemy_tanks.size; i++ )
	{
		enemy_tanks[i] thread panther_strat();
	}


	level.enemy_basin_tanks = enemy_tanks;


	// friendlies fight back
	for( i  = 0; i < level.friendly_tanks.size; i++ )
	{
		level.friendly_tanks[i] thread basin_friendly_strat();
	}
	
}



///////////////////
//
// Handles second wave of panthers
//
///////////////////////////////

wave_2_panthers()
{
	

	// wait till we're close enough to start the panthers
	trig = getent( "trig_move_panthers_2", "targetname"	);
	trig waittill( "trigger" );

	quick_text(	"moving	panthers 2!" );


	// spawn infantry around train
	level thread setup_end_train_guys();

	// keep track of how many enemy tanks remain
	level thread monitor_panther_2_tanks();	


	// move up the panthers to engage the russians
	enemy_tanks	= getentarray( "basin_panther_2",	"targetname" );
	
	
	// get array of all friendlies so panthers know who to target
	group_basin_friendly_tanks();
	
	// panther attack strategy
	array_thread( enemy_tanks, ::panther_strat );
	
	
	// wave 3
	// wait till we're near the train and then have the remainder of the panthers roll up
	trig = getent( "trig_move_panthers_3", "targetname" );
	trig waittill( "trigger" );

	enemy_tanks_extra = getentarray( "basin_panther_2a", "script_noteworthy" );	
	
	array_thread( enemy_tanks_extra, ::panther_strat );
	
	// move up friendlies manually
	
	trig = getent( "trig_tank_path_basin_d", "targetname" );
	trig notify( "trigger" );	
	
	
}



///////////////////
//
// Panther's pathing
//
///////////////////////////////

panther_patrol()
{

	self endon( "death" );
	self endon( "stop_patrolling" );
	
	self setspeed( 17, 12, 9 );
	

	original_path = getent( self.script_noteworthy, "targetname" );
	alternate_path = getent( original_path.target, "targetname" );
	
	// make them path between two points repeatedly
	while( 1 )
	{
	

		self setVehGoalPos( original_path.origin + ( 0, 0, 0 ) , 1 );
		self setGoalYaw ( original_path.angles[1] );
		
		self waittillmatch ( "goal" );
		
		wait( randomintrange( 3, 6 ) );
		
		// slow down their speed
		self setspeed( 14, 6, 7 );		
		
		
		self setVehGoalPos( alternate_path.origin + ( 0, 0, 0 ) , 1 );
		self setGoalYaw ( alternate_path.angles[1] );
		
		self waittillmatch ( "goal" );		
		
		wait( randomintrange( 3, 5 ) );
		
		
	}
	
	
}



///////////////////
//
// Figure out which tanks the panthers will target and fire at
//
///////////////////////////////

group_basin_friendly_tanks()
{

	// account for player tanks
	tank = getent( "player_tank_basin_1", "targetname" );
	level.friendly_basin_tanks = add_to_array( level.friendly_basin_tanks, tank );

	tank = getent( "player_tank_basin_2", "targetname" );
	level.friendly_basin_tanks = add_to_array( level.friendly_basin_tanks, tank );
	
	tank = getent( "player_tank_basin_3", "targetname" );
	level.friendly_basin_tanks = add_to_array( level.friendly_basin_tanks, tank );
	
	
	// account for tiger tank
	tiger_tank = getent( "captured_tiger", "targetname" );
	level.friendly_basin_tanks = add_to_array( level.friendly_basin_tanks, tiger_tank );
	
	
	// account for friendly tanks
	tank = getent( "basin_ally_tank_1", "targetname" );
	level.friendly_basin_tanks = add_to_array( level.friendly_basin_tanks, tank );

	tank = getent( "basin_ally_tank_2", "targetname" );
	level.friendly_basin_tanks = add_to_array( level.friendly_basin_tanks, tank );
	
	tank = getent( "basin_ally_tank_3", "targetname" );
	level.friendly_basin_tanks = add_to_array( level.friendly_basin_tanks, tank );
	
	tank = getent( "basin_ally_tank_4", "targetname" );
	level.friendly_basin_tanks = add_to_array( level.friendly_basin_tanks, tank );						
	
}



///////////////////
//
// Keep track of first wave of panther tanks
//
///////////////////////////////

monitor_panther_1_tanks()
{

	while( 1 )
	{
		
		tanks = getentarray( "basin_panther_1", "targetname" );
		tanks_left = 0;
		
		for( i = 0; i < tanks.size; i++ )
		{
			if( tanks[i].health > 0 )
			{
				tanks_left++;
			}
		}
	
		//quick_text( "tanks_left: " + tanks_left );
	
		if( tanks_left == 0 )
		{
			break	;
		}
	
		wait( 1 );
		
	}
	
	quick_text( "wave_1_destroyed" );
	
	// move up friendly tanks
	trig = getent( "trig_tank_path_basin_c", "targetname" );
	trig trigger_on();
	trig notify( "trigger" );

	level.panther_tanks_1_dead = 1;	

	level notify( "obj_basin_1_complete" );

	level.enemy_basin_tanks = getentarray( "basin_panther_2", "targetname" );
	quick_text( level.enemy_basin_tanks.size + " more tanks to kill!" );
	
	
		// stop previous strat
	level notify( "stop_basin_friendly_strat" );

	// friendlies fight back
	for( i  = 0; i < level.friendly_tanks.size; i++ )
	{
		level.friendly_tanks[i] thread basin_friendly_strat();
	}
	
	

}



///////////////////
//
// Keep track of second wave of panther tanks
//
///////////////////////////////

monitor_panther_2_tanks()
{

	while( 1 )
	{
		
		tanks = getentarray( "basin_panther_2", "targetname" );
		tanks_left = 0;
		
		for( i = 0; i < tanks.size; i++ )
		{
			if( tanks[i].health > 0 )
			{
				tanks_left++;
			}
		}
	
		//quick_text( "tanks_left: " + tanks_left );
	
		if( tanks_left == 0 )
		{
			break	;
		}
	
		wait( 1 );
		
	}
	
	quick_text( "wave_2_destroyed" );

	level.panther_tanks_2_dead = 1;	

}



///////////////////
//
// How the panthers behave in the basin
//
///////////////////////////////

panther_strat()
{
	
	self endon( "death" );

	current_target = undefined;

	// TODO see TODO below about "death" notify
	if( self.health > 1 )
	{
		// tank's movement
		self thread panther_patrol();
	}

	// Main loop which makes the vehicle fire on the nearest group it's been set to attack
	while( 1 )
	{
			
		if ( level.friendly_basin_tanks.size != 0 )
		{
			current_target = self maps\_vehicle::get_nearest_target( level.friendly_basin_tanks );
		}
		else
		{
			//there are no friendly tanks to shoot... possibly do something here
			return;
		}
		
		// if it's a death vehicle, remove it from the list of valid targets
		if ( current_target.health <= 0 )
		{
			level.friendly_basin_tanks = array_remove( level.friendly_basin_tanks, current_target );
			continue;
		}
			
		// TODO why arent these tanks getting "death" notifies when they're killed? shouldn't this be something in _vehicle?
		if( self.health < 1 )
		{
			self notify( "death" );	
			return;
		}
		
		// set the target ent for the vehicle. offset a bit so it doesnt shoot into the ground
		self setturrettargetent( current_target, ( RandomIntRange( -75, 75 ), RandomIntRange( -75, 75 ), 50 ) );
		wait ( randomintrange( 4, 6 ) );
		self fireweapon();
			
	}
	
}



///////////////////
//
// To determine how friendly tanks act. right now this is identical to the enemy tanks behavior
//
///////////////////////////////

basin_friendly_strat()
{
	
	self endon( "death" );
	level endon( "stop_basin_friendly_strat" );

	current_target = undefined;

	// Main loop which makes the vehicle fire on the nearest group it's been set to attack
	while( 1 )
	{
			
		if ( level.enemy_basin_tanks.size != 0 )
		{
			current_target = self maps\_vehicle::get_nearest_target( level.enemy_basin_tanks );
		}
		else
		{
			//there are no enemy tanks to shoot... possibly do something here
			return;
		}
		
		// if it's a death vehicle, remove it from the list of valid targets
		if ( current_target.health <= 0 )
		{
			level.enemy_basin_tanks = array_remove( level.enemy_basin_tanks, current_target );
			continue;
		}
		
		// TODO why arent these tanks getting "death" notifies when they're killed? shouldn't this be something in _vehicle?
		if( self.health < 1 )
		{
			self notify( "death" );
			return;
		}
		
		
		// set the target ent for the vehicle. offset a bit so it doesnt shoot into the ground
		self setturrettargetent( current_target, ( 0, 0, 50 ) );
		wait ( randomintrange( 4, 6 ) );
		self fireweapon();
			
	}
	
}



///////////////////
//
// Friendly tank chains in basin area
//
///////////////////////////////

basin_tank_chains()
{
	
	tank_chain_basin( "aa" );
	tank_chain_basin( "a" );
	tank_chain_basin( "b" );
	tank_chain_basin( "c" );
	tank_chain_basin( "d" );
	
}



basin_tank_chains_skip()
{
	
	tank_chain_basin( "a" );
	tank_chain_basin( "b" );
	tank_chain_basin( "c" );
	tank_chain_basin( "d" );
	
}



///////////////////
//
// Handles retreat behavior in event 4
//
///////////////////////////////

tiger_retreat( trig_num )
{

	// TODO check this
	level endon( "obj_tiger_complete" );
	
	trig = getent( "trig_tiger_retreat_" + trig_num, "targetname" );
	trig waittill( "trigger" );
	
	quick_text( "tiger_retreat " + trig_num );
	
	guys = get_ai_group_ai( "tiger_ai_" + trig_num );
	
	if( guys.size )
	{
		goto_retreat_nodes( guys );	
	}
	
}



///////////////////
//
// Handles tank "friendly chains" 
//
///////////////////////////////

tank_chain_basin( chain_letter )
{

	trig = getent( "trig_tank_path_basin_" + chain_letter, "targetname" );
	trig waittill( "trigger" );	
	
	level.event_info settext( "path " + chain_letter );
	level notify( "end_current_tank_paths" );
	
	pathstart = getent( "path_basin_t34_1_" + chain_letter,"targetname" );
	level.friendly_tanks[0] thread tank_move( pathstart );

	pathstart = getent( "path_basin_t34_2_" + chain_letter,"targetname" );
	level.friendly_tanks[1] thread tank_move( pathstart );

	pathstart = getent( "path_basin_t34_3_"  + chain_letter,"targetname" );
	level.friendly_tanks[2] thread tank_move( pathstart );	

	pathstart = getent( "path_basin_t34_4_"  + chain_letter,"targetname" );
	level.friendly_tanks[3] thread tank_move( pathstart );	
	
}



setup_end_train_guys()
{
	
	simple_spawn( "end_train_spawner" );
	
}



end_igc()
{

	simple_spawn( "basin_friendly_spawners" );

	level thread maps\_camsys::playback_scene( "end" );

	level waittill( "plackback_finished" );

	missionsuccess( "see3", false );

}

