#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;


main()
{
	
	level.campaign = "russian";
	
	maps\_panther::main( "vehicle_ger_tracked_panther" ); 
	maps\_t34::main( "vehicle_rus_tracked_t34" );	
	
	default_start( ::field_begin );

	maps\_load::main();	
	
	/*
	level.firing = [];
	level.firing[0] = undefined;
	level.firing[1] = GetEntArray( "firingpos1", "script_noteworthy" );
	level.firing[2] = GetEntArray( "firingpos2", "script_noteworthy" );
	level.firing[3] = GetEntArray( "firingpos3", "script_noteworthy" );
	level.firing[4] = GetEntArray( "firingpos4", "script_noteworthy" );
	*/
}

field_begin()
{
	thread setup_early_tanks();
	
	wait_for_first_player();
	wait( 4 );
	
	setup_player_tanks();
}

setup_early_tanks()
{
	/*
	level.player_tanks[0] = getent( "player_tank_1", "targetname" );
	level.player_tanks[1] = getent( "player_tank_2", "targetname" );
	level.player_tanks[2] = getent( "player_tank_3", "targetname" );
	*/
	level.player_tanks[3] = getent( "player_tank_4", "targetname" );
	
	// TEMP put in so players don't die in tanks
	/*
	level.player_tanks[0] thread keep_tank_alive();
	level.player_tanks[1] thread keep_tank_alive();
	level.player_tanks[2] thread keep_tank_alive();
	*/
	level.player_tanks[3] thread keep_tank_alive();
}

setup_player_tanks()
{
	level.players = get_players();
	entry_points = getstructarray( "orig_enter_tanks", "targetname" );
	
	
	for( i  = 0; i < level.players.size; i++ )
	{
		
		level.players[i].ignoreme = true;
		
		tank = getent( entry_points[i].target, "targetname" );
		
		// Set the players' origin to the entry point because useby() is based on distance
		level.players[i] setOrigin( tank gettagorigin( "tag_enter_driver" ) );
		
		tank makevehicleunusable();
		
		tank useby( level.players[i] );
		
		level.player_in_tank = true;

		// god mode for tanks
		tank thread keep_tank_alive();
		
	}
	
	for( i = 1; i < 5; i++ )
	{
		level.pantherwaves[i] = GetEntArray( "wave"+i+"panthers", "script_noteworthy" );
		for( j = 0; j < level.pantherwaves[i].size; j++ )
		{
			level.pantherwaves[i][j] thread panther_strat(i);
		}
	}
}

panther_strat( wave )
{
	if( wave < 4 )
	{
		target = wave + 1;
	}
	else
	{
		target = 1;
	}
	targetnode = GetEnt( "node"+target, "script_noteworthy" );
	/*
	firetargetnode = level.firing[wave][randomint(level.firing[wave].size)];
	self setturrettargetent( firetargetnode, (0, 0, 50) );
	self thread panther_fire();
	*/
	self SetSpeed( 17, 15, 5 );
	self setVehGoalPos( targetnode.origin );
	while( 1 )
	{
		self waittill( "goal" );
		
		target++;
		//firetargetnode = level.firing[target-1][randomint(level.firing[target-1].size)];
		//self setturrettargetent( firetargetnode, (0, 0, 50) );
		if( target > 4 )
		{
			target = 1;
		}
		targetnode = GetEnt( "node"+target, "script_noteworthy" );
		self returnPlayerControl();
		wait( 0.05 );
		self setSpeed( 0, 0.1, 400 );
		wait( 5 );
		self SetSpeed( 17, 15, 5 );
		self setVehGoalPos( targetnode.origin );
	}
}

panther_fire()
{
	while( 1 )
	{
		wait( randomintrange( 1, 3 ) );
		self fireweapon();
	}
}