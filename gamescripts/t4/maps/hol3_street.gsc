#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;

// hol3_street script

#using_animtree ("generic_human");

main()
{

	trigger_wait( "chain_pre_street_2", "targetname" );

	hide_wall_chunks();

	level thread near_town();
	// POLISH make sure sprinting past all this works
	level thread barricade_fight();
	level thread street_color_reinforcements();

	// make squad inactive
	array_thread( level.heroes, ::set_pacifist_on );
	array_thread( level.heroes, ::set_ignoreme_on );

	level.commando = simple_spawn_single( "friendly_commando", ::commando_strat );
	intro_redshirts = get_specific_ai( "intro_redshirt_ai" );
	intro_redshirts = add_to_array( intro_redshirts, level.commando );
	
	array_thread( intro_redshirts, ::set_pacifist_on );
	array_thread( intro_redshirts, ::set_ignoreme_on );

	dead_axis = Spawn( "script_model", level.commando.origin );
	dead_axis character\char_ger_wrmcht_mp40::main();
	dead_axis UseAnimTree( #animtree );
	dead_axis.animname = "body_toss_german";
	
	anim_guys = [];
	anim_guys[0] = dead_axis;
	anim_guys[1] = level.commando;
	
	anim_orig = getent( "orig_body_toss", "targetname" );
	
	anim_single( anim_guys, "body_toss", undefined, anim_orig );
	
	level.commando thread say_dialogue( "body_toss_british", "body_toss_2" );
	
	level.commando set_force_color( "g" );
	
}
	
	
	
street_color_reinforcements()
{

	flag_wait_either( "near_town_axis_alert", "grenade_throw_release" );
	
	trig = getent( "street_friendly_1", "target" );
	trig notify( "trigger" );
	
}	



commando_strat()
{
	self thread magic_bullet_shield();
	self.animname = "body_toss_british";
}



barricade_fight()
{

	level thread allies_crouch();
	
	// barrel fire
	firepoint = getstruct( "orig_street_barrel_fire", "targetname" );
	playfx( level._effect["barrel_fire"], firepoint.origin );	
	
	level thread intro_street_spawners();
	level thread near_barricade();
	
	trig = getent( "trig_near_town_edge", "targetname" );
	
	
	// wait till player is near squad
	while( 1 )
	{
		
		if( flag( "near_town_axis_alert" ) )
		{
			break;	
		}
		// if everyone is in place and player is nearby, so do grenade vignette
		else if( flag( "everyone_in_place" ) && ( any_player_IsTouching( trig ) || any_player_can_see_grenaders() ) )
		{
			grenade_vignette();
			break;
		}
	
		wait( 0.25 );
	}	
	
	savegame( "Hol3 Barricade Clear" );
	
	// re-add gren guys to color chain
	array_thread( level.heroes, ::enable_ai_color );
	level.commando enable_ai_color();
	
	// make squad active again
	array_thread( level.heroes, ::set_pacifist_off );
	array_thread( level.heroes, ::set_ignoreme_off );
	intro_redshirts = get_specific_ai( "intro_redshirt_ai" );
	commando = get_specific_ai( "friendly_commando_ai" );
	intro_redshirts = array_combine( intro_redshirts, commando );
	array_thread( intro_redshirts, ::set_pacifist_off );
	array_thread( intro_redshirts, ::set_ignoreme_off );
	
	// give them their original grenades
	for( i  = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i].grenadeammo = level.heroes[i].old_grenadeammo;
	}
	
	street_fight();

}



any_player_can_see_grenaders()
{

	players = get_players();
	
	for( i  = 0; i < players.size; i++ )
	{
		// if any player can see one of the grenaders, return true
		if( ( players[i] islookingat( level.goddard ) ) || ( players[i] islookingat( level.extra_hero ) ) || ( players[i] islookingat( level.commando ) ) )
		{
			quick_text( "grenader vignette looked at!", 3, true );
			return true;	
		}
	}
	
	return false;
	
}



///////////////////
//
// Guys throw grenades at the barricade
//
///////////////////////////////

grenade_vignette()
{

	flag_set( "grenade_throw_time" );
	
	anim_guys = [];
	anim_guys[0] = level.commando;
	anim_guys[1] = level.goddard;
	anim_guys[2] = level.extra_hero;
	
	anim_node = getnode( "node_gren_toss","targetname" );
	
	anim_single( anim_guys, "nest", undefined, anim_node );	
	
	level.commando enable_ai_color();
	level.goddard enable_ai_color();
	level.extra_hero enable_ai_color();	
	
	set_color_chain( "chain_post_gren_throw" );
	
}



///////////////////
//
// Notify when player is near the barricade mgs
//
///////////////////////////////

near_barricade()
{
	trigger_wait( "trig_near_barricade", "targetname" );
	flag_set( "near_barricade" );
}



///////////////////
//
// Allies crouch for sneak up on barricade
//
///////////////////////////////

allies_crouch()
{

	trigger_wait( "trig_setup_grens", "targetname" );

	// take gren guys off color chain
	array_thread( level.heroes, ::disable_ai_color );
	level.commando disable_ai_color();

	level thread everyone_in_place();

	// if the axis have already been alerted, don't crouch
	if( !flag( "near_town_axis_alert" ) )
	{
	
		wait( 2 );

		level.commando thread say_dialogue( "body_toss_british", "body_toss_3" );
	
		allies = getaiarray( "allies" );
		
		for( i  = 0; i < allies.size; i++ )
		{
			allies[i] thread allies_delay_crouch();
		}
		
	}
	
	level waittill_either( "grenade_throw_done", "near_town_axis_alert" );
	
	allies = getaiarray( "allies" );
	
	for( i  = 0; i < allies.size; i++ )
	{
		allies[i] allowedstances( "stand", "crouch", "prone" );
	}
	
	
}



///////////////////
//
// Make sure they start crouching once in the desired area
//
///////////////////////////////

allies_delay_crouch()
{

	self endon( "death" );
	level endon( "grenade_throw_done" );

	trig = getent( "trig_allies_start_crouching", "targetname" );
	
	while( 1 )
	{
		
		if( self isTouching( trig ) || flag( "near_town_axis_alert" ) )
		{
			break;	
		}
		
		wait( 0.3 );
		
	}
	
	// only crouch if we still need to keep quiet
	if( !flag( "near_town_axis_alert" ) )
	{
		self allowedstances( "crouch" );
	}
	
}



///////////////////
//
// Set flag when everyone is in place for grenade vignette
//
///////////////////////////////

everyone_in_place()
{

	level.commando.animname = "gren_throw_1";
	level.goddard.animname = "gren_throw_2";
	level.extra_hero.animname = "gren_throw_3";

	level.commando disable_ai_color();
	level.goddard disable_ai_color();
	level.extra_hero disable_ai_color();

	level thread anim_reach_all_nest( "nest", level.commando, "commando_in_place" );
	level thread anim_reach_all_nest( "nest", level.goddard, "goddard_in_place" );
	level thread anim_reach_all_nest( "nest", level.extra_hero, "extra_in_place" );
	
	// TEMP!
	wait( 0.2 );
	level.extra_hero.goalradius = 30;
	level.goddard.goalradius = 30;
	level.commando.goalradius = 30;
	/////////////////////////
	
	level waittill_multiple ( "commando_in_place", "goddard_in_place", "extra_in_place" );		
	
	flag_set( "everyone_in_place" );

}


anim_reach_all_nest( the_anim, guy, notify_name )
{
	
	anim_node = getnode( "node_gren_toss","targetname" );

	guy anim_reach_solo( guy, the_anim, undefined, anim_node );
	level notify( notify_name );
	
}



///////////////////
//
// Set up the fight in the street
//
///////////////////////////////

street_fight()
{

	objective_string( 1, &"HOL3_MAKE_YOUR_WAY_TOWARDS"  );
	objective_position( 1, ( 101, 4800, 139 ) );

	simple_spawn( "street_right_top_spawners" );
	simple_floodspawn( "street_bulk_spawners" );
	simple_spawn_single( "random_right_spawner_2", ::random_right_spawner_2_strat );

	level thread pub_bookcase();
	level thread main_street_battle();	
	level thread shutter_guys();
	level thread street_seekers_1();
	level thread street_seekers_2();
	level thread mid_street_reinforce();
	level thread mid_street();

	// create badplaces so allies don't run all over the street
	street_badplace = getent( "street_badplace", "targetname");
	badplace_brush( "street_badplace", 0, street_badplace, "allies" );	

	mansion_roof = getent( "mansion_roof", "targetname" );
	mansion_roof notsolid();
	mansion_roof connectpaths();

}



///////////////////
//
// Guy that pushes over bookcase in pub
//
///////////////////////////////

pub_bookcase()
{
	
	// clip brush
	bookcase_clip_brush = getent( "pub_bookcase_brush", "targetname" );
	bookcase_clip_brush notsolid();
	
	// wait till near the pub
	trigger_wait( "trig_mid_street_reinforce", "targetname" );
	
	// Blows up right house if player doesn't look at the lookat trigger but moves far ahead enough
	level thread trig_override( "trig_lookat_bookcase" );
	// wait for player to look at the bookcase area
	trigger_wait( "trig_lookat_bookcase", "targetname" );
	
	simple_floodspawn( "pub_spawner" );
	simple_spawn_single( "pub_bookcase_spawner", ::pub_bookcase_strat );
	
}



pub_bookcase_strat()
{

	self endon( "death" );

	self.goalradius = 30;
	self.animname = "street";
	
	anim_node = getent( "orig_pub_bookcase", "targetname" );
	anim_reach_solo( self, "bookcase_push", undefined, anim_node );
	
	// clip brush turn on
	bookcase_clip_brush = getent( "pub_bookcase_brush", "targetname" );
	bookcase_clip_brush solid();	
	
	anim_single_solo( self, "bookcase_push", undefined, anim_node );		
	
	wait( 5 );
	
	self.goalradius = 250;
		
}



random_right_spawner_2_strat()
{

	self endon( "death" );
	
	self.ignoreme = 1;
	
	while( 1 )
	{
		self waittill( "damage", amount, attacker );
		
		if( isdefined( attacker ) && isplayer( attacker ) )
		{
			break;
		}
	}
	
	no_sight_brush = getent( "brush_building_right", "targetname" );
	no_sight_brush delete();
	
}



///////////////////
//
// Guys that spawn near the shutters that open
//
///////////////////////////////

shutter_guys()
{
	
	trigger_wait( "trig_shutter_guys", "targetname" );

	simple_spawn( "shutter_guys" );
	
	level thread trig_override( "trig_shutters_lookat" );
	// wait for player to look in the shutters' direction
	trigger_wait( "trig_shutters_lookat", "targetname" );
	
	quick_text( "shutters open!" );
	
	// make sure there are axis ai near the shutters before they open
	guys = getAIarrayTouchingVolume( "axis", "vol_shutters" );
	
	if( guys.size )
	{

		br_left_shudder = getent( "shutters_1_l", "targetname" );
		br_right_shudder = getent( "shutters_1_r", "targetname" );
		br_left_shudder rotateyaw( -130, 0.4, 0.3, .1 );
		br_right_shudder rotateyaw( 130, 0.4, 0.3, .1 );
		wait 0.5;
		bl_left_shudder = getent("shutters_2_l", "targetname" );
		bl_right_shudder = getent("shutters_2_r", "targetname" );
		bl_left_shudder rotateyaw( -130, 0.4, 0.3, .1 );
		bl_right_shudder rotateyaw( 130, 0.4, 0.3, .1 );
	
	}
	
}



///////////////////
//
// Germans that run from the left to reinforce the fight on the main street
//
///////////////////////////////

mid_street_reinforce()
{
	
	// wait till they're close enough
	trigger_wait( "trig_mid_street_reinforce", "targetname" );
	// then wait till they're looking
	trigger_wait_or_timeout( "lookat_mid_reinforce", 15 );
	
	trig = getent( "lookat_mid_reinforce", "targetname" );
	trig delete();
	
	quick_text( "mid_street_reinforce", 3, true );

	level thread brush_building_flank();
	level thread brush_building_flank_2();

	slippers = simple_spawn( "mid_street_reinforcers", ::mid_street_reinforcers_strat );
	// TEMP OFF
//	if( isdefined( slippers ) && slippers.size )
//	{
//		slippers[randomint(slippers.size)] thread slip_on_ice( "vol_street_slip" );
//	}
	level.mid_mg_guy = simple_spawn_single( "mid_street_mgguy", ::mid_street_mg_strat );
	simple_spawn_single( "mid_street_mg_helper", ::mid_street_mg_strat_2 );
	
	// have main_street_friendlies pay no attention to mid_street_reinforcers
	setthreatbias( "main_street_friendlies", "mid_street_reinforcers", 0 );
	// have mid_street_reinforcers pay lots of attention to main_street_friendlies
	setthreatbias( "mid_street_reinforcers", "main_street_friendlies", 100000 );
	
}



slip_on_ice( vol_name )
{

	self endon( "death" );

	self.animname = "street";
	self.ignoreme = 1;
	
	vol = getent( vol_name, "targetname" );
	
	// wait till he's in the volume
	while( 1 )
	{
		if( self istouching( vol ) )
		{
			break;
		}
		
		wait( 0.05 );
	}
	
	// TODO put this back
	//if( randomint(2) )
	if( 1 )
	{
		// TODO need more anim variations?
		anim_single_solo( self, "slipping_b", undefined, self );
	}
	
	self.ignoreme = 0;
	
}



mid_street_mg_strat()
{

	self endon( "death" );
	
	self.health = 1;
	self.ignoreme = 1;
	
	level waittill( "end_fakefire_1" );
	
	self.ignoreme = 0;
	
}



mid_street_mg_strat_2()
{

	self endon( "death" );

	// make him act like the default mg guy
	self thread mid_street_mg_strat();
	
	// make sure the original mg guy spawned and is alive
	if( isdefined( level.mid_mg_guy ) && isalive( level.mid_mg_guy ) )
	{
	
		// wait till original mg guy duys
		level.mid_mg_guy waittill( "death" );
		
		wait( RandomInt( 3 ) );
		
		
		turret = getent( "mid_street_mg", "targetname" );
		
		// hop on mg		
		self setgoalnode( getnode( "auto2601", "targetname" ) );
		self.goalradius = 4;
		self waittill( "goal" );
		self.goalradius = 200;
		self maps\_spawner::use_a_turret( turret );	
	}
	
	
}



///////////////////
//
// Axis guys that run to the fence to support the main street
//
///////////////////////////////

mid_street_reinforcers_strat()
{

	self endon( "death" );

	self.ignoreall = 1;
	self.ignoresuppression = 1;
	self.ignoreme = 1;
	
	self waittill( "goal" );
	
	// set flag when they take damage
	self thread building_flank_damage();	
	
	self.ignoreall = 0;
	self.ignoresuppression = 0;	

	// don't have friendly ai fire on them till at least midstreet
	flag_wait( "mid_street" );
	
	self.ignoreme = 0;

}



building_flank_damage()
{
	self waittill( "damage" );
	flag_set( "building_flank_damage" );
}



///////////////////
//
// The brush blocking vision from the house to the fence guys
//
///////////////////////////////

brush_building_flank()
{

	trig = getent( "trig_building_flank", "targetname" );
	set_flag_on_trigger( trig, "building_flank" );
	
	// wait till player is in the room
	flag_wait( "building_flank" );
	
	// wait till one of the ai takes damage
	flag_wait( "building_flank_damage" );

	change_ai_group_goalradii( "mid_street_reinforcers_ai", 300 );

	flank_brush = getent( "brush_building_flank", "targetname" );
	flank_brush delete();
	
}



///////////////////
//
// The brush blocking vision from behind the fence guys
//
///////////////////////////////

brush_building_flank_2()
{

	// wait till one of the ai takes damage
	flag_wait( "building_flank_damage" );

	change_ai_group_goalradii( "mid_street_reinforcers_ai", 300 );

	flank_brush = getent( "brush_building_flank_2", "targetname" );
	flank_brush delete();
	
}



///////////////////
//
// Handle some color chain behavior
//
///////////////////////////////

street_chains()
{
	
	level thread trig_color_left_3();
	level thread trig_color_left_4();
	
	// delete some chains we don't need
	delete_targetname_ents( "pre_mid_town_chain_right" );
	set_color_chain( "pre_mid_town_chain_left" );
	wait( 0.05 );
	delete_targetname_ents( "pre_mid_town_chain_left" );	
	
}



trig_color_pub()
{
	
	level endon( "trig_color_pub_end" );	

	trig = getent( "chain_pub", "targetname" );
	trig trigger_off();	
	
	while( 1 )
	{
		
		// if no axis are around the area, move the chain up
		if( !get_ai_group_count( "restaurant_ai" ) )
		{
			if( !getAIarrayTouchingVolume( "axis", "trig_restaurant_vol" ).size )
			{
				break;	
			}
		}
		
		wait( 0.7 );
	}

	// turn on the chain
	trig trigger_on();
	quick_text( "trig_color_left_pub", 3, true );
	
}



///////////////////
//
// Guys on 2nd story of buildings on the right. Will playerseek if attacked from behind
//
///////////////////////////////

street_seekers_1()
{
	
	trig = getent( "trig_street_seekers_1", "targetname" );
	trig waittill( "trigger", triggerer );
	
	seekers = get_ai_group_ai( "street_seekers_1_ai" );

	for( i  = 0; i < seekers.size; i++ )
	{
		seekers[i] thread street_seeker_strat( triggerer );
	}
	
}


///////////////////
//
// Guys on 2nd story of buildings on the right. Will playerseek if attacked from behind
//
///////////////////////////////


street_seekers_2()
{
	
	trig = getent( "trig_street_seekers_2", "targetname" );
	trig waittill( "trigger", triggerer );
	
	seekers = get_ai_group_ai( "street_seekers_2_ai" );

	for( i  = 0; i < seekers.size; i++ )
	{
		seekers[i] thread street_seeker_strat( triggerer );
	}
	
}



street_seeker_strat( triggerer )
{

	self endon( "death" );
	
	while( 1 )
	{
		
		// get the nearest player
		nearest_player = get_closest_player( self.origin );
	
		// if the nearest player is the one that set off the trigger, break out of the loop
		if( nearest_player == triggerer && ( IsDefined( self.enemy ) && self.enemy == nearest_player ) )
		{
			break;	
		}
	
		wait( 0.75 );		
		
	}
	
	// set them to seek that player
	if( isdefined( nearest_player ) )
	{
		self SetGoalEntity( nearest_player ); 
	}
	
}



main_street_battle()
{

	mg = getent( "house_right_mg", "targetname" );
	mg setTurretTeam( "axis" );
	mg SetMode( "auto_nonai" );
	mg thread maps\_mgturret::burst_fire_unmanned();
	
	simple_floodspawn( "main_street_friendlies", ::main_street_friendlies_strat );
	simple_spawn_single( "house_right_mgguy", ::house_right_mgguy_strat );
	
	level thread purple_respawners();
	
	// spawn mainstreet tanks
	trig = getent( "trig_spawn_main_tank", "targetname" );
	trig notify( "trigger" );
	
	// wait for tanks to spawn in
	wait( 0.05 );

	// move tank
	trig = getent( "trig_move_main_tank", "targetname" );
	trig notify( "trigger" );	
	
	// TODO make sure these tanks never die ahead of schedule
	level thread main_street_tank_1();
	level thread main_street_tank_2();
	level thread mainstreet_car_spawners();
	
	wait( 1 );
	
	level thread main_street_fakefire();
	
}



main_street_friendlies_strat()
{
	
	self endon( "death" );
	
	self set_force_color( "p" );
	self.maxsightdistsqrd = 1500*1500;
}



purple_respawners()
{
	
	wait( 1 );
	
	guys = get_ai_group_ai( "main_street_ai" );
	
	assertex( guys.size > 0, "purple_respawners size == 0 !" );
	
	guys[0] thread magic_bullet_shield();
	
}



mainstreet_car_spawners()
{

	trigger_wait( "trig_mainstreet_car_spawners", "targetname" );

	simple_spawn( "mainstreet_car_spawners", ::mainstreet_car_spawners_strat );
	
	// have mid_street_reinforcers pay lots of attention to main_street_friendlies
	setthreatbias( "mainstreet_car_spawners", "main_street_friendlies", 100000 );	
	// have heroes pay no attention to mainstreet_car_spawners
	setthreatbias( "heroes", "mainstreet_car_spawners", 0 );	

}



mainstreet_car_spawners_strat()
{

	self endon( "death" );
	
	// don't want them targeted just yet
	self.ignoreme = 1;
	
	level waittill( "end_fakefire_1" );
	
	self.ignoreme = 0;
	
	// wait till tank is advancing
	waitnode = getvehiclenode( "main_street_wait_blowup", "script_noteworthy" );
	waitnode waittill( "trigger" );	
	
	self thread bloody_death( true, 0 );	
	
}


///////////////////
//
// Sherman tank 1 on the main street (gets blown up first)
//
///////////////////////////////

main_street_tank_1()
{
	
	tank = getent( "main_street_tank_1", "targetname" );
	tank.health = 1000000;
	tank thread main_street_tank_fire( true );
	
	waitnode = getvehiclenode( "main_street_wait_1", "targetname" );
	waitnode waittill( "trigger" );
	
	tank setspeed( 0, 6, 6 );
	
	// Blows up tank if player doesn't look at the lookat trigger but moves far ahead enough
	level thread trig_override( "trig_main_tank_blowup" );
	// wait for player to look in the tank's direction
	trigger_wait( "trig_main_tank_blowup", "targetname" );
	
	// TEMP OFF
	//start some drones
	//level thread main_street_drones();
	
	set_color_chain( "chain_post_main_tank" );
	
	tank resumespeed( 3 );
	
	wait( 1.25 );
	
	tank.health = 1000;
	
	rocket_orig = getstruct( "orig_main_rocket", "targetname" );
	rocket_time = 1.4;
	rocket_fake_fire( rocket_orig, tank.origin, rocket_time );
	
	wait( rocket_time );
	
	RadiusDamage( tank.origin, 100, tank.health + 100, tank.health + 100 );	
	
	// wait for the tank to be done its crashpath before we spawn the smoke fx
	wait( 2.75 );	
	
	// smoke fx
	tank.looper = playLoopedFx( level._effect["sherman_smoke"], 1, tank.origin );
	
	level waittill( "obj_satchel_complete" );
	
	tank.looper delete();
	
}



///////////////////
//
// Sherman tank 2 on the main street
//
///////////////////////////////

main_street_tank_2()
{
	
	wait( 0.05 );

	tank = getent( "main_street_tank_2", "targetname" );
	tank.health = 1000000;
	tank thread main_street_tank_fire();
	
	tank veh_stop_at_node( "main_street_wait_2", 6, 6 );
	
	tank setspeed( 0, 6, 6 );

	level thread trig_override( "trig_right_house_blowup" );
	// wait for player to look in the tank's direction
	trigger_wait( "trig_right_house_blowup", "targetname" );
	
	level thread right_house_blowup();
	
	tank notify( "stop_tank_firing" );
	tank clearturretTarget();
	
	wait( 2.3 );
	
	tank resumespeed( 4 );
	
	tank veh_stop_at_node( "main_street_wait_3", 6, 6 );
	
	// wait till player is at the midstreet area
	flag_wait( "mid_street" );
	event_text( "moving up tank 2" );
	
	// center its turret
	tank setturrettargetvec( ( 1215, 1875, 0 ) );
	
	tank resumespeed( 4 );

	tank veh_stop_at_node( "main_street_wait_4", 6, 6 );

	// waittill player hits midstreet
	flag_wait( "mid_street" );
	// waittill player looks over at the fakefire or some time elapses
	trigger_wait_or_timeout( "trig_blowup_fakefire", 10 );
	
	// some extra drones retreat
	trig = getent( "trig_mainstreet_drones_5", "script_noteworthy" );
	trig notify( "trigger" );
	
	simple_spawn( "main_street_retreaters", ::main_street_retreaters_strat );
	
	// have tank shoot the fakefire spot
	fire_orig = getstruct( "street_muzzleflash_1", "script_noteworthy" );
	tank setturrettargetvec( fire_orig.origin );
	tank waittill( "turret_on_target" ); 
	wait ( 0.3 );
	tank ClearTurretTarget(); 
	tank notify( "turret_fire" ); 
	
	playfx( level._effect["sandbags_explosion"], fire_orig.origin, anglestoforward( fire_orig.angles ) );
	
	level notify( "end_fakefire_1" );
	
	tank thread main_street_tank_2_mg_fire();
	
	wait( 4.2 );
	
	// have tank shoot the retreating axis
	tank setturrettargetvec( ( 1926, 1798, -22.3 ) );
	tank waittill( "turret_on_target" ); 
	wait ( 1.3 );
	tank ClearTurretTarget(); 
	tank notify( "turret_fire" );
	
	RadiusDamage( ( 1861, 1653, -39 ), 150, 190, 270 ); 
	
	tank thread tank_reset_turret();
	
	tank resumespeed( 4 );
	
	waitnode = getvehiclenode( "main_street_wait_blowup", "script_noteworthy" );
	waitnode waittill( "trigger" );	
	
	level thread chain_main_street_final();
	
	// pschrek blows up the tank
	rocket_orig = getstruct( "orig_main_rocket_2", "targetname" );
	rocket_time = 1.1;
	rocket_fake_fire( rocket_orig, tank.origin, rocket_time );
	
	wait( rocket_time );
	
	RadiusDamage( tank.origin, 100, tank.health, tank.health );	
	
	// wait for the tank to be done its crashpath before we spawn the smoke fx
	wait( 2.75 );
	
	// smoke fx
	tank.looper = playLoopedFx( level._effect["sherman_smoke"], 1, tank.origin );
	
	level waittill( "obj_satchel_complete" );
	
	tank.looper delete();	
	
}



///////////////////
//
// purple guys' last chain up the street
//
///////////////////////////////

chain_main_street_final()
{

	level endon( "obj_satchel_complete" );

	waittill_aigroupcleared( "mid_street_reinforcers_ai" );
	waittill_aigroupcleared( "mid_street_mgguy_ai" );
	waittill_aigroupcleared( "mid_street_mg_helper_ai" );

	set_color_chain( "chain_main_street_final" );	
	
}



main_street_tank_2_mg_fire()
{

	tank_mg = self.mgturret[0];
	
	bursts = 4;

	for( i  = 0; i < bursts; i++ )
	{
		
		shots = randomintrange( 8, 15 );
		
		for( i  = 0; i < shots; i++ )
		{
			tank_mg shootturret();
			wait( 0.1 );		
		}
		
		wait( RandomFloatRange( 0.7, 1.5 ) );		
		
	}
	
}


// from ber2_event1.gsc
// spawns a rocket model at an entity's location and "fires" it off
rocket_fake_fire( startSpot, endpoint, moveTime )
{
	rocket = Spawn( "script_model", startSpot.origin );
	rocket SetModel( "weapon_ger_panzershreck_rocket" );
	rocket.angles = startSpot.angles;

	thread rocket_move( rocket, endpoint, moveTime );
}

// actually moves the rocket when it is "fired"
rocket_move( rocket, endpoint, moveTime )
{

	// start the particle  
	wait( 0.1 );  // HACK TODO remove this when conserva fixes it
	PlayFxOnTag( level._effect["rocket_trail"], rocket, "tag_origin" );
	
	// play launching sound
	//thread play_sound_in_space( "katyusha_launch", rocket.origin );

	// move the rocket
	rocket MoveTo( endpoint, moveTime );

	// notify that we fired the rocket
	rocket notify( "rocket_fired" );

	// wait until the rocket is done moving, then delete it
	wait( moveTime );
	rocket Delete();
}




///////////////////
//
// Drones on street to the right of the player
//
///////////////////////////////

main_street_drones()
{
	
	level thread main_street_drones_end();
	level thread main_street_drones_cover();
	
	trig = getent( "trig_mainstreet_drones", "script_noteworthy" );
	trig notify( "trigger" );

	trig = getent( "trig_mainstreet_drones_2", "script_noteworthy" );
	trig notify( "trigger" );
	
	trig = getent( "trig_mainstreet_drones_3", "script_noteworthy" );
	trig notify( "trigger" );

	trig = getent( "trig_mainstreet_drones_4", "script_noteworthy" );
	trig notify( "trigger" );
	
}



main_street_drones_end()
{

	// this notify currently comes from a script_notify on a trigger
	level waittill( "end_main_drones_1" );

	drones = getentarray( "drone","targetname" );
	
	for( i = 0; i < drones.size; i++ )
	{
		drones[i] dodamage( drones[i].health + 10, (0,0,0) );
	}
	
}



main_street_drones_cover()
{

	level endon( "end_main_drones_1" );	

	while( 1 )
	{
	
		wait( 6 );
	
		drones = getentarray( "drone","targetname" );
		for (i = 0; i < drones.size; i++)
		{
			drones[i] notify ("drone out of cover");
			//drones[i] notify ("Stop shooting");
		}
	
	}	

}



main_street_retreaters_strat()
{

	self endon( "death" );
	
	self.ignoresuppression = 1;
	self.ignoreall = 1;
	self.ignoreme = 1;
	self waittill( "goal" );
	
	self dodamage( self.health + 50, ( 0, 0, 0 ) );
	
}



///////////////////
//
// Tank firing behavior on main street
//
///////////////////////////////

main_street_tank_fire( first_tank )
{

	self endon( "death" );
	self endon( "stop_tank_firing" );

	// first tank needs to kill some fakefire first
	if( isdefined( first_tank ) && first_tank )
	{

		fire_orig = getstruct( "street_muzzleflash_2", "script_noteworthy" );	
		self setturrettargetvec( fire_orig.origin );

		self waittill( "turret_on_target" ); 

		wait ( 1 );

		self ClearTurretTarget(); 
		self notify( "turret_fire" ); 

		level notify( "end_fakefire_2" );

		wait( 2.7 );		
		
	}


	fire_origins = getstructarray( "orig_main_tank_fire", "targetname" );

	while( 1 )
	{
	
		self setturrettargetvec( fire_origins[randomint(fire_origins.size)].origin );

		self waittill( "turret_on_target" ); 

		wait ( 1 );

		self ClearTurretTarget(); 
		self notify( "turret_fire" ); 

		wait( RandomIntRange( 4, 7 ) );
		
	}

}




///////////////////
//
// ambient: spawners that run from a distance into some buildings, then are killed
//
///////////////////////////////

intro_street_spawners()
{

	level endon( "stop_intro_street_spawners" );

	trigger_wait( "trig_intro_street_runners", "targetname" );

	level thread stop_intro_street_spawners();	

	while( 1 )
	{
	
		guys = get_ai_group_ai( "intro_street_ai" );
		if( guys.size < 1 )
		{
			simple_spawn( "intro_street_runners", ::intro_street_runners_strat );
		}
		
		wait( RandomFloatRange( 4.0, 7.0 ) );
		
	}

}



///////////////////
//
// stop intro street spawners when progressed far enough
//
///////////////////////////////

stop_intro_street_spawners()
{
	trigger_wait( "trig_stop_intro_street_runners", "targetname" );
	level notify( "stop_intro_street_spawners" );
}



intro_street_runners_strat()
{

	self endon( "death" );
	
	self.ignoresuppression = 1;
	self waittill( "goal" );
	
	self dodamage( self.health + 50, ( 0, 0, 0 ) );
	
}




///////////////////
//
// Sets up action as player gets near the town
//
///////////////////////////////

near_town()
{

	level thread near_town_axis_alert();
	level thread barricade_advance_chain();

	simple_spawn( "building_street_1_spawners", ::building_street_1_spawners_strat );	
	simple_spawn( "building_street_2_spawners", ::building_street_2_spawners_strat );
	
	// set up pub guys fire barrel anims
	pub_guys = simple_spawn( "pub_retreater", ::pub_retreater_strat );

	fire_anims = [];
	fire_anims[0] = "fire_a";
	fire_anims[1] = "fire_b";
	fire_anims[2] = "fire_d";

	assertex( pub_guys.size == fire_anims.size, "pub_guys.size != fire_anims.size !!!" );

	for( i  = 0; i < pub_guys.size; i++ )
	{
		pub_guys[i].animname = "rail";
		
		goalnode = getnode( pub_guys[i].target, "targetname" );
		
		level thread anim_loop_solo( pub_guys[i], fire_anims[i], undefined, "stop_barrel_loop", goalnode );		
	}
	
}



///////////////////
//
// In case the surprise is botched, then the player hangs back and kills all the barricade dudes, then move the chain up
//
///////////////////////////////

barricade_advance_chain()
{

	// if grenade throw happens, don't need this chain anymore
	level endon( "grenade_throw_time" );
	// if player moves up, don't need this chain anymore
	trig = getent( "chain_barricade", "targetname" );
	trig endon( "trigger" );
	
	flag_wait( "near_town_axis_alert" );

	while( 1 )
	{
		
		guys = getAIarrayTouchingVolume( "axis", "vol_barricade" );
			
		if( !guys.size )
		{
			break;	
		}			
			
		wait( 0.5 );
	
	}
	
	set_color_chain( "chain_post_gren_throw" );
	
}


///////////////////
//
// Guy on mg in first house on the right
//
///////////////////////////////

house_right_mgguy_strat()
{

	self.ignoreme = 1;

	self waittill( "death" );
	
	mg = getent( "house_right_mg", "targetname" );
	mg SetMode( "manual" );
	
}



///////////////////
//
// Alert axis near the barricade
//
///////////////////////////////

near_town_axis_alert()
{

	level thread near_town_dmg_trigger();
	level thread near_town_grenade_watch();
	level thread near_town_crouch_alert();
	level thread botched_throw_chain();
	level thread barricade_nosight();
	
	level endon( "near_town_axis_alert" );
	level endon( "grenade_throw_time" );

	// waittill player nears town
	trigger_wait( "trig_near_town", "targetname" );
	event_text( "near_town" );
	
	// if player walks up out in the open street
	flag_set( "near_town_axis_alert" );
	
}



barricade_nosight()
{

	flag_wait_either( "near_town_axis_alert", "grenade_throw_time" );
	
	brush = getent( "brush_barricade_nosight", "targetname" );
	brush delete();
	
}



///////////////////
//
// Alert axis if a grenade lands in the vicinity
//
///////////////////////////////

near_town_grenade_watch()
{

	level endon( "near_town_axis_alert" );
	level endon( "grenade_throw_time" );

	vol = getent( "vol_barricade_gren_watch", "targetname" );

	while( 1 )
	{

		grenades = getentarray ( "grenade", "classname" );
		
		for (i = 0; i < grenades.size; i++)
		{
			if( grenades[i] istouching( vol ) )
			{
				quick_text( "grenade_alert!", 3, true );
				flag_set( "near_town_axis_alert" );
			}
		}
		
		wait( 0.25 );
	
	}
	
}




///////////////////
//
// The color chain that is set if the surprise is botched
//
///////////////////////////////

botched_throw_chain()
{

	level endon( "grenade_throw_time" );

	flag_wait( "near_town_axis_alert" );

	set_color_chain( "chain_post_gren_throw_botched" );
	
}



///////////////////
//
// If player stands up and alerts the axis to his presence
//
///////////////////////////////

near_town_crouch_alert()
{
	
	level endon( "near_town_axis_alert" );
	level endon( "grenade_throw_time" );
	
	trig = getent( "trig_near_town_crouching", "targetname" );
	
	player_stood_up = 0;
	
	while( player_stood_up < 4 )
	{
	
		players = get_players(); 
	
		for( i = 0; i < players.size; i++ )
		{
			if( IsAlive( players[i] ) && players[i] IsTouching( trig ) && players[i] getstance() == "stand" )
			{
				player_stood_up++;
				quick_text( "player stood up partial: " + player_stood_up, 3, true );
			}
		}
		
		wait( 0.25 );
		
	}

	quick_text( "town alert; player stood up!!!" + player_stood_up, 3, true );

	// if player stands up in the bushes	
	flag_set( "near_town_axis_alert" );
	
}



///////////////////
//
// If player fires near barricade, alert the germans
//
///////////////////////////////

near_town_dmg_trigger()
{

	level endon( "near_town_axis_alert" );
	level endon( "grenade_throw_time" );
	
	trig = getent( "trig_barricade_damage", "targetname" );
	
	player_triggered = false;
	
	while( !player_triggered )
	{
	
		trig waittill( "damage", damage_amount, attacker );
	
		players = get_players();
		
		for( i  = 0; i < players.size; i++ )
		{
			if( players[i] == attacker )
			{
				player_triggered = true;
			}
		}
		
		wait( 0.25 );
		
	}
	
	trig delete();
	event_text( "near_town_dmg_trigger" );
	
	// if player fires near the barricade
	flag_set( "near_town_axis_alert" );
	
}



///////////////////
//
// Alert axis if any one of them takes damage
//
///////////////////////////////

near_town_axis_damage()
{

	level endon( "grenade_throw_time" );

	self waittill( "damage" );
	// if one of the patrol barricade guys takes damage
	flag_set( "near_town_axis_alert" );
	
}



building_street_1_spawners_strat()
{
	
	self endon( "death" );
	self.ignoreall = 1;
	self set_pacifist_on();
	
	self thread near_town_axis_damage();
	
	flag_wait_either( "near_town_axis_alert", "grenade_throw_release" );
	
	// now aware of player/squad
	level thread barricade_mg_owner( "barricade_mg_l" );
	self stop_patrol_behavior();
	self.ignoreall = 0;
	self set_pacifist_off();	
	
	flag_wait_either( "near_town_axis_alert", "grenade_throw_done" );
	
	// retreat behind barricade
	self.script_goalvolume = 107;
	goal = getnode( self.script_noteworthy, "targetname" );
	self setgoalnode( goal );
	
	
	// if they're the default mg guy
	if( isdefined( goal.target ) && goal.target == "barricade_mg_l" )
	{
		//self thread barricade_mg_l_death();
		turret = getent( "barricade_mg_l", "targetname" );
		turret thread barricade_mg_l_monitor();		
		self thread barricade_mg_strat( goal.target );	
	}
	
	self maps\_spawner::set_goal_volume();
	
	// run inside shortly after the grenade throw, or if player breaks the line
	if( flag( "grenade_throw_done" ) )
	{
		wait( RandomFloatRange( 2.0, 4.5 ) );
	}
	else
	{
		wait( RandomFloatRange( 3.0, 6.5 ) );
		self.goalradius = 200;
		flag_wait( "near_barricade" );
	}
	
	
	self.ignoresuppression = 1;
	self.script_goalvolume = 101;
	self.goalradius = 2048;
	self setgoalpos( ( -632, 830, -62 ) );
	self maps\_spawner::set_goal_volume();	
	
}



building_street_2_spawners_strat()
{
	
	self endon( "death" );
	self.ignoreall = 1;
	self set_pacifist_on();
	
	self thread near_town_axis_damage();
	
	flag_wait_either( "near_town_axis_alert", "grenade_throw_release" );	

	// now aware of player/squad	
	level thread barricade_mg_owner( "barricade_mg_r" );
	self stop_patrol_behavior();
	self.ignoreall = 0;
	self set_pacifist_off();	
	
	flag_wait_either( "near_town_axis_alert", "grenade_throw_done" );
	
	// retreat behind barricade	
	self.script_goalvolume = 107;
	goal = getnode( self.script_noteworthy, "targetname" );
	self setgoalnode( goal );
	
	// if they're the default mg guy
	if( isdefined( goal.target ) && goal.target == "barricade_mg_r" )
	{
		//self thread barricade_mg_r_death();
		turret = getent( "barricade_mg_r", "targetname" );
		turret thread barricade_mg_r_monitor();
		self thread barricade_mg_strat( goal.target );	
	}
		
	self maps\_spawner::set_goal_volume();
	
	
	// run inside shortly after the grenade throw, or if player breaks the line
	if( flag( "grenade_throw_done" ) )
	{
		wait( RandomFloatRange( 2.0, 4.5 ) );
	}
	else
	{
		wait( RandomFloatRange( 3.0, 6.5 ) );
		self.goalradius = 200;		
		flag_wait( "near_barricade" );
	}
	
	self.ignoresuppression = 1;
	self.script_goalvolume = 110;
	self.goalradius = 2048;
	self setgoalpos( ( 551, 161, -46 ) );
	self maps\_spawner::set_goal_volume();
	
}



barricade_mg_strat( mg_name )
{

	self endon( "death" );
	
	self.on_barricade_mg = true;
	
	if( mg_name == "barricade_mg_l" )
	{
		// TODO use flag
		level.barricade_mg_l_occupied = 1;
	}
	else
	{
		level.barricade_mg_r_occupied = 1;
	}
	
	self waittill( "goal" );
	
	turret = getent( mg_name, "targetname" );
	
	//turret SetMode( "auto_nonai" );
	self Useturret( turret );
	
	//self maps\_spawner::use_a_turret( turret ); 
	
}



barricade_mg_l_monitor()
{
	
	level endon( "near_barricade" );
	
	wait( 5 );
	
	while( 1 )
	{
	
		if( !isdefined( self getturretowner() ) )
		{
			level.barricade_mg_l_occupied = 0;
			//self SetMode( "manual" );
		}
		
		wait( 1.0 );
		
	}
	
}



barricade_mg_r_monitor()
{
	
	level endon( "near_barricade" );
	
	wait( 5 );
	
	while( 1 )
	{
	
		if( !isdefined( self getturretowner() ) )
		{
			level.barricade_mg_r_occupied = 0;
			//self SetMode( "manual" );
		}
		
		wait( 1.0 );
		
	}
	
}



///////////////////
//
// Guys hop on mgs if they're not occupied
//
///////////////////////////////

barricade_mg_owner( mg_name )
{

	level endon( "near_barricade" );
	level endon( "grenade_throw_done" );

	wait( 3 );
	
	turret = getent( mg_name, "targetname" );
	mg_node = getnode( mg_name, "target" );
	
	guys = get_ai_group_ai( "barricade_ai" );	
	
	while( guys.size )
	{
	
		// TODO tidy this shit up
		if( (mg_name == "barricade_mg_l" && !level.barricade_mg_l_occupied) || (mg_name == "barricade_mg_r" && !level.barricade_mg_r_occupied) )
		{
			
			for( i  = 0; i < guys.size; i++ )
			{			
				// make sure he's not on an mg already
				if( !isdefined( guys[i].on_barricade_mg ) || ( isdefined( guys[i].on_barricade_mg ) && !guys[i].on_barricade_mg ) )
				{
					guys[i] thread guy_hop_on_mg( mg_node, turret );
					wait( 3 );
					break;
				}
			}
	
		}
	
		wait( RandomFloatRange( 1.5, 3.0 ) );
		
		guys = get_ai_group_ai( "barricade_ai" );	
		
	}
	
}




guy_hop_on_mg( mg_node, turret )
{
	
	self endon( "death" );
	
	if( mg_node.target == "barricade_mg_l" )
	{
		//self thread barricade_mg_l_death();
		level.barricade_mg_l_occupied = 1;
	}
	else
	{
		//self thread barricade_mg_r_death();
		level.barricade_mg_r_occupied = 1;
	}	
	
	self.on_barricade_mg = true;
	
	self setgoalnode( mg_node );
	self.goalradius = 4;
	self waittill( "goal" );
	self.goalradius = 200;
	
	//turret SetMode( "auto_nonai" );
	self Useturret( turret );
	//self maps\_spawner::use_a_turret( turret );	
}



///////////////////
//
// stops _patrol behavior by sending an "enemy" notify
//
///////////////////////////////

stop_patrol_behavior()
{
	
	if( isdefined( self.script_patroller ) && self.script_patroller == 1 )
	{
		self notify( "enemy" );
		wait( 0.05 );
	}	
	
}



///////////////////
//
// Strat for guys around fire barrel
//
///////////////////////////////

pub_retreater_strat()
{
	
	self endon( "death" );
	self.ignoreall = 1;
	self set_pacifist_on();
	
	self thread near_town_axis_damage();
	
	flag_wait_either( "near_town_axis_alert", "grenade_throw_release" );
	
	// now aware of player/squad
	self.ignoreall = 0;
	self set_pacifist_off();	
	
	flag_wait_either( "near_town_axis_alert", "grenade_throw_done" );
	
	// stop the anim loop
	self stopanimscripted();
	
	wait( RandomFloatRange( 0.8, 2.0 ) );

	// retreat indoors
	
	self.script_goalvolume = 101;
	goal = getnode( self.script_noteworthy, "targetname" );
	self setgoalnode( goal );
	self maps\_spawner::set_goal_volume();
	self.goalradius = 2048;	

}



///////////////////
//
// Mgs for ambient battle to the right
//
///////////////////////////////

main_street_fakefire()
{

	shot_origin = getstruct( "street_muzzleflash_1" ,"script_noteworthy" );
	shot_destination = getent( "street_bullet_hit_1", "script_noteworthy" );

	level thread fakefire_move_target( shot_destination );

	level thread main_street_fakefire_think( shot_origin, shot_destination, "end_fakefire_1" );

	shot_origin = getstruct( "street_muzzleflash_2" ,"script_noteworthy" );
	shot_destination = getent( "street_bullet_hit_2", "script_noteworthy" );

	level thread main_street_fakefire_think( shot_origin, shot_destination, "end_fakefire_2" );


	flag_wait( "mid_street" );

	shot_origin = getstruct( "street_muzzleflash_3" ,"script_noteworthy" );
	shot_destination = getent( "street_bullet_hit_3", "script_noteworthy" );

	level thread main_street_fakefire_think( shot_origin, shot_destination, "obj_assault_complete" );

}



///////////////////
//
// Move the script origin that the fake fire is firing at back and forth 
//
///////////////////////////////

fakefire_move_target( orig )
{

	level endon( "stop_fakefire_mover" );
	
	targ_1 = orig.origin + ( 200, 50, 0 );
	targ_2 = orig.origin - ( 200, 0, 0 );

	while( 1 )
	{
		orig MoveTo( targ_1, 5 );
		orig waittill( "movedone" );
		orig MoveTo( targ_2, 5 );
		orig waittill( "movedone" );
	}	
	
}



///////////////////
//
// Tank fires at mg house on right
//
///////////////////////////////

right_house_blowup()
{

	wait( RandomFloatRange( 0.0, 1.75 ) );

	orig = getstruct( "orig_right_house_blowup", "targetname" );
	
	playfx( level._effect["sandbags_explosion"], orig.origin, anglestoforward( orig.angles ) );

	boards = getent( "right_house_boards", "targetname" );
	boards delete();
	
	// turn off the mg
	mg = getent( "house_right_mg", "targetname" );
	mg SetMode( "manual" );
	
	mgguy = get_specific_single_ai( "house_right_mgguy_ai" );
	if( isdefined( mgguy ) && isalive( mgguy ) )
	{
		mgguy dodamage( mgguy.health + 20, mgguy.origin - ( 0, 100, 0 ) );
	}

}



///////////////////
//
// Fakefire for mainstreet mgs
//
///////////////////////////////

main_street_fakefire_think( shot_origin, shot_destination, ender )
{
	
	level endon( ender );
	
	while( 1 )
	{
		
		if ( isdefined ( shot_origin.is_firing ) && shot_origin.is_firing == true)
		{
			continue;
		}

		// were good to go
		shot_origin.is_firing = true;

		// burst fire
		clipsize = randomintrange( 8, 15 );
		for ( i = 0; i < clipsize; i++ )
		{

			// play fx with tracers
			playfx ( level._effect["mg42_muzzleflash"], shot_origin.origin, anglestoforward( shot_origin.angles ) );

			magicbullet( "mp40", shot_origin.origin, shot_destination.origin );

			wait ( randomfloatrange( 0.05, 0.15 ) );
			
		}
		
		wait( randomfloatrange( 1.1, 1.75 ) );
		
		// can be accessed again
		shot_origin.is_firing = false;

	}
	
}



///////////////////
//
// Mgs in the mansion
//
///////////////////////////////

mansion_mgs()
{

	simple_floodspawn( "street_mg_spawners", ::street_mg_spawners_strat );

	// have mg guys pay less attention to heroes
	setthreatbias( "street_mg_guys", "heroes", 10 );
	level thread mansion_mg_threatbias();
	
}



street_mg_spawners_strat()
{
	//self thread magic_bullet_shield();
	self.ignoreme = 1;
}



///////////////////
//
// Repeatedly set threat bias between mg guys and intro redshirts
//
///////////////////////////////

mansion_mg_threatbias()
{
	
	level endon( "obj_assault_complete" );	
	
	while( 1 )
	{
	
		guys = get_specific_ai( "intro_redshirt_ai" );
		for( i  = 0; i < guys.size; i++ )
		{
			guys[i] setthreatbiasgroup( "intro_redshirt_ai" );
		}
		
		// have mg guys pay less attention to redshirts
		setthreatbias( "street_mg_guys", "intro_redshirt_ai", 10 );		
	
		wait( 1.5 );
		
	}	
	
}



///////////////////
//
// Turn on color chain when building 3 on left is cleared (or when player rushes really far ahead)
//
///////////////////////////////

trig_color_left_3()
{
	
	// script_notify on trigger will send the notify
	level endon( "trig_color_left_3_end" );

	trig = getent( "trig_color_left_3", "script_noteworthy" );
	trig trigger_off();
	
	waittill_aigroupcleared( "street_ai_left_3" );
	
	trig trigger_on();
	extra_text( "trig_color_left_3" );
	
	// retreat some close axis ai if needed
	axis_ai = get_ai_group_ai( "color_left_3_ai" );
	for( i  = 0; i < axis_ai.size; i++ )
	{
		extra_text( "retreating color_left_3_ai" );
		axis_ai[i].script_goalvolume = undefined;
		axis_ai[i].goalradius = 1000;
		axis_ai[i] setgoalpos( ( -817, 2459, -15 ) );
	}
	
}



///////////////////
//
// Turn on color chain when building 4 on left is cleared
//
///////////////////////////////

trig_color_left_4()
{

	// script_notify on trigger will send the notify
	level endon( "trig_color_left_4_end" );
	
	trig = getent( "trig_color_left_4", "script_noteworthy" );
	trig trigger_off();
	
	waittill_aigroupcleared( "street_ai_left_4" );
	
	trig trigger_on();
	extra_text( "trig_color_left_4" );
	
}



///////////////////
//
// Action that happens mid way up the street
//
///////////////////////////////
#using_animtree("generic_human");

mid_street()
{

	trigger_wait( "trig_mid_street", "targetname" );
	
	flag_set( "mid_street" );
	event_text( "mid_street" );

	simple_floodspawn( "restaurant_spawners" );

	level thread street_chains();
	level thread mansion_mgs();
	level thread move_pub_ai();
	level thread trig_color_pub();
	level thread mansion_pen_ai();
	level thread street_respawner_clear();
	level thread satchel_charge_prepare();
	
	// wait till player looks down the street or after a certain amount of time
	trigger_wait_or_timeout( "trig_mid_street_lookat", 6 );

	// Guys that run across street behind tank-traps and guys that jump and slide down snow drift	
	simple_floodspawn( "mid_street_spawners" );
	
	mid_street_2();
	
}



///////////////////
//
// Stop color respawns in street event
//
///////////////////////////////

street_respawner_clear()
{

	trigger_wait( "trig_respawn_street_clear", "script_noteworthy" );

	// to stop guys from being respawned in as blue guys when the next friendly_respawn_trigger is hit (also done in lastSequence() in bog_b.gsc)
	allies = getaiarray( "allies" );
	for( i  = 0; i < allies.size; i++ )
	{
		allies[i] notify( "_disable_reinforcement" );
	}
	
}



///////////////////
//
// Controlled spawning of dudes near the mansion that run up
//
///////////////////////////////

mansion_pen_ai()
{
	
	level endon( "stop_mansion_pen_ai" );	
	
	level thread stop_mansion_pen_ai();	
	
	while( 1 )
	{
	
		guys = get_ai_group_ai( "mansion_pen_ai" );
		if( guys.size < 1 )
		{
			slippers = simple_spawn( "mansion_pen_spawners" );
			// TEMP OFF!
//			if( isdefined( slippers ) && slippers.size )
//			{
//				slippers[randomint(slippers.size)] thread slip_on_ice( "vol_street_slip_2" );
//			}
		}
		
		wait( RandomFloatRange( 2.0, 4.0 ) );
		
	}
	
}



stop_mansion_pen_ai()
{
	trigger_wait( "trig_stop_mansion_pen_ai","targetname" );
	level notify( "stop_mansion_pen_ai" );
}



///////////////////
//
// Move guys from restaurant area to building where they spawn so that they don't get left behind
//
///////////////////////////////

move_pub_ai()
{

	guys = get_ai_group_ai( "pub_ai" );
	nodes = getnodearray( "node_pub_ai", "targetname" );
	
	for( i  = 0; i < guys.size; i++ )
	{
		guys[i].goalradius = 1000;
		guys[i] setgoalnode( nodes[i] );
	}
	
}



///////////////////
//
// Action that happens further up the street
//
///////////////////////////////

mid_street_2()
{
	
	wait( 4 );
	
	level thread trig_override( "trig_mid_street_lookat_2" );
	// wait for player to look further down the street
	trigger_wait( "trig_mid_street_lookat_2", "targetname" );
	
	
	event_text( "mid_street_2" );
	
	simple_spawn( "mid_street_spawners_2", ::mid_street_spawners_2_strat );
	
}



mid_street_spawners_2_strat()
{
	
	self endon( "death" );
	
	self.pacifist = 1;
	self waittill( "goal" );
	
	self dodamage( self.health + 50, ( 0, 0, 0 ) );
	
}



///////////////////
//
// Prepare satchel charge event
//
///////////////////////////////

#using_animtree("scripted_wall");
satchel_charge_prepare()
{

	trigger_wait( "mid_street_spawners_2_override", "targetname" );

	//do some cleanup
	kill_aigroup( "pub_ai" );
	trig = getent( "auto1097", "target" );
	if( isdefined( trig ) )
	{
		trig delete();
	}
	trig = getent( "auto2357", "targetname" );
	if( isdefined( trig ) )
	{
		trig delete();
	}


	// TODO make this threaded so you can still satchel even if axis are around?
	satchel_defenders_monitor();
	
	level notify( "obj_assault_complete" );
	
	//delete color chain we dont need
	trig = getent( "chain_near_satchel", "script_noteworthy" );
	trig delete();
	
	
	satchel_charge();
	
}



satchel_defenders_monitor()
{

	waittill_aigroupcleared( "satchel_defender_ai" );
	quick_text( "satchel defenders killed", 3, true );	

	level thread ditch_street_friendlies();
	set_color_chain( "chain_satchel" );
	
}



///////////////////
//
// Take extra redshirts and commando off the color chain
//
///////////////////////////////

ditch_street_friendlies()
{

	guys = get_specific_ai( "intro_redshirt_ai" );
	
	for( i  = 0; i < guys.size; i++ )
	{
		guys[i] disable_ai_color();
	}
	
	// make him a regular redshirt now
	level.commando disable_ai_color();
	level.commando.script_noteworthy = "intro_redshirt_ai";
	
}



///////////////////
//
// Satchel charge the mansion
//
///////////////////////////////

satchel_charge()
{
	
	// wait till player uses the trigger
	trig = getent( "trig_satchel", "targetname" );
	trig waittill( "trigger" );

	trig delete();
	
	quick_text( "satchel charge building!" );
	
	satchel_orig = getstruct( "orig_satchel", "targetname" );
	
	satchel = spawn( "script_model", satchel_orig.origin );
	satchel setmodel( "viewmodel_usa_satchel_charge" );	
	satchel.angles = satchel_orig.angles;
	
	wait( 3.0 );
	
	kill_aigroup( "street_mg_ai" );

	satchel delete();

	// actual fx and animation for explosion
	level thread satchel_explosion();
	
	level thread cleanup_satchel_axis();
	
	maps\hol3_defend::main();
	
}



cleanup_satchel_axis()
{

	// TODO even need this?
	trigger_wait( "trig_inside_mansion", "script_noteworthy" );

	trig = getent( "trig_killspawner_106", "targetname" );
	trig notify( "trigger" );

	level thread kill_all_axis_ai();
	level thread kill_aigroup( "main_street_ai" );
	
	simple_spawn( "mansion_core_spawners", ::mansion_core_strat );	
	
}


mansion_core_strat()
{

	self endon( "death" );
	
	self.ignoreall = 1;
	
	flag_wait( "mansion_door_kick" );
	
	wait( 3 );

	// TODO make them just ignore the friendly ai, so that if the player barges in he won't see the axis ai ignoring him
	
	self.ignoreall = 0;
	
}



///////////////////
//
// Satchel charge the wall to open up the mansion
//
///////////////////////////////

#using_animtree("scripted_wall");
satchel_explosion()
{

	mansion_hole = getent( "mansion_hole", "targetname" );
	
	playfx( level._effect["satchel_house"], mansion_hole.origin );
	mansion_hole connectpaths();
	wait( 0.05 );
	// remove brushmodel
	mansion_hole delete();

	mansion_roof = getent( "mansion_roof", "targetname" );
	mansion_roof solid();
	mansion_roof disconnectpaths();

	show_wall_chunks();

	// numbered left-right relative to how the player first sees them
	chunk_1 = GetEnt( "wall_chunk_1", "targetname" );
	chunk_2 = GetEnt( "wall_chunk_2", "targetname" );
	chunk_3 = GetEnt( "wall_chunk_5", "targetname" ); // account for misnaming
	chunk_4 = GetEnt( "wall_chunk_3", "targetname" ); // account for misnaming
	chunk_5 = GetEnt( "wall_chunk_4", "targetname" ); // account for misnaming
	chunk_6 = GetEnt( "wall_chunk_6", "targetname" );
	chunk_7 = GetEnt( "wall_chunk_7", "targetname" );
	chunk_8 = GetEnt( "wall_chunk_8", "targetname" );
	chunk_9 = GetEnt( "wall_chunk_9", "targetname" );
	
	// animated version
	animSpot = getnode( "node_satchel_explosion", "targetname" );
	
	chunk_1.script_linkto = "chunk01_jnt";
	chunk_2.script_linkto = "chunk02_jnt";
	chunk_3.script_linkto = "chunk03_jnt";
	chunk_4.script_linkto = "chunk04_jnt";
	chunk_5.script_linkto = "chunk05_jnt";
	chunk_6.script_linkto = "chunk06_jnt";
	chunk_7.script_linkto = "chunk07_jnt";
	chunk_8.script_linkto = "chunk08_jnt";
	chunk_9.script_linkto = "chunk09_jnt";
	
	chunks = [];
	chunks[0] = chunk_1;
	chunks[1] = chunk_2;
	chunks[2] = chunk_3;
	chunks[3] = chunk_4;
	chunks[4] = chunk_5;
	chunks[5] = chunk_6;
	chunks[6] = chunk_7;
	chunks[7] = chunk_8;
	chunks[8] = chunk_9;						
	
	Earthquake( 0.5, 2, animSpot.origin, 500 );
	
	anim_ents( chunks, "satchel_wall", undefined, undefined, animSpot, "satchel_wall_controlmodel" );

	level notify( "obj_satchel_complete" );
	savegame( "Hol3 Start Mansion Clear" );
	// send guys inside
	set_color_chain( "chain_mansion" );		
	
}



///////////////////
//
// Hide script_brushmodels that animate during satchel explosion
//
///////////////////////////////

hide_wall_chunks()
{

	chunks = getentarray( "wall_chunks", "script_noteworthy" );
	
	for( i  = 0; i < chunks.size; i++ )
	{
		chunks[i] hide();
	}
	
}



///////////////////
//
// Show script_brushmodels that animate during satchel explosion
//
///////////////////////////////

show_wall_chunks()
{

	chunks = getentarray( "wall_chunks", "script_noteworthy" );
	
	for( i  = 0; i < chunks.size; i++ )
	{
		chunks[i] show();
	}
	
}
