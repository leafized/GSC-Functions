//
// file: rhi2_event_bridge.gsc
// description: bridge event script for rhineland2
// scripter: slayback
//

#include maps\_utility;
#include common_scripts\utility;
#include maps\rhi2;
#include maps\rhi2_event_sweep;
#include maps\rhi2_util;

// --- STARTS ---
// normal map start
event_bridge_start()
{
	SetDvar( "introscreen", "0" );
	
	objectives_skip( 5 );
	
	// cutscene is already done
	flag_set( "midlevel_igc_done" );
	
	// spawn the MG guys
	GetEnt( "trig_aispawners_mgGuys", "targetname" ) notify( "trigger" );
	
	// spawn the nashorn
	GetEnt( "trig_vehiclespawner_nashorn", "targetname" ) notify( "trigger" );
	
	warp_players( "struct_bridge_start", "targetname" );
	warp_friendlies( "struct_bridge_start_friends", "targetname" );
	
	// set up the radioman & convoy
	radioman_setup();
	convoy_setup();

	level thread event_bridge_setup( true );
}

event_bridge_setup( skippedTo )
{	
	flag_clear( "convoy_crossbridge" );
	flag_clear( "bridge_mgnest_destroyed" );
	
	level thread event_bridge_mgnest();
	level thread rocketmen_init( "trig_spawner_bridge_rocketgroup1", "rocketman_bridge", "convoy_crossbridge" );
	
	// kick off the event action
	level thread event_bridge_action();
	level thread convoy_movement_bridge( skippedTo );
}

event_bridge_action()
{
	flag_wait( "midlevel_igc_done" );
	
	set_objective( 6 );
	
	set_friendlychain( "node_bridge_fc1" );
	
	trigger_wait( "trig_bridge_nashornRetreat", "targetname" );
	iprintlnbold( "look, the Nashorn is retreating!" );
	wait( 7 );
	iprintlnbold( "clear the rest of the rocket guys..." );
	iprintlnbold( "...and call up the convoy when it's clear!" );
	
	// radioman ready for use again
	thread radioman_think();
	thread objective_follow_ent( 6, level.radioman );
	level waittill( "radioman_used" );
	level notify( "stop_radioman_think" );
	level notify( "objective_stop_following_ent" );
	
	objective_state( 6, "done" );
	
	flag_set( "convoy_crossbridge" );
	
	// wait for tank to cross bridge
	flag_wait( "bridge_mgnest_destroyed" );
	
	// send control to next event
	iprintlnbold( "MG nest destroyed, path opened!" );
	level thread maps\rhi2_event_church::event_church_setup();
}

convoy_movement_bridge( skippedTo )
{	
	if( IsDefined( skippedTo ) && skippedTo )
	{
		// HACK figure out what _vehicle does when the trigger is hit that
		//  is different from just calling vehicle_paths().  some setup maybe?
		GetEnt( "trig_convoy_move1", "targetname" ) notify( "trigger" );
	}
	
	tank1 = GetEnt( "vehicle_convoy_tank1", "targetname" );
	tank2 = GetEnt( "vehicle_convoy_tank2", "targetname" );
	node1 = GetVehicleNode( "vnode_convoy_tank1_crossbridge_pathStart", "targetname" );
	node2 = GetVehicleNode( "vnode_convoy_tank2_crossbridge_pathStart", "targetname" );
	
	tank1 AttachPath( node1 );
	tank2 AttachPath( node2 );
	tank1 SetSpeed( 0, 1000 );
	tank2 SetSpeed( 0, 1000 );
	
	flag_wait( "convoy_crossbridge" );
	
	tank1 SetSpeed( 9, 10 );
	tank1 thread maps\_vehicle::vehicle_paths( node1 );
	tank2 SetSpeed( 9, 10 );
	tank2 thread maps\_vehicle::vehicle_paths( node2 );
		
	tank1 waittill( "reached_end_node" );
	tank1 convoy_movement_destroy_mgnest();
}

// self = the tank
convoy_movement_destroy_mgnest()
{
	// destroy MG nest!
	mgnest = GetEnt( "bridge_pillbox", "targetname" );
	mgnest ConnectPaths();
	mgnest Delete();
	
	flag_set( "bridge_mgnest_destroyed" );
}

event_bridge_mgnest()
{
	wait( 1 );
	
	ais = get_ai_group_ai( "ai_bridge_mgnest" );
	ASSERTEX( IsDefined( ais ) && ais.size > 0, "Couldn't find mgnest AI!" );
	ASSERTEX( ais.size == 1, "Found too many mgnest AIs!" );
	
	gunner = ais[0];
	
	gunner.suppressionwait = 0;
	gunner.health = 10000;
}
