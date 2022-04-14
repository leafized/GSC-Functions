#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;
#include maps\_anim;

// see2_grave script

main()
{

	trig = getent( "trig_obj_2", "targetname" );
	trig waittill( "trigger" );
	
	level notify( "obj_field_complete" );
	
	maps\_status::show_task( "Event2" );
	
	level thread goliaths();
	
	graveyard_tanks();
	
}



///////////////////
//
// Start goliaths
//
///////////////////////////////

goliaths()
{
	
	// goliath setup here
	
	level thread goliath_canned_left();
	level thread goliath_canned_right();
	
	level thread goliaths_left();
	level thread goliaths_right();
	
}



///////////////////
//
// Goliaths that spawn on left path
//
///////////////////////////////

goliaths_left()
{
	
	trig = getent( "trig_goliaths_player_left", "targetname" );
	trig waittill( "trigger" );	
	
	quick_text( "left goliaths coming at player!" );

	vehicleArray = maps\_vehicle::scripted_spawn( 14 );
	
	array_thread( vehicleArray, ::goliath_strat );
	
}



///////////////////
//
// Goliaths that spawn on right path
//
///////////////////////////////

goliaths_right()
{

	trig = getent( "trig_goliaths_player_right", "targetname" );
	trig waittill( "trigger" );

	quick_text( "right goliaths coming at player!" );
	
	vehicleArray = maps\_vehicle::scripted_spawn( 13 );
	
	array_thread( vehicleArray, ::goliath_strat );
	//array_thread( vehicleArray, ::goliath_strat_explode );

}



///////////////////
//
// The strategy used by the goliaths
//
///////////////////////////////

goliath_strat()
{

	self endon( "death" );
	self endon( "stop_goliath" );

	self setspeed( 9, 7, 6 );
	
	wait_time = 4;
	
	while( 1 )
	{
		
		target_ent = get_random_player();
		self setvehgoalpos( target_ent.origin, 0 );

		self thread goliath_strat_explode( target_ent, wait_time );
		
		wait( wait_time );
		
	}

}



///////////////////
//
// Separate strategy thread that checks if goliath is near enough to the player to explode
//
///////////////////////////////

goliath_strat_explode( target_ent, wait_time )
{

	self endon( "death" );


	for( i  = 0; i < wait_time; i++ )
	{
	
		if( distance( self.origin, target_ent.origin ) < 100 )
		{
		
			quick_text( "goliath too close! you lose!" );
			self notify( "stop_goliath" );
			self setvehgoalpos( self.origin, 0 );
			self setcontents( 0 );
			
			return;
			//radiusdamage();
			
		}
		
		wait( 1 );
			
		
	}
	

}



///////////////////
//
// Canned moment of goliath killing friendly tank
//
///////////////////////////////

goliath_canned_left()
{
	
	trig = getent( "trig_goliath_left", "targetname" );
	trig waittill( "trigger" );	

	tank = getent( "goliath_victim_left", "targetname" );
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 12 );
	
	level thread maps\_vehicle::gopath( tank );	

	tank waittill( "reached_end_node" );

	quick_text( "goliath_explosion!" );

	// blow it up!
	playfx( level._effect["grenadeExp_dirt"], tank.origin + ( 0, 0, 100 ) );
	playfx( level._effect["grenadeExp_dirt"], tank.origin + ( 50, -50, 0 ) );
	playfx( level._effect["large_vehicle_explosion"], tank.origin );

	tank dodamage( tank.health + 1000, ( 0, 0, 0 ) );	
	
}



///////////////////
//
// Canned moment of goliath killing friendly tank
//
///////////////////////////////

goliath_canned_right()
{
		
	trig = getent( "trig_goliath_right", "targetname" );
	trig waittill( "trigger" );	
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 11 );
	
	tank = getent( "goliath_victim_right", "targetname" );
	
	level thread maps\_vehicle::gopath( tank );	
	
	tank waittill( "reached_end_node" );
	
	quick_text( "goliath_explosion!" );
	
	// blow it up!
	playfx( level._effect["grenadeExp_dirt"], tank.origin + ( 0, 0, 100 ) );
	playfx( level._effect["grenadeExp_dirt"], tank.origin + ( 50, -50, 0 ) );
	playfx( level._effect["large_vehicle_explosion"], tank.origin );

	tank dodamage( tank.health + 1000, ( 0, 0, 0 ) );	

}



///////////////////
//
// Guys that spawn around graveyard tanks
//
///////////////////////////////

grave_spawners()
{

	trig = getent( "trig_grave_spawners", "targetname" );
	trig waittill( "trigger" );
	
	simple_spawn( "grave_spawners_1" );
	
}



///////////////////
//
// Figure out which tanks the panthers will target and fire at
//
///////////////////////////////

group_grave_friendly_tanks()
{

	// get friendly tanks
	
	tank = getent( "player_tank_1", "targetname" );
	level.friendly_grave_tanks = add_to_array( level.friendly_grave_tanks, tank );

	tank = getent( "player_tank_2", "targetname" );
	level.friendly_grave_tanks = add_to_array( level.friendly_grave_tanks, tank );
	
	tank = getent( "player_tank_3", "targetname" );
	level.friendly_grave_tanks = add_to_array( level.friendly_grave_tanks, tank );
	
	tank = getent( "player_tank_4", "targetname" );
	level.friendly_grave_tanks = add_to_array( level.friendly_grave_tanks, tank );						
	
	
	// TODO right now these are invinc, but need to account for them being dead at this spot when the invinc is removed
	
	tank = getent( "t34_1", "targetname" );
	level.friendly_grave_tanks = add_to_array( level.friendly_grave_tanks, tank );	
	
	tank = getent( "t34_2", "targetname" );
	level.friendly_grave_tanks = add_to_array( level.friendly_grave_tanks, tank );	
	
	tank = getent( "t34_3", "targetname" );
	level.friendly_grave_tanks = add_to_array( level.friendly_grave_tanks, tank );				
	
}



///////////////////
//
// Mid-level igc
//
///////////////////////////////

mid_igc()
{

	trig = getent( "trig_mid_igc_start", "targetname" );
	trig waittill( "trigger" );
	
	quick_text( "mid_igc!" );

	kill_all_ai();

	wait( 3 );

	level notify( "obj_graveyard_complete" );

	level notify( "stop_draw_tank_locations" );

	get_players_out_of_tank();

	maps\see2_town::mid_igc_begin();

}



///////////////////
//
// Get players out of tank so the mid IGC can start
//
///////////////////////////////

get_players_out_of_tank()
{

	players = get_players();
	
	for( i= 0; i < level.player_tanks.size; i++ )
	{

		owner = level.player_tanks[i] getvehicleowner();	

		for( j = 0; j < players.size; j++ )
		{
		
			if( IsDefined( owner ) && owner == players[j] )
			{
				level.player_tanks[i] useby( players[j] );
				break;
			}		
			
		}

	}
	
	

	
//	player_out_of_tank = false;
//	
//	player_tank_1 = getent( "player_tank_1", "targetname" );	
//
//	// wait till player is out of tank before teleporting him
//	while( !player_out_of_tank )
//	{
//	
//		players = get_players();
//		//owner = player_tank_1 getvehicleowner();
//		
//		for( i = 0; i < players.size; i++ )
//		{
//		
////			if( IsDefined( owner ) && owner != players[i] )
////			{
////				player_out_of_tank = true;
////			}
//			
//		}
//		
//		wait( 0.3 );
//		
//	}
	
	
	
}



///////////////////
//
// Handles the graveyard tank battle
//
///////////////////////////////

graveyard_tanks()
{

	trig = getent( "trig_spawn_grave_tanks", "targetname" );
	trig waittill( "trigger" );

	wait( 1 );
	
	group_grave_friendly_tanks();
	
	// cleanup ai
	kill_all_ai();
	
	// remove mgs in the field to prevent max turret error (32 turrets max)
	mg42s = getentarray( "field_mgs", "script_noteworthy" );
	for( i  = 0; i < mg42s.size; i++ )
	{
		mg42s[i] notify( "stopfiring" );
		waittillframeend;
		mg42s[i] delete();
	}
	
	level thread grave_spawners();
	level thread graveyard_ambush();
	level thread graveyard_tanks_2();
	
}



///////////////////
//
// Panthers ambush Russians
//
///////////////////////////////

graveyard_ambush()
{

	
	trig = getent( "trig_graveyard_ambush", "targetname" );
	trig waittill( "trigger" );
	
	// make panthers shoot at the allies
	tanks = getentarray( "graveyard_panthers", "targetname" );
	array_thread( tanks, ::graveyard_panther_strat );
	
	level.enemy_grave_tanks	= tanks;

	// friendlies fight back	
	array_thread( level.friendly_tanks, ::graveyard_friendly_strat );
	
	
}



///////////////////
//
// Mobile panthers at the end of event 2
//
///////////////////////////////

graveyard_tanks_2()
{

	trig = getent( "trig_move_vehiclegroup_21", "targetname" );
	trig waittill( "trigger" );

	wait( 0.1 );

	tanks = getentarray( "graveyard_panthers_2", "targetname" );	
	array_thread( tanks, ::graveyard_panther_strat );

	// add mobile panthers to list of threats
	level.enemy_grave_tanks = array_combine( level.enemy_grave_tanks, tanks );

	level thread mid_igc();
	
}



///////////////////
//
// How the panthers behave in the graveyard
//
///////////////////////////////

graveyard_panther_strat()
{
	
	self endon( "death" );
	level endon( "obj_graveyard_complete" );

	current_target = undefined;

	// move tank if it's not disabled
	if( self.targetname == "graveyard_panthers_2" )
	{
		self thread maps\see2_tiger::panther_patrol();
	}

	// Main loop which makes the vehicle fire on the nearest group it's been set to attack
	while( 1 )
	{
			
		if ( level.friendly_grave_tanks.size != 0 )
		{
			current_target = self maps\_vehicle::get_nearest_target( level.friendly_grave_tanks );
		}
		else
		{
			//there are no friendly tanks to shoot... possibly do something here
			return;
		}
		
		// if it's a death vehicle, remove it from the list of valid targets
		if ( current_target.health <= 0 )
		{
			level.friendly_grave_tanks = array_remove( level.friendly_grave_tanks, current_target );
			continue;
		}
		else if( distance( current_target.origin, self.origin ) > 2500 )
		{
		
			// TODO add this type of check for end tank battle
			// if the target is far away, wait a while and recalculate targets			
			wait( 3 );
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
// To determine how friendly tanks act. right now this is identical to the enemy tanks behavior
//
///////////////////////////////

graveyard_friendly_strat()
{
	
	self endon( "death" );
	level endon( "stop_grave_friendly_strat" );
	level endon( "obj_graveyard_complete" );

	current_target = undefined;

	// Main loop which makes the vehicle fire on the nearest group it's been set to attack
	while( 1 )
	{
			
		if ( level.enemy_grave_tanks.size != 0 )
		{
			
			current_target = self maps\_vehicle::get_nearest_target( level.enemy_grave_tanks );

			// if the target is far away, wait a while and recalculate targets			
			if( distance( current_target.origin, self.origin ) > 2500 )
			{
				wait( 3 );
				continue;
			}
			
		}
		else
		{
			//there are no enemy tanks to shoot... possibly do something here
			return;
		}
		
		// if it's a death vehicle, remove it from the list of valid targets
		if ( current_target.health <= 0 )
		{
			level.enemy_grave_tanks = array_remove( level.enemy_grave_tanks, current_target );
			continue;
		}
		

		// TODO why arent these tanks getting "death" notifies when they're killed? shouldn't this be something in _vehicle?
		if( self.health < 1 )
		{
			self notify( "death" );	
			return;
		}
		
		// set the target ent for the vehicle
		self setturrettargetent( current_target, ( RandomIntRange( -75, 75 ), RandomIntRange( -75, 75 ), 50 ) );
		wait ( randomintrange( 4, 6 ) );
		self fireweapon();
			
		
			
	}
	
}
