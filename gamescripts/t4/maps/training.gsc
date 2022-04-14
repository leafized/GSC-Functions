#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#include maps\_hud_util;
#using_animtree ("generic_human");

main()
{
	setsaveddvar("compassMaxRange", 1500);
	
	// load up effects -- placed by Dale.  Hi!
	maps\training_fx::main();
	
	// vehicle loading functions
	//maps\_buffalo::main( "vehicle_usa_tracked_lvt4", "buffalo" );
	maps\_buffalo::main( "vehicle_usa_tracked_lvt4", "buffalo_players" );	
	maps\_jeep::main( "vehicle_usa_wheeled_jeep", "jeep" );
	maps\_p51::main( "vehicle_p51_mustang" );
	
	maps\_load::main();
	maps\training_amb::main();
	// load up the anims for the level
	maps\training_anim::main();
	
	do_precacheing();
	
	wait_for_first_player();
		
	level.players = get_players();
	//players[0] is the first player
	
	level.players[0] SetWeaponAmmoClip("m1garand", 0);
	level.players[0] SetWeaponAmmoStock("m1garand", 0);
	
	prepare_anims();
	init_level();
	
	// Ride in on the LVT
	level_setup();
	
	// Wait until the last trigger is hit before moving on to the next section.
	getent( "finished_locomotion", "targetname") waittill( "trigger" );
	
	level.off1 thread maps\training_anim::off1_dialog_and_sound(0);
	
	level thread objective_choose();
	//level thread start_amb_marchers();
	
	//Start the combat training
	level thread select_next_event();
}

do_precacheing()
{
	precachestring(&"TRAINING_HINT_PRONE");
	precachestring(&"TRAINING_HINT_CROUCH");
	precachestring(&"TRAINING_HINT_ADS");
	precachestring(&"TRAINING_HINT_FIRE");
	precachestring(&"TRAINING_HINT_GRENADE");
	precachestring(&"TRAINING_HINT_CHECK_OBJ");
	precachestring(&"TRAINING_HINT_SPRINT");
	precachestring(&"TRAINING_HINT_CROUCH_SPRINT");
	precachestring(&"TRAINING_HINT_MELEE");
	precachestring(&"TRAINING_OBJ_CHECK_OBJ");
	precachestring(&"TRAINING_OC_TIME_COMPLETED");
	precachestring(&"TRAINING_OC_TOTAL_TIME");
	precachestring(&"TRAINING_OC_TARGETS_MISSED");
	precachestring(&"TRAINING_OC_GRENADES_MISSED");	
	precachestring(&"TRAINING_OC_NA");
	
	precacheshader("black");
	
	precacheModel("vehicle_p51_mustang");
	
	precacheMenu("select_difficulty");
}

prepare_anims()
{
	level.srgt = getent("officer1","targetname");
	level.srgt.animname = "sarge1";	
	
	level.off1 = getent("end_loco_officer","targetname");
	level.off1.animname = "off1";
	
	level.sr_off = getent("sr_officer","targetname");
	level.sr_off.animname = "off2";
}

init_level()
{
	//fog and bloom effects
	setVolFog(100, 5500, 0, 3000, 0.4, 0.45, 0.47, 10.0);
	VisionSetNaked("training",1);    
	
	// Remove the sarge's weapon
	level.srgt animscripts\shared::placeWeaponOn( level.srgt.primaryweapon, "none");
	
	level.trainees = [];
	
	setup_wave_manager();	
	
	level.trainees = getentarray("trainee","targetname");
	assertex(level.trainees.size > 0, "Trainee Array Size is < 1");
	
	// set their animname
	for(i = 0; i < level.trainees.size; i++)
	{
		level.trainees[i].animname = "trainee";
	}
	
	//set these as the first wave
	level.wave_manager.waves[0] = level.trainees;
	
	level.bbeam_nodes = getnodearray("oc_balance_beam_start", "targetname");	
	level.ai_end_pos = getnodearray("oc_ai_end_node", "targetname");	
}

///////////////////////////////////////////////////////////////////////////////////////////
//	SECTION 0:  BEGIN THE LEVEL - RIDE IN ON LVT
///////////////////////////////////////////////////////////////////////////////////////////
level_setup()
{
	level.previous_best = 0;
	
	level thread sarge_startup();
	
	level thread add_player_to_lvt();
	level thread add_ai_to_lvt();

	level thread test_lvt();
	level thread wait_to_move();
}

sarge_startup()
{
	level.srgt thread set_run_anim( "run_anim");
	
	//wait(15);
	
	//while(true)
	//{
	//	level.srgt anim_single_solo( level.srgt, "lean_idle", undefined, undefined );
	//}
	
	level.srgt thread anim_loop_solo( level.srgt, "lean_idle", undefined, "new_node_selected" );
}

add_player_to_lvt()
{
	tlvt = getent( "training_lvt", "targetname");
	tag = "tag_passenger7";
	
	org = tlvt gettagOrigin( tag );
	ang = (0, 90, 0);
	
	// Place the player at the given tag
	level.players[0] setorigin (org);
	//level.players[0] setplayerangles (ang);
	
	// link the player in place
	level.players[0].lvt_linkspot = spawn("script_origin", org);
	level.players[0].lvt_linkspot linkto(tlvt, tag, (0,0,0), ang);
	level.players[0] playerlinktodelta(level.players[0].lvt_linkspot, undefined, 1.0);	
}

add_ai_to_lvt()
{
	tlvt = getent( "training_lvt", "targetname");
	ang = (0, 90, 0);
	
	tag = "tag_passenger2";
	level.trainees[0] linkto (tlvt, tag, (0,0,0), (0,90,0));
	
	tag = "tag_passenger3";
	level.trainees[1] linkto (tlvt, tag, (0,0,0), (0,0,0));
	
	tag = "tag_passenger4";
	level.trainees[2] linkto (tlvt, tag, (0,0,0), (0,0,0));
	
	tag = "tag_passenger5";
	level.trainees[3] linkto (tlvt, tag, (0,0,0), (0,0,0));
	
	tag = "tag_passenger6";
	level.trainees[4] linkto (tlvt, tag, (0,0,0), (0,0,0));
	
	tag = "tag_passenger8";
	level.trainees[5] linkto (tlvt, tag, (0,0,0), (0,0,0));
	
	tag = "tag_passenger9";
	level.trainees[6] linkto (tlvt, tag, (0,0,0), (0,0,0));	
}

wait_to_move()
{
	level waittill("lvt_unloaded");
	
	// turn off collision with the vehicle
	tlvt = getent( "training_lvt", "targetname");
	
	level.players[0] unlink();
	level.players[0].lvt_linkspot delete();
	
	for(i = 0; i < level.trainees.size; i++)
	{
		level.trainees[i] unlink();
	}
	
	level thread start_run_course();
	level thread start_ai_waves();
	level thread begin_ambience();
}

start_ai_waves()
{
	getent("start_waves", "targetname") waittill( "trigger" );
	
	// Start the ambient waves of guys
	level thread start_ambient_ai();	
}

test_lvt()
{
	tlvt = getent( "training_lvt", "targetname");
	tlvt_start_node = getvehiclenode( "lvt_start_node", "targetname" );
	tlvt attachPath( tlvt_start_node );
	wait(1);
	tlvt startPath( tlvt_start_node );
	
	tlvt thread start_shake();
	
	stop_point = getvehiclenode( "lvt_unload_point", "targetname" );
	
	stop_point waittill( "trigger" );
	
	tlvt setspeed(0, 5);
	tlvt notify( "lvt_stopped" );
		
	wait(2);
	tlvt thread lvt_unload_test();
	
	wait(1);
	// call the first objective
	level thread objective_run_endurance();
}

start_shake()
{
	self endon( "lvt_stopped" );
	
	while(1)
	{
		earthquake( 0.07, 3, self.origin, 1024 );
		wait(1);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////
//	AMBIENCE
///////////////////////////////////////////////////////////////////////////////////////////
begin_ambience()
{	
	level thread ambient_planes();
	
	shooting_ai = getentarray( "amb_sr_ai", "targetname" );
	amb_target = getentarray( "amb_target1", "targetname" );
	
	for(i = 0; i < shooting_ai.size; i++)
	{
		shooting_ai[i] setentitytarget( amb_target[i], 1 );
	}
}

loop_jeep()
{
	jeep_start_node = getvehiclenode( "amb_jeep_start", "targetname" );
	
	while(true)
	{
		self travel_path();
		
		stop_point = getvehiclenode( "amb_jeep_end", "targetname" );
		stop_point waittill( "trigger" );
		wait(2);

		self attachPath( jeep_start_node);
	}
}

travel_path()  
{
	jeep_start_node = getvehiclenode( "amb_jeep_start", "targetname" );
	self attachPath( jeep_start_node );
	wait(1);
	self startPath( jeep_start_node );
}

ambient_planes()
{
	while(1)
	{
		wait( randomInt(30) + 30 );

		
		level thread send_plane();
	}
}

send_plane()
{
	model = "vehicle_p51_mustang";
	tname = "amb_p51";
	type = "p51";
	
	plane_nodes = getvehiclenodearray( "plane_start_node", "targetname" );
	randNode = randomInt(plane_nodes.size);
	
	start_node = plane_nodes[randNode];
	
	pos = start_node.origin;
	ang = start_node.angles;
	
	// create the plane
	plane = SpawnVehicle( model, tname, type, pos, ang );
	plane.vehicletype = type;	
	 
	// attach the plane to the path and send it on its way
	plane attachPath( start_node );
	wait(1);
	plane startPath( start_node );
	planesound = randomintrange(1,4);
	if (planesound == 1)
	{
		plane playsound("intro_plane1");
	}
	if (planesound == 2)
	{
		plane playsound("intro_plane2");
	}
	if (planesound == 3)
	{
		plane playsound("intro_plane3");
	}
	if (planesound == 4)
	{
		plane playsound("intro_plane4");
	}
	
	plane waittill("reached_end_node");
	plane delete();

}

start_amb_marchers()
{
	marchers = getentarray( "amb_marcher", "targetname" );
	node_pos1 = getnodearray( "amb_marcher_pos1", "targetname" );
	node_pos2 = getnodearray( "amb_marcher_pos2", "targetname" );
	
	while(true)
	{
		marchers thread amb_marchers_goto( node_pos2 );
		marchers[0] waittill( "marchers_in_position" );
		
		marchers thread amb_marchers_goto( node_pos1 );
		marchers[0] waittill( "marchers_in_position" );
	}
}

amb_marchers_goto( nodearray )
{
	for(i = 0; i < self.size; i++)
	{
		if( isdefined(self[i]) )
		{
			self[i].goalradius = 64;
			self[i] setgoalnode( nodearray[i] );
		}
	}
	
	self[0] waittill( "goal" );
	wait(5);
	
	self[0] notify( "marchers_in_position" );
}

///////////////////////////////////////////////////////////////////////////////////////////
//	SECTION 1:  TEACH LOCOMOTION
///////////////////////////////////////////////////////////////////////////////////////////
start_run_course()
{	
	//getent( "trig1","targetname") waittill( "trigger" );
	
	// send the sarge to his first position
	level.srgt notify( "end_pos1" );
	level.srgt move_sarge("sgt_crouch_place", 1);

	level thread send_wave_to_point_one(0);
	level thread wait_for_wave_death(0);
	
	setup_hintelem();
	level thread teach_crouch();
	level thread teach_mantle();
	level thread teach_prone();
	level thread teach_sprint();
	level thread teach_sprint_crouch();
	level thread teach_melee();
}



// Change the stance of the AI at the given trigger
change_ai_stance( trigger_name, stance_type )
{
	trig = getent( trigger_name, "targetname" );
	
	while( isdefined(self)  )
	{
		
		while( isdefined(self) && self istouching( trig ) )
		{
			self allowedstances(stance_type);
			wait( 0.1 );
		}
		
		wait( 0.1 );
	}
}



// Tell the player 
teach_sprint()
{
	level.hintelem setText(&"TRAINING_HINT_SPRINT");
	
	wait(3);
	
	level.hintelem setText("");	
}

teach_sprint_crouch()
{
	getent("oc_hint_crouch_sprint", "targetname") waittill( "trigger" );
	
	level.hintelem setText(&"TRAINING_HINT_SPRINT_CROUCH");
	
	wait(3);
	level.hintelem setText("");	
}

teach_melee()
{
	getent("oc_player_in_bunker", "targetname") waittill( "trigger" );
	
	level.hintelem setText(&"TRAINING_HINT_MELEE");
	
	wait(3);
	
	level.hintelem setText("");
}

teach_crouch()
{
	getent( "show_crouch","targetname") waittill( "trigger" );
	
	level.srgt thread maps\training_anim::sarge_dialog_and_sound(1);

	// move the sarge on
	level.srgt move_sarge("sgt_mantle_place", 1);

	give_hint(&"TRAINING_HINT_CROUCH", "crouch");

	//iprintlnbold("Press B To Crouch");
}

teach_mantle()
{
	getent( "show_mantle","targetname") waittill( "trigger" );
	
	// move the sarge on
	level.srgt move_sarge("sgt_prone_place", 1);
}


// Tell the player how to go prone
teach_prone()
{
	getent( "show_prone","targetname") waittill( "trigger" );
	
	level.srgt thread maps\training_anim::sarge_dialog_and_sound(2);
	
	give_hint(&"TRAINING_HINT_PRONE", "prone");
}

setup_hintelem()
{
	level.hintelem = NewHudElem();
	level.hintelem init_results_hudelem(320, 220, "center", "bottom", 1.5, 1.0);
}


give_hint(text, stance)
{
	level endon("hit");
	level thread watch_hint_stance(stance);
	
	wait(1);
	
	level.hintelem setText(text);
}

watch_hint_stance(stance)
{
	while( level.players[0] getstance() != stance )
	{
		wait(.2);
	}
	
	wait(.5);
	
	level.hintelem setText("");	
	self notify("hit");
}


// tell an ai to go to the given node
move_ai(dest_node)
{
	// send the sarge to his first position
	tempnode = getnode(dest_node, "targetname");
	self setgoalnode(tempnode);	
}

// for all the sarge moving goodness!  sets up animations to be played
move_sarge(dest_node, stance)
{
	self notify( "new_node_selected" );
	self notify( "killanimscript" );
	
	tempnode = getnode(dest_node, "targetname");
	self.goalradius = 32;
	self setgoalnode(tempnode);
	
	// Play his idle animation when he reaches his position
	self thread sarge_idle_animate(stance);
}

sarge_idle_animate(stance)
{
	self endon( "new_node_selected" );
	
	self waittill( "goal" );
	
	// Stance 1:  Leaning on a railing
	if(stance == 1)
	{
		level.srgt thread anim_loop_solo( level.srgt, "lean_idle", undefined, "new_node_selected" );
	}
	else if(stance == 2)
	{
		level.srgt thread anim_loop_solo( level.srgt, "stand_idle", undefined, "new_node_selected" );
	}
}


///////////////////////////////////////////////////////////////////////////////////////////
//	SELECT NEXT EVENT
///////////////////////////////////////////////////////////////////////////////////////////
select_next_event()
{	
	level thread objective_check_objectives();
	
	level thread sarge_movement_main();
	
	level thread watch_combat_trigger();

	level thread watch_obstacle_trigger();
}

watch_combat_trigger()
{
	getent("begin_shooting_range","targetname") waittill( "trigger" );
	
	level notify ( "choice made" );
	
	setup_combat_tutorial();
}

watch_obstacle_trigger()
{
	getent("begin_obstacle_course","targetname") waittill( "trigger" );
	
	level notify ( "choice made" );
	
	setup_obstacle_course();
}



///////////////////////////////////////////////////////////////////////////////////////////
//	COMBAT TUTORIAL
///////////////////////////////////////////////////////////////////////////////////////////
setup_combat_tutorial()
{
	level.sr_off thread maps\training_anim::officer_sr_dialog(0);		// "Alright, grab some ammo and grenades off of that table."
	
	// wait until the player grabs ammo to continue
	while( (level.players[0] GetWeaponAmmoClip("m1garand") <= 0) || !(level.players[0] HasWeapon("fraggrenade")) )
	{
		wait( 0.3 );
	}

	// Enable aim assist on all of the targets in the Shooting Range
	sr_aa_targ = getentarray("sr_assist_target", "targetname");
	
	for(i = 0; i < sr_aa_targ.size; i++)
	{
		sr_aa_targ[i] enableAimAssist();	
	}		
		
	shoot_ground_targets();
	
	//level thread make_ai_shoot_at_targets();
}



// Have the player shoot the three ground targets
shoot_ground_targets()
{		
	level.sr_off thread maps\training_anim::officer_sr_dialog(1);		// "Try shooting the lower three targets"
	
	level.targets_hit_counter = 0;
	level.player_used_ads = false;
	
	level thread watch_target( "near_target" );
	level thread watch_target( "middle_target" );
	level thread watch_target( "far_target" );
	
	level thread watch_for_ads();
	
	while( level.targets_hit_counter < 3 )
	{
		wait( 0.5 );
	}
	
	// check to see if the player knows how to ADS or not
	if(	!level.player_used_ads )
	{
		teach_ads();
	}	
	else
	{
		shoot_tower_targets();
	}
}

watch_for_ads()
{
	self endon("played_used_ads");
	cutoff_ammo = (level.players[0] getAmmoCount( "m1garand" )) - 6;
	current_ammo = level.players[0] getAmmoCount( "m1garand" );
	
	while(cutoff_ammo <= current_ammo)
	{
		if( level.players[0] playerads() > 0.8 )
		{
			self notify("player_used_ads");
			level.player_used_ads = true;
		}
		current_ammo = level.players[0] getAmmoCount( "m1garand" );
		wait(.01);
	}	
	
	//level.hintelem setText(&"TRAINING_HINT_ADS");
	//level thread turn_off_ads_text();
}

// have the player shoot the two tower targets
shoot_tower_targets()
{
	level.sr_off thread maps\training_anim::officer_sr_dialog(4);		// "Now see if you can shoot the targets up in the towers."

	sr_pop_up_targets();

	level.targets_hit_counter = 0;
	
	level thread watch_target( "left_tower_target" );
	level thread watch_target( "right_tower_target" );
	
	while (level.targets_hit_counter < 2 )
	{
		wait( 0.5 );
	}
	//iprintlnbold("Add Sensitivity Options Here");	
	practice_nade_toss();
}

sr_pop_up_targets()
{
	targ_to_spin = [];
	targ_to_spin[0] = getent("sr_target4", "targetname");
	targ_to_spin[1] = getent("sr_target5", "targetname");
	
	for(i = 0; i < targ_to_spin.size; i++)
	{
		targ_to_spin[i] rotateroll(90, .25);
	}
}


// teach the player how to toss a nade
practice_nade_toss()
{
	level.sr_off thread maps\training_anim::officer_sr_dialog(5); // toss a nade through the wall
			
	level.sr_nade_hit = false;
	level.can_throw_nade = false;
		
	level thread teach_nade();
			
	nade_target = getent("sr_grenade_target", "targetname");		
	nade_target thread sr_watch_grenade_target();
	
	while(!level.sr_nade_hit)
	{
		wait(0.01);
	}
	
	level thread objective_goto_obstacle_course();
	level.sr_off thread maps\training_anim::officer_sr_dialog(6); // go to obstacle course
}



//Teach the player how to ADS
teach_ads()
{
	player_used_ads = false;
	hit_counter = 0;
	
	level.sr_off thread maps\training_anim::officer_sr_dialog(2);		// "You've got a sight, use it."
	wait(0.5);
	
	level.hintelem setText(&"TRAINING_HINT_ADS");
	level thread turn_off_ads_text();
	
	while(!level.player_used_ads)
	{
		hit_counter = level.targets_hit_counter + 1;
		watch_target( "far_target");
		
		while( level.targets_hit_counter < hit_counter )
		{
			wait(0.5);
		}
	}

	shoot_tower_targets();
}

turn_off_ads_text()
{
	while(!level.player_used_ads)
	{
		if( level.players[0] playerads() > 0.8 )
		{
			level.player_used_ads = true;
		}
		
		wait(.1);
	}
	
	wait(.5);
	
	level.hintelem setText("");
}

teach_nade()
{
	wait(5);
	
	if(!level.can_throw_nade)	
	{
		level.hintelem setText(&"TRAINING_HINT_GRENADE");
		wait(2);
		level.hintelem setText("");
	}
}



// Watch the targets until they are hit
watch_target( which_target )
{
	target_hit = false;
	
	while( !target_hit )
	{
		temptarg = getent( which_target, "targetname");
		temptarg waittill( "trigger", guy );
		
		wait(.1);
		
		//if the player shoots the target, hurray!
		if( isdefined(guy) && isPlayer( guy ) )
		{
			target_hit = true;
			level.targets_hit_counter++;
			
			level.sr_off thread maps\training_anim::officer_sr_dialog(11);		// "Good shot"
			
			temptarg thread spin_target();
			
			// check to see if the player uses ADS while shooting the targets
			if( guy playerads() > 0.8 )
			{
				level.player_used_ads = true;
			}
			
			// Turn off the aim assist on the target after it is hit
			aAssist = getent("aim_" + temptarg.script_noteworthy, "script_noteworthy");
	
			if(	isdefined(aAssist) )		
			{
				aAssist disableAimAssist();
			}			
		}		
	}
}



// watch the given trigger to see if a grenade hits it...and stuff
sr_watch_grenade_target()
{	
	while(!level.sr_nade_hit)
	{
		level.players[0] waittill("grenade_fire", grenade);
	
		level.can_throw_nade = true;
	
		wait(.1);
	
		grenade thread sr_check_grenade(self);
	}
	wait(0.1);
}



// Watch the grenade to see if it hits the given trigger
sr_check_grenade(trigger_to_watch)
{
	grenade_hit = false;
	
	while(isdefined(self) && !level.sr_nade_hit)
	{
		if(isdefined(self) && self isTouching(trigger_to_watch))
		{							
			level.sr_nade_hit = true;
		}
		
		wait(.1);
	}
}



///////////////////////////////////////////////////////////////////////////////////////////
//	OBSTACLE COURSE
///////////////////////////////////////////////////////////////////////////////////////////
setup_obstacle_course()
{
	level.oc_running = false;
	level.oc_timer_time = 0.01;
	
	ptarg = getent("oc_targ7", "targetname");
	level.oc_p_targ_angles = ptarg.angles;
	
	setup_oc_timer();
	
	// get the target triggers in the level and watch to see if they are shot.
  oc_targets = getentarray("oc_target", "targetname");
  for(i = 0; i < oc_targets.size; i++)
  {
  	oc_targets[i] thread watch_oc_target();
  }
  
  // get the grenade target triggers in the level and watch to see if they are hit.
  oc_nade_triggers = getentarray("oc_grenade_target", "targetname");
  for(i = 0; i < oc_nade_triggers.size; i++)
  {
  	oc_nade_triggers[i] thread watch_grenade_target();
	}
	
	level.oc_targets_remaining = oc_targets.size + 2;
	level.oc_total_targets = oc_targets.size;
	level.oc_nade_targets_remaining = oc_nade_triggers.size;

	// Enable aim assist on all of the targets in the Obstacle Course
	oc_aa_targ = getentarray("oc_assist_target", "targetname");
	
	for(i = 0; i < oc_aa_targ.size; i++)
	{
		oc_aa_targ[i] enableAimAssist();	
	}
	
	level thread throw_nade_in_window();
	level thread say_shoot_targets();
	
	oc_move_trigs = getentarray("oc_move", "targetname");
	
	for(i = 0; i < oc_move_trigs.size; i++)
	{
		oc_move_trigs[i] thread say_move();
	}
	
	// find triggers to tell the player to toss grenade
}



throw_nade_in_window()
{
	getent("oc_toss_nade2", "targetname") waittill("trigger");
	
	level.srgt thread maps\training_anim::sarge_oc_dialog(3);
}

say_shoot_targets()
{
	getent("oc_shoot_targets", "targetname") waittill("trigger");
	
	level.srgt thread maps\training_anim::sarge_oc_dialog(0);
}

say_shoot_through_wood()
{
	getent("oc_penetrate_wood", "targetname") waittill("trigger");
	
	level.srgt thread maps\training_anim::sarge_oc_dialog(7);	
}

say_move()
{
	self waittill("trigger");

	level.srgt thread maps\training_anim::sarge_oc_dialog(6);
}

//run the obstacle course timer
setup_oc_timer()
{
	level.oc_start_time = 0;
	level.oc_end_time = 0;
	
	// Set up the Timer
	level.oc_timer = NewHudElem();
	level.oc_timer.x = 320;
	level.oc_timer.y = 100;
	level.oc_timer.alignX = "right";
	level.oc_timer.alignY = "bottom";
	level.oc_timer.fontScale = 2.5;
	level.oc_timer.alpha = 1.0;

	getent("oc_timer_start","targetname") waittill("trigger");
  
  level thread get_starting_ammo();
  
  level.oc_running = true;
  
  level.oc_timer SetTenthsTimerUp( level.oc_timer_time );  
  level.oc_start_time = gettime();

	level.srgt thread move_sarge("sgt_oc_pos1", 2);
	level.srgt thread maps\training_anim::sarge_oc_dialog(0);

	level thread objective_obstacle_course();

  level thread watch_oc_timer_end();
}



//  Wait for the ending trigger to get hit, then end the timer
watch_oc_timer_end()
{
	getent("oc_final_target1","targetname") waittill("trigger");
	
	level notify("oc_complete");
	
	level.oc_end_time = gettime();
	
	level.oc_timer destroy();
	
	level thread print_results();
	
	level thread ask_redo();
}



print_results()
{
	// TEMP RESULTS TO TEST
//	level.oc_end_time = 350000;
//	level.oc_start_time = 100;
//	level.oc_targets_remaining = 1;
//	level.oc_nade_targets_remaining = 0;
//	level.oc_total_targets = 12;
//	level.starting_ammo = 230;
//	level.ending_ammo = 218;
		
	oc_time_completed = (level.oc_end_time - level.oc_start_time);// / 1000;						// figure out the player's time
	oc_target_penalty = (level.oc_targets_remaining * 5000);															// time penalty for targets missed
	oc_nade_target_penalty = (level.oc_nade_targets_remaining * 10000);									// time penalty for nades missed
	oc_total_time = ( oc_time_completed + oc_target_penalty + oc_nade_target_penalty );	// total time
	
	oc_completed_str = convert_time_to_str(oc_time_completed);
	oc_total_str = convert_time_to_str(oc_total_time);
	oc_targ_str = convert_time_to_str(oc_target_penalty);
	oc_nade_str = convert_time_to_str(oc_nade_target_penalty);
	 
	// figure out accuracy	
	garand_ammo = level.players[0] getAmmoCount( "m1garand" );
	thompson_ammo = level.players[0] getAmmoCount( "thompson" );
	level.ending_ammo = garand_ammo + thompson_ammo;
	shots_fired = level.starting_ammo - level.ending_ammo;
	oc_accuracy = 0;
	if(shots_fired > 0)
	{
		targets_hit = level.oc_total_targets - level.oc_targets_remaining;
		oc_accuracy = int( ( targets_hit / shots_fired ) * 100 );
	}
		
	level.oc_end_results = [];	
	
	// Vars to quickly change location/size/etc of the results
	col1X = 300;
	colSpace = 230;
	col2X = col1x + colSpace;
	iniY = 120;
	Ystep = 11;
	textSize = 1.1;
	textAlpha = 1.0;
	
	// Ugly, repetitive stuff.  Fix this up when i'm not in a rush.
	level.oc_end_results[0] = NewHudElem();			// "Time Completed:"
	level.oc_end_results[0] init_results_hudelem(col1X, iniY, "left", "bottom", textSize, textAlpha);
	
	level.oc_end_results[1] = NewHudElem();			// Print out for the var, oc_time_completed
	level.oc_end_results[1] init_results_hudelem(col2X, iniY, "right", "bottom", textSize, textAlpha);
	
	level.oc_end_results[2] = NewHudElem();			// "Targets Missed:"
	level.oc_end_results[2] init_results_hudelem(col1X, iniY + (Ystep *1), "left", "bottom", textSize, textAlpha);
	
	level.oc_end_results[3] = NewHudElem();		// Print out how many targets are missed
	level.oc_end_results[3] init_results_hudelem(col1X, iniY + (Ystep *1), "left", "bottom", textSize, textAlpha);
	
	level.oc_end_results[4] = NewHudElem();			// Print out for the var, oc_target_penalty
	level.oc_end_results[4] init_results_hudelem(col2X, iniY + (Ystep *1), "right", "bottom", textSize, textAlpha);
	
	level.oc_end_results[5] = NewHudElem();			// "Grenade Targets Missed:"
	level.oc_end_results[5] init_results_hudelem(col1X, iniY + (Ystep *2), "left", "bottom", textSize, textAlpha);
	
	level.oc_end_results[6] = NewHudElem();			// Print out for the var, oc_nade_target_penalty
	level.oc_end_results[6] init_results_hudelem(col2X, iniY + (Ystep *2), "right", "bottom", textSize, textAlpha);
	
	level.oc_end_results[7] = NewHudElem();			// "Accuracy"
	level.oc_end_results[7] init_results_hudelem(col1X, iniY + (Ystep *3), "left", "bottom", textSize, textAlpha);
	
	level.oc_end_results[8] = NewHudElem();			// Print out for the var, oc_accuracy
	level.oc_end_results[8] init_results_hudelem(col2X, iniY + (Ystep *3), "right", "bottom", textSize, textAlpha);

	level.oc_end_results[9] = NewHudElem();			// "Previous Time:"
	level.oc_end_results[9] init_results_hudelem(col1X, iniY + (Ystep *5), "left", "bottom", textSize, textAlpha);
	
	level.oc_end_results[10] = NewHudElem();			// Print out for the var, level.previous_best
	level.oc_end_results[10] init_results_hudelem(col2X, iniY + (Ystep *5), "right", "bottom", textSize, textAlpha);
	
	level.oc_end_results[11] = NewHudElem();			// "Total Time:"
	level.oc_end_results[11] init_results_hudelem(col1X, iniY + (Ystep *6), "left", "bottom", textSize, textAlpha);
	
	level.oc_end_results[12] = NewHudElem();			// Print out for the var, oc_total_time
	level.oc_end_results[12] init_results_hudelem(col2X, iniY + (Ystep *6), "right", "bottom", textSize, textAlpha);

	level.oc_end_results[13] = NewHudElem();			// Shader behind the text
	level.oc_end_results[13] init_results_hudelem(col1X - 5, (iniY - Ystep) - 5, "left", "top", textSize, 0.7);

	// Print out the results of the Obstacle Course.		
	level.oc_end_results[0] SetText( &"TRAINING_OC_TIME_COMPLETED" );
	level.oc_end_results[1] SetText( oc_completed_str );
	level.oc_end_results[2] SetText( &"TRAINING_OC_TARGETS_MISSED" ); 	//level.oc_targets_remaining
	level.oc_end_results[3] SetText( level.oc_targets_remaining );
	level.oc_end_results[4] SetText( "+" + oc_targ_str );
	level.oc_end_results[5] SetText( &"TRAINING_OC_GRENADES_MISSED" );	//level.oc_nade_targets_remaining
	level.oc_end_results[6] SetText( "+" + oc_nade_str);
	level.oc_end_results[7] SetText( "ACCURACY" );											// Accuracy
	if(shots_fired > 0)
	{
		level.oc_end_results[8] SetText( oc_accuracy + "%");								// oc_accuracy
	}
	else
	{
		level.oc_end_results[8] SetText( &"TRAINING_OC_NA" );								// you didn't shoot
	}
	level.oc_end_results[9] SetText( "PREVIOUS BEST:" ); 		// TEMP -- GET THIS CONVERTED TO LOCALIZED STRING
	level.oc_end_results[11] SetText( &"TRAINING_OC_TOTAL_TIME" );
	level.oc_end_results[12] Settext( oc_total_str );
	
	// if this is the first time running the OC, pring N/A as previous time
	if(level.previous_best == 0)
	{
		level.oc_end_results[10] setText( &"TRAINING_OC_NA" );
	}
	else
	{
		oc_prev_str = convert_time_to_str( level.previous_best );
		level.oc_end_results[10] setText( oc_prev_str );
	}
	
	level.oc_end_results[13] SetShader( "black", colSpace + Ystep, (Ystep *7) + Ystep);
	level.oc_end_results[13].sort = 10;
	
	// If the player beats their record, set as new record.
	if( level.previous_best > oc_total_time || level.previous_best == 0 )
	{
		level.previous_best = oc_total_time;
	}
	
	// have sarge react to th etime
	level thread sarge_reaction(oc_total_time, level.oc_targets_remaining, level.oc_nade_targets_remaining);
}



init_results_hudelem(x, y, alignX, alignY, fontscale, alpha)
{
	self.x = x;
	self.y = y;
	self.alignX = alignX;
	self.alignY = alignY;
	self.fontScale = fontScale;
	self.alpha = alpha;
	self.sort = 20;
	self.font = "objective";
}

// Pass in time as milliseconds!
convert_time_to_str(oc_time)
{
	// figure out minutes and seconds
	time_min = int(oc_time / 60000);
	time_sec = int(oc_time) % 60000;
	
	time_sec /= 1000;
	
	if(time_sec < 10)
	{
		time_sec = "0" + time_sec;
	}
	
	time_str = time_min + ":" + time_sec;
	
	return time_str;	
}

ask_redo()
{
	level thread oc_restart();
	getent("oc_ask_redo", "targetname") waittill("trigger");
	
	level.srgt thread maps\training_anim::sarge_oc_dialog(8);
	level thread objective_goto_oc_or_tents();

	// remove player clip from end
	endclip = getent("oc_disable_end", "targetname");
	if( isdefined(endclip) )
	{
		endclip delete();
	}

	oc_pop_targets = [];
	oc_pop_targets[0] = getent("oc_targ7", "targetname");
  oc_pop_targets[1] = getent("oc_targ8", "targetname");
  for(i = 0; i < oc_pop_targets.size; i++)
  {
  	oc_pop_targets[i].angles = level.oc_p_targ_angles;
  }	
	
	level thread check_end();	
}


// Set up the OC to run again
oc_restart()
{
	getent("oc_restart","targetname") waittill("trigger");
	
	for(i = 0; i < level.oc_end_results.size; i++)
	{
		level.oc_end_results[i] destroy();
	}
	
	level.players[0] giveMaxAmmo( "m1garand" );
	level.players[0] giveMaxAmmo( "thompson" );
	level.players[0] giveMaxAmmo( "fraggrenade" );
	
	level.srgt thread sarge_oc_setup();
	
	level thread setup_obstacle_course();
}



// Watch the target to see if it is hit
watch_oc_target()
{
	level endon("oc_complete");
	
	self.drawoncompass =1;
	
	target_hit = false;
	
	while( !target_hit )
	{
		self waittill( "trigger", guy, dmg);
		
		//if the player shoots the target, hurray!
		if(isPlayer( guy ) )
		{
  		target_hit = true;
			level.oc_targets_remaining--;
			
			level.srgt thread maps\training_anim::sarge_oc_dialog(1);
			
			self thread spin_target();
			
			// Turn off the aim assist on the target after it is hit
			aAssist = getent("oc_" + self.script_noteworthy, "script_noteworthy");
	
			if(	isdefined(aAssist) )		
			{
				aAssist disableAimAssist();
			}
		}
	}
}



// Watch the target to see if it is hit
watch_oc_pop_target()
{
	level endon("oc_complete");
	
	target_hit = false;
	
	while( !target_hit )
	{
		self waittill( "trigger", guy, dmg);
		
		//if the player shoots the target, hurray!
		if(isPlayer( guy ) )
		{
  		target_hit = true;
			level.oc_targets_remaining--;
			
			level.srgt thread maps\training_anim::sarge_oc_dialog(1);
			
			self thread lay_down_target();
		}
	}
}



// watch the given trigger to see if a grenade hits it...and stuff
watch_grenade_target(ending_signal)
{	
	level endon("oc_complete");
	
	while(1)
	{
		level.players[0] waittill("grenade_fire", grenade);
	
		wait(.1);
	
		grenade thread check_grenade(self, ending_signal);
	}
	wait(0.1);
}



// Watch the grenade to see if it hits the given trigger
check_grenade(trigger_to_watch, ending_signal)
{
	level endon("oc_complete");
	
	grenade_hit = false;
	
	while(isdefined(self) && !grenade_hit)
	{
		if(isdefined(self) && self isTouching(trigger_to_watch))
		{			
			level.oc_nade_targets_remaining--;
	
			level.srgt thread maps\training_anim::sarge_oc_dialog(4);
			grenade_hit = true;
			
			flip_up_targets();
		}
		
		wait(.1);
	}
}


flip_up_targets()
{
	targ_to_spin = [];
	targ_to_spin[0] = getent("oc_targ7", "targetname");
	targ_to_spin[1] = getent("oc_targ8", "targetname");
	
	for(i = 0; i < 2; i++)
	{
		targ_to_spin[i] rotateroll(-90, .25);
	}

  oc_pop_targets = getentarray("oc_popup_target", "targetname");
  for(i = 0; i < oc_pop_targets.size; i++)
  {
  	oc_pop_targets[i] thread watch_oc_pop_target();
  }
  
	sr_aa_targ = getentarray("oc_p_assist_target", "targetname");
	for(i = 0; i < sr_aa_targ.size; i++)
	{
		sr_aa_targ[i] enableAimAssist();	
	}
}

lay_down_target()
{
	targ_to_lay = getent(self.target, "targetname");
	
	targ_to_lay rotateroll(90, .25);
}

spin_target()
{	
	targ_to_spin = getent(self.target, "targetname");
	
	targ_to_spin rotateyaw(360, .5);
}



sarge_reaction(total_time, targs_left, nade_targs_left)
{
	if(targs_left >= 3)
	{
		level.srgt thread maps\training_anim::sarge_dialog("oc_results_targs");
	}
	else if(nade_targs_left)
	{
		level.srgt thread maps\training_anim::sarge_dialog("oc_results_nade_targs");
	}
	else if(total_time <= 40)
	{
		level.srgt thread maps\training_anim::sarge_dialog("oc_results_good");
	}
	else if(total_time <= 55)
	{
		level.srgt thread maps\training_anim::sarge_dialog("oc_results_average");
	}
	else if(total_time > 55)
	{
		level.srgt thread maps\training_anim::sarge_dialog("oc_results_bad");
	}
}



check_end()
{
	getent("training_over", "targetname") waittill("trigger");
	
	difficulty_select();

}

get_starting_ammo()
{
	garand_ammo = level.players[0] getAmmoCount( "m1garand" );
	thompson_ammo = level.players[0] getAmmoCount( "thompson" );
	level.starting_ammo = garand_ammo + thompson_ammo;
}


///////////////////////////////////////////////////////////////////////////////////////////
//	SARGE MOVEMENT
///////////////////////////////////////////////////////////////////////////////////////////

// Probably sloppy for now
sarge_movement_main()
{
	level thread watch_to_oc();
	
	level thread watch_to_sr();
}

watch_to_oc()
{
	getent("player_to_oc", "targetname") waittill("trigger");
	
	level.srgt thread maps\training_anim::sarge_dialog_and_sound(4);
	level.srgt thread move_sarge("sgt_oc_start", 2);	
	
	level thread objective_grab_thompson();
	
	ambjeep = getent( "amb_jeep", "targetname");
	ambjeep thread loop_jeep();	
	
	wait_for_thompson();	
}

watch_to_sr()
{
	getent("player_to_sr", "targetname") waittill("trigger");
	
	//level.srgt thread maps\training_anim::sarge_dialog_and_sound(5);
}

sarge_oc_setup()
{	
	getent("oc_timer_start", "targetname") waittill("trigger");
	self thread move_sarge("sgt_oc_pos1", 2);
	
	getent("oc_at_river1", "targetname") waittill("trigger");
	self thread move_sarge("sgt_oc_pos2", 2);
	
	getent("oc_shoot_targets", "targetname") waittill("trigger");
	self thread move_sarge("sgt_oc_pos3", 2);
	
	getent("oc_through_crouch", "targetname") waittill("trigger");
	self thread move_sarge("sgt_oc_pos4", 2);
	
	getent("oc_through_water", "targetname") waittill("trigger");
	self thread move_sarge("sgt_oc_pos5", 2);
	
	getent("oc_player_in_bunker","targetname") waittill("trigger");
	level.srgt thread maps\training_anim::sarge_oc_dialog(5);
	self thread move_sarge("sgt_oc_start", 2);	
}

wait_for_thompson()
{
	while( level.players[0] getCurrentWeapon() != "thompson" && level.players[0] getCurrentOffhand() != "thompson" )
	{
		wait( 0.3 );
	}
	
	level notify ( "thompson picked up" );
	
	oc_ready_to_start();
}

oc_ready_to_start()
{
	level.srgt thread sarge_oc_setup();
	
	getent("oc_first_time_speech", "targetname") waittill("trigger");
	
	level.srgt thread maps\training_anim::sarge_dialog_and_sound(6);
	
	wait(2);
	
	level.srgt thread maps\training_anim::sarge_dialog_and_sound(7);
	
	//wait(1);
	
	tempbrush = getent("oc_disable_mantle", "targetname");
	tempbrush delete();	
}

///////////////////////////////////////////////////////////////////////////////////////////
//	AMBIENT AI
///////////////////////////////////////////////////////////////////////////////////////////

//Time Table:
//	0:00 - 1:00:  Spawn guys and send them to lvt start + run to end of first section
//	1:00 - 1:15:  Make decision on where they would like to go (OC or SR) and move to position
//	1:30 - -:--:  Spawn the next wave
//	3:30 - -:--:  Delete current wave
//	
//	Obstacle Course
//		1:15 - 1:45:  First set of two men begin the course and get half way through
//		1:45 - 2:15:  Second set of two men run the course and get half way through (first wave exits)
//		2:15 - 2:45:  2 Soldiers from SR run the OC, other two walk off
//	
//	Shooting Range
//		1:15 - 2:00:  Soldiers shoot at targets and toss grenades
//		2:00 - 2:15:  Soldiers run to obstacle course
		
	
		
		

start_ambient_ai()
{	
	while( true )
	{
		level.wave_manager.cur_wave++;

		wait(85);		// time to delay before starting the new wave				

		level thread create_new_wave();
		wait(20);		// time to get the group from where they spawned to the lvt

		level thread send_wave_to_point_one( level.wave_manager.cur_wave );
		
		level thread wait_for_wave_death(level.wave_manager.cur_wave);

	}
}

wait_for_wave_death(which_wave)
{
	wait(190);
	delete_wave(which_wave);
}

setup_wave_manager()
{
	level.wave_manager = spawn(	"script_origin", (0, 0, 0) );
	
	level.barn_count = 0;
	level.barn_array = getnodearray("death_node","targetname");
	
	level.wave_manager.cur_wave = 0;
	level.wave_manager.waves = [];
}



//create a new wave and add it to the array
create_new_wave()
{	
	new_wave = [];
	spawn_locs = [];				
	
	wave_num = level.wave_manager.cur_wave;										// make life more simple, the wave number
	
	spawn_name = "new_recruit" + wave_num;										// create a name to give to the soldiers
	spawn_locs = getentarray("new_trainee", "targetname");		// get an array of the spawners
	lvt_goal_nodes = getnodearray("lvt_spot", "targetname");	// get an array of the lvt spots
	
	assertex(isdefined(spawn_locs), "spawn_locs is not defined!");
	assertex(isdefined(lvt_goal_nodes), "lvt_goal_nodes is not defined!");
	
	for(j = 0; j < spawn_locs.size; j++)
	{
		spawn_locs[j].count = 1;
	}
	
	for(i = 0; i < spawn_locs.size; i++)
	{
		new_wave[i] = spawn_locs[i] stalingradspawn();

		if(!maps\_utility::spawn_failed(new_wave[i]))
		{
			new_wave[i].targetname = spawn_name;
			new_wave[i].animname = "trainee";

			wait(0.1);
		}
		else
		{
			assertex(isdefined(new_wave[i]), "create_new_wave(): Failed to spawn dude");
		}
	}
	
	level.wave_manager.waves[wave_num] = new_wave;
}



send_wave_to_point_one( wave_num )
{
	move_wave = [];
	move_wave = level.wave_manager.waves[wave_num];
	run_end_array = getnodearray("run_course_end","targetname");
	
	// send the soldiers to their destination nodes, as well as setting up the stance-changing triggers
	for(i = 0; i < move_wave.size; i++)
	{
		move_wave[i] setgoalnode(run_end_array[i]);
		move_wave[i] thread change_ai_stance("ai_crouch_trig", "crouch");
		move_wave[i] thread change_ai_stance("ai_stand_trig1", "stand"); 
		move_wave[i] thread change_ai_stance("ai_prone_trig", "prone");
		move_wave[i] thread change_ai_stance("ai_stand_trig2", "stand");
	}
	
	wait(40);	// delay to allow them to get there (setting wait to keep a strict time schedule)
	
	// send the first four to the OC, second four to the SR
	move_wave thread send_group_to_oc();
	move_wave thread send_group_to_sr();
}



// Send 0-3 to the OC and 4-7 to SR
send_group_to_oc(move_wave)
{
	oc_node_array = getnodearray("oc_start_node","targetname");	
	oc_od_node_array = getnodearray("oc_on_deck","targetname");
	
	for(i = 0; i < 4; i++)
	{
		if(i < 2)
			self[i] setgoalnode( oc_node_array[i] );
		else
			self[i] setgoalnode( oc_od_node_array[i - 2] );
	}
	
	wait(15);
	
	
	self[0] thread send_entity_through_oc( 0 );
	self[1] thread send_entity_through_oc( 1 );

	self[2] setgoalnode( oc_node_array[0] );
	self[3] setgoalnode( oc_node_array[1] );
	
	wait(30);
	
	self[2] thread send_entity_through_oc( 0 );
	self[3] thread send_entity_through_oc( 1 );
}

send_group_to_sr()
{
	sr_node_array = getnodearray("shooting_range_node","targetname");
	oc_node_array = getnodearray("oc_start_node","targetname");	
	oc_death_array = getnodearray("death_node","targetname");
	
	for(i = 0; i < 4; i++)
	{
		if(	isdefined(self[i + 4]) )
		{
			self[i + 4] setgoalnode( sr_node_array[i] );
		}
	}	
	
	wait(45);
	
	self[4] setgoalnode( oc_node_array[0] );
	self[5] setgoalnode( oc_node_array[1] );
	self[6] go_behind_barn();
	
	if(	isdefined(self[7]) )
	{
		self[7] go_behind_barn();
	}
	
	wait(30);
	
	self[4] thread send_entity_through_oc( 0 );
	self[5] thread send_entity_through_oc( 1 );
}



send_entity_through_oc(index)
{	
	// run to the first point
	self setgoalnode( level.bbeam_nodes[index] );
	self.goalradius = 64;	
	
	self waittill( "goal" );
	
	// run to the ending point of the OC
	self setgoalnode( level.ai_end_pos[index] );
	self thread change_ai_stance("oc_crouch_trig", "crouch");
	self thread change_ai_stance("oc_stand_trig", "stand");		
	
	self waittill( "goal" );
	
	// run to the despawning point
	self go_behind_barn();
}

go_behind_barn()
{
	self setgoalnode( level.barn_array[level.barn_count] );
	
	level.barn_count++;
	
	if(level.barn_count >= 8)
	{
		level.barn_count = 0;
	}
}



delete_wave(which_wave)
{
	dead_wave = [];
	dead_wave = level.wave_manager.waves[which_wave];
	
	// send the soldiers to their destination nodes, as well as setting up the stance-changing triggers
	for(i = 0; i < dead_wave.size; i++)
	{
		if( isdefined(dead_wave[i]) )
		{
			dead_wave[i] delete();
		}
	}
}



///////////////////////////////////////////////////////////////////////////////////////////
//	Objective Functions
///////////////////////////////////////////////////////////////////////////////////////////
objective_run_endurance()
{
	obj_struct = getstruct( "obj_endurance", "targetname" );
	
	objective_add(1, "current", &"TRAINING_OBJ_ENDURANCE", obj_struct.origin);
	
	obj_end_trig = getent( "finished_locomotion", "targetname" );
	obj_end_trig waittill( "trigger" );
	
	objective_state( 1, "done" );
}

objective_choose()
{
	obj_struct1 = getstruct( "obj_choose1", "targetname" );
	obj_struct2 = getstruct( "obj_choose2", "targetname" );
	
	objective_add( 2, "current", &"TRAINING_OBJ_CHOOSE", obj_struct1.origin );
	objective_AdditionalPosition( 2, 1, obj_struct2.origin );
	
	level waittill( "choice made" );
	
	objective_state( 2, "done" );
}

objective_grab_thompson()
{
	obj_struct = getstruct( "obj_thompson", "targetname" );
	
	objective_add( 3, "current", &"TRAINING_OBJ_THOMPSON", obj_struct.origin );
	
	level waittill( "thompson picked up" );
	
	objective_state( 3, "done" );
	wait(.5);
	objective_delete( 3 );
}

objective_obstacle_course()
{
	
	objective_add( 4, "current", &"TRAINING_OBJ_OBSTACLE" );
	
	level waittill( "oc_complete" );
	
	objective_state( 4, "done" );
}

objective_check_objectives()
{
	objective_add( 5, "current", &"TRAINING_OBJ_CHECK_OBJ" );
	
	wait(1);
	level.hintelem setText(&"TRAINING_HINT_CHECK_OBJ");	
	level thread obj_check_obj_remove();
	
	level thread wait_for_pause();
	level waittill( "menu checked" );
	
	objective_state( 5, "done" );
	wait(.5);
	objective_delete( 5 );
}

objective_goto_obstacle_course()
{
	obj_struct = getstruct( "obj_choose2", "targetname" );
	
	objective_add( 6, "current", &"TRAINING_OBJ_GOTO_OC", obj_struct.origin );
	
	obj_end_trig = getent( "player_to_oc", "targetname" );
	obj_end_trig waittill( "trigger" );
	
	objective_state( 6, "done" );
}

objective_goto_wall()
{
	objective_add( 7, "current", &"TRAINING_OBJ_OC_WALL" );
	
	level waittill( "something" );
	
	objective_state( 7, "done");
	wait(.5);
	objective_delete( 7 );
}

objective_goto_oc_or_tents()
{
	obj_struct1 = getstruct( "obj_oc_wall", "targetname" );
	obj_struct2 = getstruct( "obj_end", "targetname" );	
	
	objective_add( 8, "current", &"TRAINING_OBJ_OC_OR_END", obj_struct1.origin );
	objective_AdditionalPosition( 8, 1, obj_struct2.origin );
	
	// maybe set invisible if the player goes to the OC?
}

obj_check_obj_remove()
{
	wait(3);
	
	level.hintelem setText("");	
}

wait_for_pause()
{
	while( GetDvarInt("cl_paused") != 1 )
	{
		wait(.01);
	}
	
	self notify( "menu checked" );
}


///////////////////////////////////////////////////////////////////////////////////////////
//	Menu Functions
///////////////////////////////////////////////////////////////////////////////////////////
difficulty_select()
{	
	difficulty_shader = NewHudElem();			// Shader behind the text
	difficulty_shader init_results_hudelem(-120, 1, "left", "top", 1, 0.6);
	difficulty_shader SetShader( "black", 1000, 480);	
	
	// --- menu popup for difficulty selection ---
	level.players[0] openMenu("select_difficulty");
	level.players[0] freezecontrols(true);
	level.players[0] setblur(5, 0);


	while( true )
	{
		level.players[0] waittill("menuresponse", menu, response);
		if( response == "continue" || response == "tryagain" )
			break;

		wait(1);

		level.players[0] openMenu("select_difficulty");
	} 
		
	level.players[0] setblur(0, .2);
	difficulty_shader destroy();
	level.players[0] freezecontrols(false);		
		
	if(response == "continue")
	{
		nextmission();
	}
	else if(response == "tryagain")
	{
		level.srgt thread maps\training_anim::sarge_oc_dialog(8);
		wait(5);
		level thread check_end();
	}
}



///////////////////////////////////////////////////////////////////////////////////////////
//	Vehicle Functions
///////////////////////////////////////////////////////////////////////////////////////////
#using_animtree ("vehicles");
lvt_unload_test()
{
	level notify( "lvt_unloaded" );
	
	self setflaggedanim( "drop_gate", %v_lvt4_open_ramp, 1, 0 );
}
