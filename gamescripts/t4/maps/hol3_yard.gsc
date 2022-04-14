#include common_scripts\utility;
#include maps\_anim;
#include maps\_utility;
#include maps\pel2_util;

// hol3 yard script
#using_animtree ("generic_human");
main()
{

	// triggers in yard event that need to be turned back on
	triggers_to_turn_on = getentarray( "yard_ents_to_hide", "script_noteworthy" );
	array_thread( triggers_to_turn_on, common_scripts\utility::trigger_on );
	
	level.maddock set_force_color( "y" );
	// change one of the yellow redshirts to green
	redshirt_y_to_g();

	set_color_chain( "chain_yard_advance" );

	// wasp behavior
	level thread wasp_trigger_moves();
	level thread wasp_1_yard_strat();
	level thread wasp_2_yard_strat();	

	//spawn extra friendlies for color reinforcements
	simple_spawn( "yard_extras" );
	trig = getent( "trig_yard_friendlies", "script_noteworthy" );
	trig notify( "trigger" );

	yard_action();

}



///////////////////
//
// Put a random yellow redshirt on the green chain
//
///////////////////////////////

redshirt_y_to_g()
{

	guys = getaiarray( "allies" );
	
	for( i  = 0; i < guys.size; i++ )
	{
	
		if( guys[i].script_forceColor == "y" )
		{
			guys[i] set_force_color( "g" );
			break;
		}	
			
	}
	
	/#
	if( i == guys.size )
	{
		assertmsg( "redshirt_y_to_g() failed!" );	
	}
	#/
	
}



///////////////////
//
// Set up the action that happens in the yard event
//
///////////////////////////////

yard_action()
{

	trigger_wait( "trig_yard_1", "targetname" );

	// stop wasp drones
	level notify( "end_yard_drones_2" );

	simple_spawn( "yard_1_spawners" );
	simple_spawn( "yard_1_runners" );

	// ignored so wasps have a chance to take care of them
	special_guys = simple_spawn( "yard_1_spawners_special" );
	array_thread( special_guys, ::set_ignoreme_on );
	
	level thread backyard_1_check();
	level thread backyard_2_check();
	level thread courtyard_spawn();
	level thread yard_runners();
	level thread fallback_430();

	house_blocker_off( "brush_house_10" );
	house_blocker_off( "brush_house_5" );

	yard_mghouse();
	
}



fallback_430()
{

	trigger_wait( "trig_fallback_430", "targetname" );
	
	guys = get_ai_group_ai( "courtyard_ai" );
	
	for( i  = 0; i < guys.size; i++ )
	{
		guys[i].script_goalvolume = "";
	}
	
	
}



///////////////////
//
// Guys that spawn in courtyard on right side of main street
//
///////////////////////////////

courtyard_spawn()
{
	
	// don't spawn dudes if house was set on fire already
	level endon( "house_7_burned" );

	level thread trig_override( "trig_courtyard_spawn" );
	trigger_wait( "trig_courtyard_spawn", "targetname" );

	quick_text( "courtyard_spawn", 3, true );
	simple_floodspawn( "courtyard_spawners" );

}



///////////////////
//
// ambient: spawners that run from a distance into some buildings, then are killed
//
///////////////////////////////

yard_runners()
{

	level endon( "stop_yard_runners" );

	// POLISH better trigger to do this off of?
	trigger_wait( "auto2810", "target" );

	level thread stop_yard_runners();	

	while( 1 )
	{
	
		guys = get_ai_group_ai( "yard_runners_ai" );
		if( guys.size < 1 )
		{
			simple_spawn( "yard_runners", ::yard_runners_strat );
		}
		
		wait( RandomIntRange( 5, 9 ) );
		
	}

}



///////////////////
//
// stop yard runners when progressed far enough
//
///////////////////////////////

stop_yard_runners()
{
	trigger_wait( "trig_blue_schrek", "targetname" );
	level notify( "stop_yard_runners" );
	simple_spawn_single( "blue_schrek_spawner", ::blue_schrek_strat );
}



yard_runners_strat()
{

	self endon( "death" );
	
	self.ignoresuppression = 1;
	self waittill( "goal" );
	
	self delete();
	//self dodamage( self.health + 50, ( 0, 0, 0 ) );
	
}



blue_schrek_strat()
{
	
	self endon( "death" );
	
	self waittill( "goal" );
	
	blue_shutters();
	
}



///////////////////
//
// Blue shutters pop open
//
///////////////////////////////

blue_shutters()
{

  	left_shudder = getent( "shutter_blue_l", "targetname" ); right_shudder =
	getent( "shutter_blue_r", "targetname" ); left_shudder rotateyaw( -130, 0.6,
          	0.3, .1 ); right_shudder rotateyaw( 130, 0.7, 0.3, .1 );
	
}



///////////////////
//
// helps determine when backyard color chain should move up
//
///////////////////////////////

backyard_1_check()
{

	// wait till backyard guys are spawned
	trigger_wait( "backyard_spawners", "target" );

	// wait till some guys get to their nodes
	wait( 4 );

	// because the chain trig has this flag set on it, the thread should die if it's physically hit
	level endon( "chain_backyard_1" );

	trig = getent( "chain_backyard_1", "targetname" );
	level thread set_flag_on_trigger( trig, "chain_backyard_1" );	
	
	while( 1 )
	{
	
		guys = getAIarrayTouchingVolume( "axis", "vol_backyard_1" );
		
		if( guys.size < 2 )
		{
			break;
		}
		
		wait( 1 );
	
	}
	
	extra_text( "chain_backyard_1" );
	
	// no axis around backyard, manually trigger color chain to move up guys
	trig notify( "trigger" );
	
	// TODO check this!  this is in case chain_backyard_1 gets triggered as the wasp is moving to flame this area, but won't entirely 
	// prevent flames from hitting friendlies if they move up as it's about to fire
	wasp_trig = getent( "trig_wasp_2_house_6", "script_noteworthy" );
	wasp_trig notify( "trigger" );
	
}




///////////////////
//
// helps determine when backyard color chain should move up
//
///////////////////////////////

backyard_2_check()
{

	// wait till backyard guys are spawned
	trigger_wait( "auto2921", "target" );

	// wait till some guys get to their nodes
	wait( 4 );

	// because the chain trig has this flag set on it, the thread should die if it's physically hit
	level endon( "chain_backyard_1" );

	// lets wasp_2_yard_strat() know whether the wasp should flame this area. if the trigger with this flag has been hit, don't flame.
	trig = getent( "chain_backyard_2", "targetname" );
	level thread set_flag_on_trigger( trig, "chain_backyard_2" );	
	
	// check the amount of axis in the the volume
	while( 1 )
	{
	
		guys = getAIarrayTouchingVolume( "axis", "vol_backyard_2" );
		
		if( guys.size < 2 )
		{
			break;
		}
		
		wait( 1 );
	
	}
	
	// manually trigger color chain to move up guys
	trig notify( "trigger" );
	extra_text( "chain_backyard_2" );
	
	// TODO check this!  this is in case chain_backyard_2 gets triggered as the wasp is moving to flame this area, but won't entirely 
	// prevent flames from hitting friendlies if they move up as it's about to fire
	wasp_trig = getent( "trig_wasp_2_house_10", "script_noteworthy" );
	wasp_trig notify( "trigger" );
	
}



///////////////////
//
// Wasp 1 strategy
//
///////////////////////////////

wasp_1_yard_strat()
{
	
	level.wasp_1 resumespeed( 5 );
	
	level.wasp_1 veh_stop_at_node( "wasp_1_house_2" );
	
	level thread flame_death_canned( "flame_death_house_2", "node_house_2_fire", "death_balcony_e", undefined, "lookat_house_2", 19, "wasp_1_house_2" );
	house_fire( level.wasp_1, "orig_house_2_fire", 14, undefined, "wasp_1_house_2" );
	house_blocker_delete( "brush_house_2" );
	
	// wait for flames or flag_override
	
	level.wasp_1 resumespeed( 5 );	
	level.wasp_1 veh_stop_at_node( "wasp_1_house_5" );	

	
	
	//HOUSE FIRE!!!
	//////////////
	house_blocker_on( "brush_house_5" );
	level thread house_fire_5_deaths();
	house_fire( level.wasp_1, "orig_house_5_fire", 14, undefined, "wasp_1_house_5" );
	house_blocker_delete( "brush_house_5" );
	/////////////////////
	
	
	level.wasp_1 resumespeed( 5 );	
	level.wasp_1 veh_stop_at_node( "wasp_1_house_7" );	
	
	
	//flag_wait( "wasp_1_house_5" );	
	
	
	//HOUSE FIRE!!!
	//////////////
	// manually trigger killspawner cuz the building is on FIRE! (only if it hasn't been hit already)
	trig = getent( "trig_killspawner_403", "targetname" );
	if( isdefined( trig ) )
	{
		flag_set( "house_7_burned" );
		trig notify( "trigger" );
	}
	level thread house_fire_7_deaths();
	house_fire( level.wasp_1, "orig_house_7_fire", undefined, undefined, "yard_mghouse_active" );
	//////////////////////
	

	// wait for mg house to be active
	flag_wait( "yard_mghouse_active" );	
	
	level.wasp_1 resumespeed( 5 );	
	level.wasp_1 veh_stop_at_node( "wasp_1_house_4" );	
	
	
	
	//HOUSE FIRE!!!
	//////////////	
	flag_set( "house_4_flamed" );
	// manually trigger killspawner cuz the building is on FIRE!
	trig = getent( "trig_killspawner_402", "targetname" );
	trig notify( "trigger" );
	level thread house_fire_4_deaths();
	house_fire( level.wasp_1, "orig_house_4_fire", 12, undefined, "wasp_1_house_4" );
	///////////////////////
	
	
	// wait
	flag_wait( "wasp_1_house_4" );	
	
	level.wasp_1 resumespeed( 5 );
	level.wasp_1 veh_stop_at_node( "wasp_1_house_8" );	
	
	house_fire( level.wasp_1, "orig_house_8_fire", 13, undefined, "wasp_1_house_8" );
	house_blocker_delete( "brush_house_8" );
	
	// wait
	flag_wait( "wasp_1_house_8" );	
	
	level.wasp_1 resumespeed( 5 );
	
	level thread maps\hol3_end::wasp_1_square_strat();
	
}



///////////////////
//
// Wasp 2 strategy
//
///////////////////////////////

wasp_2_yard_strat()
{
	
	level.wasp_2 resumespeed( 5 );
	level.wasp_2 veh_stop_at_node( "wasp_2_house_3" );	
	
	//HOUSE FIRE!!!
	level thread flame_death_canned( "flame_death_house_3", "node_house_3_fire", "death_balcony_d", undefined, "lookat_house_3", undefined, "wasp_2_house_3", true );
	house_fire( level.wasp_2, "orig_house_3_fire", undefined, undefined, "wasp_2_house_3" );
	house_blocker_delete( "brush_house_3" );
	//////////////////
	
	
	// wait
	//flag_wait( "wasp_2_house_3" );
	
	level.wasp_2 resumespeed( 5 );	
	level.wasp_2 veh_stop_at_node( "wasp_2_house_1" );	
	
	
	
	//HOUSE FIRE!!!
	level thread flame_death_canned( "flame_death_house_1", "node_house_1_fire", "death_balcony_c", undefined, "lookat_house_1", undefined, "wasp_2_house_1" );
	house_fire( level.wasp_2, "orig_house_1_fire", 14, undefined, "wasp_2_house_1" );
	house_blocker_delete( "brush_house_1" );
	////////////////////


	// wait for flames or flag_override	
	level.wasp_2 resumespeed( 5 );	
	
	
	// dont' flame this area if this color chain has been hit!
	if( !flag( "chain_backyard_1" ) )
	{
	
		level.wasp_2 veh_stop_at_node( "wasp_2_house_6" );	
		
		// skip this area if player(s) would get flamed. set house flag so wasp just moves on
		vol = getent( "vol_backyard_1", "targetname" );
		if( any_player_istouching( vol ) )
		{
			wasp_trig = getent( "trig_wasp_2_house_6", "script_noteworthy" );
			
			if( isdefined( wasp_trig ) )
			{
				wasp_trig notify( "trigger" );
			}
		}		
		
		//HOUSE FIRE!!!
		house_fire( level.wasp_2, "orig_house_6_fire", 0, 17, "wasp_2_house_6" );
		///////////////////////

		// wait for flames or flag_override	
		
		level.wasp_2 resumespeed( 5 );	
		
	}


	
	// dont' flame this area if this color chain has been hit!
	if( !flag( "chain_backyard_2" ) )
	{
	
		house_blocker_on( "brush_house_10" );
		level.wasp_2 veh_stop_at_node( "wasp_2_house_10" );
		house_fire( level.wasp_2, "orig_house_10_fire", 12, undefined, "wasp_2_house_10" );
		house_blocker_delete( "brush_house_10" );
		// wait for flames or flag_override	

		level.wasp_2 resumespeed( 5 );	

	}	


	level.wasp_2 veh_stop_at_node( "wasp_2_house_9" );	
	
	level thread house_fire_9_deaths();
	house_fire( level.wasp_2, "orig_house_9_fire", undefined, undefined, "wasp_1_house_8" );
	house_blocker_delete( "brush_house_9" );
	
	// wait
	flag_wait( "wasp_1_house_8" );	
	
	level.wasp_2 resumespeed( 5 );
	level.wasp_2 veh_stop_at_node( "wasp_2_house_11" );		
	
	
	// wait
	flag_wait( "wasp_2_house_11" );	
	
	level.wasp_2 resumespeed( 7 );	
	
	level thread maps\hol3_end::wasp_2_square_strat();
	
}



///////////////////
//
// Sets up triggers that tell the wasps when to move
//
///////////////////////////////

wasp_trigger_moves()
{

	// WASP 1
	/////////
	
	trig = getent( "trig_wasp_1_house_2", "script_noteworthy" );
	level thread set_flag_on_trigger( trig, "wasp_1_house_2" );		
	
	
	trig = getent( "trig_wasp_1_house_4", "script_noteworthy" );
	level thread set_flag_on_trigger( trig, "wasp_1_house_4" );	

	
	trig = getent( "trig_wasp_1_house_5", "script_noteworthy" );
	level thread set_flag_on_trigger( trig, "wasp_1_house_5" );		
	
	
	trig = getent( "trig_wasp_1_house_8", "script_noteworthy" );
	level thread set_flag_on_trigger( trig, "wasp_1_house_8" );
		
	
	
	// WASP 2
	/////////
	
	trig = getent( "trig_wasp_2_house_1", "script_noteworthy" );
	level thread set_flag_on_trigger( trig, "wasp_2_house_1" );		
	
	
	trig = getent( "trig_wasp_2_house_3", "script_noteworthy" );
	level thread set_flag_on_trigger( trig, "wasp_2_house_3" );	
	

	trig = getent( "trig_wasp_2_house_6", "script_noteworthy" );
	level thread set_flag_on_trigger( trig, "wasp_2_house_6" );	


	trig = getent( "trig_wasp_2_house_10", "script_noteworthy" );
	level thread set_flag_on_trigger( trig, "wasp_2_house_10" );	
	

	trig = getent( "trig_wasp_2_house_11", "script_noteworthy" );
	level thread set_flag_on_trigger( trig, "wasp_2_house_11" );	
		
}



///////////////////
//
// Guys on 2nd floor of building with badly-destroyed roof get flamed
//
///////////////////////////////

house_fire_5_deaths()
{
	
	vol = getent( "vol_fire_5", "targetname" );
	
	guys = getAIarrayTouchingVolume( "axis", "vol_fire_5" );
	
	array_thread( guys, ::house_fire_5_deaths_think );
	
	wait( 3.5 );
	
	// now some canned deaths
	level thread flame_death_canned( "flame_death_house_5_a", "node_house_5_fire_3", "death_balcony_a" );
	level thread flame_death_canned( "flame_death_house_5_b", "node_house_5_fire_1", "death_balcony_d", undefined, undefined, undefined, undefined, true );
	
}



house_fire_5_deaths_think()
{

	self endon( "death" );

	if( isdefined( self.script_aigroup ) && self.script_aigroup == "yard_1_ai" )
	{
	
		self setcandamage( false );
	
		wait( RandomFloatRange( 1.0, 2.5 ) );
		
		self.animname = "yard";
	
		anim_node = getnode( self.script_noteworthy, "targetname" );
	
		anim_names = [];
		anim_names[0] = "death_balcony_a";
		anim_names[1] = "death_balcony_b";
		anim_names[2] = "death_balcony_e";
	
		playfxontag( level._effect["wasp_guy_fire"], self, "TAG_ORIGIN" );

		anim_reach_solo( self, random( anim_names ), undefined, anim_node );
		self setcandamage( true );
		self take_away_weapon();
		anim_single_solo( self, random( anim_names ), undefined, anim_node );	
		
	}
	
}



house_fire_4_deaths()
{
	guys = get_ai_group_ai( "yard_mghouse_front_ai" );
	array_thread( guys, ::house_fire_4_deaths_think );
}



house_fire_4_deaths_think()
{

	self endon( "death" );

	self setcandamage( false );

	wait( RandomFloatRange( 1.0, 2.5 ) );
	
	self.animname = "yard";

	anim_node = getnode( self.script_noteworthy, "targetname" );

	anim_names = [];
	anim_names[0] = "death_balcony_a";
	anim_names[1] = "death_balcony_b";
	anim_names[2] = "death_balcony_e";

	playfxontag( level._effect["wasp_guy_fire"], self, "TAG_ORIGIN" );

	anim_reach_solo( self, random( anim_names ), undefined, anim_node );
	self setcandamage( true );
	self take_away_weapon();
	anim_single_solo( self, random( anim_names ), undefined, anim_node );	
		
}



house_fire_7_deaths()
{
	guys = get_ai_group_ai( "house_7_a_ai" );
	array_thread( guys, ::house_fire_7_deaths_think );
}



house_fire_7_deaths_think()
{

	self endon( "death" );

	// make them do flame deaths
	self.a.special = "none";
	self.a.forceflamedeath = 1;
	
	// so death doesn't get interrupted
	self setcandamage( false );
	
	playfxontag( level._effect["wasp_guy_fire"], self, "TAG_ORIGIN" );
	
	wait( RandomIntRange( 2, 4 ) );
	
	self setcandamage( true );
	
	self take_away_weapon();
	
	self dodamage( self.health + 1, (0,0,0) );
	
}



house_fire_9_deaths()
{
	guys = get_ai_group_ai( "yard_mghouse_back_ai" );
	array_thread( guys, ::house_fire_9_deaths_think );
}



house_fire_9_deaths_think()
{

	self endon( "death" );

	// make them do flame deaths
	self.a.special = "none";
	self.a.forceflamedeath = 1;
	
	// so death doesn't get interrupted
	self setcandamage( false );
	
	playfxontag( level._effect["wasp_guy_fire"], self, "TAG_ORIGIN" );
	
	wait( RandomIntRange( 2, 4 ) );
	
	self setcandamage( true );

	self take_away_weapon();

	self dodamage( self.health + 1, (0,0,0) );
	
}




///////////////////
//
// Action centered around mghouse in the yard
//
///////////////////////////////

yard_mghouse()
{

	trigger_wait( "trig_yard_mghouse_2", "targetname" );

	// TODO make sure trig_yard_mghouse_2 isn't possible to hit before trig_mghouse_retreat's targeted trigger
	level thread mg_house_retreat();
	level thread end_yard_retreat();
	simple_floodspawn( "mghouse_2_spawners" );

	trigger_wait( "trig_yard_mghouse_3", "targetname" );
	
	// set up town square action
	level thread town_square();
	
	simple_floodspawn( "yard_mg_spawners" );
	simple_floodspawn( "mghouse_spawners" );	
	
	flag_set( "yard_mghouse_active" );
	
	// wait till it's being flamed
	flag_wait( "house_4_flamed" );
	
	guys = getAIarrayTouchingVolume( "axis", "vol_mghouse" );
	
	// have them retreat
	for( i  = 0; i < guys.size; i++ )
	{
		guys[i] setgoalpos( ( 4547.5, 5957, 242 ) );
		guys[i] thread mghouse_retreater_strat();
	}	

}



///////////////////
//
// Guys that retreat into mghouse
//
///////////////////////////////

mg_house_retreat()
{

	level thread trig_override( "trig_mghouse_retreat" );
	trigger_wait( "trig_mghouse_retreat", "targetname" );

	quick_text( "mghouse_retreat", 3, true );
	
	simple_spawn( "mghouse_retreaters", ::mghouse_retreater_strat );
	
}



///////////////////
//
// Guys that retreat into townsquare
//
///////////////////////////////

end_yard_retreat()
{

	trigger_wait( "trig_end_yard_retreaters", "targetname" );

	quick_text( "end_yard_retreat", 3, true );
	
	simple_spawn( "end_yard_retreaters", ::mghouse_retreater_strat );
	
}


mghouse_retreater_strat()
{

	self endon( "death" );
	
	self.goalradius = 30;
	self.ignoreall = 1;
	self.pacifist = 1;
	self.ignoresuppression = 1;
	
	self waittill( "goal" );

	self.goalradius = 100;
	self.ignoreall = 0;
	self.pacifist = 0;
	self.ignoresuppression = 0;
	
}



///////////////////
//
// Moves a script origin back and forth that a Wasp targets
//
///////////////////////////////

wasp_move_target( orig )
{

	orig endon( "stop_fakefire_mover" );
	
	targ_1 = orig.origin;
	targ_2 = getstruct( orig.target, "targetname" ).origin;

	while( 1 )
	{
		orig MoveTo( targ_2, 4 );
		orig waittill( "movedone" );
		orig MoveTo( targ_1, 4 );
		orig waittill( "movedone" );
	}	
	
}



///////////////////
//
// Wasp shoots at an area
//
///////////////////////////////
// max_time_to_fire - the max time that the wasp will fire its turret
// flag_override - if set, the fire loop will break out
// min_time_to_fire - the minimum amount of time the wasp will fire
wasp_shoot_at_ent( wasp, targ_ent, min_time_to_fire, max_time_to_fire, flag_override )
{

	wasp endon( "death" );

	if( !isdefined( max_time_to_fire ) )
	{
		max_time_to_fire = 35;
	}
	
	if( !isdefined( min_time_to_fire ) )
	{
		min_time_to_fire = 8;
	}	
	
	assertex( max_time_to_fire >= min_time_to_fire, "bad min,max times for targ_ent: " + targ_ent.targetname );
	
	
	// aim at the script_origin target
	wasp SetTurretTargetEnt( targ_ent );
	wasp waittill_notify_or_timeout( "turret_on_target", 2 );

	level thread wasp_move_target( targ_ent );
	
	time_elapsed = 0;
	
	// keep firing until the max_time_to_fire has been satisfied
	while( time_elapsed < max_time_to_fire )
	{
		
		// break out if flag has been hit
		if( isdefined( flag_override ) && flag( flag_override ) )
		{
			// make sure we've fired for the minimum amount of time
			if(  time_elapsed >= min_time_to_fire )
			{
				break;	
			}
			
		}
		
		// start firing
		wasp fireweapon();
		
		// how long the fire burst lasts
		burst_time = RandomFloatRange( 2.5, 4 );
		wait( burst_time );
		time_elapsed += burst_time;
		
		// stop firing
		wasp stopfireweapon();

		// break out if flag has been hit
		if( isdefined( flag_override ) && flag( flag_override ) )
		{
			// make sure we've fired for the minimum amount of time
			if(  time_elapsed >= min_time_to_fire )
			{
				break;	
			}
			
		}
		
		// how long to let the gun cool down
		rest_time = RandomFloatRange( 2, 3 );
		wait( rest_time );
		time_elapsed += burst_time;
		
	}
	
	wasp ClearTurretTarget(); 

	// stop moving the script_origin target and delete it
	targ_ent notify( "stop_fakefire_mover" );
	targ_ent delete();
	
}



///////////////////
//
// Sets a house on fire
//
///////////////////////////////

house_fire( wasp, orig_name, min_time_to_fire, max_time_to_fire, flag_override )
{
	
	wasp endon( "death" );
	
	orig = getent( orig_name, "targetname" );
	orig_2 = getstruct( orig_name + "_a", "targetname" );
	
	wasp_shoot_at_ent( wasp, orig, min_time_to_fire, max_time_to_fire, flag_override );

	if( isdefined( orig_2 ) )
	{

		playfx( level._effect["wasp_fire"], orig_2.origin );
		playfx( level._effect["wasp_smoke"], orig_2.origin + ( 0, 0, 30 ) );
		
		level thread basic_fire( orig_name + "_a" );
		
	}
	
}



// OLD
///////////////////
//
// Does damage to guys in a volume
//
///////////////////////////////
//
//house_fire_damage( vol_name )
//{
//	
//	wait( 1.5 );
//	
//	guys = getAIarrayTouchingVolume( "axis", vol_name );
//	
//	for( i  = 0; i < guys.size; i++ )
//	{
//		guys[i] dodamage( guys[i].health + 10, ( 0, 0, 0 ) );
//	}
//	
//}



///////////////////
//
// FX that persist after Wasp stops flaming them
//
///////////////////////////////

basic_fire( orig_name )
{
	
	orig = getstruct( orig_name, "targetname" );
	
	orig.looper = playLoopedFx( level._effect["wasp_fire"], 1, orig.origin );
	
	wait( 15 );
	
	orig.looper delete();
	
}



///////////////////
//
// For cutting off the pathing in front of a wasp while it's flaming an area (so ai don't path there)
//
///////////////////////////////

house_blocker_delete( brush_name )
{

	blocker = getent( brush_name, "targetname" );
	blocker connectpaths();
	blocker delete();
	
}



house_blocker_on( brush_name )
{

	blocker = getent( brush_name, "targetname" );
	blocker solid();
	blocker disconnectpaths();
	
}



house_blocker_off( brush_name )
{

	blocker = getent( brush_name, "targetname" );
	blocker notsolid();
	blocker connectpaths();
	
}



// TODO make these bloody deaths? should kill_aigroup automatically do bloody death?
cleanup_yard_ai()
{

	kill_aigroup( "yard_1_ai" );
	wait( 1 );
	kill_aigroup( "yard_1_runner_ai" );
	wait( 1 );
	kill_aigroup( "yard_annoying" );
	
}



///////////////////
//
// Play a canned flame death on a guy
//
///////////////////////////////

flame_death_canned( guy_name, node_name, anim_name, start_delay, lookat_name, lookat_timeout, lookat_flag, flame_death_d )
{
	
	// delay before starting anything
	if( isdefined( start_delay ) )
	{
		wait( start_delay );	
	}
	
	if( !isdefined( flame_death_d ) )
	{
		flame_death_d = false;
	}
	
	// if we want to wait for a lookat
	if( isdefined( lookat_name ) )
	{
		
		// if we dont specify a timeout setting
		if( !isdefined( lookat_timeout ) )
		{
			lookat_timeout = 7;	
		}
		
		trigger_or_flag_or_timeout( lookat_name, lookat_flag, lookat_timeout );
		
	}

	anim_node = getnode( node_name, "targetname" );

	spawner_org = getstartorigin( anim_node.origin, anim_node.angles, level.scr_anim[ "yard" ][ anim_name ] );
	spawner_ang = getstartangles( anim_node.origin, anim_node.angles, level.scr_anim[ "yard" ][ anim_name ] );
	
	spawner = getent( guy_name, "targetname" );
	spawner.origin = spawner_org;
	spawner.angles = spawner_ang;
	
	guy = simple_spawn_single( guy_name );

	// he may not have spawned because of ai limit	
	if( !isdefined( guy ) )
	{
		return;
	}
	
	guy.animname = "yard";
	guy setcandamage( false );
	//guy.deathanim = level.scr_anim[ "yard" ][ anim_name ];
	
	if( flame_death_d )
	{
		guy.deathanim = level.scr_anim["yard"]["death_balcony_d"];
	}

	playfxontag( level._effect["wasp_guy_fire"], guy, "TAG_ORIGIN" );

	anim_reach_solo( guy, anim_name, undefined, anim_node );

	guy setcandamage( true );
	//guy dodamage( guy.health + 1, (0,0,0) );

	guy take_away_weapon();

	if( flame_death_d )
	{
		guy dodamage( guy.health + 1, (0,0,0) );
		return;
	}	
	
	anim_single_solo( guy, anim_name, undefined, anim_node );
		
	
}



// for use with flame death logic
trigger_or_flag_or_timeout( trig_name, flag_name, time, key )
{

	assertex( isdefined( time ), "time needs to be defined!" );

	if( !isdefined( key ) )
	{
		key = "targetname";	
	}

	// dont want trigger_once types involved here...
	trig = getent( trig_name, key );
	assertex( ( trig.classname == "trigger_multiple" || trig.classname == "trigger_lookat" ), "trigger must be a trigger_multiple or trigger_lookat to use this function!" );

	// trigger it if timeout happens
	level thread trigger_wait_or_timeout_helper( trig_name, time, key );
	// trigger it if flag happens (can't use set_flag_on_trigger if 2 independent flags are involved)
	level thread flag_wait_helper( trig_name, flag_name );

	trigger_wait( trig_name, key );
	
}



///////////////////
//
// used with trigger_or_flag_or_timeout()
//
///////////////////////////////

flag_wait_helper( trig_name, flag_name )
{

	trig = getent( trig_name, "targetname" );

	trig endon( "trigger" );

	flag_wait( flag_name );
	
	trig notify( "trigger" );
	
}



take_away_weapon()
{

	self.ignoreall = 1;
	self.pacifist = 1;
	self.pacifistwait = 0.05;
	self.maxsightdistsqrd = 0.0;

	// stop any animscript threads
	self notify( "killanimscript" );
	self notify( "stopShooting" );

	// take away his weapon
//	self animscripts\shared::placeWeaponOn( self.primaryweapon, "none" );
//	self.weapon = "none";
	self animscripts\shared::DropAIWeapon();
	

}



///////////////////
//
// Prepare for town square end event
//
///////////////////////////////

town_square()
{

	trigger_wait( "trig_town_square_pre", "targetname" );

	level notify( "obj_yard_complete" );

	level thread cleanup_yard_ai();

	maps\hol3_end::main();
	
}


