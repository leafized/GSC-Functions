//
// file: ber2b_event3.gsc
// description: event 3 script for berlin2 - this map has been split, so this event now occurs in ber2b
// scripter: slayback
//

#include maps\_utility;
#include maps\ber2b;
#include maps\ber2_util;

// -- STARTS --
// starts at the very beginning of ber2b, where the player wakes up from the wave blackout
postwave_wakeup_start()
{
	warp_players_underworld();
	warp_friendlies( "struct_postwave_start_friends", "targetname" );
	warp_players( "struct_postwave_start", "targetname" );
	//set_color_chain( "trig_script_color_allies_b31" );  // DEPRECATED players hit this themselves for now
	
	objectives_skip( 1 );  // skip event 1 & 2 objectives
	
	level thread event3_setup( true );
}

// starts at the beginning of event 3 action
event3_start()
{
	warp_players_underworld();
	warp_friendlies( "struct_event3_start_friends", "targetname" );
	warp_players( "struct_event3_start", "targetname" );
	// set_friendlychain( "node_e3_fc1" );  // DEPRECATED
	set_color_chain( "trig_script_color_allies_b32" );
	
	objectives_skip( 1 );  // skip event 1 & 2 objectives
	
	event3_panther_manualspawn();  // trigger the panther to spawn
	level thread event3_setup();
}

event3_setup( doWakeup )
{
	if( IsDefined( doWakeup ) || doWakeup )
	{
		flag_wait( "introscreen_complete" );
		postwave_wakeup();
	}
	
	level set_objective( 2 );  // activate event 3 objectives
	maps\_status::show_task( "Event_3" );
		
	level thread event3_panther_turret_think();
	level thread event3_panther_kill();
	level thread event3_action();
}

postwave_wakeup()
{
	lock_players();
	iprintlnbold( "Post-wave wakeup sequence goes here" );
	wait( 5 );
	unlock_players();
}

lock_players()
{
	players = get_players();
	
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		player.linkOrg = Spawn( "script_origin", player.origin );
		player LinkTo( player.linkOrg );
	
		player DisableWeapons();
	}
}

unlock_players()
{
	players = get_players();
	
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		ASSERTEX( IsDefined( player.linkOrg ), "Can't find the linker script_origin to which a player is supposed to be linked." );
		
		player Unlink();
		player.linkOrg Delete();
	
		player EnableWeapons();
	}
}

event3_action()
{
	// stub for now
}


// -- PANTHER --
// for when the player won't hit the spawn trigger during regular gameplay (starts, etc).
event3_panther_manualspawn()
{
	trig = GetEnt( "trig_e3_pantherspawn", "targetname" );
	ASSERTEX( IsDefined( trig ), "Panther manual spawn failed because we can't find the trigger!" );
	
	trig notify( "trigger" );
}

// TODO make this smarter after trying w/ coop
event3_panther_turret_think()
{
	level waittill ( "spawnvehiclegroup0" );
	wait( 0.1 );
	panther = GetEnt( "vehicle_e3_panther", "targetname" );
	
	panther endon( "death" );
	
	closestPlayerPercentage = 50;
	
	while( 1 )
	{
		target = get_closest_player( panther.origin );
		
		// if coop, there's a chance that the closest player won't always get slammed
		if( get_players().size > 1 && randomint( 100 ) >= 50 )
		{			
			// get a random player who's not the closest guy
			players = array_randomize( get_players() );
			if( players[0] == target )
			{
				target = players[1];
			}
			else
			{
				target = players[0];
			}
		}
		
		panther SetTurretTargetEnt( target );
		panther FireWeapon();
		wait( RandomFloatRange( 6, 10 ) );
	}
}

event3_panther_kill()
{
	level waittill ( "spawnvehiclegroup0" );
	// If you don't put a wait here it won't find the vehicle on a GetEnt.
	wait( 0.1 );
	panther = GetEnt( "vehicle_e3_panther", "targetname" );
	
	trigger_wait( "trig_e3_panther_use_trigger", "targetname" );
	
	iprintlnbold( "Cool mantling anim!" );
	wait( 2 );
	
	// TODO figure out how the F tank damage works!
	damage = panther.health + 10000;
	expSpot = panther.origin;
	panther DoDamage( damage, ( 0, 0, 0 ) );
	RadiusDamage( expSpot, 256, damage, damage );
	
	level set_objective( 3 );  // complete objective
	
	wait( 1 );
	
	event3_finish();
}
// -- END PANTHER --


// DEPRECATED we're not doing IGCs anymore
/*
event3_play_midlevel_igc( waitForTrigger )
{
	// default = wait for trigger
	if( !IsDefined( waitForTrigger ) || waitForTrigger )
	{
		trigger_wait( "trig_e3_midlevel_igc", "targetname" );
	}
	
	// turn off triggers in the area, so IGC doesn't trip them
	trigs[0] = GetEnt( "trig_e3_fc5", "targetname" );
	trigs[1] = GetEnt( "trig_e3_fc7", "targetname" );
	trigs[2] = GetEnt( "trig_killspawner_16", "targetname" );
	
	for( i = 0; i < trigs.size; i++ )
	{
		if( IsDefined( trigs[i] ) )
		{
			trigs[i] trigger_off();
		}
	}

	maps\_camsys::playback_scene( "midlevel" );  // play the igc
	
	warp_players_underworld();
	
	warp_friendlies( "struct_event3_start_friends", "targetname" );
	// set_friendlychain( "node_e3_fc1" );  // DEPRECATED
	set_color_chain( "trig_script_color_allies_b32" );
	
	warp_players( "struct_event3_start", "targetname" );  // warp players together
	
	// turn triggers back on
	for( i = 0; i < trigs.size; i++ )
	{
		if( IsDefined( trigs[i] ) )
		{
			trigs[i] trigger_on();
		}
	}
}
*/

event3_finish()
{
	level thread kill_all_axis();  // clean up enemies
	
	MissionSuccess( "ber2b" );  // TODO change to ber3 (or whatever the leads want) later
}
// -- END IGCs --
