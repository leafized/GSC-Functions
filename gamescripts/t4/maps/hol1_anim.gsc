// Animation Level File
#include maps\_anim;
#include common_scripts\utility;
#include maps\_utility;
#include maps\hol1_util;

#using_animtree("generic_human");

main()
{
	anim_loader();
}

anim_loader()
{
	// driving

	level.scr_anim["jeep_driver"]["driver_idle"][0] = %crew_jeep1_driver_drive_idle; 
	level.scr_anim["jeep_driver"]["driver_idle"][1] = %crew_jeep1_driver_drive_idle;
	level.scr_anim["jeep_driver"]["driver_turn_left"] = %crew_jeep1_driver_turn_left_light;  
	level.scr_anim["jeep_driver"]["driver_turn_right"] = %crew_jeep1_driver_turn_right_light;
	level.scr_anim["jeep_driver"]["driver_sharp_turn_left"] = %crew_jeep1_driver_turn_left_heavy;
	level.scr_anim["jeep_driver"]["driver_sharp_turn_right"] = %crew_jeep1_driver_turn_right_heavy;
	level.scr_anim["jeep_driver"]["climb_out"] = %crew_jeep1_driver_climbout;

	level.scr_anim["jeep_passenger"]["passenger_idle"][0] = %crew_jeep1_passenger1_drive_idle;
	level.scr_anim["jeep_passenger"]["passenger_idle"][1] = %crew_jeep1_passenger1_drive_idle;
	level.scr_anim["jeep_passenger"]["passenger_turn_left"] = %crew_jeep1_passenger1_turn_left_light;
	level.scr_anim["jeep_passenger"]["passenger_turn_right"] = %crew_jeep1_passenger1_turn_right_light;
	level.scr_anim["jeep_passenger"]["passenger_sharp_turn_left"] = %crew_jeep1_passenger1_turn_left_heavy;
	level.scr_anim["jeep_passenger"]["passenger_sharp_turn_right"] = %crew_jeep1_passenger1_turn_right_heavy;
	level.scr_anim["jeep_passenger"]["climb_out"] = %crew_jeep1_passenger1_climbout;

	level.scr_anim["jeep_passenger2"]["passenger2_idle"][0] = %crew_jeep1_passenger2_drive_idle;
	level.scr_anim["jeep_passenger2"]["passenger2_idle"][1] = %crew_jeep1_passenger2_drive_idle;
	level.scr_anim["jeep_passenger2"]["passenger2_turn_left"] = %crew_jeep1_passenger2_turn_left_light;
	level.scr_anim["jeep_passenger2"]["passenger2_turn_right"] = %crew_jeep1_passenger2_turn_right_light;
	level.scr_anim["jeep_passenger2"]["passenger2_sharp_turn_left"] = %crew_jeep1_passenger2_turn_left_heavy;
	level.scr_anim["jeep_passenger2"]["passenger2_sharp_turn_right"] = %crew_jeep1_passenger2_turn_right_heavy;
	level.scr_anim["jeep_passenger2"]["climb_out"] = %crew_jeep1_passenger2_climbout;

	level.scr_anim["jeep_passenger"]["maddock_get_out"] = %crew_jeep1_passenger1_climbout;
	level.scr_anim["jeep_passenger"]["maddock_close_door"] = %crew_jeep1_passenger1_closedoor;
	level.scr_anim["jeep_passenger"]["maddock_capture"] = %run_2_melee_charge;
	level.scr_anim["jeep_passenger"]["maddock_on_ground"][0] = %reload_prone_rifle;
	level.scr_anim["jeep_passenger"]["maddock_on_ground"][1] = %reload_prone_rifle;

	// german checkpoint

	level.scr_anim["german_camp_fire"]["around_fire_a"][0] = %ch_aroundfire_guy_a; 
	level.scr_anim["german_camp_fire"]["around_fire_a"][1] = %ch_aroundfire_guy_a;
	level.scr_anim["german_camp_fire"]["around_fire_b"][0] = %ch_aroundfire_guy_b; 
	level.scr_anim["german_camp_fire"]["around_fire_b"][1] = %ch_aroundfire_guy_b;
	level.scr_anim["german_camp_fire"]["around_fire_c"][0] = %ch_aroundfire_guy_c; 
	level.scr_anim["german_camp_fire"]["around_fire_c"][1] = %ch_aroundfire_guy_c;
	level.scr_anim["german_camp_fire"]["around_fire_d"][0] = %ch_aroundfire_guy_d; 
	level.scr_anim["german_camp_fire"]["around_fire_d"][1] = %ch_aroundfire_guy_d;

	level.scr_anim["german_guard"]["crouch_alert_idle_reach"] = %crouch_alert_A_idle;
	level.scr_anim["german_guard"]["crouch_alert_idle"][0] = %crouch_alert_A_idle;
	level.scr_anim["german_guard"]["crouch_alert_idle"][1] = %crouch_alert_A_twitch;

	level.scr_anim["german_guard"]["stand_alert_idle_reach"] = %stand_alertb_idle1;  
	level.scr_anim["german_guard"]["stand_alert_idle"][0] = %stand_alertb_idle1;  
	level.scr_anim["german_guard"]["stand_alert_idle"][1] = %stand_alertb_twitch1;

	level.scr_anim["german_guard"]["stand_aim_reach"] = %stand_aim_straight;
	level.scr_anim["german_guard"]["stand_aim"][0] = %stand_aim_straight;
	level.scr_anim["german_guard"]["stand_aim"][1] = %stand_aim_straight;

	level.scr_anim["german_guard"]["stand_melee"] = %stand_2_melee_1;

	// patrols anims
	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %patrol_bored_2_walk_180turn;
	
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]			= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]			= %patrol_bored_twitch_stretch;
	
	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]	= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]	= %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]		= %patrol_bored_idle_cellphone;

	level.scr_anim[ "generic" ][ "sneak_walk_1" ]		= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "sneak_walk_2" ]		= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "sneak_walk_3" ]		= %patrol_bored_patrolwalk;

	// generic anims
	level.scr_anim[ "generic" ][ "generic_wave" ][0]		= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "generic_wave" ][1]		= %patrol_bored_idle_smoke;

	level.scr_anim[ "generic" ][ "patrol_idle_all" ][0]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_all" ][1]			= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_all" ][2]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_all" ][3]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_all" ][4]			= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_all" ][5]			= %patrol_bored_twitch_stretch;

	// capture anims
	level.scr_anim["captor"]["capture_walk_formation"] = %ch_captor_formation1; 
	level.scr_anim["captor"]["capture_walk_formation_idle"][0] = %ch_captor_formation_idle1; 
	level.scr_anim["captor"]["capture_walk_formation_idle"][1] = %ch_captor_formation_idle1; 
	level.scr_anim["captor"]["capture_walk_in"] = %ch_captor_in1; 
	level.scr_anim["captor"]["capture_walk_loop"] = %ch_captor_loop1; 
	level.scr_anim["captor"]["capture_walk_out"] = %ch_captor_out1;
	level.scr_anim["captor"]["capture_walk_idle"][0] = %ch_captor_walk_idle1;
	level.scr_anim["captor"]["capture_walk_idle"][1] = %ch_captor_walk_idle1;

	level.scr_anim["prisonerL"]["capture_walk_formation"] = %ch_captor_formation; 
	level.scr_anim["prisonerL"]["capture_walk_formation_idle"][0] = %ch_captor_formation_idle; 
	level.scr_anim["prisonerL"]["capture_walk_formation_idle"][1] = %ch_captor_formation_idle; 
	level.scr_anim["prisonerL"]["capture_walk_in"] = %ch_captor_in; 
	level.scr_anim["prisonerL"]["capture_walk_loop"] = %ch_captor_loop; 
	level.scr_anim["prisonerL"]["capture_walk_out"] = %ch_captor_out;
	level.scr_anim["prisonerL"]["capture_walk_idle"][0] = %ch_captor_walk_idle;
	level.scr_anim["prisonerL"]["capture_walk_idle"][1] = %ch_captor_walk_idle;

	level.scr_anim["prisonerR"]["capture_walk_formation"] = %ch_captor_formation2; 
	level.scr_anim["prisonerR"]["capture_walk_formation_idle"][0] = %ch_captor_formation_idle2; 
	level.scr_anim["prisonerR"]["capture_walk_formation_idle"][1] = %ch_captor_formation_idle2; 
	level.scr_anim["prisonerR"]["capture_walk_in"] = %ch_captor_in2; 
	level.scr_anim["prisonerR"]["capture_walk_loop"] = %ch_captor_loop2; 
	level.scr_anim["prisonerR"]["capture_walk_out"] = %ch_captor_out2;
	level.scr_anim["prisonerR"]["capture_walk_idle"][0] = %ch_captor_walk_idle2;
	level.scr_anim["prisonerR"]["capture_walk_idle"][1] = %ch_captor_walk_idle2;

	// ambient

	level.scr_anim["snow_digger"]["snow_dig_react"] = %ch_holland1_shoveling_alert;
	level.scr_anim["snow_digger"]["snow_dig"][0] = %ch_holland1_shoveling_loop;
	level.scr_anim["snow_digger"]["snow_dig"][1] = %ch_holland1_shoveling_loop;

	level.scr_anim["sitting"]["sitting_react"] = %ch_seated_weaponcheck_alert;
	level.scr_anim["sitting"]["sitting_idle_1"][0] = %ch_seated_weaponcheck_guy1;
	level.scr_anim["sitting"]["sitting_idle_1"][1] = %ch_seated_weaponcheck_guy1;
	level.scr_anim["sitting"]["sitting_idle_2"][0] = %ch_seated_weaponcheck_guy2;
	level.scr_anim["sitting"]["sitting_idle_2"][1] = %ch_seated_weaponcheck_guy2;
	level.scr_anim["sitting"]["sitting_idle_3"][0] = %ch_seated_weaponcheck_guy3;
	level.scr_anim["sitting"]["sitting_idle_3"][1] = %ch_seated_weaponcheck_guy3;
	level.scr_anim["sitting"]["sitting_idle_4"][0] = %ch_seated_weaponcheck_guy4;
	level.scr_anim["sitting"]["sitting_idle_4"][1] = %ch_seated_weaponcheck_guy4;

	level.scr_anim["cargo_guy1"]["cargo_jump"] = %ch_holland1_cargo_guy1;
	level.scr_anim["cargo_guy2"]["cargo_jump"] = %ch_holland1_cargo_guy2;
	level.scr_anim["jump_guy1"]["jump_for_cover"] = %ch_holland1_jump2cover_guy1;
	level.scr_anim["jump_guy2"]["jump_for_cover"] = %ch_holland1_jump2cover_guy2;

	// goddard kill
	level.scr_anim["sneaky_goddard"]["goddard_knife"]	= %ch_holland2_slit_sarge;
	level.scr_anim["nazi_knifed"]["goddard_knife"]		= %ch_holland2_slit_german;
	level.scr_anim["sneaky_goddard"]["goddard_sneak"]	= %ch_holland2_slit_sarge_sneaking;
	level.scr_anim["sneaky_goddard"]["goddard_kill"]	= %ch_holland2_slit_sarge_death;
	level.scr_anim["nazi_knifed"]["nazi_death"]			= %ch_holland2_slit_german_death;


	// SHooting prisoner
	level.scr_anim["knees_execution_executioner"]["execute"] = %ch_berlin2_E1vignette2_german;
	level.scr_anim["knees_execution_victim"]["execute"] = %ch_berlin2_E1vignette2_russian;
	level.scr_anim["knees_execution_victim"]["deathidle"][0] = %ch_berlin2_E1vignette2_russian_dead;
	level.scr_sound["knees_execution_victim"]["saved_getup"] = "print:getting up anim";
	addNotetrack_sound( "knees_execution_executioner", "shoot", "execute", "weap_kar98k_fire" );  // gunshot sound
	addNotetrack_customFunction( "knees_execution_executioner", "shoot", ::event3_execution_gunshotFX, "execute" );  // gunshot fx
	addNotetrack_sound( "knees_execution_executioner", "shot_in_the_head", "execute", "bullet_large_flesh" );  // headshot sound

	// movements
	level.scr_anim["gesture"]["gesture_stop"]			= %ch_crouch_gesture_stop;
	level.scr_anim["gesture"]["gesture_closer"]			= %ch_crouch_gesture_closer;
}

/////////////////////////////////////////////////////////////////////////////////////////

#using_animtree ("hol1_trucks");
ev2_truck_crash_anim()
{
	level waittill( "truck_collision_anim_starts" );
	iprintlnbold( "TRUCK ANIM" );

	origin_start = getent( "trucks_collision_start_origin", "targetname" );
	
	opel1 = spawn("script_model",origin_start getorigin());
	opel1.angles = origin_start.angles;
	opel1 setmodel("vehicle_ger_wheeled_opel_blitz_winter");
	
	opel2 = spawn("script_model",origin_start getorigin());
	opel2.angles = origin_start.angles;
	opel2 setmodel("vehicle_ger_wheeled_opel_blitz_winter");
	
	opel1.animname = "opel";
	opel2.animname = "opel";

	opel1 UseAnimTree( #animtree );
	opel2 UseAnimTree( #animtree );

	opel1 setflaggedanim( "anim", %v_holl1_truck_crashing_a, 1, 0.1, 1 );
	opel2 setflaggedanim( "anim", %v_holl1_truck_crashing_b, 1, 0.1, 1 );

	wait( 0.5 );

	playfxontag( level._effect["headlight"], opel1, "tag_headlight_left" );
	playfxontag( level._effect["headlight"], opel1, "tag_headlight_right" );
	//playfxontag( level._effect["brakelight"], opel1, "tag_brakelight_left" );

	playfxontag( level._effect["headlight"], opel2, "tag_headlight_left" );
	playfxontag( level._effect["headlight"], opel2, "tag_headlight_right" );
	//playfxontag( level._effect["brakelight"], opel2, "tag_brakelight_left" );

	wait( 10 );

	opel1 delete();
	opel2 delete();
}

#using_animtree("generic_human");

/////////////////////////////////////////////////////////////////////////////////////////

driver_anims( guy )
{
	guy endon( "death" );

	// idle unless instructed to make turns
	guy.animname = "jeep_driver";

	guy thread left_turn_driver_anim();
	guy thread sharp_left_turn_driver_anim();
	guy thread right_turn_driver_anim();
	guy thread sharp_right_turn_driver_anim();

	guy thread exit_driver_anim();

	guy thread anim_loop_solo( guy, "driver_idle", undefined, "stop_idle" );

	guy waittill( "get_out" );
	guy notify( "stop_idle" );
}

left_turn_driver_anim()
{
	self endon( "death" );
	self endon( "get_out" );
	
	while( 1 )
	{
		self waittill( "turn_left" );
		self SetFlaggedAnimKnobRestart( "driver_turn_left", level.scr_anim["jeep_driver"]["driver_turn_left"], 1.0, 0.2, 1.0 );
	}
}

right_turn_driver_anim()
{
	self endon( "death" );
	self endon( "get_out" );
	
	while( 1 )
	{
		self waittill( "turn_right" );
		self SetFlaggedAnimKnobRestart( "driver_turn_right", level.scr_anim["jeep_driver"]["driver_turn_right"], 1.0, 0.2, 1.0 );
	}
}

sharp_left_turn_driver_anim()
{
	self endon( "death" );
	self endon( "get_out" );
	
	while( 1 )
	{
		self waittill( "sharp_turn_left" );
		self SetFlaggedAnimKnobRestart( "driver_sharp_turn_left", level.scr_anim["jeep_driver"]["driver_sharp_turn_left"], 1.0, 0.2, 1.0 );
	}
}

sharp_right_turn_driver_anim()
{
	self endon( "death" );
	self endon( "get_out" );
	
	while( 1 )
	{
		self waittill( "sharp_turn_right" );
		self SetFlaggedAnimKnobRestart( "driver_sharp_turn_right", level.scr_anim["jeep_driver"]["driver_sharp_turn_right"], 1.0, 0.2, 1.0 );
	}
}

exit_driver_anim()
{
	self endon( "death" );
	self waittill( "get_out" );

	self notify( "stop_idle" );

	self SetFlaggedAnimKnobRestart( "climb_out", level.scr_anim["jeep_driver"]["climb_out"], 1.0, 0.2, 1.0 );
	//self waittillmatch("climb_out", "end");
	wait( 2 );

	self unlink();
}

/////////////////////////////////////////////////////////////////////////////////////////

passenger_anims( guy )
{
	guy endon( "death" );

	// idle unless instructed to make turns
	guy.animname = "jeep_passenger";

	guy thread left_turn_passenger_anim();
	guy thread right_turn_passenger_anim();
	guy thread sharp_left_turn_passenger_anim();
	guy thread sharp_right_turn_passenger_anim();

	guy thread exit_passenger_anim();

	guy thread anim_loop_solo( guy, "passenger_idle", undefined, "stop_idle" );

	guy waittill( "get_out" );
	guy notify( "stop_idle" );
}

left_turn_passenger_anim()
{
	self endon( "death" );
	self endon( "get_out" );
	
	while( 1 )
	{
		self waittill( "turn_left" );
		self SetFlaggedAnimKnobRestart( "passenger_turn_left", level.scr_anim["jeep_passenger"]["passenger_turn_left"], 1.0, 0.2, 1.0 );
	}
}

right_turn_passenger_anim()
{
	self endon( "death" );
	self endon( "get_out" );
	
	while( 1 )
	{
		self waittill( "turn_right" );
		self SetFlaggedAnimKnobRestart( "passenger_turn_right", level.scr_anim["jeep_passenger"]["passenger_turn_right"], 1.0, 0.2, 1.0 );
	}
}

sharp_left_turn_passenger_anim()
{
	self endon( "death" );
	self endon( "get_out" );
	
	while( 1 )
	{
		self waittill( "sharp_turn_left" );
		self SetFlaggedAnimKnobRestart( "passenger_sharp_turn_left", level.scr_anim["jeep_passenger"]["passenger_sharp_turn_left"], 1.0, 0.2, 1.0 );
	}
}

sharp_right_turn_passenger_anim()
{
	self endon( "death" );
	self endon( "get_out" );

	while( 1 )
	{
		self waittill( "sharp_turn_right" );
		self SetFlaggedAnimKnobRestart( "passenger_sharp_turn_right", level.scr_anim["jeep_passenger"]["passenger_sharp_turn_right"], 1.0, 0.2, 1.0 );
	}
}

exit_passenger_anim()
{
	self endon( "death" );
	self waittill( "get_out" );
	
	self notify( "stop_idle" );

	self SetFlaggedAnimKnobRestart( "climb_out", level.scr_anim["jeep_passenger"]["climb_out"], 1.0, 0.2, 1.0 );
	//self waittillmatch("climb_out", "end");

	wait( 2 );

	self unlink();
}

/////////////////////////////////////////////////////////////////////////////////////////

passenger2_anims( guy )
{
	guy endon( "death" );

	// idle unless instructed to make turns
	guy.animname = "jeep_passenger2";

	guy thread left_turn_passenger2_anim();
	guy thread right_turn_passenger2_anim();
	guy thread sharp_left_turn_passenger2_anim();
	guy thread sharp_right_turn_passenger2_anim();

	guy thread exit_passenger2_anim();

	guy thread anim_loop_solo( guy, "passenger2_idle", undefined, "stop_idle" );

	guy waittill( "get_out" );
	guy notify( "stop_idle" );
}

left_turn_passenger2_anim()
{
	self endon( "death" );
	self endon( "get_out" );
	
	while( 1 )
	{
		self waittill( "turn_left" );
		self SetFlaggedAnimKnobRestart( "passenger2_turn_left", level.scr_anim["jeep_passenger2"]["passenger2_turn_left"], 1.0, 0.2, 1.0 );
	}
}

right_turn_passenger2_anim()
{
	self endon( "death" );
	self endon( "get_out" );
	
	while( 1 )
	{
		self waittill( "turn_right" );
		self SetFlaggedAnimKnobRestart( "passenger2_turn_right", level.scr_anim["jeep_passenger2"]["passenger2_turn_right"], 1.0, 0.2, 1.0 );
	}
}

sharp_left_turn_passenger2_anim()
{
	self endon( "death" );
	self endon( "get_out" );
	
	while( 1 )
	{
		self waittill( "sharp_turn_left" );
		self SetFlaggedAnimKnobRestart( "passenger2_sharp_turn_left", level.scr_anim["jeep_passenger2"]["passenger2_sharp_turn_left"], 1.0, 0.2, 1.0 );
	}
}

sharp_right_turn_passenger2_anim()
{
	self endon( "death" );
	self endon( "get_out" );

	while( 1 )
	{
		self waittill( "sharp_turn_right" );
		self SetFlaggedAnimKnobRestart( "passenger2_sharp_turn_right", level.scr_anim["jeep_passenger2"]["passenger2_sharp_turn_right"], 1.0, 0.2, 1.0 );
	}
}

exit_passenger2_anim()
{
	self endon( "death" );
	self waittill( "get_out" );

	self notify( "stop_idle" );
	
	self SetFlaggedAnimKnobRestart( "climb_out", level.scr_anim["jeep_passenger2"]["climb_out"], 1.0, 0.2, 1.0 );
	//self waittillmatch("climb_out", "end");

	wait( 2 );

	self unlink();
}

/////////////////////////////////////////////////////////////////////////////////////////

maddock_capture_anims( guy )
{
	guy endon( "death" );
	
	guy anim_single_solo( guy, "maddock_get_out" );

	pos = getstruct( "maddock_exit_point", "script_noteworthy" );
	org = spawn( "script_origin", pos.origin );
	guy unlink();
	guy linkto( org );

	level notify( "maddock_out" );

	iprintlnbold( "Maddock arguing with guard" );
	wait( 3 );

	level notify( "maddock_captured" );
}

/////////////////////////////////////////////////////////////////////////////////////////

ev1_spawners_anims_init()
{
	// enemies from train (some run and die, while others fight normally)
	initialize_spawn_func( "ev1_checkpoint_patrol", "script_noteworthy", ::ev1_patrol_think );
	initialize_spawn_func( "ev1_checkpoint_barrel", "script_noteworthy", ::ev1_fire_think );
	initialize_spawn_func( "ev1_checkpoint_guard1", "script_noteworthy", ::ev1_stand_guard_think );
	initialize_spawn_func( "ev1_checkpoint_guard2", "script_noteworthy", ::ev1_stand_guard_think );
	initialize_spawn_func( "ev1_checkpoint_guard3", "script_noteworthy", ::ev1_stand_guard_think );
	initialize_spawn_func( "ev1_checkpoint_guard4", "script_noteworthy", ::ev1_stand_guard_think );
	initialize_spawn_func( "ev1_checkpoint_guard5", "script_noteworthy", ::ev1_stand_guard_think );
	initialize_spawn_func( "ev1_checkpoint_gunner1", "script_noteworthy", ::ev1_gunner_think );
	initialize_spawn_func( "ev1_checkpoint_checker", "script_noteworthy", ::ev1_checker_think );
	initialize_spawn_func( "ev1_checkpoint_approacher1", "script_noteworthy", ::ev1_approacher_think );
	initialize_spawn_func( "ev1_checkpoint_approacher2", "script_noteworthy", ::ev1_approacher_think );
	initialize_spawn_func( "ev1_checkpoint_approacher3", "script_noteworthy", ::ev1_approacher_think );
	initialize_spawn_func( "ev1_checkpoint_approacher4", "script_noteworthy", ::ev1_approacher_think );
	initialize_spawn_func( "ev1_checkpoint_approacher5", "script_noteworthy", ::ev1_approacher_think );

	initialize_spawn_func( "ev1_jumper_1", "script_noteworthy", ::ev1_jumper1_think );
	initialize_spawn_func( "ev1_jumper_2", "script_noteworthy", ::ev1_jumper2_think );

}


ev1_patrol_think()
{
	self endon( "death" );

	maps\hol1_util::hold_fire( self );

	level waittill( "checkpoint_break_through" );
	maps\hol1_util::open_fire_fake( self );
}

ev1_fire_think()
{
	self endon( "death" );
	
	self.animname = "german_camp_fire";
	maps\hol1_util::hold_fire( self );

	index = randomint( 4 );
	if( index == 0 )
	{
		self thread anim_loop_solo ( self, "around_fire_a", undefined, "stop_looping");	
	}
	else if( index == 1 )
	{
		self thread anim_loop_solo ( self, "around_fire_b", undefined, "stop_looping");	
	}
	else if( index == 2 )
	{
		self thread anim_loop_solo ( self, "around_fire_c", undefined, "stop_looping");	
	}
	else
	{
		self thread anim_loop_solo ( self, "around_fire_d", undefined, "stop_looping");	
	}

	level waittill( "checkpoint_break_through" );
	self notify ("stop_looping");
	maps\hol1_util::open_fire_fake( self );
}

ev1_stand_guard_think()
{
	self endon( "death" );
	
	self.animname = "german_guard";
	maps\hol1_util::hold_fire( self );

	self thread anim_loop_solo ( self, "stand_alert_idle", undefined, "stop_looping");	

	level waittill( "checkpoint_break_through" );
	self notify ("stop_looping");
	maps\hol1_util::open_fire_fake( self );
}

ev1_gunner_think()
{
	self endon( "death" );
	
	self.animname = "german_guard";
	maps\hol1_util::hold_fire( self );

	self thread anim_loop_solo ( self, "crouch_alert_idle", undefined, "stop_looping");	

	level waittill( "checkpoint_break_through" );
	self notify ("stop_looping");
	maps\hol1_util::open_fire_fake( self );
}

ev1_approacher_think()
{
	self endon( "death" );
	
	self.animname = "german_guard";
	maps\hol1_util::hold_fire( self );

	self thread anim_loop_solo ( self, "stand_alert_idle", undefined, "stop_looping");	

	level waittill( "checkpoint_entered" );
	self notify ("stop_looping");

	// go into a second animation spot

	self thread anim_loop_solo ( self, "stand_aim", undefined, "stop_looping");	

	level waittill( "checkpoint_break_through" );
	self notify ("stop_looping");
	maps\hol1_util::open_fire_fake( self );
}

ev1_checker_think()
{
	self endon( "death" );
	
	self.animname = "german_guard";
	maps\hol1_util::hold_fire( self );

	self thread anim_loop_solo ( self, "stand_alert_idle", undefined, "stop_looping");	

	level waittill( "checkpoint_entered" );
	self notify ("stop_looping");

	self thread anim_loop_solo ( self, "stand_aim", undefined, "stop_looping");	

	level waittill( "maddock_out" );
	self notify ("stop_looping");	

	self thread anim_single_solo( self, "stand_melee" );

	level notify( "time_to_run" );
	maps\hol1_util::open_fire_fake( self );
}

ev1_jumper1_think()
{
	self endon( "death" );
	
	self.animname = "jump_guy1";
	level thread maps\hol1_util::hold_fire( self );

	self thread anim_single_solo( self, "jump_for_cover" );
}

ev1_jumper2_think()
{
	self endon( "death" );
	
	self.animname = "jump_guy2";
	level thread maps\hol1_util::hold_fire( self );

	self thread anim_single_solo( self, "jump_for_cover" );
}

/////////////////////////////////////////////////////////////////////////////////////////

ev2_spawners_anims_init()
{
	// enemies from train (some run and die, while others fight normally)
	initialize_spawn_func( "ev2_halftrack", "script_noteworthy", ::ev2_halftrack_think );
	initialize_spawn_func( "ev2_truck_unloader1", "script_noteworthy", ::ev2_truck_unload1_think );
	initialize_spawn_func( "ev2_truck_unloader2", "script_noteworthy", ::ev2_truck_unload2_think );
	initialize_spawn_func( "ev2_tank_guard", "script_noteworthy", ::ev2_tank_guard_think );
	initialize_spawn_func( "ev2_truck_chaser", "script_noteworthy", ::ev2_halftrack_think );

	level thread cargo_guys_jump_anim();
}

ev2_truck_unload1_think()
{
	self endon( "death" );
	level.cargo_guy1 = self;

	self.animname = "cargo_guy1";

	level thread maps\hol1_util::hold_fire( self );

	anim_trigger = getent( "ev2_truck_chase_spawn", "targetname" );
	anim_trigger waittill( "trigger" );

	level notify( "cargo_guy1_ready" );

	//level waittill( "stop_at_halftrack" );

	//maps\hol1_util::open_fire_fake2( self );
}

ev2_truck_unload2_think()
{
	self endon( "death" );
	level.cargo_guy2 = self;

	self.animname = "cargo_guy2";

	level thread maps\hol1_util::hold_fire( self );

	anim_trigger = getent( "ev2_truck_chase_spawn", "targetname" );
	anim_trigger waittill( "trigger" );

	level notify( "cargo_guy2_ready" );

	//level waittill( "lake_stop" );

	//maps\hol1_util::open_fire_fake2( self );
}

cargo_guys_jump_anim()
{
	level waittill_multiple( "cargo_guy1_ready", "cargo_guy2_ready" );

	wait( 1.8 );

	anim_node = getnode( "ev2_cargo_jump_node", "targetname" );

	level thread anim_reach_node( "cargo_jump", level.cargo_guy1, anim_node, "cargo1_in_place" );
	level thread anim_reach_node( "cargo_jump", level.cargo_guy2, anim_node, "cargo2_in_place" );
	
	level.cargo_guy1.goalradius = 4;
	level.cargo_guy2.goalradius = 4;

	level waittill_multiple( "cargo1_in_place", "cargo2_in_place" );		

	anim_guys = [];
	anim_guys[0] = level.cargo_guy1;
	anim_guys[1] = level.cargo_guy2;
	
	anim_single( anim_guys, "cargo_jump", undefined, anim_node );
}

ev2_halftrack_think()
{
	self endon( "death" );

	//maps\hol1_util::hold_fire( self );

	//level waittill( "lake_stop" );

	maps\hol1_util::open_fire_fake2( self );
}

ev2_tank_guard_think()
{
	self endon( "death" );
	self.goalradius = 4;

	maps\hol1_util::hold_fire( self );

	//level waittill( "stop_at_tank" );

	//maps\hol1_util::open_fire_fake2( self );

	//level waittill( "tank_guards_escape" );

	//retreat_node = getnode( "ev2_tank_guard_escape", "targetname" );
	//maps\hol1_util::hold_fire( self );
	//self setgoalnode( retreat_node );
}

	
ev3_spawners_anims_init()
{
	// enemies from train (some run and die, while others fight normally)
	initialize_spawn_func( "ev3_camp", "script_noteworthy", ::ev2_halftrack_think );

}


/////////////////////////////////////////////////////////////////////////////

formation_anim()
{
	anim_node = getnode( "formation_1_start", "targetname" );

	everyone_anim_reach( "capture_walk_formation", anim_node );
	everyone_anim_single( "capture_walk_formation", anim_node );
}

everyone_anim_reach( anim_name, anim_node )
{
	level thread anim_reach_node( anim_name, level.goddard, anim_node, "captor_in_place" );
	level thread anim_reach_node( anim_name, level.friend1, anim_node, "prisonerL_in_place" );
	level thread anim_reach_node( anim_name, level.friend2, anim_node, "prisonerR_in_place" );
	
	level.goddard.goalradius = 4;
	level.friend1.goalradius = 4;
	level.friend2.goalradius = 4;
	
	level waittill_multiple( "captor_in_place", "prisonerL_in_place", "prisonerR_in_place" );		
	level notify( "everyone_in_place" );
}

anim_reach_node( anim_name, guy, anim_node, notify_name )
{
	guy anim_reach_solo( guy, anim_name, undefined, anim_node );
	level notify( notify_name );
}

everyone_anim_single( anim_name, anim_node )
{
	anim_guys = [];
	anim_guys[0] = level.goddard;
	anim_guys[1] = level.friend1;
	anim_guys[2] = level.friend2;
	
	anim_single( anim_guys, anim_name, undefined, anim_node );

	//anim_guys[0] waittill( anim_name ); // assume the 3 anims end at teh same time
	level notify( "everyone_finished_anim" );
}

everyone_single_solo( anim_name )
{
	level.goddard thread anim_single_solo( level.goddard, anim_name );
	level.friend1 thread anim_single_solo( level.friend1, anim_name );
	level.friend2 thread anim_single_solo( level.friend2, anim_name );

	level.goddard waittill( anim_name ); // assume the 3 anims end at teh same time
	level notify( "everyone_finished_anim" );
}

/////////////////////////////////////////////////////////////////////////////

turn_anim_with_idle()
{
	anim_node = getnode( "formation_2_start", "targetname" );

	level thread single_reach_anim_idle( anim_node, level.goddard, "captor_in_place" );
	level thread single_reach_anim_idle( anim_node, level.friend1, "prisonerL_in_place" );
	level thread single_reach_anim_idle( anim_node, level.friend2, "prisonerR_in_place" );

	level.goddard.goalradius = 4;
	level.friend1.goalradius = 4;
	level.friend2.goalradius = 4;

	level waittill_multiple( "captor_in_place", "prisonerL_in_place", "prisonerR_in_place" );		

	level notify( "everyone_in_place" );

	wait( 0.1 );
	level.goddard notify( "stop_idle" );
	level.friend1 notify( "stop_idle" );
	level.friend2 notify( "stop_idle" );

	level notify( "everyone_finished_anim" );
}

single_reach_anim_idle( anim_node, guy, msg )
{
	//level endon( "everyone_in_place" );

	level thread anim_reach_node( "capture_walk_formation", guy, anim_node, msg );
	level waittill( msg );

	// guy is now in position. The next part may play if others are not yet in position
	guy thread anim_loop_solo( guy, "capture_walk_idle", undefined, "stop_idle" );
}


set_capture_walk_anims()
{
	level.goddard thread set_run_anim( "capture_walk_loop" );
	level.friend1 thread set_run_anim( "capture_walk_loop" );
	level.friend2 thread set_run_anim( "capture_walk_loop" );
}

reset_capture_walk_anims()
{
	level.goddard thread reset_run_anim();
	level.friend1 thread reset_run_anim();
	level.friend2 thread reset_run_anim();
}

reset_run_anim()
{
	self.a.combatrunanim = undefined;
	self.run_noncombatanim = self.a.combatrunanim;
	self.walk_combatanim = self.a.combatrunanim;
	self.walk_noncombatanim = self.a.combatrunanim;
	self.preCombatRunEnabled = false;
}

////////////////////////////////////////////////////

digger_anim()
{
	wait( randomfloat( 4 ) );
	self.animname = "snow_digger";
	self thread single_loop_react_anim( "snow_dig", "snow_dig_react", "enemy_in_sight" );
}

barrel_anim()
{
	self.animname = "german_camp_fire";
	
	index = randomint( 4 );
	if( index == 0 )
	{
		self thread single_loop_react_anim( "around_fire_a", undefined, "enemy_in_sight" );
	}
	else if( index == 1 )
	{
		self thread single_loop_react_anim( "around_fire_b", undefined, "enemy_in_sight" );
	}
	else if( index == 2 )
	{
		self thread single_loop_react_anim( "around_fire_c", undefined, "enemy_in_sight" );
	}
	else 
	{
		self thread single_loop_react_anim( "around_fire_d", undefined, "enemy_in_sight" );
	}
}

weapon_check_1_anim()
{
	self.animname = "sitting";
	self thread single_loop_react_anim( "sitting_idle_1", "sitting_react", "enemy_in_sight" );
}

weapon_check_2_anim()
{
	self.animname = "sitting";
	self thread single_loop_react_anim( "sitting_idle_2", "sitting_react", "enemy_in_sight" );
}

weapon_check_3_anim()
{
	self.animname = "sitting";
	self thread single_loop_react_anim( "sitting_idle_3", "sitting_react", "enemy_in_sight" );
}

weapon_check_4_anim()
{
	self.animname = "sitting";
	self thread single_loop_react_anim( "sitting_idle_4", "sitting_react", "enemy_in_sight" );
}

single_loop_react_anim( anim_idle_name, anim_react_name, end_msg )
{
	self endon( "death" );

	self thread anim_loop_solo( self, anim_idle_name, undefined, end_msg );

	self waittill( end_msg );

	if( isdefined( anim_react_name ) )
	{
		self thread anim_single_solo( self, anim_react_name );
	}
}

/////////////////////////////////////////////////////

event3_execution_2man_anims( victim, executioner, animSpot )
{	
	knees_execution_guys_array = [];
	knees_execution_guys_array[0] = victim;
	knees_execution_guys_array[1] = executioner;
	
	// run the anim
	animSpot thread anim_single( knees_execution_guys_array, "execute" );
	animSpot thread victim_deathanim( victim );
}

victim_deathanim( victim )
{
	// wait for the headshot notetrack
	victim.executioner waittillmatch( "single anim", "shot_in_the_head" );
	
	// wait for the shooting animation to finish
	victim waittillmatch( "single anim", "end" );
	
	// drop the weapon	
	victim animscripts\shared::DropAllAIWeapons();
	
	// set custom deathanim and kill the man!
	victim.deathanim = level.scr_anim[victim.animname]["deathidle"][0];
	victim DoDamage( victim.health + 5, (0,0,0) );

	wait( 1 );

	level notify( "execution_done" );
}

event3_execution_gunshotFX( executioner )
{
	executioner endon( "death" );
	
	PlayFxOnTag( level._effect["rifleflash"], executioner, "tag_flash" );
	wait( 0.2 );
	PlayFxOnTag( level._effect["rifle_shelleject"], executioner, "tag_brass" );
}

event3_execution_headshotFX( executioner )
{
	executioner endon( "death" );
	
	victim = executioner.victim;
	
	forward = AnglesToForward( ( executioner GetTagAngles( "tag_flash" ) ) );
	PlayFX( level._effect["headshot"], victim GetTagOrigin( "J_HEAD" ), forward );
}

/////////////////////////////////////////////////////