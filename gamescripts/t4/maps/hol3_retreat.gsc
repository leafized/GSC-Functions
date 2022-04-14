#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;

// hol3 retreat script

main()
{

//	set_color_chain( "chain_outdoors" );
//
//	// TEMP TODO make friendlies not stop and fire until they get to their first cover positions
//	//friendlies = getentarray( "friendly_squad", "targetname" );
//	//array_thread( friendlies, :: friendly_retreat_strat );
//	
//	// handle retreat behavior
//	//level thread retreat_chains();
//
//	// handle axis advance bevaior
//	level thread retreat_waves();
//	// TEMP OFF
//	//level thread halftrack_advance_a();
//	//level thread halftrack_advance_b();
//
//	wait( 2 );
//	
//	simple_floodspawn( "retreat_1_spawner");
//	simple_floodspawn( "retreat_4_spawner");
//
//	// prepare for small house that squad retreats into
//	level thread retreat_house();
	
}



///////////////////
//
// So friendlies retreat to cover before they try fight back
//
///////////////////////////////

friendly_retreat_strat()
{
//
//	self.pacifist = 1;
//	
//	old_goalradius = self.goalradius;
//	self.goalradius = 50;
//	
//	self waittill( "goal" );
//	
//	self.goalradius = old_goalradius;
//	self.pacifist = 0;
//	

	count = 0;

	self setgoalnode( getnode( "auto1183", "targetname" ) );

	while( 1 )
	{
	
		self waittill( "goal" );
		
		count++;
		
		quick_text( "goal: " + count, 1 );
		
	}

}



///////////////////
//
// Handles extra friendly chain behavior on retreat
//
///////////////////////////////

retreat_chains()
{

	change_noteworthy_goalradii( "friendly_squad_ai", 250 );

	level.retreat_wave = 0;

	level thread retreat_text( "retreat into the field!" );

	trig = getent( "trig_retreat_1", "targetname" );
	trig waittill( "trigger" );

	level notify( "new_retreat_wave" );
	level.retreat_wave = 1;

	level thread retreat_text( "retreat to the destroyed barn!" );
	
	level thread wait_chain( "node_chain_outdoors_1" );



	trig = getent( "trig_retreat_2", "targetname" );
	trig waittill( "trigger" );

	level notify( "new_retreat_wave" );
	level.retreat_wave = 2;

	level thread retreat_text( "retreat behind the low wall!" );	

	level thread wait_chain( "node_chain_outdoors_2" );
	
	
	
	trig = getent( "trig_retreat_3", "targetname" );
	trig waittill( "trigger" );
	
	level notify( "new_retreat_wave" );
	level.retreat_wave = 3;

	level thread retreat_text( "retreat to that small house!" );
	
	level thread wait_chain( "node_chain_outdoors_3" );
	
	
	trig = getent( "trig_retreat_4", "targetname" );
	trig waittill( "trigger" );
	
	level notify( "new_retreat_wave" );
	level.retreat_wave = 4;
	
	// TEMP TODO make friendlies not stop and fire when theyre going to their last cover positions in the house
	level thread wait_chain( "node_chain_outdoors_4" );

	
}



///////////////////
//
// For debug
//
///////////////////////////////

retreat_text( text )
{
	level endon( "new_retreat_wave" );
	
	quick_text( "retreat!", 4 );
	
	wait( 4 );
	
	quick_text( text, 100 );
}



///////////////////
//
// Have ai wait a bit before going to new chain
//
///////////////////////////////

wait_chain( trig_name )
{
	
	level endon( "new_retreat_wave" );
	
	wait( randomintrange( 2, 4 ) );		
	// TODO replace with color chain
//	set_player_chain( trig_name );
	
}



///////////////////
//
// Handles how the halftrack advances
//
///////////////////////////////

halftrack_advance_a()
{

	// halftrack moves up
	level.halftrack_field = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "defend_halftrack_2" );
	
	level.halftrack_field thread halftrack_mg_behavior();
	level.halftrack_house thread halftrack_mg_behavior();
	
	// set up first wait node
	level.halftrack_field setwaitnode( getvehiclenode( "node_field_wait_1a", "targetname" ) );
	
	
	
	level.halftrack_field waittill( "reached_wait_node" );
	
	event_text( "halftrack wait 1a" );
	
	level.halftrack_field setspeed( 0, 4, 4 );
	
	while( level.retreat_wave < 1 )
	{
		wait( 0.5 );	
	}
	wait( 0.05 ); // needs to be here, otherwise vehicle wont recognize waitnodes 

	vnode = getvehiclenode( "node_field_wait_2a", "targetname" );
	level.halftrack_field setwaitnode( vnode );

	level.halftrack_field resumespeed( 7, 4, 4 );
	
	
	

	level.halftrack_field waittill( "reached_wait_node" );	
	
	event_text( "halftrack wait 2a" );
	
	level.halftrack_field setspeed( 0, 4, 4 );
	
	while( level.retreat_wave < 3 )
	{
		wait( 0.5 );	
	}
	wait( 0.05 );
	
	// wait some extra time so player can retreat
	wait( randomintrange( 4, 7 ) );
	
	vnode = getvehiclenode( "node_field_wait_3a", "targetname" );
	level.halftrack_field setwaitnode( vnode );
	
	level.halftrack_field resumespeed( 7, 4, 4 );
	
	
	
	
	level.halftrack_field waittill( "reached_wait_node" );	
	
	event_text( "halftrack wait 3a" );
	
	level.halftrack_field setspeed( 0, 4, 4 );


	// waittill back door is open in retreat house
	while( !flag( "retreat_house_open" ) )
	{
		wait( 0.5 );	
	}
	wait( 0.05 );

	vnode = getvehiclenode( "node_field_wait_4a", "targetname" );
	level.halftrack_field setwaitnode( vnode );

	level.halftrack_field resumespeed( 7, 4, 4 );	




	level.halftrack_field waittill( "reached_wait_node" );	
	
	event_text( "halftrack wait 4a" );
	level.halftrack_field setspeed( 0, 4, 4 );
	
	// wait till igc time
	while( !flag( "outside_retreat_house" ) )
	{
		wait( 0.5 );	
	}
	
	level.halftrack_field resumespeed( 7, 4, 4 );	
	
	
	// wait till wasp rescues squad
	flag_wait( "wasp_rescue" );
	
	wait( 0.05 );
	
	// turn off alternating mg thread
	level.halftrack_field notify( "stop_hol3_mg_behavior" );
	
	level.halftrack_field thread maps\_vehicle::mgoff();
	
	// wall that halftrack crashes through
	getent( "halftrack_wall_igc", "targetname" ) delete();
	
	level.halftrack_field resumespeed( 7, 4, 4 );
	
}



///////////////////
//
// Handles how the halftrack advances
//
///////////////////////////////

halftrack_advance_b()
{
	
	// set up first wait node
	level.halftrack_house setwaitnode( getvehiclenode( "node_field_wait_1b", "targetname" ) );
	
	
	
	level.halftrack_house waittill( "reached_wait_node" );
	
	event_text( "halftrack wait 1b" );
	
	level.halftrack_house setspeed( 0, 4, 4 );
	
	while( level.retreat_wave < 1 )
	{
		wait( 0.5 );	
	}
	wait( 0.05 ); // needs to be here, otherwise vehicle wont recognize waitnodes 

	vnode = getvehiclenode( "node_field_wait_2b", "targetname" );
	level.halftrack_house setwaitnode( vnode );

	level.halftrack_house resumespeed( 7, 4, 4 );
	
	

	level.halftrack_house waittill( "reached_wait_node" );	
	
	event_text( "halftrack wait 2b" );
	
	level.halftrack_house setspeed( 0, 4, 4 );
	
	while( level.retreat_wave < 3 )
	{
		wait( 0.5 );	
	}
	wait( 0.05 );
	
	// wait some extra time so player can retreat
	wait( randomintrange( 4, 7 ) );
	
	vnode = getvehiclenode( "node_field_wait_3b", "targetname" );
	level.halftrack_house setwaitnode( vnode );
	
	level.halftrack_house resumespeed( 7, 4, 4 );
	
	getent( "halftrack_wall_2", "targetname" ) delete();
	
	
	
	level.halftrack_house waittill( "reached_wait_node" );	
	
	event_text( "halftrack wait 3b" );
	
	level.halftrack_house setspeed( 0, 4, 4 );

	// waittill back door is open in retreat house
	while( !flag( "retreat_house_open" ) )
	{
		wait( 0.5 );	
	}

	// wait a couple seconds so the other halftrack can plow through the wall
	wait( 2 );

	level.halftrack_house resumespeed( 7, 4, 4 );	
	
}



///////////////////
//
// Manage how often halftrack mgs are on and firing
//
///////////////////////////////

halftrack_mg_behavior()
{

	self endon( "death" );
	self endon( "stop_hol3_mg_behavior" );
	
	
	while( 1 )
	{
	
		wait( 5 );
		
		self maps\_vehicle::mgoff();
		
		wait( 3 );
		
		self maps\_vehicle::mgon();
		
	}
	
}



///////////////////
//
// Handles how the axis advance during the retreat
//
///////////////////////////////

retreat_waves()
{

	retreat_spawners = getentarray( "retreat_1_spawner", "targetname" );
	
	level waittill( "new_retreat_wave" );
	
	
	// move ai up
	ai = get_ai_group_ai( "retreat_1_ai" );
	for( i  = 0; i < ai.size; i++ )
	{
		//ai[i] setgoalpos( ( -1687, 5209, -44 ) );
		ai[i] thread maps\hol3_end::delay_rush( ( -1687, 5209, -44 ) );
	}
	
	
	// set spawners' new targets so they advance further
	nodes = getnodearray( "node_retreat_2", "targetname" );
	assertex( nodes.size >= retreat_spawners.size, "need more nodes in retreat_waves()!" );
	
	for( i  = 0; i < retreat_spawners.size; i++ )
	{
		retreat_spawners[i].target = nodes[i].targetname;
	}
	
	
	
	level waittill( "new_retreat_wave" );
	
	
	// move ai up
	ai = get_ai_group_ai( "retreat_1_ai" );
	for( i  = 0; i < ai.size; i++ )
	{
		//ai[i] setgoalpos( ( -2085, 4959, -43 ) );
		ai[i] thread maps\hol3_end::delay_rush( ( -2085, 4959, -43 ) );
	}
	
	// set spawners' new targets so they advance further
	nodes = getnodearray( "node_retreat_3", "targetname" );
	assertex( nodes.size >= retreat_spawners.size, "need more nodes in retreat_waves()!" );
	
	for( i  = 0; i < retreat_spawners.size; i++ )
	{
		retreat_spawners[i].target = nodes[i].targetname;
	}



	level waittill( "new_retreat_wave" );
	
	
	// move ai up
	ai = get_ai_group_ai( "retreat_1_ai" );
	for( i  = 0; i < ai.size; i++ )
	{
		//ai[i] setgoalpos( ( -2679, 3909, -45 ) );
		ai[i] thread maps\hol3_end::delay_rush( ( -2679, 3909, -45 ) );
	}
	
	// set spawners' new targets so they advance further
	nodes = getnodearray( "node_retreat_4", "targetname" );
	assertex( nodes.size >= retreat_spawners.size, "need more nodes in retreat_waves()!" );
	
	for( i  = 0; i < retreat_spawners.size; i++ )
	{
		retreat_spawners[i].target = nodes[i].targetname;
	}


}




///////////////////
//
// Handles the activity in the house near the end of the retreat
//
///////////////////////////////

retreat_house()
{
	
	
	trig = getent( "trig_retreat_house", "targetname" );
	trig waittill( "trigger" );
	
	quick_text( "need to break open doorway! hold off the germans!", 10 );
	
	// put their goalradii back
	change_noteworthy_goalradii( "friendly_squad_ai", 400 );
	
	array_thread( level.heroes, ::set_ignoresuppression_off );
	
	// spawn extra axis
	simple_floodspawn( "retreat_3_spawner" );
	
	break_down_door();
	
	quick_text( "door open! retreat!", 5 );
	
	flag_set( "retreat_house_open" );
	
	// open door
	door = getent( "retreat_door", "targetname" );
	door connectpaths();
	wait( 0.01 );
	door delete();
	
	// TODO make sure player(s) cannot reach trig_outside_retreat_house trigger before these 2 seconds are up
	wait( 2 );
	
	// make friendlies pacifists briefly to get them to leave the house better
	friendlies = get_specific_ai( "friendly_squad_ai" );
	array_thread( friendlies, ::brief_pacifist );
	
	// TODO replace with color chain
//	set_player_chain( "node_chain_igc" );
	
	// wait till getting near igc area
	trig = getent( "trig_outside_retreat_house", "targetname" );
	trig waittill( "trigger" );

	flag_set( "outside_retreat_house" );
	
	// prepare for mid igc
	level thread wasp_saves();
	
}



break_down_door()
{
	
	door_guy = get_specific_ai( "friendly_squad_ai" )[0];
	
	door_guy.animname = "retreat";
	old_radius = door_guy.goalradius;
	door_guy.goalradius = 24;
	
	goal_node = getnode( "node_back_door_break", "targetname" );
	door_guy setgoalnode( goal_node );
	
	door_guy waittill( "goal" );
	
	level thread anim_loop_solo( door_guy, "door_smash", undefined, "retreat_house_open", door_guy );	
	
	wait( 34 );
	
	door_guy.goalradius = old_radius;
	
}



brief_pacifist()
{

	self.pacifist = 1;

	wait( 4 );
	
	self.pacifist = 0;
	
}


///////////////////
//
// Mid IGC
//
///////////////////////////////

wasp_saves()
{
	
	trig = getent( "trig_wasp_saves", "targetname" );
	trig waittill( "trigger" );
	
	quick_text( "wasp saves!" );
	
	flag_set( "wasp_rescue" );
	
	// spawn backup brits that come to player's aid	
	//	simple_spawn( "igc_backup_spawners" );
	
	level notify( "obj_retreat_complete" );
	
	// waittill halftrack breaks through wall
	halftrack = getent( "defend_halftrack_2", "targetname" );
	halftrack waittill( "reached_end_node" );	
	
	// wasp saves the day
	level.wasp_1 = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "wasp_1" );
	
	level.wasp_1 waittill( "reached_end_node" );

	// TEMP play temp fire near halftrack
	orig = getstruct( "orig_mid_igc_flame", "targetname" );
	playfx( level._effect["temp_wasp_fire"], orig.origin );	

	level thread delay_halftrack_explosion( orig );

	wait( 2 );
	
	//maps\_camsys::playback_scene( "mid" );
	
	kill_all_axis_ai();
	
	start_trick_teleport_player();
	start_teleport_ai( "orig_start_yard" );	
	start_teleport_players( "orig_start_yard" );

	maps\hol3_yard::main();	
	
}


delay_halftrack_explosion( orig )
{

	wait( 4 );
	playfx( level._effect["large_vehicle_explosion"], orig.origin + ( -100, 170, 0 ) );	
	
}