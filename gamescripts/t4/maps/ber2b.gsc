//
// file: ber2b.gsc
// description: main level script for berlin2b
// scripter: slayback
//

#include maps\_utility;
#include maps\ber2_util;


main()
{
	maps\ber2b_fx::main();  // set up level fx
	
	setdvar("r_watersim_enabled","0");
	build_starts();  // set up level starts
	
	init_flags();

	maps\_panther::main( "vehicle_tiger_woodland" );  // TEMP replace with the Panther model when we get it
	
	setup_friendlies();  // get the initial friendlies set up

	maps\_load::main();  // COD magic
	
	thread maps\ber2b_amb::main();  // kick off ambient scripting
	maps\ber2b_anim::main();  // set up level anims
	// maps\ber2b_status::build_status();  // set up status text
		
	setup_strings();  // set up localized string references for the level
}

// setup the start functions for the level start system
build_starts()
{
	// event 3 starts
	add_start( "postwave", maps\ber2b_event3::postwave_wakeup_start );
	add_start( "event3", maps\ber2b_event3::event3_start );
	
	// default start
	default_start( level.start_functions[ "postwave" ] );
	
	// turn off the introscreen if necessary
	start = tolower( GetDvar( "start" ) );
	if( IsDefined( start ) && start != "" && start != "default" && start != "postwave" )
	{
		SetDvar( "introscreen", "0" );  // disable the introscreen
	}
}

init_flags()
{
	flag_init( "friends_setup" );
}

setup_strings()
{
	level.obj1_string = &"BER2B_OBJ_1";
	level.obj2_string = &"BER2B_OBJ_2";
	level.obj3_string = &"BER2B_OBJ_3";
}

set_objective( num )
{
	if( num == 0 )
	{		
		objective_add( 0, "active", level.obj1_string, get_playerone().origin );
		objective_current( 0 );
	}
	else if( num == 1 )
	{		
		objective_state( 0, "done" );
		objective_add( 1, "active", level.obj2_string, get_playerone().origin );
		objective_current( 1 );
	}
	else if( num == 2 )
	{
		marker = GetStruct( "org_objective3_marker", "targetname" );
		
		objective_state( 1, "done" );
		objective_add( 2, "active", level.obj3_string, marker.origin );
		objective_current( 2 );
	}
	else if( num == 3 )
	{
		objective_state( 2, "done" );
	}
}

// skips past objectives that should have already happened (for skiptos)
objectives_skip( numToSkipPast )
{
	for( i = 0; i <= numToSkipPast; i++ )
	{
		set_objective( i );
	}
}


warp_players_underworld()
{
	// get the spot under the world for temp placement
	underworld = GetStruct( "struct_player_teleport_underworld", "targetname" );
	if( !IsDefined( underworld ) )
	{
		ASSERTMSG( "warp_players_underworld(): can't find the underworld warp spot! aborting." );
		return;
	}
	
	players = get_players();

	for( i = 0; i < players.size; i++ )
	{
		players[i] SetOrigin( underworld.origin );
	}
}


// warp players to a given set of points
warp_players( startValue, startKey )
{
	// get start points
	starts = GetStructArray( startValue, startKey );
	
	ASSERTEX( starts.size == 4, "warp_players(): there aren't 4 player start spots!" );
	
	players = get_players();

	for( i = 0; i < players.size; i++ )
	{
		// Set the players' origin to each start point
		players[i] setOrigin( starts[i].origin );
	
		// Set the players' angles to face the right way.
		players[i] setPlayerAngles( starts[i].angles );
	}
}

// warp player to a given set of points
warp_player( startValue, startKey )
{
	// get start points
	starts = GetEntArray( startValue, startKey );
	ASSERT( starts.size == 4 );
	
	players = get_players();
	index = players.size; 

	// figure out what start index this player should be at
	for( i = 0; i < players.size; i++ )
	{
		if ( players[i] == self )
		{
			index = i;
		}
	}
	
	ASSERT( index < 4 );
	
	// Set the players' origin to each start point
	self setOrigin( starts[index].origin );
	
	// Set the players' angles to face the right way.
	self setPlayerAngles( starts[index].angles );
}

setup_friendlies()
{
	level.friends = grab_starting_friends();	
	ASSERTEX( IsDefined( level.friends ) && level.friends.size > 0, "setup_friendlies(): can't find any friendlies!" );
	
	for( i = 0; i < level.friends.size; i++ )
	{
		guy = level.friends[i];
		
		guy.followmin = -1;
		guy thread magic_bullet_shield();  // TODO remove when we start using friendly_waves
		
		if( IsDefined( guy.script_noteworthy ) && guy.script_noteworthy == "sarge" )
		{
			guy.name = "Sgt. Zietzev";
			level.sarge = guy;
		}
	}
	
	flag_set( "friends_setup" );
}

// warp friendlies to a given set of points
warp_friendlies( startValue, startKey )
{
	ASSERTEX( flag( "friends_setup" ), "warp_friendlies(): level.friends needs to be set up before this runs." );
	
	// get start points
	friendlyStarts = GetStructArray( startValue, startKey );

	ASSERTEX( friendlyStarts.size >= 4, "warp_friendlies(): didn't find 4 or more friendly start points!" );

	for( i = 0; i < level.friends.size; i++ )
	{
		level.friends[i] Teleport( groundpos( friendlyStarts[i].origin ), friendlyStarts[i].angles );
	}
}
