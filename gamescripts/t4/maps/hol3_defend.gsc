#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;

// hol3_defend script
#using_animtree ("generic_human");
main()
{
	save_the_pows();
}



///////////////////
//
// Setup the saving of the POWs in the basement
//
///////////////////////////////

save_the_pows()
{
	
	level.extra_pow = simple_spawn_single( "pow_extra", ::pow_misc_strat );
	level.maddock = simple_spawn_single( "pow_maddock", ::pow_maddock_strat );
	level.maddock.name = "TEMP Maddock";
	level.heroes[2] = level.maddock;

	level.extra_pow.animname = "rail";
	level.maddock.animname = "rail";
	
	level thread anim_loop_solo( level.extra_pow, "sit_cold_1", undefined, "stop_pow_loop", level.extra_pow );
	level thread anim_loop_solo( level.maddock, "sit_cold_2", undefined, "stop_pow_loop", level.maddock );

	trigger_wait( "trig_save_pows", "targetname" );
	
	level notify( "stop_pow_loop" );
	
	flag_set( "pows_saved" );
	event_text( "pows saved" );

	level thread save_the_pows_text();

	level notify( "obj_pows_complete" );

	level.extra_pow set_force_color( "y" );
	level.maddock set_force_color( "g" );
	
	mansion_door_bash();
	
}



save_the_pows_text()
{
	
	level.maddock thread say_dialogue( "pow", "maddock_pow" );
	wait( 3.0 );
	level.maddock thread say_dialogue( "pow", "maddock_pow_2" );
	
}



pow_misc_strat()
{

	self.animname = "mansion";
	self.goalradius = 30;
	self magic_bullet_shield();
	
}



pow_maddock_strat()
{
	
	self thread magic_bullet_shield();
	self.goalradius = 400;
	self setthreatbiasgroup( "heroes" );
	self.script_noteworthy = "friendly_squad_ai";
	self.targetname = "friendly_squad";
	
}



///////////////////
//
// Door kick after pows are saved
//
///////////////////////////////

mansion_door_bash()
{

	door_trig = getent( "trig_mansion_door", "targetname" );
	
	kicknode = getnode( "node_mansion_kick", "targetname" );
	
	level.goddard disable_ai_color();
	
	level.goddard.animname = "door_kicker";
	
	orig = getent( "orig_mansion_kick", "targetname" );
	anim_node = getnode( "node_mansion_kick", "targetname" );
	
	anim_reach_solo( level.goddard, "door_kick", undefined, orig );
	
	while( !any_player_IsTouching( door_trig ) )
	{
		wait( 0.5 );	
	}	
	
	old_dist = level.goddard.walkdist;
	level.goddard.walkdist = 1000;
	
	anim_single_solo( level.goddard, "door_kick", undefined, orig );

	level.goddard post_door_bash( old_dist );

	secure_mansion();
	
}



post_door_bash( old_dist )
{

	level.goddard enable_ai_color();
	
	wait( 1 );
	
	level.goddard.walkdist = old_dist;

}


///////////////////
//
// Clear furniture blocking the front door
//
///////////////////////////////

furniture_clear_vignette()
{
	
	level.extra_pow disable_ai_color();
	level.maddock disable_ai_color();
	level.goddard disable_ai_color();

	goal_node = getnode( "node_furniture_clear", "targetname" );
	
	animguys = [];	
	animguys[0] = level.extra_pow;
	animguys[1] = level.maddock;
	animguys[2] = level.goddard;
	
	level.extra_pow.animname = "furniture_1";
	level.maddock.animname = "furniture_2";
	level.goddard.animname = "furniture_3";
	
	anim_reach( animguys, "furniture_push", undefined, undefined, goal_node );
	
	array_thread ( animguys, ::furniture_movers_walk );

	// waittill player is near the door (or looking at it) until we actually play the anim
	level thread trig_furniture_clear_lookat();
	trigger_wait( "trig_furniture_clear", "targetname" );	
	
	level thread maps\hol3_anim::mansion_door_animate();
	anim_single( animguys, "furniture_push", undefined, undefined, goal_node );
	
	savegame( "Hol3 Furniture Clear Done" );
	
	flag_set( "furniture_clear_done" );

	level thread spawn_sdk();
	// TEMP TODO
	level thread advance_fail();
	
	level.extra_pow enable_ai_color();
	level.maddock enable_ai_color();
	level.goddard enable_ai_color();

	// respawn guys off extra pow
	level.extra_pow stop_magic_bullet_shield();
	level.extra_pow thread replace_on_death();

	mine_plant_in_yard();
	
}



trig_furniture_clear_lookat()
{

	trig = getent( "trig_furniture_clear", "targetname" );
	
	trig endon( "trigger" );	
	
	looked_at = false;
	
	while( !looked_at )
	{
	
		players = get_players();
		
		for( i  = 0; i < players.size; i++ )
		{
			// if any player can see one of the furniture movers, return true
			if( ( players[i] islookingat( level.goddard ) ) || ( players[i] islookingat( level.maddock ) ) || ( players[i] islookingat( level.extra_pow ) ) )
			{
				quick_text( "furniture vignette looked at!", 2, true );
				looked_at = true;
				break;	
			}
		}
		
		wait( 0.25 );
		
	}
	
	trig notify( "trigger" );
	
}



furniture_movers_walk()
{
	
	old_walkdist = self.walkdist;
	self.walkdist = 500;
	
	flag_wait( "furniture_clear_done" );
	
	wait( 2.75 );
	
	self.walkdist = old_walkdist;
	
}



turn_off_yard_triggers()
{

	// triggers in yard event that we don't want to be hit early
	triggers_to_turn_off = getentarray( "yard_ents_to_hide", "script_noteworthy" );
	array_thread( triggers_to_turn_off, common_scripts\utility::trigger_off );
	
}



///////////////////
//
// Mansion needs to be cleared of enemies after saving the POWs
//
///////////////////////////////

secure_mansion()
{

	trigger = getent( "trig_betty_cache_1", "targetname" );
	trigger trigger_off();

	// kill guy on 3rd floor; don't need him
	kill_aigroup( "mansion_top_ai" );

	set_color_chain( "chain_mansion_2" );

	kill_noteworthy_group( "intro_redshirt_ai" );

	level thread mansion_core_extra();

	// wait till all inside guys are cleared
	waittill_aigroupcleared ( "mansion_core_ai" );      
	
	//spawn extra friendlies for color reinforcements
	simple_spawn( "mansion_extras" );
	trig = getent( "trig_mansion_friendlies", "script_noteworthy" );
	trig notify( "trigger" );	
	
	level notify( "obj_clear_mansion_complete" );
	
	flag_set( "mansion_secured" );
	event_text( "mansion_secured" );
	
	// TEMP!
	savegame( "Hol3 Furniture Clear Start" );
	/////////

	set_color_chain( "chain_furniture_move" );

	furniture_clear_vignette();

}



mansion_core_extra()
{
	
	guy = get_specific_single_ai( "mansion_core_bottom_guy" );
	
	if( isdefined( guy ) )
	{
	
		guy waittill( "death" );
		
		// if mansion hasn't been secured yet...
		if( !flag( "mansion_secured" ) )
		{
			set_color_chain( "chain_mansion_3" );
			wait( 0.1 );
		}
		
		// don't need chain anymore
		color_trig = getent( "chain_mansion_3", "targetname" );
		color_trig delete();
		
	}
	
}



///////////////////
//
// Player and squad plant mines before the german counterattack
//
///////////////////////////////

mine_plant_in_yard()
{

	iprintlnbold( "we dont have much time. set up these bouncing betty mines before the german counterattack" );

	set_color_chain( "chain_mansion_yard" );
	ai_run_into_yard();

	objective_string( 5, &"HOL3_RETRIEVE_BETTIES"  );
	objective_position( 5, (-56, 5488, 83) );

	trigger = getent( "trig_betty_cache_1", "targetname" );
	trigger trigger_on();
	// TODO make this coop compatible
	trigger waittill( "trigger" );
	trigger delete();
	
	level thread mine_equip_players();

	objective_string( 5, &"HOL3_PLANT_BETTIES"  );
	objective_position( 5, ( 744, 6176, 98 ) );

	// wait till player goes out into the yard
	trigger_wait( "trig_in_front_yard", "targetname" );
	
	
	// the timer countdown for the mine planting
	level thread mine_countdown();

	// have ai plant mines
	level thread mine_plant_ai_1();
	level thread mine_plant_ai_2();
	// TODO put this behavior in _bouncing_betties.gsc
	level thread betty_mine_hack();
	level thread in_defensive_pos_early();
	// wait until the player has had time to set up
	flag_wait( "mine_countdown_over" );
	
	level notify( "obj_plant_betties" );
	
	if( !flag( "in_defensive_pos_early" ) )
	{
		// wait till player gets in position on 2nd floor
		trigger_wait_or_timeout( "trig_defensive_pos", 20 );		
	}
	else
	{
		// kill the timer thread
		level notify( "stop_countdown_timer" );
		level.countdown_hudelem destroy();		
		
		// if player got into position early, wait a couple extra seconds so heros have time to get back into mansion	
		wait( 2.5 );
	}
	
	level notify( "obj_defensive_pos" );
	level thread drones_wasp();
	
	level thread allies_hold_fire();
	
	// start the defend waves
	mansion_defend();
	
}



allies_hold_fire()
{
	
	
	// make friendlies hold their fire for a bit
	all_friendlies = getaiarray( "allies" );
	array_thread ( all_friendlies, ::set_pacifist_on );
	
	wait( 6 );	
	
	all_friendlies = getaiarray( "allies" );
	array_thread ( all_friendlies, ::set_pacifist_off );	
	
}



///////////////////
//
// Drones near where wasps break in
//
///////////////////////////////

drones_wasp()
{

	drone_trig = getent( "trig_yard_drones_2", "script_noteworthy" );
	drone_trig notify( "trigger" );
		
	// squib hits on the ground
	shot_origin = getstruct( "yard_muzzleflash_1" ,"script_noteworthy" );
	shot_destination = getent( "yard_bullet_hit_1", "script_noteworthy" );

	level thread maps\hol3_street::fakefire_move_target( shot_destination );
	level thread maps\hol3_street::main_street_fakefire_think( shot_origin, shot_destination, "end_yard_drones_2" );		

}



///////////////////
//
// Friendlies run into yard after furniture vignette
//
///////////////////////////////

ai_run_into_yard()
{

	level.extra_hero disable_ai_color();
	level.extra_pow disable_ai_color();
	level.goddard disable_ai_color();
	level.maddock disable_ai_color();

	node = getnode( "yard_extra_pow", "targetname" );
	level.extra_pow setgoalnode( node );

	node = getnode( "yard_extra_hero", "targetname" );
	level.extra_hero setgoalnode( node );
	
	node = getnode( "yard_goddard", "targetname" );
	level.goddard setgoalnode( node );
	
	node = getnode( "yard_maddock", "targetname" );
	level.maddock setgoalnode( node );	
	
}



in_defensive_pos_early()
{

	flag_wait_all( "ai_mine_plant_1_done", "ai_mine_plant_2_done" );
	
	trigger_wait( "trig_defensive_pos", "targetname" );
	
	flag_set( "mine_countdown_over" );
	flag_set( "in_defensive_pos_early" );
	
}



betty_mine_hack()
{

	mines_trig = getentarray( "trig_betty_mine", "targetname" );

	for( i  = 0; i < mines_trig.size; i++ )
	{
		level thread mine_explode( mines_trig[i] );
	}
	
}



mine_explode( mine_trig )
{

	level endon( "wasp_1_saved_day" );
	
	mine_trig waittill( "trigger" );
	
	betty = getent( mine_trig.script_noteworthy, "targetname" );

	// set up values
	jumpHeight = RandomIntRange( 68, 80 );  // world units
	dropHeight = RandomIntRange( 10, 20 );

	jumpTime = 0.15;  // seconds
	dropTime = 0.1;
	clickWaitTime = 0.05;  // seconds after the "click" til the betty jumps up
	radiusMultiplier = 1;  // how big of an area outside the touch trigger should dudes be damaged instead of killed?  1 = 100% bigger radius.
	damageMultiplier = 0.5;  // how much less damage do guys near but not touching the trigger take?

	// TODO replace with click sound
	iprintln( "Click!" );

	wait( clickWaitTime );

	// play ground impact particle where it pops out of the ground
	PlayFX( level._effect["betty_groundPop"], betty.origin + ( 0, 0, 10 ) );
	
	// start rotating
	betty thread betty_rotate();

	// jump up out of the ground
	betty MoveTo( betty.origin + ( 0, 0, jumpHeight ), jumpTime, 0, jumpTime * 0.5 );
	betty waittill( "movedone" );

	// fall back down a bit
	betty MoveTo( betty.origin - ( 0, 0, dropHeight ), dropTime, dropTime * 0.5 );
	betty waittill( "movedone" );

	// let our threads know it's time to start cleaning up
	betty notify( "stop_rotate_thread" );

	// Blow up!
	PlayFx( level._effect["betty_explosion"], betty.origin );

	betty Delete();
	
	RadiusDamage( mine_trig.origin, 140, 150, 250 ); 
	
}



// rotates the bouncing betty as it comes out of the ground.
// NOTE: for this to look good, the betty needs to be angled already.
// self = the betty
betty_rotate()
{
	self endon( "stop_rotate_thread" );

	self thread betty_rotate_fx();

	rotateAngles = 360;
	rotateTime = 0.125;

	while( 1 )
	{
		self RotateYaw( rotateAngles, rotateTime );
		self waittill( "rotatedone" );
	}
}



// TODO this won't work until Conserva's fix works
// plays a little trail of particles off the origin of
//   the betty, to set it off visually
// self = the betty
betty_rotate_fx()
{
	self endon( "stop_rotate_thread" );

	fxOrg = Spawn( "script_model", self.origin );
	fxOrg SetModel( "tag_origin" );

	fxOrg LinkTo( self );

	wait( 0.75 );  // I thought Conserva fixed this?

	fx = PlayFxOnTag( level._effect["betty_smoketrail"], fxOrg, "tag_origin" );
}



mine_plant_ai_1()
{
	
	animguys = [];	
	animguys[0] = level.goddard;
	animguys[1] = level.maddock;
	
	level.maddock.animname = "mine_planter";
	level.goddard.animname = "mine_helper";
	
	goal_node = getnode( "node_mine_plant_1", "targetname" );
	
	anim_reach( animguys, "mines", undefined, undefined, goal_node );
	iprintlnbold( "ai mine planting anim here" );
	//anim_single( animguys, "mines", undefined, undefined, goal_node );	 
	level thread anim_single_solo( level.goddard, "mines", undefined, level.goddard );	
	level thread anim_single_solo( level.maddock, "mines", undefined, level.maddock );	
	wait( 3 );	
	
	mine = spawn( "script_model", goal_node.origin + (0,0,4) );
	mine setmodel( "viewmodel_usa_bbetty_mine" );
	mine.targetname = "betty_1";
	
	goal_node = getnode( "node_mine_plant_3", "targetname" );
	
	anim_reach( animguys, "mines", undefined, undefined, goal_node );
	iprintlnbold( "ai mine planting anim here" );
	//anim_single( animguys, "mines", undefined, undefined, goal_node );	 	
	level thread anim_single_solo( level.goddard, "mines", undefined, level.goddard );	
	level thread anim_single_solo( level.maddock, "mines", undefined, level.maddock );	
	wait( 3 );	

	mine = spawn( "script_model", goal_node.origin + (0,0,4) );
	mine setmodel( "viewmodel_usa_bbetty_mine" );
	mine.targetname = "betty_3";

	flag_set( "ai_mine_plant_1_done" );

	set_color_chain( "chain_defend" );
		
	level.goddard enable_ai_color();
	level.maddock enable_ai_color();		
	
}



mine_plant_ai_2()
{
	
	animguys = [];	
	animguys[0] = level.extra_hero;
	animguys[1] = level.extra_pow;
	
	level.extra_hero.animname = "mine_planter";
	level.extra_pow.animname = "mine_helper";

	goal_node = getnode( "node_mine_plant_2", "targetname" );
	
	anim_reach( animguys, "mines", undefined, undefined, goal_node );
	iprintlnbold( "ai mine planting anim here" );
	//anim_single( animguys, "mines", undefined, undefined, goal_node );	 
	level thread anim_single_solo( level.extra_hero, "mines", undefined, level.extra_hero );	
	level thread anim_single_solo( level.extra_pow, "mines", undefined, level.extra_pow );	
	wait( 3 );
	
	
	mine = spawn( "script_model", goal_node.origin + (0,0,4) );
	mine setmodel( "viewmodel_usa_bbetty_mine" );
	mine.targetname = "betty_2";
	
	goal_node = getnode( "node_mine_plant_4", "targetname" );
	
	anim_reach( animguys, "mines", undefined, undefined, goal_node );
	iprintlnbold( "ai mine planting anim here" );
	//anim_single( animguys, "mines", undefined, undefined, goal_node );		
	level thread anim_single_solo( level.extra_hero, "mines", undefined, level.extra_hero );	
	level thread anim_single_solo( level.extra_pow, "mines", undefined, level.extra_pow );	
	wait( 3 );	
	
	
	mine = spawn( "script_model", goal_node.origin + (0,0,4) );
	mine setmodel( "viewmodel_usa_bbetty_mine" );	
	mine.targetname = "betty_4";
	
	flag_set( "ai_mine_plant_2_done" );	
	
	set_color_chain( "chain_defend" );
	
	level.extra_hero enable_ai_color();
	level.extra_pow enable_ai_color();
	
}



mine_equip_players()
{

	// TODO how do we do an endon for this? && make co-op compatible

	player = get_players()[0];


	player GiveWeapon( "bouncing_betty" );

	player SetWeaponAmmoClip( "bouncing_betty", 6 );

	player SetActionSlot( 4, "weapon", "bouncing_betty" );
	player SwitchToWeapon( "bouncing_betty" );
	
	delete_targetname_ents( "betty_cache_1" );
	
}



mine_countdown()
{
	
	level endon( "stop_countdown_timer" );
	
	countdown = 60;

	level.countdown_hudelem = maps\_hud_util::get_countdown_hud();
	level.countdown_hudelem SetPulseFX( 100, 57000, 3000 );//something, decay start, decay duration
 	
	level.countdown_hudelem.label = &"HOL3_BETTY_TIME";// + minutes + ":" + seconds
	level.countdown_hudelem settenthstimer( countdown );

	wait( countdown );

	level.countdown_hudelem destroy();

	flag_set( "mine_countdown_over" );	

}




///////////////////
//
// Player & squad defend the mansion
//
///////////////////////////////

mansion_defend()
{

	savegame( "Hol3 Defend Wave 1" );

	level thread wave_1();
	
	level thread wave_1_timeout();
	// enough wave_1 killed
	while( level.defend_axis_killed < 12 && !flag( "defend_1_done" ) )
	{
		wait( 1 );
	}	
	
	flag_set( "defend_1_done" );

	savegame( "Hol3 Defend Wave 2" );
	
	// reset how many have been killed
	level.defend_axis_killed = 0;

	level thread wave_2();

	level thread wave_2_timeout();
	// enough wave_2 killed
	while( level.defend_axis_killed < 13 && !flag( "defend_2_done" ) )
	{
		wait( 1 );
	}

	flag_set( "defend_2_done" );

	savegame( "Hol3 Defend Wasps" );

	// sdk moves up
	level thread sdk_rolls_up();

	wait( 5.5 );

	flag_set( "rush_the_house" );

	simple_floodspawn( "defend_3a_spawners", ::defend_axis_strat );

	axis_rush_house();

	wait( 7 );
	
	level thread wasp_saves_the_day_1();
	level thread wasp_saves_the_day_2();

	flag_wait_all( "wasp_1_saved_day", "wasp_2_saved_day" );

	level notify( "obj_defend_complete" );

	flag_set( "defend_complete" );

	savegame( "Hol3 Yard Start" );

	maps\hol3_yard::main();

}



axis_rush_house()
{

	// send alive axis inside the house
	axis_ai = getaiarray( "axis" );
	for( i  = 0; i < axis_ai.size; i++ )
	{
		// panzerschrek guys don't rush up
		if( isdefined( axis_ai[i].targetname ) && axis_ai[i].targetname == "defend_schreks_alive" )
		{
			axis_ai[i] thread schrek_cleanup();
		}
		else
		{
			axis_ai[i] thread delayed_rush();	
		}
		
	}
	
}



axis_retreat_from_wasps()
{
	
	//vnode = getvehiclenode( "wasp_1_wait", "script_noteworthy" );
	//vnode waittill( "trigger" );
	
	quick_text( "axis_retreat_from_wasps", 3, true );
	
	flag_set( "wasps_own_infantry" );
	
	axis_ai = getaiarray( "axis" );
	for( i  = 0; i < axis_ai.size; i++ )
	{
		
		// don't want them lingering
		axis_ai[i].a.disableLongDeath = true;	
		
		// panzerschrek guys don't rush up
		if( isdefined( axis_ai[i].targetname ) && axis_ai[i].targetname == "defend_schreks_alive" )
		{
			continue;
		}
		else
		{
			axis_ai[i].goalradius = 425;
			goal_pos = getstruct( "orig_retreat_from_wasps", "targetname" ).origin;
			axis_ai[i] setgoalpos( goal_pos );
			axis_ai[i].ignoreme = 1;
			axis_ai[i] thread delay_ignoreme_off();	
		}
		
	}	
	
}



delay_ignoreme_off()
{

	self endon( "death" );

	flag_wait( "flamed_sdk" );
	
	flag_wait_all( "wasp_1_saved_day", "wasp_2_saved_day" );
	
	self.ignoreme = 0;
	
}



spawn_sdk()
{

	level.house_sdk = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "house_sdk" );

	level.house_sdk thread keep_tank_alive();

	wait_node = getvehiclenode( "house_sdk_wait_1", "script_noteworthy" );
	wait_node waittill( "trigger" );

	level.house_sdk setspeed( 0, 20, 20 );
	
}



wasp_saves_the_day_1()
{
	
	level thread wasp_spawn_1();
	
	vnode = getvehiclenode( "wasp_1_wait", "script_noteworthy" );
	vnode waittill( "trigger" );
	
	level.wasp_1 setspeed( 0, 5, 5 );

	level thread axis_retreat_from_wasps();

	// STOP AXIS
	level notify( "stop_mansion_waves" );	
	// manually trigger killspawner 102
	trig = getent( "trig_killspawner_102", "targetname" );
	trig notify( "trigger" );

	wasp_fire_at_sdk();
	
	flag_set( "flamed_sdk" );
	
	level.wasp_1 resumespeed( 5 );
	
	vnode = getvehiclenode( "wasp_1_wait_2", "script_noteworthy" );
	vnode waittill( "trigger" );	

	level.wasp_1 setspeed( 0, 5, 5 );
	
	// make sure the turret is facing forward
	level.wasp_1 tank_reset_turret( 1 );
	
	wasp_1_fire_on_guys();
	
	flag_set( "wasp_1_saved_day" );

}



wasp_saves_the_day_2()
{
	
	level thread wasp_spawn_2();	
	
	vnode = getvehiclenode( "wasp_2_wait", "script_noteworthy" );
	vnode waittill( "trigger" );
	
	level.wasp_2 setspeed( 0, 15, 15 );

	flag_wait( "flamed_sdk" );

	level.wasp_2 resumespeed( 5 );	
	
	vnode = getvehiclenode( "wasp_2_wait_2", "script_noteworthy" );
	vnode waittill( "trigger" );	
	
	level.wasp_2 setspeed( 0, 5, 5 );

	wasp_2_fire_on_guys();
	
	flag_set( "wasp_2_saved_day" );
	
}



wasp_fire_at_sdk()
{
	
	targ_ent = getent( "orig_sdk_fire", "targetname" );
	
	// aim at the script_origin target
	level.wasp_1 SetTurretTargetEnt( targ_ent );

	level thread maps\hol3_yard::wasp_move_target( targ_ent );

	// start firing
	level.wasp_1 fireweapon();
	
	level thread sdk_tries_to_fight_back();
	
	wait( 3.5 );
	// stop firing
	level.wasp_1 stopfireweapon();

	wait( 2 );

	// start firing
	level.wasp_1 fireweapon();
	wait( 2.5 );
	
	level thread sdk_blowwup();
	
	wait( 1 );
	// stop firing
	level.wasp_1 stopfireweapon();

	level.wasp_1 ClearTurretTarget(); 

	// stop moving the script_origin target and delete it
	targ_ent notify( "stop_fakefire_mover" );
	targ_ent delete();

}



wasp_1_fire_on_guys()
{
	
	targ_ent = getent( "orig_sdk_fire_2", "targetname" );
	
	// aim at the script_origin target
	level.wasp_1 SetTurretTargetEnt( targ_ent );

	level thread maps\hol3_yard::wasp_move_target( targ_ent );

	// start firing
	level.wasp_1 fireweapon();
	wait( 3.5 );
	// stop firing
	level.wasp_1 stopfireweapon();

	wait( 2 );

	// start firing
	level.wasp_1 fireweapon();
	wait( 3.5 );
	// stop firing
	level.wasp_1 stopfireweapon();

	level.wasp_1 ClearTurretTarget(); 

	// stop moving the script_origin target and delete it
	targ_ent notify( "stop_fakefire_mover" );
	targ_ent delete();	
	
}



wasp_2_fire_on_guys()
{
	
	targ_ent = getent( "orig_sdk_fire_3", "targetname" );
	
	// aim at the script_origin target
	level.wasp_2 SetTurretTargetEnt( targ_ent );

	level thread maps\hol3_yard::wasp_move_target( targ_ent );

	// start firing
	level.wasp_2 fireweapon();
	wait( 3.5 );
	// stop firing
	level.wasp_2 stopfireweapon();

	wait( 2 );

	// start firing
	level.wasp_2 fireweapon();
	wait( 3.5 );
	// stop firing
	level.wasp_2 stopfireweapon();

	level.wasp_2 ClearTurretTarget(); 

	// stop moving the script_origin target and delete it
	targ_ent notify( "stop_fakefire_mover" );
	targ_ent delete();	
	
}



wasp_spawn_1()
{

	// wasp saves the day
	level.wasp_1 = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "wasp_1" );
	
	level.wasp_1.health = 100000;
	level.wasp_1 thread keep_tank_alive();
	
	//level.wasp_1.unload_group = "none";
	
	for( i  = 0; i < 2; i++ )
	{
	
		passenger[i] = Spawn( "script_model", level.wasp_1.origin );
		passenger[i] character\char_brt_infwint_r_enfield::main();
		passenger[i] UseAnimTree( #animtree );
		passenger[i].animname = "jeep";
		passenger[i].drone_delete_on_unload = false;
		
		level.wasp_1 thread maps\_vehicle_aianim::guy_enter( passenger[i], level.wasp_1 );	
		
	}
	
	level thread wasp_wall_break();
	
}



wasp_spawn_2()
{

	// wasp saves the day
	level.wasp_2 = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "wasp_2" );
	
	level.wasp_2.health = 100000;
	level.wasp_2 thread keep_tank_alive();
	
	//level.wasp_2.unload_group = "none";
	
	for( i  = 0; i < 2; i++ )
	{
	
		passenger[i] = Spawn( "script_model", level.wasp_2.origin );
		passenger[i] character\char_brt_infwint_r_enfield::main();
		passenger[i] UseAnimTree( #animtree );
		passenger[i].animname = "jeep";
		passenger[i].drone_delete_on_unload = false;
		
		level.wasp_2 thread maps\_vehicle_aianim::guy_enter( passenger[i], level.wasp_2 );	
		
	}
	
}



wasp_wall_break()
{

	vnode = getvehiclenode( "node_wasp_wall", "script_noteworthy" );
	vnode waittill( "trigger" );
	
	gate_orig = getstruct( "orig_gate_break_3", "targetname" );
	playfx( level._effect["gate_vehicle_damage"], gate_orig.origin, anglestoforward( gate_orig.angles ) );
	
	wall_brush = getent( "wall_wasp_1", "targetname" );
	wall_brush delete();	
	
}


sdk_tries_to_fight_back()
{

	level.house_sdk notify( "stop_keep_tank_alive" );
	level.house_sdk endon( "death" );

	flag_set( "sdk_retaliate" );
	
	while( 1 )
	{
		
		level.house_sdk setturrettargetent( level.wasp_1 );
		level.house_sdk waittill_notify_or_timeout( "turret_on_target", 7 ); 
		wait ( 0.3 );
		level.house_sdk ClearTurretTarget(); 
		
		how_many_shots = randomintrange( 3, 5 );
		
		for( i  = 0; i < how_many_shots; i++ )
		{
			level.house_sdk notify( "turret_fire" );	
			wait( 0.35 );
		}
		
		wait( RandomFloatRange( 0.5, 1.5 ) );
	
	}
		
}



sdk_blowwup()
{

	// blow up sdk
	radiusDamage( level.house_sdk.origin, 150, level.house_sdk.health + 5000, level.house_sdk.health + 4000 );
	// smoke fx
	level.house_sdk.looper = playLoopedFx( level._effect["sherman_smoke"], 1, level.house_sdk.origin );
	
	level waittill( "obj_satchel_complete" );
	
	level.house_sdk.looper delete();	
	
	
}



schrek_cleanup()
{

	self endon( "death" );
	
	self.health = 10;
	
	wait( RandomIntRange( 7, 12 ) );

	// POLISH bloody death here
	//self dodamage( self.health + 10, ( 0, 0, 0 ) );	
	self thread bloody_death( true, 0 );
	
}




///////////////////
//
// Wave one of axis
//
///////////////////////////////

wave_1()
{

	level thread defend_wave( "defend_1a_spawners", "defend_1a_ai" );
	level thread defend_wave( "defend_1b_spawners", "defend_1b_ai" );
	level thread defend_wave( "defend_2a_spawners", "defend_2a_ai", true );	
	
	// just spawn these guys once for now, them wave spawn them later
	simple_spawn( "defend_1f_spawners", ::defend_axis_strat );
	
	level thread defend_door_open();
	
	//TEMP!!!
//	axis = getaiarray( "axis" );
//	array_thread( axis, :: temp_axis_check );
	
	wait( 4 );
	
	level thread defend_wave( "defend_1c_spawners", "defend_1c_ai" );
	level thread defend_wave( "defend_1g_spawners", "defend_1g_ai" );
	
	wait( 5 );
	
	level thread defend_wave( "defend_1d_spawners", "defend_1d_ai" );
	simple_spawn( "defend_1e_spawners", ::defend_axis_strat );
	
}


//temp_axis_check()
//{
//	
//	self waittill( "death", attacker, type, weapon );
//	iprintlnbold( "a: " + attacker.classname + " type: " + type + " weapon: " + self.damageWeapon );
//	
//}


///////////////////
//
// Wave two of axis
//
///////////////////////////////

wave_2()
{

	iprintlnbold( "germans incoming, to the west!" );

	//// spawn horchs
	trig = getent( "trig_spawn_horchs", "targetname" );
	trig notify( "trigger" );
	wait( 0.05 );
	trig = getent( "trig_move_horchs", "targetname" );
	trig notify( "trigger" );
	/////////////

	level thread wall_break_1();
	level thread wall_break_2();
	
	level thread wave_2b_spawners();
	
	level thread wave_2_schreks();
	
}



wave_2_schreks()
{

	// enough wave_2 killed
	while( level.defend_axis_killed < 5 )
	{
		wait( 1 );
	}
	
	iprintlnbold( "panzerschreks incoming, to the west!" );
	
	simple_spawn( "defend_schreks" );
	
	level thread waves_move_up_quicker();
	
}



waves_move_up_quicker()
{

	// make guys move up on nodes quicker
	delay_nodes = getnodearray( "nodes_first_delay", "script_noteworthy" );
	
	for( i  = 0; i < delay_nodes.size; i++ )
	{
		if( isdefined( delay_nodes[i].script_delay ) )
		{
			
			new_delay = 5;
			
			// only use the new delay if it's lower than the previous delay
			if( delay_nodes[i].script_delay > new_delay )
			{
				delay_nodes[i].script_delay = new_delay;
			}
			
		}
	}
	
	
	flag_wait( "rush_the_house" );

	delay_nodes_2 = getnodearray( "nodes_second_delay", "script_noteworthy" );	
	delay_nodes = array_combine( delay_nodes, delay_nodes_2 );

	for( i  = 0; i < delay_nodes.size; i++ )
	{
		if( isdefined( delay_nodes[i].script_delay ) )
		{
			delay_nodes[i].script_delay = 5000;
		}
	}
			
}


///////////////////
//
// thread for respawning axis groups during the defend
//
///////////////////////////////

defend_wave( name, ai_name, skip_first_check )
{

	level endon( "stop_mansion_waves" );

	if( !isdefined( skip_first_check ) )
	{
		skip_first_check = false;
	}

	while( 1 )
	{
	
		guys = get_ai_group_ai( ai_name );
		
		// if skip_first_check is true, the group will be spawned regardless if there are any of group alive already
		if( guys.size < 1 || skip_first_check )
		{
			simple_spawn( name, ::defend_axis_strat );
			skip_first_check = false;
		}
		
		wait( RandomFloatRange( 2.0, 5.0 ) );
		
	}

	
}



///////////////////
//
// Wave 1 ends after x seconds, regardless of kills
//
///////////////////////////////

wave_1_timeout()
{
	level endon( "defend_1_done" );

	wait( 50 );
	flag_set( "defend_1_done" );
}



///////////////////
//
// Wave 2 ends after x seconds, regardless of kills
//
///////////////////////////////

wave_2_timeout()
{
	level endon( "defend_2_done" );

	wait( 70 );
	flag_set( "defend_2_done" );
}



wave_2b_spawners()
{
	
	level endon( "stop_mansion_waves" );
	
	// wait till most horch guys are dead
	while( 1 )
	{
	
		guys = get_ai_group_ai( "horch_1_ai" );
		if( guys.size < 2 )
		{
			break;	
		}
	
		wait( 1.5 );
		
	}
	
	level thread defend_wave( "defend_2b_spawners", "defend_2b_ai" );
	
}



///////////////////
//
// Open the door in the small house across from the mansion when the defend waves are near it
//
///////////////////////////////

defend_door_open()
{

	// wait until there are guys near the door	
	while( !getAIarrayTouchingVolume( "axis", "vol_defend_door" ).size )
	{
		wait( 0.35 );
	}
	
	door = getent( "door_defend", "targetname" );
	
	door rotateyaw( 120, 0.55, 0.3, 0.15 );
	door connectpaths();	
	
	
}



///////////////////
//
// Sdk crashes through fence
//
///////////////////////////////

wall_break_1()
{
	
	node = getvehiclenode( "node_wall_break_1", "script_noteworthy" );
	node waittill( "trigger" );
	
	gate_orig = getstruct( "orig_gate_break_1", "targetname" );
	playfx( level._effect["gate_vehicle_damage"], gate_orig.origin, anglestoforward( gate_orig.angles ) );
	
	// guys can now take cover in these areas
	brush = getent( "defend_gate_1", "targetname" );
	brush connectpaths();
	brush delete();
	
	wait( 3 );
	
}


///////////////////
//
// Sdk crashes through fence
//
///////////////////////////////

wall_break_2()
{
	
	node = getvehiclenode( "node_wall_break_2", "script_noteworthy" );
	node waittill( "trigger" );
	
	gate_orig = getstruct( "orig_gate_break_2", "targetname" );
	playfx( level._effect["gate_vehicle_damage"], gate_orig.origin, anglestoforward( gate_orig.angles ) );	
	
	brush = getent( "defend_gate_2", "targetname" );
	brush connectpaths();
	brush delete();	
	
	wait( 3 );
	
	// guys can now take cover in these areas
	blocker = getent( "brush_horch_blocker", "targetname" );
	blocker connectpaths();
	blocker delete();
	
}



///////////////////
//
// sdk that rolls up on the mansion
//
///////////////////////////////

sdk_rolls_up()
{

	level.house_sdk resumespeed( 5 );
	
	level endon( "sdk_retaliate" );
	
	targets = getstructarray( "sdk_targets", "targetname" );
	
	// sdk fires at mansion
	
	while( 1 )
	{
	
		current_target = random( targets );
	
		level.house_sdk setturrettargetvec( current_target.origin );
		level.house_sdk waittill_notify_or_timeout( "turret_on_target", 7 ); 
		wait ( 0.3 );
		level.house_sdk ClearTurretTarget(); 
		
		how_many_shots = randomintrange( 3, 5 );
		
		for( i  = 0; i < how_many_shots; i++ )
		{
			level.house_sdk notify( "turret_fire" );	
			wait( 0.35 );
		}
		
		wait( RandomFloatRange( 0.5, 1.5 ) );
		
	}
	
}



///////////////////
//
// Thread run on axis guys attacking the house
//
///////////////////////////////

defend_axis_strat()
{

	// if retreat has started, send them straight into the house
	if( flag( "rush_the_house" ) && !flag( "wasps_own_infantry" ) )
	{
		goal_pos = [];
		goal_pos[0] = getstruct( "orig_mansion_center", "targetname" ).origin;
		goal_pos[1] = getstruct( "orig_mansion_center_2", "targetname" ).origin;
		
		self setgoalpos( goal_pos[randomint(goal_pos.size)] );		
	}

	if( flag( "wasps_own_infantry" ) )
	{
		goal_pos = getstruct( "orig_retreat_from_wasps", "targetname" ).origin;
		self setgoalpos( goal_pos );		
	}	
	
	self waittill( "death", attacker, type );
	
	// don't count ai-placed bouncing betties
	if( !isplayer( attacker ) || type != "MOD_EXPLOSIVE" )
	{
		level.defend_axis_killed++;	
	}
	
	extra_text( "attackers killed: " + level.defend_axis_killed );
	
}



delayed_rush()
{

	self endon( "death" );
	
	goal_pos = [];
	goal_pos[0] = getstruct( "orig_mansion_center", "targetname" ).origin;
	goal_pos[1] = getstruct( "orig_mansion_center_2", "targetname" ).origin;
	
	wait( randomintrange( 4, 9 ) );

	self.goalradius = 50;

	self setgoalpos( goal_pos[randomint(goal_pos.size)] );
	
	self waittill( "goal" );
	
	self.goalradius = 500;
	
}


// TEMP, sdk will eventually take care of this
advance_fail()
{
	
	// TODO add proper endon here
	level endon( "obj_defensive_pos" );
	
	trig_warn = getent( "trig_defend_warn", "targetname" );
	trig_fail= getent( "trig_defend_fail", "targetname" );
	
	while( 1 )
	{
	
		if( any_player_istouching( trig_warn ) )
		{
		
			iprintlnbold( "Warning! Return to your squad!" );
			
			if( any_player_istouching( trig_fail ) )
			{			
				maps\_utility::missionFailedWrapper();
				return;
			}
			
		}
	
		wait( 1 );
		
	}
	
}
