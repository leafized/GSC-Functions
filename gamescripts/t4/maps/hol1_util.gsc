#include common_scripts\utility;
#include maps\_utility;



initialize_spawn_function( name, key, spawn_func )
{
	spawners = getEntArray( name, key );
	
	if( isdefined( spawn_func ) )
	{
		for( i  = 0; i < spawners.size; i++ )
		{
			if( !isdefined( spawners[i].spawn_functions ) )
			{
				spawners[i].spawn_functions = [];
			}
			
			// CODER_MOD - JamesS
			if( !isalive(spawners[i]) )
			{
				spawners[i] add_spawn_function( spawn_func );
			}
			else
			{
				println( "Warning - alive guys can't be spawners" );
			}
		}
	}
}

get_script_origin_by_noteworthy( script_noteworthy_value )
{
	origins = getentarray( script_noteworthy_value, "script_noteworthy" );
	for( i = 0; i < origins.size; i++ )
	{
		if( origins[i].classname == "script_origin" )
		{
			return origins[i];
		}
	}
}

hold_fire( guy )
{
	guy endon( "death" );

	guy.ignoreall = true;
	guy.pacifist = 1;

	guy waittill( "open_fire" );
	guy.ignoreall = false;
	guy.pacifist = 0;
}

open_fire_fake( guy )
{
	guy.ignoreall = false;
	guy.pacifist = 0;
	guy stopanimscripted();
	guy setentitytarget( level.jeep1, 1 );
}

open_fire_fake2( guy )
{
	guy.ignoreall = false;
	guy.pacifist = 0;
	guy stopanimscripted();
	guy setentitytarget( level.jeep2, 1 );
}
	

start_rail_opel( start_node_noteworthy )
{
	start_node = getvehiclenode( start_node_noteworthy, "script_noteworthy" );

	opel = spawnvehicle( 	"vehicle_ger_wheeled_opel_blitz_winter", 
							"truck", 
							"opel", 
							start_node.origin, 
							start_node.angles );

	wait( 0.1 );
			
	playfxontag( level._effect["headlight"], opel, "tag_headlight_left" );
	playfxontag( level._effect["headlight"], opel, "tag_headlight_right" );
	//playfxontag( level._effect["brakelight"], opel, "tag_brakelight_left" );

	opel attachPath( start_node );
	opel startpath();
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

onFirstPlayerConnect()
{
	level waittill( "connecting_first_player", player );

	println( "First player connected to game." );
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connecting", player );

		player thread onPlayerDisconnect();
		player thread onPlayerSpawned();
		player thread onPlayerKilled();

		player setthreatbiasgroup("allies");
	
		// put any calls here that you want to happen when the player connects to the game
		if( level.rail_sequence == true )
		{
			maps\hol1_rail::put_player_on_rail( player );
		}

		println( "Player connected to game." );

		//wait( 2 );
		//player thread maps\_stealth_logic::stealth_ai();
	}
}

onPlayerDisconnect()
{
	self waittill( "disconnect" );
	
	// put any calls here that you want to happen when the player disconnects from the game
	// this is a good place to do any clean up you need to do

	if( level.rail_sequence == true )
	{
		maps\hol1_rail::remove_player_from_rail( self );
	}

	println( "Player disconnected from the game." );
}

onPlayerSpawned()
{
	self endon( "disconnect" );
	
	for(;;)
	{
		self waittill( "spawned_player" );
		
		// put any calls here that you want to happen when the player spawns
		// this will happen every time the player spawns
		println("Player spawned in to game at " + self.origin);

		if( level.rail_sequence == true )
		{
			maps\hol1_rail::put_player_on_rail( self );
		}
	}
}

onPlayerKilled()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill( "killed_player" );

		// put any calls here that you want to happen when the player gets killed
		println( "Player killed at " + self.origin );

		if( level.rail_sequence == true )
		{
			missionfailed();
		}
	}
}

// USED AT START
// Teleport players to positions of specified scrip_origins
teleport_players( struct_name )
{
	starts = getstructarray( struct_name,"targetname" );
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] setOrigin( starts[i].origin );
		players[i] setPlayerAngles( starts[i].angles );
	}
}	


// teleport AIs to specified struct positions
// This will move the player temporarily out of the way
// ONLY use it during starts
friendlies_force_teleport( event_name )
{
	if( event_name == "event3" )
	{
		goddard_start = getstruct( "ev2_goddard_off", "targetname" );
		friend1_start = getstruct( "ev2_friend1_off", "targetname" );
		friend2_start = getstruct( "ev2_friend2_off", "targetname" );

		// teleport player out of the way first. AI won't teleport unless player can't see them
		level thread teleport_player_temp_into_enclosure();

		level.goddard teleport( goddard_start.origin );
		level.friend1 teleport( friend1_start.origin );
		level.friend2 teleport( friend2_start.origin );

		wait( 0.1 ); 
		level notify( "restore_player_positions" );
		wait( 0.1 );
	}
}


// teleport player to a temporary and fully enclosed position
// as to allow AI teleporting (currently they can't while player can see them)
// move players back once teleporting is complete
teleport_player_temp_into_enclosure()
{
	players = get_players();
	old_origins = [];

	origs = getstructarray( "temp_teleport_position", "targetname" );
	if( origs.size >= 4 )
	{
		// store original positions
		for (i = 0; i < players.size; i++)
		{
			old_origins = add_to_array( old_origins, players[i].origin );
			players[i] setOrigin( origs[i].origin );
		}		
		
		level waittill( "restore_player_positions" );
		
		// restore positions
		for (i = 0; i < players.size; i++)
		{
			players[i] setOrigin( old_origins[i] );
		}	
	}
}

initialize_spawn_func( name, key, spawn_func )
{
	spawners = getEntArray( name, key );
	
	if( isdefined( spawn_func ) )
	{
		for( i  = 0; i < spawners.size; i++ )
		{
			if( !isdefined( spawners[i].spawn_functions ) )
			{
				spawners[i].spawn_functions = [];
			}
			spawners[i] add_spawn_function( spawn_func );
		}
	}
}

go_to_node_with_notify( node, msg )
{
	self.goalradius = 4;
	self setgoalnode( node );
	self waittill( "goal" );
	level notify( msg );
}

avoid_combat()
{
	self.pacifist = true;
	self.ignoreall = true;
	self.script_sightrange = 4;
	self.maxsightdistsqrd = 4;
}

resume_combat()
{
	self.pacifist = false;
	self.ignoreall = false;
	self.script_sightrange = 4000000;
	self.maxsightdistsqrd = 4000000;
	self.goalradius = 512;
}
