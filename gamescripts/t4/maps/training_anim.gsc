#include maps\_utility;
#include maps\_anim;

#using_animtree ("generic_human");
main()
{
	anim_loader();
	
	audio_loader();
}

anim_loader()
{
	// Sarge locomotion anims:  Leaning
	level.scr_anim["sarge1"]["lean_in"] 						= %ch_training_sarge_lean_in;
	level.scr_anim["sarge1"]["lean_out"] 						= %ch_training_sarge_lean_out;
	level.scr_anim["sarge1"]["lean_idle"][0] 				= %ch_training_sarge_lean_idle;
	level.scr_anim["sarge1"]["lean_idle"][1] 				= %ch_training_sarge_lean_disappointed;
	level.scr_anim["sarge1"]["lean_idle"][2] 				= %ch_training_sarge_lean_gogogo;
	
	// Sarge locomotion anims:  Standing
	level.scr_anim["sarge1"]["stand_disappointed"] 	= %ch_training_sarge_stand_disappointed;
	level.scr_anim["sarge1"]["stand_get_moving"] 		= %ch_training_sarge_stand_get_moving;
	level.scr_anim["sarge1"]["stand_to_run"] 				= %ch_training_sarge_stand_to_run;
	level.scr_anim["sarge1"]["stand_to_walk"] 			= %ch_training_sarge_stand_to_walk;	
	level.scr_anim["sarge1"]["stand_idle"][0]				= %ch_training_sarge_stand_idle;
	level.scr_anim["sarge1"]["stand_idle"][1]				= %ch_training_sarge_stand_idle;
	level.scr_anim["sarge1"]["stand_idle"][2]				= %ch_training_sarge_stand_disappointed;
	
	// Sarge locomotion anims:  Walking/Running
	level.scr_anim["sarge1"]["run_anim"] 						= %ch_training_sarge_run;
	level.scr_anim["sarge1"]["run_to_stand"] 				= %ch_training_sarge_run_to_stand;
	level.scr_anim["sarge1"]["walk_anim"] 					= %ch_training_sarge_walk;
	level.scr_anim["sarge1"]["walk_to_stand"] 			= %ch_training_sarge_walk_to_stand;	
	
	// Trainee animations
	level.scr_anim["trainee"]["throw_grenade1"]			= %ch_training_throw_grenade_guy1_b;
	level.scr_anim["trainee"]["throw_grenade2"]			= %ch_training_throw_grenade_guy2_b;
	level.scr_anim["trainee"]["mantle_wall1"]				= %ch_training_mantle_wall_guy1_b;
	level.scr_anim["trainee"]["mantle_wall2"]				= %ch_training_mantle_wall_guy2_b;
	level.scr_anim["trainee"]["obstacle_fall1"]			= %ch_training_fall_off_obstacle_guy1_b;
	level.scr_anim["trainee"]["obstacle_fall2"]			= %ch_training_fall_off_obstacle_guy2_b;
}

audio_loader()
{
	// Sarge's anims/dialog during the running section
	level.scr_sound["sarge1"]["move_dialog"] 				= "print: Move! Move!";
	level.scr_sound["sarge1"]["crouch_dialog"] 			= "print: Get under those logs!";
	level.scr_sound["sarge1"]["crawl_dialog"] 			= "print: Now crawl under that barbed wire!";
	level.scr_sound["sarge1"]["shoot_first_target"] = "print: Shoot through the top of the Left Tower";
	level.scr_sound["sarge1"]["player_to_oc"] 			= "print: Grab this Thompson and get to the wall when ready.";
	level.scr_sound["sarge1"]["player_needs_ammo"] 	= "print:  Go get some Ammo from the Shooting Range First";
	level.scr_sound["sarge1"]["sarge_walkthrough"] 	= "print:  Alright Soldiers, try to get through the course as fast as you can while hitting all the targets";
	level.scr_sound["sarge1"]["oc_start"] 					= "print:  Ready?  ...GO!";
	
	// Sarge's anims/dialog during the obstacle course
	level.scr_sound["sarge1"]["oc_shoot_targets"] 				= "print: Shoot the Targets!";
	level.scr_sound["sarge1"]["oc_shoot_target_success"] 	= "print: Good Shot";
	level.scr_sound["sarge1"]["oc_toss_grenade1"] 				= "print: Toss a grenade into the cave";
	level.scr_sound["sarge1"]["oc_toss_grenade2"] 				= "print: Toss a grenade into that window";
	level.scr_sound["sarge1"]["oc_toss_grenade_success"] 	= "print: Good Throw";
	level.scr_sound["sarge1"]["oc_melee"] 								= "print: Run and Melee that Target";
	level.scr_sound["sarge1"]["oc_results_good"] 					= "print: Great run Miller";
	level.scr_sound["sarge1"]["oc_results_average"] 			= "print: Miller, can't you do better than that?";
	level.scr_sound["sarge1"]["oc_results_bad"] 					= "print: Do we need to send you back to basic, Miller?";
	level.scr_sound["sarge1"]["oc_results_targs"] 				= "print: Miller, Don't forget to hit the targets";
	level.scr_sound["sarge1"]["oc_results_nade_targs"] 		= "print: Miller, you forget how to throw a grenade again?";
	level.scr_sound["sarge1"]["oc_move"] 									= "print: Move Move Move!";
	level.scr_sound["sarge1"]["oc_wood_shot"] 						= "print: Shoot that target through the wood!";
	level.scr_sound["sarge1"]["oc_ask_do_again"] 					= "print: Back to the wall if you want another go.  Otherwise, up the stairs and to the tents";
	
	// end_loco_officer's anims/dialog 
	level.scr_sound["off1"]["instruction_dialog"] = "print: Shooting range to your right, Obstacle Course to your left";
	
	// sr_officer's anims/dialog
	level.scr_sound["off2"]["player_to_sr"] 						= "print: Alright, grab some ammo and grenades off of that table.";
	level.scr_sound["off2"]["shoot_ground_targets"] 		= "print: Try shooting the lower three targets";
	level.scr_sound["off2"]["use_ads"] 									= "print: You've got a sight, use it.  Shoot that far target again";
	level.scr_sound["off2"]["shoot_tower_targets"] 			= "print: Now see if you can shoot the targets up in the towers.";
	level.scr_sound["off2"]["sr_shoot_target_success"] 	= "print: Good Shot.";
	level.scr_sound["off2"]["sr_toss_nade"] 						= "print: Move on to the grenade practice.  Lob one through a hole in that wall";
	level.scr_sound["off2"]["sr_good_toss"] 						= "print: Good toss.  Why don't you head over to the Obstacle Course now?";
	

}



// General dialog used by the sarge during Training
sarge_dialog_and_sound(index)
{
	switch(index)
	{
		case 0:		
			self anim_single_solo(self, "move_dialog");
		break;
		
		case 1:
			self anim_single_solo(self, "crouch_dialog");
		break;
		
		case 2:
			self anim_single_solo(self, "crawl_dialog");
		break;
			
		case 3:
			self anim_single_solo(self, "shoot_first_target");
		break;
			
		case 4:
			self anim_single_solo(self, "player_to_oc");
		break;			
		
		case 5:
			self anim_single_solo(self, "player_needs_ammo");
		break;
		
		case 6:
			self anim_single_solo(self, "sarge_walkthrough");
		break;			
		
		case 7:
			self anim_single_solo(self, "oc_start");
		break;	
			
		default:
		break;
	}
}


// Sarge's dialog during the Obstacle Course
sarge_oc_dialog(index)
{
	switch(index)
	{
		case 0:		
			self anim_single_solo(self, "oc_shoot_targets");
		break;
	
		case 1:		
			self anim_single_solo(self, "oc_shoot_target_success");
		break;
		
		case 2:		
			self anim_single_solo(self, "oc_toss_grenade1");
		break;
		
		case 3:		
			self anim_single_solo(self, "oc_toss_grenade2");
		break;
		
		case 4:		
			self anim_single_solo(self, "oc_toss_grenade_success");
		break;
		
		case 5:		
			self anim_single_solo(self, "oc_melee");
		break;
		
		case 6:
			self anim_single_solo(self, "oc_move");
		break;	
		
		case 7:
			self anim_single_solo(self, "oc_wood_shot");
		break;			

		case 8:
			self anim_single_solo(self, "oc_ask_do_again");
		break;			
		
		default:
		break;
	}	
}


sarge_dialog(index)
{
	self anim_single_solo(self, index);
}


// Sarge's dialog during the Obstacle Course
officer_sr_dialog(index)
{
	switch(index)
	{
		case 0:		
			self anim_single_solo(self, "player_to_sr");
		break;
		
		case 1:
			self anim_single_solo(self, "shoot_ground_targets");
		break;	
		
		case 2:
			self anim_single_solo(self, "use_ads");
		break;
		
		case 3:
			self anim_single_solo(self, "shoot_ground_targets");
		break; 
		
		case 4:
			self anim_single_solo(self, "shoot_tower_targets");
		break;
		
		case 5:
			self anim_single_solo(self, "sr_toss_nade");
		break;
		
		case 6:
			self anim_single_solo(self, "sr_good_toss");
		break;
		
		case 11:
			self anim_single_solo(self, "sr_shoot_target_success");
		break;
		
		default:
		break;
	}
}


// Dialog by the officer after the running section
off1_dialog_and_sound(index)
{
	switch(index)
	{
		case 0:
			self anim_single_solo(self, "instruction_dialog");
		break;
		
		default:
		break;
	}
}