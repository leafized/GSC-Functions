//
// file: rhi2_event_convoywalk.gsc
// description: convoy walk event script for rhineland2
// scripter: slayback
//

#include maps\_utility;
#include common_scripts\utility;
#include maps\rhi2;
#include maps\rhi2_util;

// --- STARTS ---
// normal map start
event_convoywalk_start()
{
	SetDvar( "introscreen", "0" );
	
	objectives_skip( 4 );
	
	warp_players( "struct_convoywalk_start", "targetname" );
	warp_friendlies( "struct_convoywalk_start_friends", "targetname" );

	// HACK figure out what _vehicle does when the trigger is hit that
	//  is different from just calling vehicle_paths().  some setup maybe?
	GetEnt( "trig_convoy_move1", "targetname" ) notify( "trigger" );
	
	level thread event_convoywalk_setup();
}

event_convoywalk_setup()
{
	flag_clear( "midlevel_igc_done" );
	
	level thread event_convoywalk_action();
}

event_convoywalk_action()
{
	set_objective( 5 );
	set_friendlychain( "node_sweep_fc39" );
	
	// convoy on new paths now
	tank1 = GetEnt( "vehicle_convoy_tank1", "targetname" );
	tank2 = GetEnt( "vehicle_convoy_tank2", "targetname" );
	node1 = GetVehicleNode( "vnode_convoy_tank1_convoywalk1_pathStart", "targetname" );
	node2 = GetVehicleNode( "vnode_convoy_tank2_convoywalk1_pathStart", "targetname" );
	
	tank1 AttachPath( node1 );
	tank2 AttachPath( node2 );
	tank1 SetSpeed( 0, 1000 );
	tank2 SetSpeed( 0, 1000 );
	
	trigger_wait( "trig_sweep_atBarricade2", "targetname" );
	
	tank1 SetSpeed( 9, 10 );
	tank1 thread maps\_vehicle::vehicle_paths( node1 );
	tank2 SetSpeed( 9, 10 );
	tank2 thread maps\_vehicle::vehicle_paths( node2 );
	
	wait( 0.5 );
	
	set_friendlychain( "node_convoywalk_fc5" );
	
	trigger_wait( "trig_convoywalk_igcspot", "targetname" );
	
	level thread maps\rhi2_event_bridge::event_bridge_setup();
	
	play_midlevel_igc();
}

play_midlevel_igc()
{
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] FreezeControls( true );
	}
	
	iprintlnbold( "hold up! a Nashorn is covering the bridge." );
	wait( 2 );
	iprintlnbold( "infantry go clear it out, then radio back." );
	wait( 2 );
	
	// TODO switch to ForceTeleport whenever Mike writes it, for now HACK player into a building for a sec
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		vec = ( ( -3526 + ( ( i + 1 ) * 32 ) ), 7724, -1110 );
		player SetOrigin( vec );
	}
	wait( 1 );
	
	warp_friendlies( "struct_bridge_start_friends", "targetname" );
	warp_players( "struct_bridge_start", "targetname" );
	
	wait( 0.5 );
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] FreezeControls( false );
	}
	
	flag_set( "midlevel_igc_done" );
}
