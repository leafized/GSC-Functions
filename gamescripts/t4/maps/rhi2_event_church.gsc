//
// file: rhi2_event_church.gsc
// description: church event script for rhineland2
// scripter: slayback
//

#include maps\_utility;
#include common_scripts\utility;
#include maps\rhi2;
#include maps\rhi2_event_sweep;
#include maps\rhi2_util;

// --- STARTS ---
// normal map start
event_church_start()
{
	SetDvar( "introscreen", "0" );
	
	objectives_skip( 6 );
	
	warp_friendlies( "struct_church_start_friends", "targetname" );
	warp_players( "struct_church_start", "targetname" );
	
	// destroy mg nest
	maps\rhi2_event_bridge::convoy_movement_destroy_mgnest();
	
	// spawn the nashorn and retreat it quickly
	GetEnt( "trig_vehiclespawner_nashorn", "targetname" ) notify( "trigger" );
	wait( 0.1 );
	GetEnt( "trig_bridge_nashornRetreat", "targetname" ) notify( "trigger" );
	GetEnt( "vehicle_church_nashorn", "targetname" ) SetSpeed( 100, 1000 );
	
	// set up the radioman & convoy
	radioman_setup();
	convoy_setup();

	level thread event_church_setup();
}

event_church_setup()
{
	level thread event_church_action();
}

event_church_action()
{
	set_objective( 7 );
	
	set_friendlychain( "node_church_fc1" );
	
	thread event_church_goodLOS();
	thread event_church_nashornMolotovs();
	
	// wait for player to get in position
	level waittill( "church_found_position" );
	
	objective_state( 7, "done" );
	
	wait( 5 );
	
	level play_endlevel_igc();
}

event_church_goodLOS()
{
	level endon( "church_found_position" );
	
	trigger_wait( "trig_church_goodNashornLOS", "targetname" );
	iprintlnbold( "Firing position found; Nashorn crew sniped." );
	
	level notify( "church_found_position" );
}

event_church_nashornMolotovs()
{
	level endon( "church_found_position" );
	
	trigger_wait( "trig_church_nashornMolotovs", "targetname" );
	iprintlnbold( "Molotovs found; Nashorn crew flamed." );
	
	level notify( "church_found_position" );
}

play_endlevel_igc()
{
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] FreezeControls( true );
	}
	
	wait( 2 );
	iprintlnbold( "**end IGC: tanks move up and attack church**" );
	wait( 6 );
	
	// TODO move convoy up
	
	MissionSuccess( "rhi2" );  // TODO change to rhi3
}