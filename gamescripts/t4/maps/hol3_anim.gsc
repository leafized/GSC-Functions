// hol3 anim file

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\pel2_util;

#using_animtree ("generic_human");
main()
{

	// truck unload

	level thread addNotetrack_attach( "truck_unload_0", "attach", "static_holland_gm_ammobox2", "tag_inhand", "truck_unload" );
	level thread addNotetrack_detach( "truck_unload_0", "detach", "static_holland_gm_ammobox2", "tag_inhand", "truck_unload" );

	// body toss
	/////////////
	level thread addNotetrack_customFunction( "body_toss_german", "snowpoof", ::body_toss_german_fx, "body_toss" );


	// nest throw
	/////////////
	level thread addNotetrack_customFunction( "gren_throw_2", "gren_throw_1", ::hero_throw_grenade, "nest" );
	level thread addNotetrack_customFunction( "gren_throw_3", "gren_throw_2", ::hero_throw_grenade, "nest" );
	
	
	// bookcase push
	/////////////////
	level thread addNotetrack_customFunction( "street", "attach", ::bookcase_push_attach, "bookcase_push" );
	level thread addNotetrack_customFunction( "street", "detach", ::bookcase_push_detach, "bookcase_push" );
	level thread addNotetrack_attach( "street", "attach", "static_berlin_bookshelf_short", "tag_weapon_left", "bookcase_push" );
	level thread addNotetrack_detach( "street", "detach", "static_berlin_bookshelf_short", "tag_weapon_left", "bookcase_push" );	
	
	// mansion
	//////////////////
	level thread addNotetrack_customFunction( "door_kicker", "bash", ::mansion_door_kick_timing, "door_kick" );
	
	
	// furniture push
	//////////////////
	level thread addNotetrack_customFunction( "furniture_2", "attach_1", ::furniture_note_2_a_1, "furniture_push" );
	level thread addNotetrack_customFunction( "furniture_2", "detach_1", ::furniture_note_2_d_1, "furniture_push" );
	level thread addNotetrack_attach( "furniture_2", "attach_1", "static_berlin_dresser_open_1", "tag_weapon_left", "furniture_push" );
	level thread addNotetrack_detach( "furniture_2", "detach_1", "static_berlin_dresser_open_1", "tag_weapon_left", "furniture_push" );	
	
	level thread addNotetrack_customFunction( "furniture_2", "attach_2", ::furniture_note_2_a_2, "furniture_push" );
	level thread addNotetrack_customFunction( "furniture_2", "detach_2", ::furniture_note_2_d_2, "furniture_push" );
	level thread addNotetrack_attach( "furniture_2", "attach_2", "static_holland_china_cabinet_h3", "tag_weapon_left", "furniture_push" );
	level thread addNotetrack_detach( "furniture_2", "detach_2", "static_holland_china_cabinet_h3", "tag_weapon_left", "furniture_push" );		
	
	level thread addNotetrack_customFunction( "furniture_3", "attach_1", ::furniture_note_3_a_1, "furniture_push" );
	level thread addNotetrack_customFunction( "furniture_3", "detach_1", ::furniture_note_3_d_1, "furniture_push" );
	level thread addNotetrack_attach( "furniture_3", "attach_1", "static_holland_dresser_open_h3", "tag_weapon_left", "furniture_push" );
	level thread addNotetrack_detach( "furniture_3", "detach_1", "static_holland_dresser_open_h3", "tag_weapon_left", "furniture_push" );		
	
	level thread addNotetrack_customFunction( "furniture_3", "attach_2", ::furniture_note_3_a_2, "furniture_push" );
	level thread addNotetrack_customFunction( "furniture_3", "detach_2", ::furniture_note_3_d_2, "furniture_push" );
	level thread addNotetrack_attach( "furniture_3", "attach_2", "static_berlin_china_cabinet", "tag_weapon_left", "furniture_push" );
	level thread addNotetrack_detach( "furniture_3", "detach_2", "static_berlin_china_cabinet", "tag_weapon_left", "furniture_push" );	


	// furniture guns
	///////////////////
	level thread addNotetrack_customFunction( "furniture_1", "gun_attach1", ::furniture_gun_note_a, "furniture_push" );
	level thread addNotetrack_customFunction( "furniture_1", "gun_detach1", ::furniture_gun_note_d, "furniture_push" );
	level thread addNotetrack_customFunction( "furniture_2", "gun_attach2", ::furniture_gun_note_a, "furniture_push" );
	level thread addNotetrack_customFunction( "furniture_2", "gun_detach2", ::furniture_gun_note_d, "furniture_push" );
	level thread addNotetrack_customFunction( "furniture_3", "gun_attach3", ::furniture_gun_note_a, "furniture_push" );
	level thread addNotetrack_customFunction( "furniture_3", "gun_detach3", ::furniture_gun_note_d, "furniture_push" );	
	
	
	//yard
	//////////////////
	level thread addNotetrack_customFunction( "yard", "ragdoll", ::flame_death_ragdoll, "death_balcony_a" );
	level thread addNotetrack_customFunction( "yard", "ragdoll", ::flame_death_ragdoll, "death_balcony_b" );
	level thread addNotetrack_customFunction( "yard", "ragdoll", ::flame_death_ragdoll, "death_balcony_c" );
	level thread addNotetrack_customFunction( "yard", "ragdoll", ::flame_death_ragdoll, "death_balcony_e" );
	
	
	
	// rail
	///////////
	level.scr_anim["rail"]["traffic"][0] 						= %ch_holland3_traffic;
	
	level.scr_anim["rail"]["stuck_driver"][0] 					= %ch_jeep_stuck_driver;
	level.scr_anim["rail"]["stuck_pusher_left"][0] 				= %ch_jeep_stuck_pusher1;
	level.scr_anim["rail"]["stuck_pusher_right"][0] 			= %ch_jeep_stuck_pusher2;

	level.scr_anim["rail"]["fire_a"][0] 						= %ch_aroundfire_guy_a;
	level.scr_anim["rail"]["fire_b"][0] 						= %ch_aroundfire_guy_b;
	level.scr_anim["rail"]["fire_c"][0] 						= %ch_aroundfire_guy_c;
	level.scr_anim["rail"]["fire_d"][0] 						= %ch_aroundfire_guy_d;

	level.scr_anim["road_walkers"]["weary_walk1"]				= %Ai_walk_weary_a;														
	level.scr_anim["road_walkers"]["weary_walk2"]				= %Ai_walk_weary_b;														
	level.scr_anim["road_walkers"]["weary_walk3"]				= %Ai_walk_weary_c;														
	level.scr_anim["road_walkers"]["weary_walk4"]				= %Ai_walk_weary_d;														

	level.scr_anim[ "rail_smokers" ][ "smoker_1" ][0]			= %ch_holland2_smoking_guy1;
	level.scr_anim[ "rail_smokers" ][ "smoker_2" ][0]			= %ch_holland2_smoking_guy2;

	level.scr_anim["rail"]["sit_cold_1"][0] 					= %ch_seated_weaponcheck_guy3;
	level.scr_anim["rail"]["sit_cold_2"][0] 					= %ch_seated_weaponcheck_guy4;

	level.scr_anim["truck_unload_0"]["truck_unload"][0] 		= %ch_holland3_unloading_guy1;
	level.scr_anim["truck_unload_1"]["truck_unload"][0] 		= %ch_holland3_unloading_guy2;

	

	// street
	///////////
	level.scr_anim["body_toss_german"]["body_toss"] 			= %ch_holland3_sandbag_german;
	level.scr_anim["body_toss_british"]["body_toss"] 			= %ch_holland3_sandbag_british;
	level.scr_sound["body_toss_british"]["body_toss"] 			= "print:greetings, gents. german watch up ahead, hold your fire and stay alert";
	level.scr_sound["body_toss_british"]["body_toss_2"] 		= "print:The main assault starts at oh nine hundred sharp, and we gotta make jerry think it's coming from this direction";
	level.scr_sound["body_toss_british"]["body_toss_3"] 		= "print:keep low and wait for my signal...";


	level.scr_anim["gren_throw_1"]["nest"] 						= %ch_holland3_nest_guy1;
	level.scr_anim["gren_throw_2"]["nest"] 						= %ch_holland3_nest_guy2;
	level.scr_anim["gren_throw_3"]["nest"] 						= %ch_holland3_nest_guy3;
	level.scr_sound["gren_throw_3"]["nest"] 					= "print:pins out...";

	level.scr_anim["street"]["slipping_a"] 						= %ch_holland3_slipping_a;
	level.scr_anim["street"]["slipping_b"] 						= %ch_holland3_slipping_b;

	level.scr_anim["street"]["bookcase_push"] 					= %ch_holland3_dresser;

	
	// mansion
	///////////
	
	
	//level.scr_anim["door_kicker"]["door_kick"]            		= %door_kick_in;
	level.scr_anim["door_kicker"]["door_kick"]          	  	= %ch_holland3_door_bash;	
	
	//level.scr_anim["pow"]["maddock_pow"] 						= %ANIM_HERE;
	level.scr_sound["pow"]["maddock_pow"] 						= "print:thanks for the assistance, chums.";
	level.scr_sound["pow"]["maddock_pow_2"] 					= "print:there are some bouncing betties the jerries kept luggin' around. maybe we can make some use of them...";

	level.scr_anim["furniture_1"]["furniture_push"]				= %ch_holland3_unblocking_guy1;
	level.scr_anim["furniture_2"]["furniture_push"]				= %ch_holland3_unblocking_guy2;
	level.scr_anim["furniture_3"]["furniture_push"]				= %ch_holland3_unblocking_guy3;

	// TEMP (need correct anim)!
	level.scr_anim["mine_planter"]["mines"]						= %ch_plantingCharge_kneeling;
	level.scr_anim["mine_helper"]["mines"]						= %ch_plantingCharge_kneeling;
	

	
	// yard
	///////////
	
	level.scr_anim["yard"]["death_balcony_a"] 					= %ai_flame_deathbalcony_a;
	level.scr_anim["yard"]["death_balcony_b"] 					= %ai_flame_deathbalcony_b;
	level.scr_anim["yard"]["death_balcony_c"] 					= %ai_flame_deathbalcony_c;
	level.scr_anim["yard"]["death_balcony_d"] 					= %ai_flame_deathbalcony_d;
	level.scr_anim["yard"]["death_balcony_e"] 					= %ai_flame_deathbalcony_e;
	
	level.scr_anim["yard"]["run_caugh_b"] 						= %ai_run_caugh_b;
	level.scr_anim["yard"]["run_caugh_a"] 						= %ai_run_caugh_a;
	
	//level.scr_anim["yard"]["molotov"] 						= %ai_molotov_throw_window;
	
	// square
	///////////
	level.scr_anim["square"]["retreat_a"] 						= %ai_retreating_a;
	//level.scr_anim["square"]["retreat_b"]						= %ai_retreating_b;
	level.scr_anim["square"]["retreat_c"]						= %ai_retreating_c;		




 	level.scr_anim[ "generic" ][ "patrol_walk" ]				= %patrol_bored_patrolwalk;
 	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]			= %patrol_bored_patrolwalk_twitch;
 	level.scr_anim[ "generic" ][ "patrol_stop" ]				= %patrol_bored_walk_2_bored;
 	level.scr_anim[ "generic" ][ "patrol_start" ]				= %patrol_bored_2_walk;
 	level.scr_anim[ "generic" ][ "patrol_turn180" ]				= %patrol_bored_2_walk_180turn;
 	
 	level.scr_anim[ "generic" ][ "patrol_idle_1" ]				= %patrol_bored_idle;
 	level.scr_anim[ "generic" ][ "patrol_idle_2" ]				= %patrol_bored_idle_smoke;
 	level.scr_anim[ "generic" ][ "patrol_idle_3" ]				= %patrol_bored_idle_cellphone;
 	level.scr_anim[ "generic" ][ "patrol_idle_4" ]				= %patrol_bored_twitch_bug;
 	level.scr_anim[ "generic" ][ "patrol_idle_5" ]				= %patrol_bored_twitch_checkphone;
 	level.scr_anim[ "generic" ][ "patrol_idle_6" ]				= %patrol_bored_twitch_stretch;
 	
 	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]			= %patrol_bored_idle_smoke;
 	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]		= %patrol_bored_twitch_checkphone;
 	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]		= %patrol_bored_twitch_stretch;
 	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]			= %patrol_bored_idle_cellphone;
	
	
	setup_satchel_anims();
	setup_mansion_door_anim();
	
}



#using_animtree( "scripted_wall" );

setup_satchel_anims()
{
	
	PrecacheModel( "anim_holland_satchel_explosion" );
	
	level.scr_animtree["satchel_wall_controlmodel"] = #animtree;	
	level.scr_model["satchel_wall_controlmodel"] = "anim_holland_satchel_explosion";
	
	level.scr_anim["satchel_wall_controlmodel"]["satchel_wall"] = %o_holland3_satchel_explosion;
}



#using_animtree( "hol3_mansion_door" );

setup_mansion_door_anim()
{

	level.scr_anim["mansion_door"]["mansion"] = %o_holland3_unblocking_door_open;

}



///////////////////
//
// Furniture pusher 1 door open
//
///////////////////////////////


#using_animtree( "hol3_mansion_door" );

mansion_door_animate()
{
	
	door = getent( "door_furniture_kick", "targetname" );

	org = Spawn( "script_model", door.origin );
	org SetModel( "tag_origin_animate" );
	
	door LinkTo( org, "origin_animate_jnt" );
	
	org UseAnimTree( #animtree );
	org SetFlaggedAnimKnob( "mansion_door_anim", level.scr_anim["mansion_door"]["mansion"], 1.0, 0.2, 1.0 );
	org waittillmatch( "mansion_door_anim", "end" );
	
	door Unlink();
	wait( 0.1 );
	org Delete();
	
	door connectpaths();
	
}



#using_animtree ("generic_human");

///////////////////
//
// Furniture pusher 2
//
///////////////////////////////


furniture_note_2_a_1( guy )
{
	furniture = getent( "dresser_top", "targetname" );
	furniture delete();
	
	//TEMP!
//	
//	orig = guy gettagorigin( "tag_weapon_left" );
//	angles = guy gettagangles( "tag_weapon_left" );
//	
//	print( "here" );	
	
}


furniture_note_2_d_1( guy )
{
	orig = guy gettagorigin( "tag_weapon_left" );
	angles = guy gettagangles( "tag_weapon_left" );

	furniture = spawn( "script_model" , orig );
	furniture.angles = angles;
	furniture setmodel( "static_berlin_dresser_open_1" );
}



furniture_note_2_a_2( guy )
{
	furniture = getent( "cabinet", "targetname" );
	furniture delete();
}


furniture_note_2_d_2( guy )
{
	orig = guy gettagorigin( "tag_weapon_left" );
	angles = guy gettagangles( "tag_weapon_left" );

	furniture = spawn( "script_model" , orig );
	furniture.angles = angles;
	furniture setmodel( "static_holland_china_cabinet_h3" );	
}



///////////////////
//
// Furniture pusher 3
//
///////////////////////////////
	
furniture_note_3_a_1( guy )
{
	furniture = getent( "dresser_bottom", "targetname" );
	furniture delete();
}


furniture_note_3_d_1( guy )
{
	orig = guy gettagorigin( "tag_weapon_left" );
	angles = guy gettagangles( "tag_weapon_left" );

	furniture = spawn( "script_model" , orig );
	furniture.angles = angles;
	furniture setmodel( "static_holland_dresser_open_h3" );	
}



furniture_note_3_a_2( guy )
{
	furniture = getent( "couch", "targetname" );
	furniture delete();
}


furniture_note_3_d_2( guy )
{
	orig = guy gettagorigin( "tag_weapon_left" );
	angles = guy gettagangles( "tag_weapon_left" );

	furniture = spawn( "script_model" , orig );
	furniture.angles = angles;
	furniture setmodel( "static_berlin_china_cabinet" );				
}



///////////////////
//
// Furniture guns
//
///////////////////////////////

furniture_gun_note_a( guy )
{
	// give his weapon back
	guy animscripts\shared::placeWeaponOn( guy.primaryweapon, "right");
	
	gun = getent( "gun_of_" + guy.name, "targetname" );
	gun delete();
}



furniture_gun_note_d( guy )
{
	// take away his weapon
	guy animscripts\shared::placeWeaponOn( guy.primaryweapon, "none");
	
	gun = spawn( "script_model", guy GetTagOrigin( "tag_weapon_right" ) );
	gun setmodel( getWeaponModel( guy.primaryweapon ) );
	gun.angles = guy GetTagAngles( "tag_weapon_right" );
	gun.targetname = "gun_of_" + guy.name;
}



///////////////////
//
// Grenade throw vignette
//
///////////////////////////////

hero_throw_grenade( guy )
{
	
	// choose where the grenade goes
	if( IsSubStr( guy.classname, "maddock" ) )
	{
		orig_name = "orig_gren_1";
	}
	else if( IsSubStr( guy.classname, "goddard" ) )
	{
		orig_name = "orig_gren_2";
	}
	else
	{
		// TODO put this back to orig_gren_3
		orig_name = "orig_gren_2";
	}

	gren_orig = getstruct( orig_name, "targetname" );
	
	// TODO remove z offset on gren source (only needed until we re-mocap it)
	guy MagicGrenade( guy gettagorigin( "tag_weapon_right" ) + (0,0,45), gren_orig.origin + ( RandomIntRange( -50, 50 ), 0, 30 ), 2.5 );

	flag_set( "grenade_throw_release" );

	wait( 2.5 );

	flag_set( "grenade_throw_done" );

}


	
mansion_door_kick_timing( guy )
{

	door = getent( "door_mansion_kick", "targetname" );

	door rotateyaw( -120, 0.4, 0.3, .1 );
	door connectpaths();
	
	flag_set( "mansion_door_kick" );
	
}



bookcase_push_attach( guy )
{

	bookcase = getent( "pub_bookcase", "targetname" );
	bookcase delete();
	
}



bookcase_push_detach( guy )
{

	orig = guy gettagorigin( "tag_weapon_left" );
	angles = guy gettagangles( "tag_weapon_left" );
	
	bookcase = spawn( "script_model" , orig );
	bookcase.angles = angles;
	bookcase setmodel( "static_berlin_bookshelf_short" );
}



flame_death_ragdoll( guy )
{
	guy startRagdoll();
	guy dodamage( guy.health + 1, (0,0,0) );
}



///////////////////
//
// Body Toss FX
//
///////////////////////////////

body_toss_german_fx( guy )
{
	playfx( level._effect["body_toss_impact"], guy.origin );
}

