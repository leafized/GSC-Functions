//
// file: rhi2.gsc
// description: main level script for rhineland2
// scripter: slayback
//

#include maps\_utility;
#include common_scripts\utility;
#include maps\rhi2_util;

main()
{
	build_starts();  // set up level starts
	init_flags();  // set up level flags
	//build_threatbias_groups();
	
	maps\_sherman::main( "vehicle_american_sherman" );
	maps\_sherman::main( "vehicle_usa_tracked_shermanm4a3" );
	maps\_sdk::main( "vehicle_german_armored_car" );
	maps\_tiger::main( "vehicle_tiger_woodland" );  // TODO replace with Nashorn!
	
	maps\_load::main();  // COD magic
		
	// Spinrad (08/01/07): kick off level sounds
	thread maps\rhi2_amb::main();

	setup_friendlies();  // get the initial friendlies set up
	//maps\rhi2_anim::main();  // set up level anims
	maps\rhi2_fx::main();  // set up level fx
	maps\rhi2_status::build_status();  // set up status text
	//maps\createcam\rhi2_cam::main();  // set up level cinematic cameras
		
	setup_strings();  // set up localized string references for the level
}

build_starts()
{		
	// sweep event starts
	add_start( "sweep", maps\rhi2_event_sweep::event_sweep_start );
	add_start( "barricade1", maps\rhi2_event_sweep::event_sweep_start_barricade1 );
	add_start( "sweep2", maps\rhi2_event_sweep::event_sweep_start_sweep2 );
		
	// convoywalk event starts
	add_start( "convoywalk", maps\rhi2_event_convoywalk::event_convoywalk_start );
		
	// bridge event starts
	add_start( "bridge", maps\rhi2_event_bridge::event_bridge_start );
		
	// church event starts
	add_start( "church", maps\rhi2_event_church::event_church_start );
	
	// default start
	add_start( "default", level.start_functions[ "sweep" ] );
	default_start( level.start_functions[ "sweep" ] );
}

init_flags()
{
	flag_init( "friends_setup" );
	
	// convoy movement flags for the sweep event
	flag_init( "convoy_move1" );
	flag_init( "convoy_move2" );
	flag_init( "convoy_move3" );
	
	// action at the first barricade
	flag_init( "sweep_barricade1_cleared" );
	flag_init( "convoy_barricade1_flametank_go" );
	flag_init( "convoy_barricade1_flametank_done" );
	flag_init( "barricade1_cavedoor_fc_hit" );
	
	// second barricade
	flag_init( "sweep_barricade2_cleared" );
	flag_init( "convoy_past_barricade2" );
	
	// convoywalk
	flag_init( "midlevel_igc_done" );
	
	// bridge
	flag_init( "convoy_crossbridge" );
	flag_init( "bridge_mgnest_destroyed" );
}

setup_strings()
{
	level.obj1_string = &"RHI2_OBJ_1";  // take out rocket guys
	level.obj2_string = &"RHI2_OBJ_2";  // clear the cave
	level.obj3_string = &"RHI2_OBJ_3";  // regroup on road
	level.obj4_string = &"RHI2_OBJ_4";  // take out rocket guys (again)
	level.obj5_string = &"RHI2_OBJ_5";  // keep moving thru town w/ convoy
	level.obj6_string = &"RHI2_OBJ_6";  // clear bridge of anti-tank
	level.obj7_string = &"RHI2_OBJ_7";  // disable nashorn
}

set_objective( num )
{
	// take out rocket guys
	if( num == 1 )
	{
		structTN = "struct_objective1_marker";
		marker = GetStruct( structTN, "targetname" );
		ASSERTEX( IsDefined( marker ), "Couldn't find objective marker with targetname " + structTN );
		
		objective_add( 1, "active", level.obj1_string, marker.origin );
		objective_current( 1 );
	}
	
	// DEPRECATED
	/*
	// clear the cave
	if( num == 2 )
	{
		objective_state( 1, "done" );
		structTN = "struct_objective2_marker";
		marker = GetStruct( structTN, "targetname" );
		ASSERTEX( IsDefined( marker ), "Couldn't find objective marker with targetname " + structTN );
		
		objective_add( 2, "active", level.obj2_string, marker.origin );
		objective_current( 2 );
	}
	*/
	
	// regroup on the road
	if( num == 3 )
	{
		objective_state( 2, "done" );
		structTN = "struct_objective3_marker";
		marker = GetStruct( structTN, "targetname" );
		ASSERTEX( IsDefined( marker ), "Couldn't find objective marker with targetname " + structTN );
		
		objective_add( 3, "active", level.obj3_string, marker.origin );
		objective_current( 3 );
	}
	// take out rocket guys (again)
	if( num == 4 )
	{
		objective_state( 3, "done" );
		structTN = "struct_objective4_marker";
		marker = GetStruct( structTN, "targetname" );
		ASSERTEX( IsDefined( marker ), "Couldn't find objective marker with targetname " + structTN );
		
		objective_add( 4, "active", level.obj4_string, marker.origin );
		objective_current( 4 );
	}
	// keep moving thru town w/ convoy
	if( num == 5 )
	{
		objective_state( 4, "done" );
		structTN = "struct_objective5_marker";
		marker = GetStruct( structTN, "targetname" );
		ASSERTEX( IsDefined( marker ), "Couldn't find objective marker with targetname " + structTN );
		
		objective_add( 5, "active", level.obj5_string, marker.origin );
		objective_current( 5 );
	}
	// clear bridge of anti-tank
	if( num == 6 )
	{
		objective_state( 5, "done" );
		structTN = "struct_objective6_marker";
		marker = GetStruct( structTN, "targetname" );
		ASSERTEX( IsDefined( marker ), "Couldn't find objective marker with targetname " + structTN );
		
		objective_add( 6, "active", level.obj6_string, marker.origin );
		objective_current( 6 );
	}
	// disable nashorn
	if( num == 7 )
	{
		objective_state( 6, "done" );
		structTN = "struct_objective7_marker";
		marker = GetStruct( structTN, "targetname" );
		ASSERTEX( IsDefined( marker ), "Couldn't find objective marker with targetname " + structTN );
		
		objective_add( 7, "active", level.obj7_string, marker.origin );
		objective_current( 7 );
	}
}

// skips past objectives that should have already happened (for skiptos)
objectives_skip( numToSkipPast )
{
	for( i = 1; i <= numToSkipPast; i++ )
	{
		set_objective( i );
	}
}

// keeps the objective star on a moving entity
objective_follow_ent( objectiveNum, ent )
{
	ent endon( "death" );
	level endon( "objective_stop_following_ent" );
	
	while( 1 )
	{
		if( IsDefined( ent ) )
		{
			objective_position( objectiveNum, ent.origin );
		}
		
		wait( 0.05 );
	}
}

// warp players to a given set of points
warp_players( startValue, startKey )
{
	// get start points
	starts = GetStructArray( startValue, startKey );
	ASSERTEX( starts.size == 4, ( "warp_players didn't find 4 player start spots with KVP: " + startKey + "/" + startValue ) );
	
	players = get_players();

	for( i = 0; i < players.size; i++ )
	{
		// Set the players' origin to each start point
		players[i] setOrigin( starts[i].origin );
	
		// Set the players' angles to face the right way.
		players[i] setPlayerAngles( starts[i].angles );
	}
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
		
		// special setup if it's our main AI character
		if( IsDefined( guy.script_noteworthy ) && guy.script_noteworthy == "ai_maincharacter" )
		{
			level.aihero = guy;
			level.aihero thread rename_friendly( "Sgt. Maddock", true );
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
	ASSERTEX( friendlyStarts.size > 0, "warp_friendlies(): didn't find enough friendly start points!" );

	for( i = 0; i < level.friends.size; i++ )
	{
		level.friends[i] Teleport( groundpos( friendlyStarts[i].origin ), friendlyStarts[i].angles );
	}
}
